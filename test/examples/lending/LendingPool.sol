// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// The source code of this contract uses the following contracts
// LendingPool: https://github.com/kaymen99/CryptoLendX/blob/main/contracts/LendingPool.sol

interface AggregatorV3Interface {
    function latestRoundData() external returns (uint256[] memory returndata);
}

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

contract LendingPool {
    enum TokenType {
        ERC20,
        ERC721
    }

    struct Vault {
        uint128 amount;
        uint128 shares;
    }

    struct AccountShares {
        uint256 collateral;
        uint256 borrow;
    }

    struct VaultInfo {
        uint64 reserveRatio;
        uint64 feeToProtocolRate;
        uint64 flashFeeRate;
        uint64 ratePerSec;
        uint64 lastBlock;
        uint64 lastTimestamp;
        uint64 baseRate;
        uint64 slope1;
        uint64 slope2;
        uint256 optimalUtilization;
    }

    struct TokenVault {
        Vault totalAsset;
        Vault totalBorrow;
        VaultInfo vaultInfo;
    }

    struct VaultSetupParams {
        uint64 reserveRatio;
        uint64 feeToProtocolRate;
        uint64 flashFeeRate;
        uint64 baseRate;
        uint64 slope1;
        uint64 slope2;
        uint256 optimalUtilization;
    }

    struct SupportedToken {
        address usdPriceFeed;
        TokenType tokenType;
        bool supported;
    }

    uint256 internal UINT256_MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256 internal MAX_PROTOCOL_FEE = 0.5e4; // 5%
    uint256 public PRECISION = 1e18; // 18 decimals precision
    uint256 public BPS = 1e5; // 5 decimals precision
    uint256 public BLOCKS_PER_YEAR = 2102400; // Average Ethereum blocks per year
    uint256 internal RATE_PRECISION = 1e18;
    uint256 internal MIN_HEALTH_FACTOR = 1e18;
    uint256 internal CLOSE_FACTOR_HF_THRESHOLD = 0.9e18;
    uint256 internal LIQUIDATION_THRESHOLD = 8e4; // 80%
    uint256 internal DEFAULT_LIQUIDATION_CLOSE_FACTOR = 5e4; // 50%
    uint256 internal LIQUIDATION_REWARD = 5e3; // 5%

    address[] internal supportedERC20s;
    address[] internal supportedNFTs;

    mapping(address => TokenVault) private vaults;
    mapping(address => SupportedToken) internal supportedTokens;
    mapping(address => mapping(address => AccountShares)) private userShares;

    event AddSupportedToken(address token, TokenType tokenType);
    event Deposit(address user, address token, uint256 amount, uint256 shares);
    event Borrow(address user, address token, uint256 amount, uint256 shares);
    event Repay(address user, address token, uint256 amount, uint256 shares);
    event Withdraw(address user, address token, uint256 amount, uint256 shares);
    event Liquidated(
        address borrower,
        address liquidator,
        uint256 repaidAmount,
        uint256 liquidatedCollateral,
        uint256 reward
    );
    event UpdateInterestRate(uint256 elapsedTime, uint64 newInterestRate);
    event AccruedInterest(
        uint64 interestRatePerSec,
        uint256 interestEarned,
        uint256 feesAmount,
        uint256 feesShare
    );
    event NewVaultSetup(address token, VaultSetupParams params);

    constructor(
        address daiAddress,
        address daiPriceFeed,
        VaultSetupParams memory daiVaultParams
    ) {
        _setupVault(
            daiAddress,
            daiPriceFeed,
            TokenType.ERC20,
            daiVaultParams,
            true
        );
    }

    function supply(
        address token,
        uint256 amount,
        uint256 minSharesOut
    ) external {
        _accrueInterest(token);

        _transferERC20(token, msg.sender, address(this), amount);
        uint256 shares = _toShares(vaults[token].totalAsset, amount, false);
        require(shares >= minSharesOut, "LendingPool: too high slippage");

        vaults[token].totalAsset.shares += uint128(shares);
        vaults[token].totalAsset.amount += uint128(amount);
        userShares[msg.sender][token].collateral += shares;

        emit Deposit(msg.sender, token, amount, shares);
    }

    function borrow(address token, uint256 amount) external {
        require(vaultAboveReserveRatio(token, amount), "LendingPool: insufficient balance");
        _accrueInterest(token);

        uint256 shares = _toShares(vaults[token].totalBorrow, amount, false);
        vaults[token].totalBorrow.shares += uint128(shares);
        vaults[token].totalBorrow.amount += uint128(amount);
        userShares[msg.sender][token].borrow += shares;

        _transferERC20(token, address(this), msg.sender, amount);
        require(
            healthFactor(msg.sender) >= MIN_HEALTH_FACTOR,
            "LendingPool: cannot borrow, account below health factor"
        );

        emit Borrow(msg.sender, token, amount, shares);
    }

    function repay(address token, uint256 amount) external {
        _accrueInterest(token);
        uint256 userBorrowShare = userShares[msg.sender][token].borrow;
        uint256 shares = _toShares(vaults[token].totalBorrow, amount, true);
        if (amount == UINT256_MAX || shares > userBorrowShare) {
            shares = userBorrowShare;
            amount = _toAmount(vaults[token].totalBorrow, shares, true);
        }
        _transferERC20(token, msg.sender, address(this), amount);
        vaults[token].totalBorrow.shares -= uint128(shares);
        vaults[token].totalBorrow.amount -= uint128(amount);
        userShares[msg.sender][token].borrow = userBorrowShare - shares;
        emit Repay(msg.sender, token, amount, shares);
    }

    function withdraw(
        address token,
        uint256 amount,
        uint256 maxSharesIn
    ) external {
        _withdraw(token, amount, maxSharesIn, false);
    }

    function redeem(
        address token,
        uint256 shares,
        uint256 minAmountOut
    ) external {
        _withdraw(token, shares, minAmountOut, true);
    }

    function liquidate(
        address account,
        address collateral,
        address userBorrowToken,
        uint256 amountToLiquidate
    ) external {
        require(msg.sender != account, "LendingPool: borrower cannot self liquidate");
        uint256 accountHF = healthFactor(account);
        require(accountHF < MIN_HEALTH_FACTOR, "LendingPool: borrower is solvant");
        uint256 collateralShares = userShares[account][collateral].collateral;
        uint256 borrowShares = userShares[account][userBorrowToken].borrow;
        if (collateralShares == 0 || borrowShares == 0) return;
        {
            uint256 totalBorrowAmount = _toAmount(
                vaults[userBorrowToken].totalBorrow,
                borrowShares,
                true
            );

            uint256 maxBorrowAmountToLiquidate = accountHF >=
                CLOSE_FACTOR_HF_THRESHOLD
                ? (totalBorrowAmount * DEFAULT_LIQUIDATION_CLOSE_FACTOR) / BPS
                : totalBorrowAmount;
            amountToLiquidate = amountToLiquidate > maxBorrowAmountToLiquidate
                ? maxBorrowAmountToLiquidate
                : amountToLiquidate;
        }

        uint256 collateralAmountToLiquidate;
        uint256 liquidationReward;
        {
            address user = account;
            address borrowToken = userBorrowToken;
            address collToken = collateral;
            uint256 liquidationAmount = amountToLiquidate;

            uint256 _userTotalCollateralAmount = _toAmount(
                vaults[collToken].totalAsset,
                collateralShares,
                false
            );

            collateralAmountToLiquidate =
                (liquidationAmount *
                    getTokenPrice(borrowToken) *
                    10 ** IERC20(collToken).decimals()) /
                (getTokenPrice(collToken) *
                    10 ** IERC20(borrowToken).decimals());
            uint256 maxLiquidationReward = (collateralAmountToLiquidate *
                LIQUIDATION_REWARD) / BPS;
            if (collateralAmountToLiquidate > _userTotalCollateralAmount) {
                collateralAmountToLiquidate = _userTotalCollateralAmount;
                liquidationAmount =
                    ((_userTotalCollateralAmount *
                        getTokenPrice(collToken) *
                        10 ** IERC20(borrowToken).decimals()) /
                        getTokenPrice(borrowToken)) *
                    10 ** IERC20(collToken).decimals();
                amountToLiquidate = liquidationAmount;
            } else {
                uint256 collateralBalanceAfter = _userTotalCollateralAmount -
                    collateralAmountToLiquidate;
                liquidationReward = maxLiquidationReward >
                    collateralBalanceAfter
                    ? collateralBalanceAfter
                    : maxLiquidationReward;
            }

            uint128 repaidBorrowShares = uint128(
                _toShares(
                    vaults[borrowToken].totalBorrow,
                    liquidationAmount,
                    false
                )
            );
            vaults[borrowToken].totalBorrow.shares -= repaidBorrowShares;
            vaults[borrowToken].totalBorrow.amount -= uint128(
                liquidationAmount
            );

            uint128 liquidatedCollShares = uint128(
                _toShares(
                    vaults[collToken].totalAsset,
                    collateralAmountToLiquidate + liquidationReward,
                    false
                )
            );
            vaults[collToken].totalAsset.shares -= liquidatedCollShares;
            vaults[collToken].totalAsset.amount -= uint128(
                collateralAmountToLiquidate + liquidationReward
            );
            userShares[user][borrowToken].borrow -= repaidBorrowShares;
            userShares[user][collToken].collateral -= liquidatedCollShares;
        }

        _transferERC20(
            userBorrowToken,
            msg.sender,
            address(this),
            amountToLiquidate
        );
        _transferERC20(
            collateral,
            address(this),
            msg.sender,
            collateralAmountToLiquidate + liquidationReward
        );

        emit Liquidated(
            account,
            msg.sender,
            amountToLiquidate,
            collateralAmountToLiquidate + liquidationReward,
            liquidationReward
        );
    }

    function getUserData(
        address user
    ) public returns (uint256[] memory returndata) {
        returndata = new uint256[](2);

        returndata[0] = getUserTotalTokenCollateral(user);
        returndata[1] = getUserTotalBorrow(user);
    }

    function getUserTotalTokenCollateral(
        address user
    ) public returns (uint256 totalValueUSD) {
        uint256 len = supportedERC20s.length;
        for (uint256 i; i < len; i++) {
            address token = supportedERC20s[i];
            uint256 tokenAmount = _toAmount(
                vaults[token].totalAsset,
                userShares[user][token].collateral,
                false
            );
            if (tokenAmount != 0) {
                totalValueUSD += getAmountInUSD(token, tokenAmount);
            }
        }
    }

    function getUserTotalBorrow(
        address user
    ) public returns (uint256 totalValueUSD) {
        uint256 len = supportedERC20s.length;
        for (uint256 i; i < len; i++) {
            address token = supportedERC20s[i];
            uint256 tokenAmount = _toAmount(
                vaults[token].totalBorrow,
                userShares[user][token].borrow,
                false
            );
            if (tokenAmount != 0) {
                totalValueUSD += getAmountInUSD(token, tokenAmount);
            }
        }
    }

    function getUserTokenCollateralAndBorrow(
        address user,
        address token
    ) external returns (uint256[] memory returndata) {
        returndata = new uint256[](2);
        returndata[0] = userShares[user][token].collateral;
        returndata[1] = userShares[user][token].borrow;
    }

    function healthFactor(address user) public returns (uint256 factor) {
        uint256[] memory returndata = getUserData(user);

        uint256 userTotalCollateralValue = returndata[0];
        if (returndata[1] == 0) return 100 * MIN_HEALTH_FACTOR;
        uint256 collateralValueWithThreshold = (userTotalCollateralValue *
            LIQUIDATION_THRESHOLD) / BPS;
        factor =
            (collateralValueWithThreshold * MIN_HEALTH_FACTOR) /
            returndata[1];
    }

    function getAmountInUSD(
        address token,
        uint256 amount
    ) public returns (uint256 value) {
        uint256 price = getTokenPrice(token);
        uint8 decimals = IERC20(token).decimals();
        uint256 amountIn18Decimals = amount * 10 ** (18 - decimals);
        // return USD value scaled by 18 decimals
        value = (amountIn18Decimals * price) / PRECISION;
    }

    function getTokenVault(
        address token
    ) public returns (TokenVault memory vault) {
        vault = vaults[token];
    }

    function amountToShares(
        address token,
        uint256 amount,
        bool isAsset
    ) external returns (uint256 shares) {
        if (isAsset) {
            shares = uint256(
                _toShares(vaults[token].totalAsset, amount, false)
            );
        } else {
            shares = uint256(
                _toShares(vaults[token].totalBorrow, amount, false)
            );
        }
    }

    function sharesToAmount(
        address token,
        uint256 shares,
        bool isAsset
    ) external returns (uint256 amount) {
        if (isAsset) {
            amount = uint256(
                _toAmount(vaults[token].totalAsset, shares, false)
            );
        } else {
            amount = uint256(
                _toAmount(vaults[token].totalBorrow, shares, false)
            );
        }
    }

    function setupVault(
        address token,
        address priceFeed,
        TokenType tokenType,
        VaultSetupParams memory params,
        bool addToken
    ) external {
        _setupVault(token, priceFeed, tokenType, params, addToken);
    }

    function vaultAboveReserveRatio(
        address token,
        uint256 pulledAmount
    ) internal returns (bool isAboveReserveRatio) {
        uint256 minVaultReserve = (vaults[token].totalAsset.amount *
            vaults[token].vaultInfo.reserveRatio) / BPS;
        isAboveReserveRatio =
            vaults[token].totalAsset.amount != 0 &&
            IERC20(token).balanceOf(address(this)) >=
            minVaultReserve + pulledAmount;
    }

    function _withdraw(
        address token,
        uint256 amount,
        uint256 minAmountOutOrMaxShareIn,
        bool share
    ) internal {
        _accrueInterest(token);
        uint256 userCollShares = userShares[msg.sender][token].collateral;
        uint256 shares;
        if (share) {
            shares = amount;
            amount = _toAmount(vaults[token].totalAsset, shares, false);
            require(amount >= minAmountOutOrMaxShareIn, "LendingPool: too high slippage");
        } else {
            shares = _toShares(vaults[token].totalAsset, amount, false);
            require(shares <= minAmountOutOrMaxShareIn, "LendingPool: too high slippage");
        }
        require(
            userCollShares >= shares && IERC20(token).balanceOf(address(this)) >= amount,
            "LendingPool: insufficient balance"
        );
        vaults[token].totalAsset.shares -= uint128(shares);
        vaults[token].totalAsset.amount -= uint128(amount);
        userShares[msg.sender][token].collateral -= shares;

        _transferERC20(token, address(this), msg.sender, amount);
        require(
            healthFactor(msg.sender) >= MIN_HEALTH_FACTOR,
            "LendingPool: cannot withdraw, account below health factor"
        );
        emit Withdraw(msg.sender, token, amount, shares);
    }

    function _accrueInterest(address token) internal {
        uint256 _interestEarned;
        uint256 _feesAmount;
        uint256 _feesShare;
        uint64 newRate;

        TokenVault memory _vault = vaults[token];
        if (_vault.totalAsset.amount == 0) {
            return;
        }

        VaultInfo memory _currentRateInfo = _vault.vaultInfo;
        if (_currentRateInfo.lastTimestamp == block.timestamp) {
            newRate = _currentRateInfo.ratePerSec;
            return;
        }

        if (_vault.totalBorrow.shares == 0) {
            _currentRateInfo.lastTimestamp = uint64(block.timestamp);
            _currentRateInfo.lastBlock = uint64(block.number);
            _vault.vaultInfo = _currentRateInfo;
        } else {
            uint256 _deltaTime = block.number - _currentRateInfo.lastBlock;
            uint256 _utilization = (_vault.totalBorrow.amount * PRECISION) /
                _vault.totalAsset.amount;
            uint256 _newRate = _calculateInterestRate(
                _currentRateInfo,
                _utilization
            );
            _currentRateInfo.ratePerSec = uint64(_newRate);
            _currentRateInfo.lastTimestamp = uint64(block.timestamp);
            _currentRateInfo.lastBlock = uint64(block.number);

            emit UpdateInterestRate(_deltaTime, uint64(_newRate));

            _interestEarned =
                (_deltaTime *
                    _vault.totalBorrow.amount *
                    _currentRateInfo.ratePerSec) /
                (PRECISION * BLOCKS_PER_YEAR);

            _vault.totalBorrow.amount += uint128(_interestEarned);
            _vault.totalAsset.amount += uint128(_interestEarned);
            _vault.vaultInfo = _currentRateInfo;
            if (_currentRateInfo.feeToProtocolRate > 0) {
                _feesAmount =
                    (_interestEarned * _currentRateInfo.feeToProtocolRate) /
                    BPS;
                _feesShare =
                    (_feesAmount * _vault.totalAsset.shares) /
                    (_vault.totalAsset.amount - _feesAmount);
                _vault.totalAsset.shares += uint128(_feesShare);

                userShares[address(this)][token].collateral += _feesShare;
            }
            emit AccruedInterest(
                _currentRateInfo.ratePerSec,
                _interestEarned,
                _feesAmount,
                _feesShare
            );
        }
        vaults[token] = _vault;
    }

    function _setupVault(
        address token,
        address priceFeed,
        TokenType tokenType,
        VaultSetupParams memory params,
        bool addToken
    ) internal {
        if (addToken) {
            _addSupportedToken(token, priceFeed, tokenType);
        }
        if (tokenType == TokenType.ERC20) {
            require(
                params.reserveRatio <= BPS,
                "LendingPool: invalid reserve ratio"
            );
            require(
                params.feeToProtocolRate <= MAX_PROTOCOL_FEE,
                "LendingPool: invalid fee to protocol rate"
            );
            require(
                params.flashFeeRate <= MAX_PROTOCOL_FEE,
                "LendingPool: invalid flash fee rate"
            );
            VaultInfo storage _vaultInfo = vaults[token].vaultInfo;
            _vaultInfo.reserveRatio = params.reserveRatio;
            _vaultInfo.feeToProtocolRate = params.feeToProtocolRate;
            _vaultInfo.flashFeeRate = params.flashFeeRate;
            _vaultInfo.optimalUtilization = params.optimalUtilization;
            _vaultInfo.baseRate = params.baseRate;
            _vaultInfo.slope1 = params.slope1;
            _vaultInfo.slope2 = params.slope2;

            emit NewVaultSetup(token, params);
        }
    }

    function _addSupportedToken(
        address token,
        address priceFeed,
        TokenType tokenType
    ) internal {
        require(
            !supportedTokens[token].supported,
            "LendingPool: adding support for already supported token"
        );
        require(
            uint256(tokenType) <= 1,
            "LendingPool: invalid token type"
        );

        supportedTokens[token].usdPriceFeed = priceFeed;
        supportedTokens[token].tokenType = tokenType;
        supportedTokens[token].supported = true;

        if (tokenType == TokenType.ERC721) {
            supportedNFTs.push(token);
        } else {
            supportedERC20s.push(token);
        }

        emit AddSupportedToken(token, tokenType);
    }

    function getTokenPrice(address token) public returns (uint256 price) {
        if (!supportedTokens[token].supported) return 0;
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            supportedTokens[token].usdPriceFeed
        );
        price = _getPrice(priceFeed);
    }
    function _getPrice(
        AggregatorV3Interface priceFeed
    ) internal returns (uint256 price) {
        uint256[] memory returndata = priceFeed.latestRoundData();
        uint256 roundId = returndata[0];
        uint256 answer = returndata[1];
        uint256 updatedAt = returndata[3];
        uint256 answeredInRound = returndata[4];

        require(
            answer > 0 && updatedAt != 0 && answeredInRound >= roundId,
            "LendingPool: invalid price for token"
        );

        price = answer;
    }

    function _transferERC20(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        bool success;
        if (_from == address(this)) {
            success = IERC20(_token).transfer(_to, _amount);
        } else {
            success = IERC20(_token).transferFrom(_from, _to, _amount);
        }
        require(success, "LendingPool: transfer failed");
    }

    function _toShares(
        Vault memory total,
        uint256 amount,
        bool roundUp
    ) internal returns (uint256 shares) {
        if (total.amount == 0) {
            shares = amount;
        } else {
            shares = (amount * total.shares) / total.amount;
            if (roundUp && (shares * total.amount) / total.shares < amount) {
                shares = shares + 1;
            }
        }
    }

    function _toAmount(
        Vault memory total,
        uint256 shares,
        bool roundUp
    ) internal returns (uint256 amount) {
        if (total.shares == 0) {
            amount = shares;
        } else {
            amount = (shares * total.amount) / total.shares;
            if (roundUp && (amount * total.shares) / total.amount < shares) {
                amount = amount + 1;
            }
        }
    }

    function _calculateInterestRate(
        VaultInfo memory _interestRateInfo,
        uint256 utilization
    ) internal returns (uint256 newRatePerSec) {
        uint256 optimalUtilization = _interestRateInfo.optimalUtilization;
        uint256 baseRate = uint256(_interestRateInfo.baseRate);
        uint256 slope1 = uint256(_interestRateInfo.slope1);
        uint256 slope2 = uint256(_interestRateInfo.slope2);

        if (utilization <= optimalUtilization) {
            uint256 rate = (utilization * slope1) / optimalUtilization;
            newRatePerSec = baseRate + rate;
        } else {
            uint256 utilizationDelta = utilization - optimalUtilization;
            uint256 excessUtilizationRate = (utilizationDelta *
                RATE_PRECISION) / (RATE_PRECISION - optimalUtilization);
            newRatePerSec =
                baseRate +
                slope1 +
                (excessUtilizationRate * slope2) /
                RATE_PRECISION;
        }
    }
}
