// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The source code of this contract uses the following contracts from Aave v1
// LendingPool: https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPool.sol
// LendingPool Core: https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPoolCore.sol
// LendingPool Core Library: https://github.com/aave/aave-protocol/blob/master/contracts/libraries/CoreLibrary.sol
// LendingPool Data Provider: https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPoolDataProvider.sol

interface IERC20 {
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);
    function balanceOf(address account) external returns (uint256);
    function decimals() external returns (uint8);
}

interface ILendingPoolAddressesProvider {
    function getPriceOracle() external returns (address);
    function getLendingRateOracle() external returns (address);
    function getTokenDistributor() external returns (address);
}

interface AToken {
    function balanceOf(address) external returns (uint256);
    function mintOnDeposit(address, uint256) external;
}

interface ILendingRateOracle {
    function getMarketBorrowRate(address) external returns (uint256);
}

interface IPriceOracleGetter {
    function getAssetPrice(address _asset) external returns (uint256);
}

interface IReserveInterestRateStrategy {
    function getBaseVariableBorrowRate() external returns (uint256);
    function calculateInterestRates(
        address _reserve,
        uint256 _utilizationRate,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate
    ) external returns (uint256[] memory return_data);
}

contract AaveLendingPool {
    enum InterestRateMode {
        NONE,
        STABLE,
        VARIABLE
    }

    struct BorrowLocalVars {
        uint256 currentLtv;
        uint256 currentLiquidationThreshold;
        uint256 borrowFee;
        uint256 amountOfCollateralNeededETH;
        uint256 userCollateralBalanceETH;
        uint256 userBorrowBalanceETH;
        uint256 userTotalFeesETH;
        uint256 borrowBalanceIncrease;
        uint256 availableLiquidity;
        uint256 finalUserBorrowRate;
        InterestRateMode rateMode;
        bool healthFactorBelowThreshold;
    }

    struct RepayLocalVars {
        uint256 principalBorrowBalance;
        uint256 compoundedBorrowBalance;
        uint256 borrowBalanceIncrease;
        bool isETH;
        uint256 paybackAmount;
        uint256 paybackAmountMinusFees;
        uint256 originationFee;
    }

    struct ReserveData {
        uint256 lastLiquidityCumulativeIndex;
        uint256 currentLiquidityRate;
        uint256 totalBorrowsStable;
        uint256 totalBorrowsVariable;
        uint256 currentVariableBorrowRate;
        uint256 currentStableBorrowRate;
        uint256 currentAverageStableBorrowRate;
        uint256 lastVariableBorrowCumulativeIndex;
        uint256 baseLTVasCollateral;
        uint256 liquidationThreshold;
        uint256 decimals;
        address aTokenAddress;
        address interestRateStrategyAddress;
        uint40 lastUpdateTimestamp;
        bool borrowingEnabled;
        bool usageAsCollateralEnabled;
        bool isStableBorrowRateEnabled;
    }

    struct UserReserveData {
        uint256 principalBorrowBalance;
        uint256 lastVariableBorrowCumulativeIndex;
        uint256 originationFee;
        uint256 stableBorrowRate;
        uint40 lastUpdateTimestamp;
        bool useAsCollateral;
    }

    struct UserGlobalDataLocalVars {
        uint256 reserveUnitPrice;
        uint256 tokenUnit;
        uint256 compoundedLiquidityBalance;
        uint256 compoundedBorrowBalance;
        uint256 reserveDecimals;
        uint256 baseLtv;
        uint256 liquidationThreshold;
        uint256 originationFee;
        bool usageAsCollateralEnabled;
        bool userUsesReserveAsCollateral;
        address currentReserve;
    }

    struct BalanceDecreaseAllowedLocalVars {
        uint256 decimals;
        uint256 collateralBalanceETH;
        uint256 borrowBalanceETH;
        uint256 totalFeesETH;
        uint256 currentLiquidationThreshold;
        uint256 reserveLiquidationThreshold;
        uint256 amountToDecreaseETH;
        uint256 collateralBalancefterDecrease;
        uint256 liquidationThresholdAfterDecrease;
        bool reserveUsageAsCollateralEnabled;
    }

    ILendingPoolAddressesProvider public addressesProvider;

    uint256 internal UINT256_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    /* LendingPoolCore variables*/
    mapping(address => ReserveData) internal reserves;
    mapping(address => mapping(address => UserReserveData))
        internal usersReserveData;
    address[] public reservesList;

    constructor(address _addressesProvider) {
        addressesProvider = ILendingPoolAddressesProvider(_addressesProvider);
    }

    function deposit(address _reserve, uint256 _amount) external {
        AToken aToken = AToken(core_getReserveATokenAddress(_reserve));
        bool isFirstDeposit = aToken.balanceOf(msg.sender) == 0;
        core_updateStateOnDeposit(
            _reserve,
            msg.sender,
            _amount,
            isFirstDeposit
        );
        aToken.mintOnDeposit(msg.sender, _amount);
        IERC20(_reserve).transferFrom(msg.sender, address(this), _amount);
    }

    function redeemUnderlying(
        address _reserve,
        address _user,
        uint256 _amount,
        uint256 _aTokenBalanceAfterRedeem
    ) external {
        uint256 currentAvailableLiquidity = IERC20(_reserve).balanceOf(
            address(this)
        );
        require(
            currentAvailableLiquidity >= _amount,
            "There is not enough liquidity available to redeem"
        );
        core_updateStateOnRedeem(
            _reserve,
            _user,
            _amount,
            _aTokenBalanceAfterRedeem == 0
        );
        IERC20(_reserve).transfer(_user, _amount);
    }

    function borrow(
        address _reserve,
        uint256 _amount,
        uint256 _interestRateMode
    ) external {
        BorrowLocalVars memory vars;

        require(
            core_isReserveBorrowingEnabled(_reserve),
            "Reserve is not enabled for borrowing"
        );

        require(
            uint256(InterestRateMode.VARIABLE) == _interestRateMode ||
                uint256(InterestRateMode.STABLE) == _interestRateMode,
            "Invalid interest rate mode selected"
        );

        vars.rateMode = InterestRateMode(_interestRateMode);

        vars.availableLiquidity = IERC20(_reserve).balanceOf(address(this));

        require(
            vars.availableLiquidity >= _amount,
            "There is not enough liquidity available in the reserve"
        );

        uint256[] memory return_data = dataProvider_calculateUserGlobalData(
            msg.sender
        );
        vars.userCollateralBalanceETH = return_data[1];
        vars.userBorrowBalanceETH = return_data[2];
        vars.userTotalFeesETH = return_data[3];
        vars.currentLtv = return_data[4];
        vars.currentLiquidationThreshold = return_data[5];

        require(
            vars.userCollateralBalanceETH > 0,
            "The collateral balance is 0"
        );

        vars.borrowFee = 0;

        vars
            .amountOfCollateralNeededETH = dataProvider_calculateCollateralNeededInETH(
            _reserve,
            _amount,
            vars.borrowFee,
            vars.userBorrowBalanceETH,
            vars.userTotalFeesETH,
            vars.currentLtv
        );

        require(
            vars.amountOfCollateralNeededETH <= vars.userCollateralBalanceETH,
            "There is not enough collateral to cover a new borrow"
        );

        if (vars.rateMode == InterestRateMode.STABLE) {
            require(
                core_isUserAllowedToBorrowAtStable(
                    _reserve,
                    msg.sender,
                    _amount
                ),
                "User cannot borrow the selected amount with a stable rate"
            );

            uint256 maxLoanPercent = 25;
            uint256 maxLoanSizeStable = (vars.availableLiquidity *
                maxLoanPercent) / 100;

            require(
                _amount <= maxLoanSizeStable,
                "User is trying to borrow too much liquidity at a stable rate"
            );
        }

        uint256[] memory update_return_data = core_updateStateOnBorrow(
            _reserve,
            msg.sender,
            _amount,
            vars.borrowFee,
            vars.rateMode
        );

        vars.finalUserBorrowRate = update_return_data[0];
        vars.borrowBalanceIncrease = update_return_data[1];

        IERC20(_reserve).transfer(msg.sender, _amount);
    }

    function repay(
        address _reserve,
        uint256 _amount,
        address _onBehalfOf
    ) external {
        RepayLocalVars memory vars;
        uint256[] memory return_data = core_getUserBorrowBalances(
            _reserve,
            _onBehalfOf
        );

        vars.principalBorrowBalance = return_data[0];
        vars.compoundedBorrowBalance = return_data[1];
        vars.borrowBalanceIncrease = return_data[2];

        vars.originationFee = core_getUserOriginationFee(_reserve, _onBehalfOf);

        require(
            vars.compoundedBorrowBalance > 0,
            "The user does not have any borrow pending"
        );

        require(
            _amount != UINT256_MAX || msg.sender == _onBehalfOf,
            "To repay on behalf of an user an explicit amount to repay is needed."
        );

        vars.paybackAmount = vars.compoundedBorrowBalance + vars.originationFee;

        if (_amount != UINT256_MAX && _amount < vars.paybackAmount) {
            vars.paybackAmount = _amount;
        }

        if (vars.paybackAmount <= vars.originationFee) {
            core_updateStateOnRepay(
                _reserve,
                _onBehalfOf,
                0,
                vars.paybackAmount,
                vars.borrowBalanceIncrease,
                false
            );

            IERC20(_reserve).transferFrom(
                _onBehalfOf,
                address(uint160(addressesProvider.getTokenDistributor())),
                vars.paybackAmount
            );

            return;
        }

        vars.paybackAmountMinusFees = vars.paybackAmount - vars.originationFee;

        core_updateStateOnRepay(
            _reserve,
            _onBehalfOf,
            vars.paybackAmountMinusFees,
            vars.originationFee,
            vars.borrowBalanceIncrease,
            vars.compoundedBorrowBalance == vars.paybackAmountMinusFees
        );

        if (vars.originationFee > 0) {
            IERC20(_reserve).transferFrom(
                msg.sender,
                address(uint160(addressesProvider.getTokenDistributor())),
                vars.originationFee
            );
        }

        IERC20(_reserve).transferFrom(
            msg.sender,
            address(this),
            vars.paybackAmountMinusFees
        );
    }

    /* LendingPoolCore functions*/

    function core_addReserve(
        address _reserve,
        ReserveData memory _reserve_data
    ) public {
        reserves[_reserve] = _reserve_data;
        reservesList.push(_reserve);
    }

    function core_addUserReserveData(
        address _user,
        address _reserve,
        UserReserveData memory _user_reserve_data
    ) public {
        usersReserveData[_user][_reserve] = _user_reserve_data;
    }

    function core_getReserveATokenAddress(
        address _reserve
    ) public returns (address) {
        ReserveData storage reserve = reserves[_reserve];
        return reserve.aTokenAddress;
    }

    function core_updateStateOnDeposit(
        address _reserve,
        address _user,
        uint256 _amount,
        bool _isFirstDeposit
    ) internal {
        core_updateCumulativeIndexes(reserves[_reserve]);
        core_updateReserveInterestRatesAndTimestampInternal(
            _reserve,
            _amount,
            0
        );

        if (_isFirstDeposit) {
            core_setUserUseReserveAsCollateral(_reserve, _user, true);
        }
    }

    function core_updateStateOnRedeem(
        address _reserve,
        address _user,
        uint256 _amountRedeemed,
        bool _userRedeemedEverything
    ) internal {
        core_updateCumulativeIndexes(reserves[_reserve]);
        core_updateReserveInterestRatesAndTimestampInternal(
            _reserve,
            0,
            _amountRedeemed
        );

        if (_userRedeemedEverything) {
            core_setUserUseReserveAsCollateral(_reserve, _user, false);
        }
    }

    function core_isReserveBorrowingEnabled(
        address _reserve
    ) internal returns (bool) {
        ReserveData storage reserve = reserves[_reserve];
        return reserve.borrowingEnabled;
    }

    function core_isUserAllowedToBorrowAtStable(
        address _reserve,
        address _user,
        uint256 _amount
    ) internal returns (bool) {
        ReserveData storage reserve = reserves[_reserve];
        UserReserveData storage user = usersReserveData[_user][_reserve];

        if (!reserve.isStableBorrowRateEnabled) return false;

        return
            !user.useAsCollateral ||
            !reserve.usageAsCollateralEnabled ||
            _amount > core_getUserUnderlyingAssetBalance(_reserve, _user);
    }

    function core_updateStateOnBorrow(
        address _reserve,
        address _user,
        uint256 _amountBorrowed,
        uint256 _borrowFee,
        InterestRateMode _rateMode
    ) internal returns (uint256[] memory return_data) {
        return_data = new uint256[](2);

        uint256[]
            memory borrow_balance_return_data = core_getUserBorrowBalances(
                _reserve,
                _user
            );
        uint256 principalBorrowBalance = borrow_balance_return_data[0];
        uint256 balanceIncrease = borrow_balance_return_data[2];

        core_updateReserveStateOnBorrowInternal(
            _reserve,
            _user,
            principalBorrowBalance,
            balanceIncrease,
            _amountBorrowed,
            _rateMode
        );

        core_updateUserStateOnBorrowInternal(
            _reserve,
            _user,
            _amountBorrowed,
            balanceIncrease,
            _borrowFee,
            _rateMode
        );

        core_updateReserveInterestRatesAndTimestampInternal(
            _reserve,
            0,
            _amountBorrowed
        );

        return_data[0] = core_getUserCurrentBorrowRate(_reserve, _user);
        return_data[1] = balanceIncrease;
    }

    function core_getUserOriginationFee(
        address _reserve,
        address _user
    ) internal returns (uint256) {
        UserReserveData storage user = usersReserveData[_user][_reserve];
        return user.originationFee;
    }

    function core_updateStateOnRepay(
        address _reserve,
        address _user,
        uint256 _paybackAmountMinusFees,
        uint256 _originationFeeRepaid,
        uint256 _balanceIncrease,
        bool _repaidWholeLoan
    ) internal {
        core_updateReserveStateOnRepayInternal(
            _reserve,
            _user,
            _paybackAmountMinusFees,
            _balanceIncrease
        );
        core_updateUserStateOnRepayInternal(
            _reserve,
            _user,
            _paybackAmountMinusFees,
            _originationFeeRepaid,
            _balanceIncrease,
            _repaidWholeLoan
        );

        core_updateReserveInterestRatesAndTimestampInternal(
            _reserve,
            _paybackAmountMinusFees,
            0
        );
    }

    function core_getUserBorrowBalances(
        address _reserve,
        address _user
    ) public returns (uint256[] memory return_data) {
        return_data = new uint256[](3);

        UserReserveData storage user = usersReserveData[_user][_reserve];
        if (user.principalBorrowBalance == 0) {
            return return_data;
        }

        uint256 principal = user.principalBorrowBalance;
        uint256 compoundedBalance = core_getCompoundedBorrowBalance(
            user,
            reserves[_reserve]
        );
        return_data[0] = principal;
        return_data[1] = compoundedBalance;
        return_data[2] = compoundedBalance - principal;
    }

    function core_getUserCurrentBorrowRateMode(
        address _reserve,
        address _user
    ) public returns (InterestRateMode) {
        UserReserveData storage user = usersReserveData[_user][_reserve];

        if (user.principalBorrowBalance == 0) {
            return InterestRateMode.NONE;
        }

        return
            user.stableBorrowRate > 0
                ? InterestRateMode.STABLE
                : InterestRateMode.VARIABLE;
    }

    function core_getUserUnderlyingAssetBalance(
        address _reserve,
        address _user
    ) public returns (uint256) {
        AToken aToken = AToken(reserves[_reserve].aTokenAddress);
        return aToken.balanceOf(_user);
    }

    function core_setUserUseReserveAsCollateral(
        address _reserve,
        address _user,
        bool _useAsCollateral
    ) public {
        UserReserveData storage user = usersReserveData[_user][_reserve];
        user.useAsCollateral = _useAsCollateral;
    }

    function core_updateReserveInterestRatesAndTimestampInternal(
        address _reserve,
        uint256 _liquidityAdded,
        uint256 _liquidityTaken
    ) internal {
        ReserveData storage reserve = reserves[_reserve];
        uint256[] memory return_data = IReserveInterestRateStrategy(
            reserve.interestRateStrategyAddress
        ).calculateInterestRates(
                _reserve,
                IERC20(_reserve).balanceOf(address(this)) +
                    _liquidityAdded -
                    _liquidityTaken,
                reserve.totalBorrowsStable,
                reserve.totalBorrowsVariable,
                reserve.currentAverageStableBorrowRate
            );

        uint256 newLiquidityRate = return_data[0];
        uint256 newStableRate = return_data[1];
        uint256 newVariableRate = return_data[2];

        reserve.currentLiquidityRate = newLiquidityRate;
        reserve.currentStableBorrowRate = newStableRate;
        reserve.currentVariableBorrowRate = newVariableRate;

        reserve.lastUpdateTimestamp = uint40(block.timestamp);
    }

    function core_updateCumulativeIndexes(ReserveData storage _self) internal {
        uint256 totalBorrows = _self.totalBorrowsStable +
            _self.totalBorrowsVariable;

        if (totalBorrows > 0) {
            uint256 cumulatedLiquidityInterest = core_calculateLinearInterest_mocked(
                    _self.currentLiquidityRate,
                    _self.lastUpdateTimestamp
                );

            _self.lastLiquidityCumulativeIndex =
                (cumulatedLiquidityInterest / 1e27) *
                _self.lastLiquidityCumulativeIndex;

            uint256 cumulatedVariableBorrowInterest = core_calculateCompoundedInterest_mocked(
                    _self.currentVariableBorrowRate,
                    _self.lastUpdateTimestamp
                );
            _self.lastVariableBorrowCumulativeIndex =
                (cumulatedVariableBorrowInterest / 1e27) *
                _self.lastVariableBorrowCumulativeIndex;
        }
    }

    function core_updateReserveStateOnBorrowInternal(
        address _reserve,
        address _user,
        uint256 _principalBorrowBalance,
        uint256 _balanceIncrease,
        uint256 _amountBorrowed,
        InterestRateMode _rateMode
    ) internal {
        core_updateCumulativeIndexes(reserves[_reserve]);

        core_updateReserveTotalBorrowsByRateModeInternal(
            _reserve,
            _user,
            _principalBorrowBalance,
            _balanceIncrease,
            _amountBorrowed,
            _rateMode
        );
    }

    function core_updateUserStateOnBorrowInternal(
        address _reserve,
        address _user,
        uint256 _amountBorrowed,
        uint256 _balanceIncrease,
        uint256 _fee,
        InterestRateMode _rateMode
    ) internal {
        ReserveData storage reserve = reserves[_reserve];
        UserReserveData storage user = usersReserveData[_user][_reserve];

        require(
            _rateMode == InterestRateMode.VARIABLE ||
                _rateMode == InterestRateMode.STABLE,
            "Invalid borrow rate mode"
        );
        if (_rateMode == InterestRateMode.STABLE) {
            user.stableBorrowRate = reserve.currentStableBorrowRate;
            user.lastVariableBorrowCumulativeIndex = 0;
        } else {
            user.stableBorrowRate = 0;
            user.lastVariableBorrowCumulativeIndex = reserve
                .lastVariableBorrowCumulativeIndex;
        }
        user.principalBorrowBalance =
            user.principalBorrowBalance +
            _amountBorrowed +
            _balanceIncrease;
        user.originationFee = user.originationFee + _fee;

        user.lastUpdateTimestamp = uint40(block.timestamp);
    }

    function core_getUserCurrentBorrowRate(
        address _reserve,
        address _user
    ) internal returns (uint256) {
        InterestRateMode rateMode = core_getUserCurrentBorrowRateMode(
            _reserve,
            _user
        );

        if (rateMode == InterestRateMode.NONE) {
            return 0;
        }

        return
            rateMode == InterestRateMode.STABLE
                ? usersReserveData[_user][_reserve].stableBorrowRate
                : reserves[_reserve].currentVariableBorrowRate;
    }

    function core_updateReserveStateOnRepayInternal(
        address _reserve,
        address _user,
        uint256 _paybackAmountMinusFees,
        uint256 _balanceIncrease
    ) internal {
        ReserveData storage reserve = reserves[_reserve];
        UserReserveData storage user = usersReserveData[_user][_reserve];

        InterestRateMode borrowRateMode = core_getUserCurrentBorrowRateMode(
            _reserve,
            _user
        );

        core_updateCumulativeIndexes(reserves[_reserve]);

        if (borrowRateMode == InterestRateMode.STABLE) {
            core_increaseTotalBorrowsStableAndUpdateAverageRate(
                reserve,
                _balanceIncrease,
                user.stableBorrowRate
            );
            core_decreaseTotalBorrowsStableAndUpdateAverageRate(
                reserve,
                _paybackAmountMinusFees,
                user.stableBorrowRate
            );
        } else {
            core_increaseTotalBorrowsVariable(reserve, _balanceIncrease);
            core_decreaseTotalBorrowsVariable(reserve, _paybackAmountMinusFees);
        }
    }

    function core_updateUserStateOnRepayInternal(
        address _reserve,
        address _user,
        uint256 _paybackAmountMinusFees,
        uint256 _originationFeeRepaid,
        uint256 _balanceIncrease,
        bool _repaidWholeLoan
    ) internal {
        ReserveData storage reserve = reserves[_reserve];
        UserReserveData storage user = usersReserveData[_user][_reserve];

        user.principalBorrowBalance =
            user.principalBorrowBalance +
            _balanceIncrease -
            _paybackAmountMinusFees;
        user.lastVariableBorrowCumulativeIndex = reserve
            .lastVariableBorrowCumulativeIndex;

        if (_repaidWholeLoan) {
            user.stableBorrowRate = 0;
            user.lastVariableBorrowCumulativeIndex = 0;
        }
        user.originationFee = user.originationFee - _originationFeeRepaid;

        user.lastUpdateTimestamp = uint40(block.timestamp);
    }

    function core_increaseTotalBorrowsStableAndUpdateAverageRate(
        ReserveData storage _reserve,
        uint256 _amount,
        uint256 _rate
    ) internal {
        uint256 previousTotalBorrowStable = _reserve.totalBorrowsStable;
        _reserve.totalBorrowsStable = _reserve.totalBorrowsStable + _amount;

        uint256 weightedLastBorrow = _amount * 1e9 * _rate;
        uint256 weightedPreviousTotalBorrows = previousTotalBorrowStable *
            1e9 *
            _reserve.currentAverageStableBorrowRate;

        _reserve.currentAverageStableBorrowRate =
            (weightedLastBorrow + weightedPreviousTotalBorrows) /
            (_reserve.totalBorrowsStable * 1e9);
    }

    function core_decreaseTotalBorrowsStableAndUpdateAverageRate(
        ReserveData storage _reserve,
        uint256 _amount,
        uint256 _rate
    ) internal {
        require(
            _reserve.totalBorrowsStable >= _amount,
            "Invalid amount to decrease"
        );

        uint256 previousTotalBorrowStable = _reserve.totalBorrowsStable;

        _reserve.totalBorrowsStable = _reserve.totalBorrowsStable - _amount;

        if (_reserve.totalBorrowsStable == 0) {
            _reserve.currentAverageStableBorrowRate = 0;
            return;
        }

        uint256 weightedLastBorrow = _amount * 1e9 * _rate;
        uint256 weightedPreviousTotalBorrows = previousTotalBorrowStable *
            1e9 *
            _reserve.currentAverageStableBorrowRate;

        require(
            weightedPreviousTotalBorrows >= weightedLastBorrow,
            "The amounts to subtract don't match"
        );

        _reserve.currentAverageStableBorrowRate =
            (weightedPreviousTotalBorrows - weightedLastBorrow) /
            (_reserve.totalBorrowsStable * 1e9);
    }

    function core_increaseTotalBorrowsVariable(
        ReserveData storage _reserve,
        uint256 _amount
    ) internal {
        _reserve.totalBorrowsVariable = _reserve.totalBorrowsVariable + _amount;
    }

    function core_decreaseTotalBorrowsVariable(
        ReserveData storage _reserve,
        uint256 _amount
    ) internal {
        require(
            _reserve.totalBorrowsVariable >= _amount,
            "The amount that is being subtracted from the variable total borrows is incorrect"
        );
        _reserve.totalBorrowsVariable = _reserve.totalBorrowsVariable - _amount;
    }

    function core_getCompoundedBorrowBalance(
        UserReserveData storage _self,
        ReserveData storage _reserve
    ) internal returns (uint256) {
        if (_self.principalBorrowBalance == 0) return 0;

        uint256 principalBorrowBalanceRay = _self.principalBorrowBalance * 1e9;
        uint256 compoundedBalance = 0;
        uint256 cumulatedInterest = 0;

        if (_self.stableBorrowRate > 0) {
            cumulatedInterest = core_calculateCompoundedInterest_mocked(
                _self.stableBorrowRate,
                _self.lastUpdateTimestamp
            );
        } else {
            cumulatedInterest =
                (core_calculateCompoundedInterest_mocked(
                    _reserve.currentVariableBorrowRate,
                    _reserve.lastUpdateTimestamp
                ) * _reserve.lastVariableBorrowCumulativeIndex) /
                _self.lastVariableBorrowCumulativeIndex;
        }

        compoundedBalance =
            (principalBorrowBalanceRay * cumulatedInterest) /
            1e9;

        if (compoundedBalance == _self.principalBorrowBalance) {
            if (_self.lastUpdateTimestamp != block.timestamp) {
                return _self.principalBorrowBalance + 1 wei;
            }
        }

        return compoundedBalance;
    }

    function core_calculateLinearInterest_mocked(
        uint256 /*_rate*/,
        uint40 /*_lastUpdateTimestamp*/
    ) internal returns (uint256) {
        return 1e27 + 0.01 * 1e27;
    }

    function core_calculateCompoundedInterest_mocked(
        uint256 /*_rate*/,
        uint40 /*_lastUpdateTimestamp*/
    ) internal returns (uint256) {
        return 1e27 + 0.01 * 1e27;
    }

    function core_updateReserveTotalBorrowsByRateModeInternal(
        address _reserve,
        address _user,
        uint256 _principalBalance,
        uint256 _balanceIncrease,
        uint256 _amountBorrowed,
        InterestRateMode _newBorrowRateMode
    ) internal {
        InterestRateMode previousRateMode = core_getUserCurrentBorrowRateMode(
            _reserve,
            _user
        );
        ReserveData storage reserve = reserves[_reserve];

        if (previousRateMode == InterestRateMode.STABLE) {
            UserReserveData storage user = usersReserveData[_user][_reserve];
            core_decreaseTotalBorrowsStableAndUpdateAverageRate(
                reserve,
                _principalBalance,
                user.stableBorrowRate
            );
        } else if (previousRateMode == InterestRateMode.VARIABLE) {
            core_decreaseTotalBorrowsVariable(reserve, _principalBalance);
        }

        uint256 newPrincipalAmount = _principalBalance +
            _balanceIncrease +
            _amountBorrowed;
        require(
           _newBorrowRateMode == InterestRateMode.VARIABLE ||
               _newBorrowRateMode == InterestRateMode.STABLE,
           "Invalid new borrow rate mode"
        );
        if (_newBorrowRateMode == InterestRateMode.STABLE) {
            core_increaseTotalBorrowsStableAndUpdateAverageRate(
                reserve,
                newPrincipalAmount,
                reserve.currentStableBorrowRate
            );
        } else {
            core_increaseTotalBorrowsVariable(reserve, newPrincipalAmount);
        }
    }

    function core_getUserBasicReserveData(
        address _reserve,
        address _user
    ) internal returns (uint256[] memory return_data) {
        return_data = new uint256[](4);
        ReserveData storage reserve = reserves[_reserve];
        UserReserveData storage user = usersReserveData[_user][_reserve];

        uint256 underlyingBalance = core_getUserUnderlyingAssetBalance(
            _reserve,
            _user
        );

        if (user.principalBorrowBalance == 0) {
            return_data[0] = underlyingBalance;
            return_data[3] = user.useAsCollateral ? 1 : 0;
            return return_data;
        }

        return_data[0] = underlyingBalance;
        return_data[1] = core_getCompoundedBorrowBalance(user, reserve);
        return_data[2] = user.originationFee;
        return_data[3] = user.useAsCollateral ? 1 : 0;
    }

    function core_getReserveConfiguration(
        address _reserve
    ) internal returns (uint256[] memory return_data) {
        return_data = new uint256[](4);

        uint256 decimals;
        uint256 baseLTVasCollateral;
        uint256 liquidationThreshold;
        bool usageAsCollateralEnabled;

        ReserveData storage reserve = reserves[_reserve];
        decimals = reserve.decimals;
        baseLTVasCollateral = reserve.baseLTVasCollateral;
        liquidationThreshold = reserve.liquidationThreshold;
        usageAsCollateralEnabled = reserve.usageAsCollateralEnabled;

        return_data[0] = decimals;
        return_data[1] = baseLTVasCollateral;
        return_data[2] = liquidationThreshold;
        return_data[3] = usageAsCollateralEnabled ? 1 : 0;
    }

    function core_isUserUseReserveAsCollateralEnabled(
        address _reserve,
        address _user
    ) internal returns (bool) {
        UserReserveData storage user = usersReserveData[_user][_reserve];
        return user.useAsCollateral;
    }

    /* LendingPoolDataProvider functions*/
    function dataProvider_calculateUserGlobalData(
        address _user
    ) public returns (uint256[] memory return_data) {
        return_data = new uint256[](7);

        IPriceOracleGetter oracle = IPriceOracleGetter(
            addressesProvider.getPriceOracle()
        );

        UserGlobalDataLocalVars memory vars;

        uint256[] memory reserve_data_return;
        uint256[] memory reserve_conf_return;

        for (uint256 i = 0; i < reservesList.length; i++) {
            vars.currentReserve = reservesList[i];
            reserve_data_return = core_getUserBasicReserveData(
                vars.currentReserve,
                _user
            );

            vars.compoundedLiquidityBalance = reserve_data_return[0];
            vars.compoundedBorrowBalance = reserve_data_return[1];
            vars.originationFee = reserve_data_return[2];
            vars.userUsesReserveAsCollateral = reserve_data_return[3] == 1
                ? true
                : false;

            if (
                vars.compoundedLiquidityBalance == 0 &&
                vars.compoundedBorrowBalance == 0
            ) {
                continue;
            }

            reserve_conf_return = core_getReserveConfiguration(
                vars.currentReserve
            );

            vars.reserveDecimals = reserve_conf_return[0];
            vars.baseLtv = reserve_conf_return[1];
            vars.liquidationThreshold = reserve_conf_return[2];
            vars.usageAsCollateralEnabled = reserve_conf_return[3] == 1
                ? true
                : false;

            vars.tokenUnit = 10 ** vars.reserveDecimals;
            vars.reserveUnitPrice = oracle.getAssetPrice(vars.currentReserve);

            if (vars.compoundedLiquidityBalance > 0) {
                uint256 liquidityBalanceETH = (vars.reserveUnitPrice *
                    vars.compoundedLiquidityBalance) / vars.tokenUnit;
                return_data[0] = return_data[0] + liquidityBalanceETH;

                if (
                    vars.usageAsCollateralEnabled &&
                    vars.userUsesReserveAsCollateral
                ) {
                    return_data[1] = return_data[1] + liquidityBalanceETH;
                    return_data[4] =
                        return_data[4] +
                        (liquidityBalanceETH * vars.baseLtv);
                    return_data[5] =
                        return_data[5] +
                        (liquidityBalanceETH * vars.liquidationThreshold);
                }
            }

            if (vars.compoundedBorrowBalance > 0) {
                return_data[2] =
                    return_data[2] +
                    ((vars.reserveUnitPrice * vars.compoundedBorrowBalance) /
                        vars.tokenUnit);
                return_data[3] =
                    return_data[3] +
                    ((vars.originationFee * vars.reserveUnitPrice) /
                        vars.tokenUnit);
            }
        }

        return_data[4] = return_data[1] > 0
            ? return_data[4] / return_data[1]
            : 0;
        return_data[5] = return_data[1] > 0
            ? return_data[5] / return_data[1]
            : 0;

        return_data[6] = dataProvider_calculateHealthFactorFromBalancesInternal(
            return_data[1],
            return_data[2],
            return_data[3],
            return_data[5]
        );
    }

    function dataProvider_calculateCollateralNeededInETH(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        uint256 _userCurrentBorrowBalanceTH,
        uint256 _userCurrentFeesETH,
        uint256 _userCurrentLtv
    ) internal returns (uint256) {
        uint256 reserveDecimals = IERC20(_reserve).decimals();

        IPriceOracleGetter oracle = IPriceOracleGetter(
            addressesProvider.getPriceOracle()
        );

        uint256 requestedBorrowAmountETH = (oracle.getAssetPrice(_reserve) *
            (_amount + _fee)) / (10 ** reserveDecimals);

        uint256 collateralNeededInETH = ((_userCurrentBorrowBalanceTH +
            _userCurrentFeesETH +
            requestedBorrowAmountETH) * 100) / _userCurrentLtv;

        return collateralNeededInETH;
    }

    function dataProvider_balanceDecreaseAllowed(
        address _reserve,
        address _user,
        uint256 _amount
    ) internal returns (bool) {
        BalanceDecreaseAllowedLocalVars memory vars;
        uint256[] memory reserve_conf_return;

        reserve_conf_return = core_getReserveConfiguration(_reserve);

        vars.decimals = reserve_conf_return[0];
        vars.reserveLiquidationThreshold = reserve_conf_return[2];
        vars.reserveUsageAsCollateralEnabled = reserve_conf_return[3] == 1
            ? true
            : false;

        if (
            !vars.reserveUsageAsCollateralEnabled ||
            !core_isUserUseReserveAsCollateralEnabled(_reserve, _user)
        ) {
            return true;
        }

        uint256[] memory return_data = dataProvider_calculateUserGlobalData(
            _user
        );
        vars.collateralBalanceETH = return_data[1];
        vars.borrowBalanceETH = return_data[2];
        vars.totalFeesETH = return_data[3];
        vars.currentLiquidationThreshold = return_data[5];

        if (vars.borrowBalanceETH == 0) {
            return true;
        }

        IPriceOracleGetter oracle = IPriceOracleGetter(
            addressesProvider.getPriceOracle()
        );

        vars.amountToDecreaseETH =
            (oracle.getAssetPrice(_reserve) * _amount) /
            (10 ** vars.decimals);

        vars.collateralBalancefterDecrease =
            vars.collateralBalanceETH -
            vars.amountToDecreaseETH;

        if (vars.collateralBalancefterDecrease == 0) {
            return false;
        }

        vars.liquidationThresholdAfterDecrease =
            (vars.collateralBalanceETH *
                vars.currentLiquidationThreshold -
                vars.amountToDecreaseETH *
                vars.reserveLiquidationThreshold) /
            vars.collateralBalancefterDecrease;

        uint256 healthFactorAfterDecrease = dataProvider_calculateHealthFactorFromBalancesInternal(
                vars.collateralBalancefterDecrease,
                vars.borrowBalanceETH,
                vars.totalFeesETH,
                vars.liquidationThresholdAfterDecrease
            );

        return healthFactorAfterDecrease > 1e18;
    }

    function dataProvider_calculateHealthFactorFromBalancesInternal(
        uint256 collateralBalanceETH,
        uint256 borrowBalanceETH,
        uint256 totalFeesETH,
        uint256 liquidationThreshold
    ) internal returns (uint256) {
        if (borrowBalanceETH == 0) return UINT256_MAX;

        return
            ((collateralBalanceETH * liquidationThreshold) / 100) /
            (borrowBalanceETH + totalFeesETH);
    }
}
