// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The source code of this contract uses the following contracts
// LiquidStaking: https://github.com/harsh08881/liquidstaking/blob/main/liquidstack.sol

interface IERC20 {
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}


contract LiquidStaking {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakedTimestamps;

    uint256 public stakingDuration = 30 days;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        stakedBalances[msg.sender] = stakedBalances[msg.sender] + amount;
        stakedTimestamps[msg.sender] = block.timestamp;
    }

    function unstake() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "No tokens staked");

        require(block.timestamp >= stakedTimestamps[msg.sender] + stakingDuration, "Staking period not over");

        uint256 rewards = calculateRewards(msg.sender);

        require(stakingToken.transfer(msg.sender, stakedAmount), "Token transfer failed");
        require(rewardToken.transfer(msg.sender, rewards), "Reward transfer failed");

        stakedBalances[msg.sender] = 0;
        stakedTimestamps[msg.sender] = 0;
    }

    function calculateRewards(address user) private returns (uint256) {
        uint256 stakedAmount = stakedBalances[user];
        uint256 stakingTime = block.timestamp - stakedTimestamps[user];

        uint256 annualInterestRate = 7;
        uint256 secondsInYear = 365 days;
        uint256 rewardRate = annualInterestRate * stakingTime / secondsInYear;

        uint256 rewards = (stakedAmount * rewardRate) / 100; 

        return rewards;
    }
}
