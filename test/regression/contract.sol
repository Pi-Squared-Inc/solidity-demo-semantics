pragma solidity ^0.8.24;

interface IERC20 {
    function balanceOf(address owner) external returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

contract UniswapV2Swap {

    IERC20 public weth;
    IERC20 public dai;
    IERC20 public usdc;
    UniswapV2Router02 public router;

    constructor(address _weth, address _dai, address _usdc){
    }

    function swapSingleHopExactAmountIn(uint256 amountIn, uint256 amountOutMin)
        external
    {
    }

    function swapMultiHopExactAmountIn(uint256 amountIn, uint256 amountOutMin)
        external
    {
    }

    function swapSingleHopExactAmountOut(
        uint256 amountOutDesired,
        uint256 amountInMax
    ) external {
    }

    function swapMultiHopExactAmountOut(
        uint256 amountOutDesired,
        uint256 amountInMax
    ) external {
    }
}
