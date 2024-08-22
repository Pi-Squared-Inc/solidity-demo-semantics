// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.25;

// The source code of this contract uses the following contracts from Lido v0.4.24
// Lido: https://github.com/lidofinance/core/blob/master/contracts/0.4.24/Lido.sol
// StETH: https://github.com/lidofinance/core/blob/master/contracts/0.4.24/StETH.sol

interface IPostTokenRebaseReceiver {
    function handlePostTokenRebase(
        uint256 _reportTimestamp,
        uint256 _timeElapsed,
        uint256 _preTotalShares,
        uint256 _preTotalEther,
        uint256 _postTotalShares,
        uint256 _postTotalEther,
        uint256 _sharesMintedAsFees
    ) external;
}

interface IOracleReportSanityChecker {
    function checkAccountingOracleReport(
        uint256 _timeElapsed,
        uint256 _preCLBalance,
        uint256 _postCLBalance,
        uint256 _withdrawalVaultBalance,
        uint256 _elRewardsVaultBalance,
        uint256 _sharesRequestedToBurn,
        uint256 _preCLValidators,
        uint256 _postCLValidators
    ) external;

    function smoothenTokenRebase(
        uint256 _preTotalPooledEther,
        uint256 _preTotalShares,
        uint256 _preCLBalance,
        uint256 _postCLBalance,
        uint256 _withdrawalVaultBalance,
        uint256 _elRewardsVaultBalance,
        uint256 _sharesRequestedToBurn,
        uint256 _etherToLockForWithdrawals,
        uint256 _newSharesToBurnForWithdrawals
    ) external returns (uint256[] memory return_data);

    function checkWithdrawalQueueOracleReport(
        uint256 _lastFinalizableRequestId,
        uint256 _reportTimestamp
    ) external;

    function checkSimulatedShareRate(
        uint256 _postTotalPooledEther,
        uint256 _postTotalShares,
        uint256 _etherLockedOnWithdrawalQueue,
        uint256 _sharesBurntDueToWithdrawals,
        uint256 _simulatedShareRate
    ) external;
}

interface ILidoExecutionLayerRewardsVault {
    function withdrawRewards(uint256 _maxAmount) external returns (uint256 amount);
}

interface IWithdrawalVault {
    function withdrawWithdrawals(uint256 _amount) external;
}

interface IStakingRouter {

    function deposit(
        uint256 _depositsCount,
        uint256 _stakingModuleId,
        bytes memory _depositCalldata
    ) external payable;

    function getStakingRewardsDistribution()
        external returns (Lido.StakingRewardsDistribution memory return_data);

    function reportRewardsMinted(uint256[] memory _stakingModuleIds, uint256[] memory _totalShares) external;

    function getStakingModuleMaxDepositsCount(uint256 _stakingModuleId, uint256 _maxDepositsValue)
        external
        returns (uint256);
}

interface IWithdrawalQueue {
    function prefinalize(uint256[] memory _batches, uint256 _maxShareRate)
        external returns (uint256[] memory return_data);

    function finalize(uint256 _lastIdToFinalize, uint256 _maxShareRate) external payable;

    function unfinalizedStETH() external returns (uint256);

    function isBunkerModeActive() external returns (bool);
}

interface IBurner {
    function commitSharesToBurn(uint256 _stETHSharesToBurn) external;
    function requestBurnShares(address _from, uint256 _sharesAmount) external;
}

interface ILidoLocatorMock{
    function burner() external returns(address);
    function stakingRouter() external returns(address);
    function treasury() external returns(address);
    function withdrawalQueue() external returns(address);
    function withdrawalVault() external returns(address);
    function elRewardsVault() external returns(address);
    function oracleReportComponentsForLido() external returns(address[] memory return_data);
}


contract Lido{

    uint256 private DEPOSIT_SIZE = 32 ether;

    address internal LIDO_LOCATOR_POSITION; 
    uint256 public BUFFERED_ETHER_POSITION; 
    uint256 internal DEPOSITED_VALIDATORS_POSITION; 
    uint256 internal CL_BALANCE_POSITION; 
    uint256 internal CL_VALIDATORS_POSITION; 
    uint256 internal TOTAL_EL_REWARDS_COLLECTED_POSITION; 

    /*stETH variables start*/
    address internal INITIAL_TOKEN_HOLDER = address(0xdead);
    uint256 internal INFINITE_ALLOWANCE = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    mapping (address => uint256) private shares;
    mapping (address => mapping (address => uint256)) private allowances;
    uint256 internal TOTAL_SHARES_POSITION;
    /*stETH variables end*/

    struct OracleReportedData {
        uint256 reportTimestamp;
        uint256 timeElapsed;
        uint256 clValidators;
        uint256 postCLBalance;
        uint256 withdrawalVaultBalance;
        uint256 elRewardsVaultBalance;
        uint256 sharesRequestedToBurn;
        uint256[] withdrawalFinalizationBatches;
        uint256 simulatedShareRate;
    }

    struct OracleReportContracts {
        address accountingOracle;
        address elRewardsVault;
        address oracleReportSanityChecker;
        address burner;
        address withdrawalQueue;
        address withdrawalVault;
        address postTokenRebaseReceiver;
    }

    struct StakingRewardsDistribution {
        address[] recipients;
        uint256[] moduleIds;
        uint256[] modulesFees;
        uint256 totalFee;
        uint256 precisionPoints;
    }
    
    struct StakingRewardsDistributionReturnData{
        StakingRewardsDistribution distributionData;
        IStakingRouter router;
    }

    struct OracleReportContext {
        uint256 preCLValidators;
        uint256 preCLBalance;
        uint256 preTotalPooledEther;
        uint256 preTotalShares;
        uint256 etherToLockOnWithdrawalQueue;
        uint256 sharesToBurnFromWithdrawalQueue;
        uint256 simulatedSharesToBurn;
        uint256 sharesToBurn;
        uint256 sharesMintedAsFees;
    }


    event CLValidatorsUpdated(
        uint256 indexed reportTimestamp,
        uint256 preCLValidators,
        uint256 postCLValidators
    );

    event DepositedValidatorsChanged(
        uint256 depositedValidators
    );

    event ETHDistributed(
        uint256 indexed reportTimestamp,
        uint256 preCLBalance,
        uint256 postCLBalance,
        uint256 withdrawalsWithdrawn,
        uint256 executionLayerRewardsWithdrawn,
        uint256 postBufferedEther
    );

    event TokenRebased(
        uint256 indexed reportTimestamp,
        uint256 timeElapsed,
        uint256 preTotalShares,
        uint256 preTotalEther,
        uint256 postTotalShares,
        uint256 postTotalEther,
        uint256 sharesMintedAsFees
    );

    event LidoLocatorSet(address lidoLocator);
    event ELRewardsReceived(uint256 amount);
    event WithdrawalsReceived(uint256 amount);
    event Submitted(address indexed sender, uint256 amount, address referral);
    event Unbuffered(uint256 amount);

    /*stETH events start*/
    event TransferShares(
        address indexed from,
        address indexed to,
        uint256 sharesValue
    );
 
    event SharesBurnt(
        address indexed account,
        uint256 preRebaseTokenAmount,
        uint256 postRebaseTokenAmount,
        uint256 sharesAmount
    );
    /*stETH events end*/

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function initialize(address _lidoLocator) public payable {
        uint256 balance = address(this).balance;
        assert(balance != 0);

        if (_getTotalShares() == 0) {
            _setBufferedEther(balance);
            emit Submitted(INITIAL_TOKEN_HOLDER, balance, address(0));
            _mintInitialShares(balance);
        }

        LIDO_LOCATOR_POSITION = _lidoLocator;

        _approve(
            ILidoLocatorMock(_lidoLocator).withdrawalQueue(),
            ILidoLocatorMock(_lidoLocator).burner(),
            INFINITE_ALLOWANCE
        );

        emit LidoLocatorSet(_lidoLocator);
    }

    function submit(address _referral) external payable returns (uint256) {
        return _submit(_referral);
    }

    function receiveELRewards() external payable {
        require(msg.sender == getLidoLocator().elRewardsVault());

        TOTAL_EL_REWARDS_COLLECTED_POSITION = getTotalELRewardsCollected() + msg.value;

        emit ELRewardsReceived(msg.value);
    }

    function receiveWithdrawals() external payable {
        require(msg.sender == getLidoLocator().withdrawalVault());

        emit WithdrawalsReceived(msg.value);
    }

    function handleOracleReport(
        uint256 _reportTimestamp,
        uint256 _timeElapsed,
        uint256 _clValidators,
        uint256 _clBalance,
        uint256 _withdrawalVaultBalance,
        uint256 _elRewardsVaultBalance,
        uint256 _sharesRequestedToBurn,
        uint256[] memory _withdrawalFinalizationBatches,
        uint256 _simulatedShareRate
    ) external returns (uint256[4] memory postRebaseAmounts) {

        return _handleOracleReport(
            OracleReportedData(
                _reportTimestamp,
                _timeElapsed,
                _clValidators,
                _clBalance,
                _withdrawalVaultBalance,
                _elRewardsVaultBalance,
                _sharesRequestedToBurn,
                _withdrawalFinalizationBatches,
                _simulatedShareRate
            )
        );
    }

    function getBufferedEther() external returns (uint256) {
        return BUFFERED_ETHER_POSITION;
    }

    function getTotalELRewardsCollected() public returns (uint256) {
        return TOTAL_EL_REWARDS_COLLECTED_POSITION;
    }

    function getLidoLocator() public returns (ILidoLocatorMock) {
        return ILidoLocatorMock(LIDO_LOCATOR_POSITION);
    }

    function getBeaconStat() external returns (uint256 depositedValidators, uint256 beaconValidators, uint256 beaconBalance) {
        depositedValidators = DEPOSITED_VALIDATORS_POSITION;
        beaconValidators = CL_VALIDATORS_POSITION;
        beaconBalance = CL_BALANCE_POSITION;
    }
    
    function getTreasury() external returns (address) {
        return _treasury();
    }

    function canDeposit() public returns (bool) {
        return !_withdrawalQueue().isBunkerModeActive();
    }

    function getDepositableEther() public returns (uint256) {
        uint256 bufferedEther = BUFFERED_ETHER_POSITION;
        uint256 withdrawalReserve = _withdrawalQueue().unfinalizedStETH();
        return bufferedEther > withdrawalReserve ? bufferedEther - withdrawalReserve : 0;
    }

    function deposit(uint256 _maxDepositsCount, uint256 _stakingModuleId, bytes memory _depositCalldata) external {
        //LidoLocatorMock locator = getLidoLocator();

        require(canDeposit(), "CAN_NOT_DEPOSIT");

        IStakingRouter stakingRouter = _stakingRouter();
        uint256 depositsCount = _min(
            _maxDepositsCount,
            stakingRouter.getStakingModuleMaxDepositsCount(_stakingModuleId, getDepositableEther())
        );

        uint256 depositsValue;
        if (depositsCount > 0) {
            depositsValue = depositsCount * DEPOSIT_SIZE;
            BUFFERED_ETHER_POSITION = BUFFERED_ETHER_POSITION - depositsValue;
            emit Unbuffered(depositsValue);

            uint256 newDepositedValidators = DEPOSITED_VALIDATORS_POSITION + depositsCount;
            DEPOSITED_VALIDATORS_POSITION = newDepositedValidators;
            emit DepositedValidatorsChanged(newDepositedValidators);
        }

        stakingRouter.deposit{value: depositsValue}(depositsCount, _stakingModuleId, _depositCalldata);
    }

    function _min(uint256 a, uint256 b) internal returns(uint256 min){
        min = a < b ? a : b;
    }

    function _processClStateUpdate(
        uint256 _reportTimestamp,
        uint256 _preClValidators,
        uint256 _postClValidators,
        uint256 _postClBalance
    ) internal returns (uint256 preCLBalance) {
        uint256 depositedValidators = DEPOSITED_VALIDATORS_POSITION;
        require(_postClValidators <= depositedValidators, "REPORTED_MORE_DEPOSITED");
        require(_postClValidators >= _preClValidators, "REPORTED_LESS_VALIDATORS");

        if (_postClValidators > _preClValidators) {
            CL_VALIDATORS_POSITION = _postClValidators;
        }

        uint256 appearedValidators = _postClValidators - _preClValidators;
        preCLBalance = CL_BALANCE_POSITION;
        preCLBalance = preCLBalance + appearedValidators * DEPOSIT_SIZE;

        CL_BALANCE_POSITION = _postClBalance;

        emit CLValidatorsUpdated(_reportTimestamp, _preClValidators, _postClValidators);
    }

    function _collectRewardsAndProcessWithdrawals(
        OracleReportContracts memory _contracts,
        uint256 _withdrawalsToWithdraw,
        uint256 _elRewardsToWithdraw,
        uint256[] memory _withdrawalFinalizationBatches,
        uint256 _simulatedShareRate,
        uint256 _etherToLockOnWithdrawalQueue
    ) internal {
        if (_elRewardsToWithdraw > 0) {
            ILidoExecutionLayerRewardsVault(_contracts.elRewardsVault).withdrawRewards(_elRewardsToWithdraw);
        }

        if (_withdrawalsToWithdraw > 0) {
            IWithdrawalVault(_contracts.withdrawalVault).withdrawWithdrawals(_withdrawalsToWithdraw);
        }

        if (_etherToLockOnWithdrawalQueue > 0) {
            IWithdrawalQueue withdrawalQueue = IWithdrawalQueue(_contracts.withdrawalQueue);
            withdrawalQueue.finalize{value: _etherToLockOnWithdrawalQueue}(
                _withdrawalFinalizationBatches[_withdrawalFinalizationBatches.length - 1],
                _simulatedShareRate
            );
        }

        uint256 postBufferedEther = BUFFERED_ETHER_POSITION + _elRewardsToWithdraw + _withdrawalsToWithdraw - _etherToLockOnWithdrawalQueue; 

        _setBufferedEther(postBufferedEther);
    }

    function _calculateWithdrawals(
        OracleReportContracts memory _contracts,
        OracleReportedData memory _reportedData
    ) internal returns (uint256[] memory return_data) {
        IWithdrawalQueue withdrawalQueue = IWithdrawalQueue(_contracts.withdrawalQueue);

        IOracleReportSanityChecker(_contracts.oracleReportSanityChecker).checkWithdrawalQueueOracleReport(
            _reportedData.withdrawalFinalizationBatches[_reportedData.withdrawalFinalizationBatches.length - 1],
            _reportedData.reportTimestamp
        );

        return withdrawalQueue.prefinalize(
            _reportedData.withdrawalFinalizationBatches,
            _reportedData.simulatedShareRate
        );
    }

    function _processRewards(
        OracleReportContext memory _reportContext,
        uint256 _postCLBalance,
        uint256 _withdrawnWithdrawals,
        uint256 _withdrawnElRewards
    ) internal returns (uint256 sharesMintedAsFees) {
        uint256 postCLTotalBalance = _postCLBalance + _withdrawnWithdrawals;
        if (postCLTotalBalance > _reportContext.preCLBalance) {
            uint256 consensusLayerRewards = postCLTotalBalance - _reportContext.preCLBalance;

            sharesMintedAsFees = _distributeFee(
                _reportContext.preTotalPooledEther,
                _reportContext.preTotalShares,
                consensusLayerRewards + _withdrawnElRewards
            );
        }
    }

    function _submit(address _referral) internal returns (uint256) {
        require(msg.value != 0, "ZERO_DEPOSIT");

        uint256 sharesAmount = getSharesByPooledEth(msg.value);

        _mintShares(msg.sender, sharesAmount);

        _setBufferedEther(BUFFERED_ETHER_POSITION + msg.value);
        emit Submitted(msg.sender, msg.value, _referral);

        _emitTransferAfterMintingShares(msg.sender, sharesAmount);
        return sharesAmount;
    }

    function _getStakingRewardsDistribution() internal returns (StakingRewardsDistributionReturnData memory return_data) {
        return_data.router = _stakingRouter();
        return_data.distributionData = return_data.router.getStakingRewardsDistribution();
        
        require(return_data.distributionData.recipients.length == return_data.distributionData.modulesFees.length, "WRONG_RECIPIENTS_INPUT");
        require(return_data.distributionData.moduleIds.length == return_data.distributionData.modulesFees.length, "WRONG_MODULE_IDS_INPUT");
    }

    function _distributeFee(
        uint256 _preTotalPooledEther,
        uint256 _preTotalShares,
        uint256 _totalRewards
    ) internal returns (uint256 sharesMintedAsFees) {
        StakingRewardsDistributionReturnData memory return_data = _getStakingRewardsDistribution();
        StakingRewardsDistribution memory rewardsDistribution = return_data.distributionData;
        IStakingRouter router = return_data.router;

        if (rewardsDistribution.totalFee > 0) {
            uint256 totalPooledEtherWithRewards = _preTotalPooledEther + _totalRewards;

            sharesMintedAsFees =
                _totalRewards * rewardsDistribution.totalFee * _preTotalShares / 
                         ( totalPooledEtherWithRewards * rewardsDistribution.precisionPoints - ( _totalRewards*rewardsDistribution.totalFee ) );

            _mintShares(address(this), sharesMintedAsFees);

            uint256[] memory moduleRewardsAndTotal = _transferModuleRewards(
                                                        rewardsDistribution.recipients,
                                                        rewardsDistribution.modulesFees,
                                                        rewardsDistribution.totalFee,
                                                        sharesMintedAsFees
                                                    );
            uint256 totalModuleRewards = moduleRewardsAndTotal[moduleRewardsAndTotal.length - 1];
            uint256[] memory moduleRewards = new uint256[](moduleRewardsAndTotal.length - 1);

            for(uint i =0; i<moduleRewards.length; i++)
                moduleRewards[i] = moduleRewardsAndTotal[i];

            _transferTreasuryRewards(sharesMintedAsFees - totalModuleRewards);

            router.reportRewardsMinted(
                rewardsDistribution.moduleIds,
                moduleRewards
            );
        }
    }

    function _transferModuleRewards(
        address[] memory recipients,
        uint256[] memory modulesFees,
        uint256 totalFee,
        uint256 totalRewards
    ) internal returns (uint256[] memory moduleRewardsAndTotal) {
        moduleRewardsAndTotal = new uint256[](recipients.length + 1);
        uint256 totalModuleRewards;

        for (uint256 i; i < recipients.length; ++i) {
            if (modulesFees[i] > 0) {
                uint256 iModuleRewards = totalRewards * modulesFees[i] / totalFee;
                moduleRewardsAndTotal[i] = iModuleRewards;
                _transferShares(address(this), recipients[i], iModuleRewards);
                _emitTransferAfterMintingShares(recipients[i], iModuleRewards);
                totalModuleRewards = totalModuleRewards + iModuleRewards;
            }
        }
        moduleRewardsAndTotal[recipients.length] = totalModuleRewards;
    }

    function _transferTreasuryRewards(uint256 treasuryReward) internal {
        address treasury = _treasury();
        _transferShares(address(this), treasury, treasuryReward);
        _emitTransferAfterMintingShares(treasury, treasuryReward);
    }

    function _setBufferedEther(uint256 _newBufferedEther) internal {
        BUFFERED_ETHER_POSITION = _newBufferedEther;
    }

    function _getTransientBalance() internal returns (uint256) {
        uint256 depositedValidators = DEPOSITED_VALIDATORS_POSITION;
        uint256 clValidators = CL_VALIDATORS_POSITION;
        assert(depositedValidators >= clValidators);
        return (depositedValidators - clValidators) * DEPOSIT_SIZE;
    }

    function _getTotalPooledEther() internal returns (uint256) {
        return BUFFERED_ETHER_POSITION + CL_BALANCE_POSITION + _getTransientBalance();
    }

    function _handleOracleReport(OracleReportedData memory _reportedData) internal returns (uint256[4] memory) {
        OracleReportContracts memory contracts = _loadOracleReportContracts();

        require(msg.sender == contracts.accountingOracle, "APP_AUTH_FAILED");
        require(_reportedData.reportTimestamp <= block.timestamp, "INVALID_REPORT_TIMESTAMP");

        OracleReportContext memory reportContext;

        reportContext.preTotalPooledEther = _getTotalPooledEther();
        reportContext.preTotalShares = _getTotalShares();
        reportContext.preCLValidators = CL_VALIDATORS_POSITION;
        reportContext.preCLBalance = _processClStateUpdate(
            _reportedData.reportTimestamp,
            reportContext.preCLValidators,
            _reportedData.clValidators,
            _reportedData.postCLBalance
        );

        _checkAccountingOracleReport(contracts, _reportedData, reportContext);

        if (_reportedData.withdrawalFinalizationBatches.length != 0) {
            uint256[] memory withdrawals_return_data = _calculateWithdrawals(contracts, _reportedData);
            reportContext.etherToLockOnWithdrawalQueue = withdrawals_return_data[0];
            reportContext.sharesToBurnFromWithdrawalQueue = withdrawals_return_data[1];

            if (reportContext.sharesToBurnFromWithdrawalQueue > 0) {
                IBurner(contracts.burner).requestBurnShares(
                    contracts.withdrawalQueue,
                    reportContext.sharesToBurnFromWithdrawalQueue
                );
            }
        }

        uint256 withdrawals;
        uint256 elRewards;
        
        uint256[] memory sanity_checker_return_data = IOracleReportSanityChecker(contracts.oracleReportSanityChecker).smoothenTokenRebase(
            reportContext.preTotalPooledEther,
            reportContext.preTotalShares,
            reportContext.preCLBalance,
            _reportedData.postCLBalance,
            _reportedData.withdrawalVaultBalance,
            _reportedData.elRewardsVaultBalance,
            _reportedData.sharesRequestedToBurn,
            reportContext.etherToLockOnWithdrawalQueue,
            reportContext.sharesToBurnFromWithdrawalQueue
        );
        
        withdrawals = sanity_checker_return_data[0];
        elRewards = sanity_checker_return_data[1];
        reportContext.simulatedSharesToBurn = sanity_checker_return_data[2];
        reportContext.sharesToBurn = sanity_checker_return_data[3];

        _collectRewardsAndProcessWithdrawals(
            contracts,
            withdrawals,
            elRewards,
            _reportedData.withdrawalFinalizationBatches,
            _reportedData.simulatedShareRate,
            reportContext.etherToLockOnWithdrawalQueue
        );

        emit ETHDistributed(
            _reportedData.reportTimestamp,
            reportContext.preCLBalance,
            _reportedData.postCLBalance,
            withdrawals,
            elRewards,
            BUFFERED_ETHER_POSITION
        );

        if (reportContext.sharesToBurn > 0) {
            IBurner(contracts.burner).commitSharesToBurn(reportContext.sharesToBurn);
            _burnShares(contracts.burner, reportContext.sharesToBurn);
        }

        reportContext.sharesMintedAsFees = _processRewards(
            reportContext,
            _reportedData.postCLBalance,
            withdrawals,
            elRewards
        );

        uint256[] memory token_rebase_return_data = _completeTokenRebase(
            _reportedData,
            reportContext,
            IPostTokenRebaseReceiver(contracts.postTokenRebaseReceiver)
        );
        
        uint256 postTotalShares = token_rebase_return_data[0];
        uint256 postTotalPooledEther = token_rebase_return_data[1];

        if (_reportedData.withdrawalFinalizationBatches.length != 0) {
            IOracleReportSanityChecker(contracts.oracleReportSanityChecker).checkSimulatedShareRate(
                postTotalPooledEther,
                postTotalShares,
                reportContext.etherToLockOnWithdrawalQueue,
                reportContext.sharesToBurn - reportContext.simulatedSharesToBurn,
                _reportedData.simulatedShareRate
            );
        }

        return [postTotalPooledEther, postTotalShares, withdrawals, elRewards];
    }

    function _checkAccountingOracleReport(
        OracleReportContracts memory _contracts,
        OracleReportedData memory _reportedData,
        OracleReportContext memory _reportContext
    ) internal {
        IOracleReportSanityChecker(_contracts.oracleReportSanityChecker).checkAccountingOracleReport(
            _reportedData.timeElapsed,
            _reportContext.preCLBalance,
            _reportedData.postCLBalance,
            _reportedData.withdrawalVaultBalance,
            _reportedData.elRewardsVaultBalance,
            _reportedData.sharesRequestedToBurn,
            _reportContext.preCLValidators,
            _reportedData.clValidators
        );
    }

 
    function _completeTokenRebase(
        OracleReportedData memory _reportedData,
        OracleReportContext memory _reportContext,
        IPostTokenRebaseReceiver _postTokenRebaseReceiver
    ) internal returns (uint256[] memory return_data) {
        return_data = new uint256[](2);

        uint256 postTotalShares = _getTotalShares();
        uint256 postTotalPooledEther = _getTotalPooledEther();
        
        return_data[0] = postTotalShares;
        return_data[1] = postTotalPooledEther;
        
        if (address(_postTokenRebaseReceiver) != address(0)) {
            _postTokenRebaseReceiver.handlePostTokenRebase(
                _reportedData.reportTimestamp,
                _reportedData.timeElapsed,
                _reportContext.preTotalShares,
                _reportContext.preTotalPooledEther,
                postTotalShares,
                postTotalPooledEther,
                _reportContext.sharesMintedAsFees
            );
        }

        emit TokenRebased(
            _reportedData.reportTimestamp,
            _reportedData.timeElapsed,
            _reportContext.preTotalShares,
            _reportContext.preTotalPooledEther,
            postTotalShares,
            postTotalPooledEther,
            _reportContext.sharesMintedAsFees
        );
    }

    function _loadOracleReportContracts() internal returns (OracleReportContracts memory ret) {
        address[] memory oracle_report_components_return_data = getLidoLocator().oracleReportComponentsForLido();

        ret.accountingOracle = oracle_report_components_return_data[0];
        ret.elRewardsVault = oracle_report_components_return_data[1];
        ret.oracleReportSanityChecker = oracle_report_components_return_data[2];
        ret.burner = oracle_report_components_return_data[3];
        ret.withdrawalQueue = oracle_report_components_return_data[4];
        ret.withdrawalVault = oracle_report_components_return_data[5];
        ret.postTokenRebaseReceiver = oracle_report_components_return_data[6];
         
    }

    function _stakingRouter() internal returns (IStakingRouter) {
        return IStakingRouter(getLidoLocator().stakingRouter());
    }

    function _withdrawalQueue() internal returns (IWithdrawalQueue) {
        return IWithdrawalQueue(getLidoLocator().withdrawalQueue());
    }

    function _treasury() internal returns (address) {
        return getLidoLocator().treasury();
    }

    /*stETH methods start*/

    function name() external returns (string memory) {
        return "Liquid staked Ether 2.0";
    }

 
    function symbol() external returns (string memory) {
        return "stETH";
    }

    function decimals() external returns (uint8) {
        return 18;
    }

    function totalSupply() external returns (uint256) {
        return _getTotalPooledEther();
    }

    function getTotalPooledEther() external returns (uint256) {
        return _getTotalPooledEther();
    }


    function balanceOf(address _account) external returns (uint256) {
        return getPooledEthByShares(_sharesOf(_account));
    }

    function transfer(address _recipient, uint256 _amount) external returns (bool) {
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }


    function allowance(address _owner, address _spender) external returns (uint256) {
        return allowances[_owner][_spender];
    }

 
    function approve(address _spender, uint256 _amount) external returns (bool) {
        _approve(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool) {
        _spendAllowance(_sender, msg.sender, _amount);
        _transfer(_sender, _recipient, _amount);
        return true;
    }

    function getTotalShares() external returns (uint256) {
        return _getTotalShares();
    }
  
    function sharesOf(address _account) external returns (uint256) {
        return _sharesOf(_account);
    }

    function getSharesByPooledEth(uint256 _ethAmount) public returns (uint256) {
        return _ethAmount * _getTotalShares() / _getTotalPooledEther();
    }
    function getPooledEthByShares(uint256 _sharesAmount) public returns (uint256) {
        return _sharesAmount * _getTotalPooledEther() / _getTotalShares();
    }


    function transferShares(address _recipient, uint256 _sharesAmount) external returns (uint256) {
        _transferShares(msg.sender, _recipient, _sharesAmount);
        uint256 tokensAmount = getPooledEthByShares(_sharesAmount);
        _emitTransferEvents(msg.sender, _recipient, tokensAmount, _sharesAmount);
        return tokensAmount;
    }

    function transferSharesFrom(
        address _sender, address _recipient, uint256 _sharesAmount
    ) external returns (uint256) {
        uint256 tokensAmount = getPooledEthByShares(_sharesAmount);
        _spendAllowance(_sender, msg.sender, tokensAmount);
        _transferShares(_sender, _recipient, _sharesAmount);
        _emitTransferEvents(_sender, _recipient, tokensAmount, _sharesAmount);
        return tokensAmount;
    }

    function _transfer(address _sender, address _recipient, uint256 _amount) internal {
        uint256 _sharesToTransfer = getSharesByPooledEth(_amount);
        _transferShares(_sender, _recipient, _sharesToTransfer);
        _emitTransferEvents(_sender, _recipient, _amount, _sharesToTransfer);
    }


    function _approve(address _owner, address _spender, uint256 _amount) internal {
        require(_owner != address(0), "APPROVE_FROM_ZERO_ADDR");
        require(_spender != address(0), "APPROVE_TO_ZERO_ADDR");

        allowances[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
    }

    function _spendAllowance(address _owner, address _spender, uint256 _amount) internal {
        uint256 currentAllowance = allowances[_owner][_spender];
        if (currentAllowance != INFINITE_ALLOWANCE) {
            require(currentAllowance >= _amount, "ALLOWANCE_EXCEEDED");
            _approve(_owner, _spender, currentAllowance - _amount);
        }
    }

    function _getTotalShares() internal returns (uint256) {
        return TOTAL_SHARES_POSITION;
    }

    function _sharesOf(address _account) internal returns (uint256) {
        return shares[_account];
    }

    function _transferShares(address _sender, address _recipient, uint256 _sharesAmount) internal {
        require(_sender != address(0), "TRANSFER_FROM_ZERO_ADDR");
        require(_recipient != address(0), "TRANSFER_TO_ZERO_ADDR");
        require(_recipient != address(this), "TRANSFER_TO_STETH_CONTRACT");

        uint256 currentSenderShares = shares[_sender];
        require(_sharesAmount <= currentSenderShares, "BALANCE_EXCEEDED");

        shares[_sender] = currentSenderShares - _sharesAmount;
        shares[_recipient] = shares[_recipient] + _sharesAmount;
    }

    function _mintShares(address _recipient, uint256 _sharesAmount) internal returns (uint256 newTotalShares) {
        require(_recipient != address(0), "MINT_TO_ZERO_ADDR");

        newTotalShares = _getTotalShares() + _sharesAmount;
        TOTAL_SHARES_POSITION = newTotalShares;

        shares[_recipient] = shares[_recipient] + _sharesAmount;

    }

    function _burnShares(address _account, uint256 _sharesAmount) internal returns (uint256 newTotalShares) {
        require(_account != address(0), "BURN_FROM_ZERO_ADDR");

        uint256 accountShares = shares[_account];
        require(_sharesAmount <= accountShares, "BALANCE_EXCEEDED");

        uint256 preRebaseTokenAmount = getPooledEthByShares(_sharesAmount);

        newTotalShares = _getTotalShares() - _sharesAmount;
        TOTAL_SHARES_POSITION = newTotalShares;

        shares[_account] = accountShares - _sharesAmount;

        uint256 postRebaseTokenAmount = getPooledEthByShares(_sharesAmount);

        emit SharesBurnt(_account, preRebaseTokenAmount, postRebaseTokenAmount, _sharesAmount);

    }

 
    function _emitTransferEvents(address _from, address _to, uint _tokenAmount, uint256 _sharesAmount) internal {
        emit Transfer(_from, _to, _tokenAmount);
        emit TransferShares(_from, _to, _sharesAmount);
    }


    function _emitTransferAfterMintingShares(address _to, uint256 _sharesAmount) internal {
        _emitTransferEvents(address(0), _to, getPooledEthByShares(_sharesAmount), _sharesAmount);
    }

    function _mintInitialShares(uint256 _sharesAmount) internal {
        _mintShares(INITIAL_TOKEN_HOLDER, _sharesAmount);
        _emitTransferAfterMintingShares(INITIAL_TOKEN_HOLDER, _sharesAmount);
    }
    
    /*stETH methods end*/

}

