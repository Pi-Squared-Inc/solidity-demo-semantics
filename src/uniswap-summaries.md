# Summarized rules for the UniswapV2Swap test

```k
module SOLIDITY-UNISWAP-TOKENS

  syntax Id ::= "account"                         [token]
              | "act"                             [token]
              | "addLiquidity"                    [token]
              | "allowance"                       [token]
              | "allowed"                         [token]
              | "amountA"                         [token]
              | "amountADesired"                  [token]
              | "amountAOptimal"                  [token]
              | "amountAMin"                      [token]
              | "amountB"                         [token]
              | "amountBDesired"                  [token]
              | "amountBMin"                      [token]
              | "amountBOptimal"                  [token]
              | "amountIn"                        [token]
              | "amountInMax"                     [token]
              | "amountInWithFee"                 [token]
              | "amountOut"                       [token]
              | "amountOutDesired"                [token]
              | "amountOutMin"                    [token]
              | "amounts"                         [token]
              | "amountsLiq"                      [token]
              | "amount0"                         [token]
              | "amount0In"                       [token]
              | "amount0Out"                      [token]
              | "amount1"                         [token]
              | "amount1In"                       [token]
              | "amount1Out"                      [token]
              | "approvalEvent"                   [token]
              | "approve"                         [token]
              | "balance"                         [token]
              | "balanceOf"                       [token]
              | "balance0"                        [token]
              | "balance0Adjusted"                [token]
              | "balance1"                        [token]
              | "balance1Adjusted"                [token]
              | "block"                           [token]
              | "blockTimestamp"                  [token]
              | "blockTimestampLast"              [token]
              | "burn"                            [token]
              | "call"                            [token]
              | "constMINIMUMLIQUIDITY"           [token]
              | "constUINTMAX"                    [token]
              | "constUINT112MAX"                 [token]
              | "constUINT256MAX"                 [token]
              | "currentAllowance"                [token]
              | "dai"                             [token]
              | "daiact"                          [token]
              | "daiAmountDesired"                [token]
              | "daiAmountIn"                     [token]
              | "daiAmountMin"                    [token]
              | "daiAmountOut"                    [token]
              | "dAIMock"                         [token]
              | "daiownr"                         [token]
              | "daispdr"                         [token]
              | "decimals"                        [token]
              | "denominator"                     [token]
              | "deposit"                         [token]
              | "desiredA"                        [token]
              | "desiredB"                        [token]
              | "dst"                             [token]
              | "emitEvent"                       [token]
              | "from"                            [token]
              | "fromBalance"                     [token]
              | "getLocalPair"                    [token]
              | "getReserves"                     [token]
              | "guy"                             [token]
              | "i"                               [token]
              | "iERC20"                          [token]
              | "input"                           [token]
              | "kLast"                           [token]
              | "length"                          [token]
              | "liquidity"                       [token]
              | "localPairs"                      [token]
              | "mathMin"                         [token]
              | "mathSqrt"                        [token]
              | "minA"                            [token]
              | "minB"                            [token]
              | "mint"                            [token]
              | "mintEvent"                       [token]
              | "mintOnDeposit"                   [token]
              | "msg"                             [token]
              | "numerator"                       [token]
              | "output"                          [token]
              | "owner"                           [token]
              | "pair"                            [token]
              | "pairEl1"                         [token]
              | "pairEl2"                         [token]
              | "pairReserves"                    [token]
              | "path"                            [token]
              | "price0CumulativeLast"            [token]
              | "price1CumulativeLast"            [token]
              | "reduced"                         [token]
              | "reserveA"                        [token]
              | "reserveB"                        [token]
              | "reserveIn"                       [token]
              | "reserveOut"                      [token]
              | "reserves"                        [token]
              | "reserve0"                        [token]
              | "reserve1"                        [token]
              | "router"                          [token]
              | "safeTransferFrom"                [token]
              | "sender"                          [token]
              | "setLocalPair"                    [token]
              | "setUp"                           [token]
              | "spender"                         [token]
              | "src"                             [token]
              | "success"                         [token]
              | "swap"                            [token]
              | "swapExactTokensForTokens"        [token]
              | "swapEvent"                       [token]
              | "swapMultiHopExactAmountIn"       [token]
              | "swapMultiHopExactAmountOut"      [token]
              | "swapSingleHopExactAmountIn"      [token]
              | "swapSingleHopExactAmountOut"     [token]
              | "swapTokensForExactTokens"        [token]
              | "sync"                            [token]
              | "syncEvent"                       [token]
              | "syncLocalPair"                   [token]
              | "testAmount"                      [token]
              | "testRouterAddLiquidity"          [token]
              | "testSwapMultiHopExactAmountIn"   [token]
              | "testSwapMultiHopExactAmountOut"  [token]
              | "testSwapSingleHopExactAmountIn"  [token]
              | "testSwapSingleHopExactAmountOut" [token]
              | "this"                            [token]
              | "timeElapsed"                     [token]
              | "timestamp"                       [token]
              | "to"                              [token]
              | "tokenA"                          [token]
              | "tokenB"                          [token]
              | "tokens"                          [token]
              | "token0"                          [token]
              | "token1"                          [token]
              | "totalSupply"                     [token]
              | "transfer"                        [token]
              | "transferEvent"                   [token]
              | "transferFrom"                    [token]
              | "uniswapV2LibraryGetAmountIn"     [token]
              | "uniswapV2LibraryGetAmountOut"    [token]
              | "uniswapV2LibraryGetAmountsIn"    [token]
              | "uniswapV2LibraryGetAmountsOut"   [token]
              | "uniswapV2LibraryGetReserves"     [token]
              | "uniswapV2LibraryPairFor"         [token]
              | "uniswapV2LibraryQuote"           [token]
              | "uniswapV2LibrarySortTokens"      [token]
              | "uniswapV2Pair"                   [token]
              | "uniswapV2Router02"               [token]
              | "uniswapV2Swap"                   [token]
              | "uniswapV2SwapTest"               [token]
              | "usdc"                            [token]
              | "usdcAmountOut"                   [token]
              | "usdcAmountOutMin"                [token]
              | "uSDCMock"                        [token]
              | "usr"                             [token]
              | "value"                           [token]
              | "wad"                             [token]
              | "weth"                            [token]
              | "wethact"                         [token]
              | "wethAmount"                      [token]
              | "wETHMock"                        [token]
              | "wethownr"                        [token]
              | "wethspdr"                        [token]
              | "x"                               [token]
              | "y"                               [token]
              | "z"                               [token]

  syntax Id ::= "vidAllowances"                   [token]
              | "vidBalances"                     [token]
              | "vidDai"                          [token]
              | "vidReserve0"                     [token]
              | "vidReserve1"                     [token]
              | "vidRouter"                       [token]
              | "vidTo"                           [token]
              | "vidToken0"                       [token]
              | "vidToken1"                       [token]
              | "vidTotalSupply"                  [token]
              | "vidUni"                          [token]
              | "vidUsdc"                         [token]
              | "vidWeth"                         [token]
              | "fidAddLiquidity"                 [token]
              | "fidApprove"                      [token]
              | "fidSpendAllowance"               [token]
              | "fidSwap"                         [token]
              | "fidTransfer"                     [token]
              | "fidUpdate"                       [token]

  syntax Id ::= "require" [token] | "assert" [token]

  syntax Decimal ::= "1e18" [token]
                   | "1e6"  [token]

endmodule
```

```k
module SOLIDITY-UNISWAP-INIT-SUMMARY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-UNISWAP-TOKENS

  rule <k> _:Program => .K ...</k>
      <summarize> true </summarize>
      (_:CompileCell => 
        <compile>
          <current-body>
            uniswapV2SwapTest
          </current-body>
          <ifaces>
            <iface>
              <iface-id>
                iERC20
              </iface-id>
              <iface-fns>
                <iface-fn>
                  <iface-fn-id>
                    approve
                  </iface-fn-id>
                  <iface-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </iface-fn-arg-types>
                  <iface-fn-return-types>
                    ListItem ( bool )
                  </iface-fn-return-types>
                </iface-fn> <iface-fn>
                  <iface-fn-id>
                    balanceOf
                  </iface-fn-id>
                  <iface-fn-arg-types>
                    ListItem ( address )
                  </iface-fn-arg-types>
                  <iface-fn-return-types>
                    ListItem ( uint256 )
                  </iface-fn-return-types>
                </iface-fn> <iface-fn>
                  <iface-fn-id>
                    transfer
                  </iface-fn-id>
                  <iface-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </iface-fn-arg-types>
                  <iface-fn-return-types>
                    ListItem ( bool )
                  </iface-fn-return-types>
                </iface-fn> <iface-fn>
                  <iface-fn-id>
                    transferFrom
                  </iface-fn-id>
                  <iface-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </iface-fn-arg-types>
                  <iface-fn-return-types>
                    ListItem ( bool )
                  </iface-fn-return-types>
                </iface-fn>
              </iface-fns>
            </iface>
          </ifaces>
          <contracts>
            <contract>
              <contract-id>
                dAIMock
              </contract-id>
              <contract-state>
                (allowance |-> mapping ( address daiownr => mapping ( address daispdr => uint256  )  ))
                (balanceOf |-> mapping ( address daiact => uint256  ))
                (constUINTMAX |-> uint256)
                (totalSupply |-> uint256)
              </contract-state>
              <contract-init>
                ListItem ( constUINTMAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff ; )
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    allowance
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( daiownr )
                    ListItem ( daispdr )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address daiownr => mapping ( address daispdr => uint256  )  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return allowance [ daiownr ] [ daispdr ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    approve
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( usr )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    allowance [ msg . sender ] [ usr ] = wad ;  emit approvalEvent ( msg . sender , usr , wad , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    balanceOf
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( daiact )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address daiact => uint256  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return balanceOf [ daiact ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    burn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( usr )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    if ( balanceOf [ usr ] >= wad ) { balanceOf [ usr ] = balanceOf [ usr ] - wad ;  totalSupply = totalSupply - wad ;  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    decimals
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint8 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return 18 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mint
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( usr )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    balanceOf [ usr ] = balanceOf [ usr ] + wad ;  totalSupply = totalSupply + wad ;  emit transferEvent ( address ( 0 , .TypedVals ) , usr , wad , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mintOnDeposit
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( usr )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    mint ( usr , wad , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    safeTransferFrom
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    transferFrom ( from , to , value , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    totalSupply
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return totalSupply ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transfer
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( dst )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return transferFrom ( msg . sender , dst , wad , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transferFrom
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( src )
                    ListItem ( dst )
                    ListItem ( wad )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( balanceOf [ src ] >= wad , "Dai/insufficient-balance" , .TypedVals ) ;  if ( src != msg . sender && allowance [ src ] [ msg . sender ] != constUINTMAX ) { require ( allowance [ src ] [ msg . sender ] >= wad , "Dai/insufficient-allowance" , .TypedVals ) ;  allowance [ src ] [ msg . sender ] = allowance [ src ] [ msg . sender ] - wad ;  .Statements }  balanceOf [ src ] = balanceOf [ src ] - wad ;  balanceOf [ dst ] = balanceOf [ dst ] + wad ;  emit transferEvent ( src , dst , wad , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              <contract-events>
                <contract-event>
                  <contract-event-id>
                    approvalEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( src )
                    ListItem ( guy )
                    ListItem ( wad )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event> <contract-event>
                  <contract-event-id>
                    transferEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( src )
                    ListItem ( dst )
                    ListItem ( wad )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event>
              </contract-events>
            </contract> <contract>
              <contract-id>
                uSDCMock
              </contract-id>
              <contract-state>
                (constUINT256MAX |-> uint256)
                (vidAllowances |-> mapping ( address account => mapping ( address spender => uint256  )  ))
                (vidBalances |-> mapping ( address account => uint256  ))
                (vidTotalSupply |-> uint256)
              </contract-state>
              <contract-init>
                ListItem ( constUINT256MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff ; )
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    allowance
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( owner )
                    ListItem ( spender )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return vidAllowances [ owner ] [ spender ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    approve
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( spender )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address owner = msg . sender ;  fidApprove ( owner , spender , value , true , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    balanceOf
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( account )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return vidBalances [ account ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    decimals
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint8 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return 18 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidApprove
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                    ListItem ( bool )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( owner )
                    ListItem ( spender )
                    ListItem ( value )
                    ListItem ( emitEvent )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( owner != address ( 0 , .TypedVals ) , "USDC: invalid approver" , .TypedVals ) ;  require ( spender != address ( 0 , .TypedVals ) , "USDC: invalid spender" , .TypedVals ) ;  vidAllowances [ owner ] [ spender ] = value ;  if ( emitEvent ) { emit approvalEvent ( owner , spender , value , .TypedVals ) ;  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidSpendAllowance
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( owner )
                    ListItem ( spender )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 currentAllowance = allowance ( owner , spender , .TypedVals ) ;  if ( currentAllowance != constUINT256MAX ) { require ( currentAllowance >= value , "USDC: insufficient allowance" , .TypedVals ) ;  fidApprove ( owner , spender , currentAllowance - value , false , .TypedVals ) ;  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidTransfer
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( from != address ( 0 , .TypedVals ) , "USDC: invalid sender" , .TypedVals ) ;  require ( to != address ( 0 , .TypedVals ) , "USDC: invalid receiver" , .TypedVals ) ;  fidUpdate ( from , to , value , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidUpdate
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    if ( from == address ( 0 , .TypedVals ) ) { vidTotalSupply = vidTotalSupply + value ;  .Statements } else { uint256 fromBalance = vidBalances [ from ] ;  require ( fromBalance >= value , "USDC: insufficient balance" , .TypedVals ) ;  vidBalances [ from ] = fromBalance - value ;  .Statements }  if ( to == address ( 0 , .TypedVals ) ) { vidTotalSupply = vidTotalSupply - value ;  .Statements } else { vidBalances [ to ] = vidBalances [ to ] + value ;  .Statements }  emit transferEvent ( from , to , value , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mint
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( account )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( account != address ( 0 , .TypedVals ) , "USDC: invalid receiver" , .TypedVals ) ;  fidUpdate ( address ( 0 , .TypedVals ) , account , value , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transfer
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address owner = msg . sender ;  fidTransfer ( owner , to , value , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transferFrom
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address spender = msg . sender ;  fidSpendAllowance ( from , spender , value , .TypedVals ) ;  fidTransfer ( from , to , value , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              <contract-events>
                <contract-event>
                  <contract-event-id>
                    approvalEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( owner )
                    ListItem ( spender )
                    ListItem ( value )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event> <contract-event>
                  <contract-event-id>
                    transferEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event>
              </contract-events>
            </contract> <contract>
              <contract-id>
                uniswapV2Pair
              </contract-id>
              <contract-state>
                (balanceOf |-> mapping ( address act => uint256  ))
                (blockTimestampLast |-> uint32)
                (constMINIMUMLIQUIDITY |-> uint256)
                (constUINT112MAX |-> uint256)
                (kLast |-> uint256)
                (price0CumulativeLast |-> uint256)
                (price1CumulativeLast |-> uint256)
                (reserve0 |-> uint112)
                (reserve1 |-> uint112)
                (token0 |-> address)
                (token1 |-> address)
                (totalSupply |-> uint256)
              </contract-state>
              <contract-init>
                ListItem ( constUINT112MAX = 0xffffffffffffffffffffffffffff ; )
                ListItem ( constMINIMUMLIQUIDITY = 10 ** 3 ; )
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    balanceOf
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( act )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address act => uint256  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return balanceOf [ act ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    constMINIMUMLIQUIDITY
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return constMINIMUMLIQUIDITY ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    constructor
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( vidToken0 )
                    ListItem ( vidToken1 )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    token0 = vidToken0 ;  token1 = vidToken1 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidUpdate
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint112 )
                    ListItem ( uint112 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( balance0 )
                    ListItem ( balance1 )
                    ListItem ( vidReserve0 )
                    ListItem ( vidReserve1 )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( balance0 <= constUINT112MAX && balance1 <= constUINT112MAX , "UniswapV2: OVERFLOW" , .TypedVals ) ;  uint32 blockTimestamp = uint32 ( block . timestamp % 2 ** 32 , .TypedVals ) ;  uint32 timeElapsed = blockTimestamp - blockTimestampLast ;  if ( timeElapsed > 0 && vidReserve0 != 0 && vidReserve1 != 0 ) { price0CumulativeLast = price0CumulativeLast + vidReserve1 / vidReserve0 * timeElapsed ;  price1CumulativeLast = price1CumulativeLast + vidReserve0 / vidReserve1 * timeElapsed ;  .Statements }  reserve0 = uint112 ( balance0 , .TypedVals ) ;  reserve1 = uint112 ( balance1 , .TypedVals ) ;  blockTimestampLast = blockTimestamp ;  emit syncEvent ( reserve0 , reserve1 , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    getReserves
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint112 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( reserves )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    reserves = new uint112 [ ] ( 3 , .TypedVals ) ;  reserves [ 0 ] = reserve0 ;  reserves [ 1 ] = reserve1 ;  reserves [ 2 ] = blockTimestampLast ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    kLast
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return kLast ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mathMin
                  </contract-fn-id>
                  <contract-fn-visibility>
                    internal
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( x )
                    ListItem ( y )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( z )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    z = x < y ? x : y ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mathSqrt
                  </contract-fn-id>
                  <contract-fn-visibility>
                    internal
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( y )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( z )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    if ( y > 3 ) { z = y ;  uint256 x = y / 2 + 1 ;  while ( x < z ) { z = x ;  x = ( y / x + x ) / 2 ;  .Statements }  .Statements } else if ( y != 0 ) { z = 1 ;  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    mint
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( to )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( liquidity )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint112 [ ] memory pairReserves = getReserves ( .TypedVals ) ;  uint256 balance0 = iERC20 ( token0 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) ;  uint256 balance1 = iERC20 ( token1 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) ;  uint256 amount0 = balance0 - pairReserves [ 0 ] ;  uint256 amount1 = balance1 - pairReserves [ 1 ] ;  uint256 vidTotalSupply = totalSupply ;  if ( vidTotalSupply == 0 ) { liquidity = mathSqrt ( amount0 * amount1 , .TypedVals ) - constMINIMUMLIQUIDITY ;  totalSupply = totalSupply + constMINIMUMLIQUIDITY ;  balanceOf [ address ( 0 , .TypedVals ) ] = balanceOf [ address ( 0 , .TypedVals ) ] + constMINIMUMLIQUIDITY ;  .Statements } else { liquidity = mathMin ( amount0 * vidTotalSupply / pairReserves [ 0 ] , amount1 * vidTotalSupply / pairReserves [ 1 ] , .TypedVals ) ;  .Statements }  require ( liquidity > 0 , "UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED" , .TypedVals ) ;  totalSupply = totalSupply + liquidity ;  balanceOf [ to ] = balanceOf [ to ] + liquidity ;  fidUpdate ( balance0 , balance1 , pairReserves [ 0 ] , pairReserves [ 1 ] , .TypedVals ) ;  emit mintEvent ( msg . sender , amount0 , amount1 , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    price0CumulativeLast
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return price0CumulativeLast ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    price1CumulativeLast
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return price1CumulativeLast ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swap
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amount0Out )
                    ListItem ( amount1Out )
                    ListItem ( to )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( amount0Out > 0 || amount1Out > 0 , "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT" , .TypedVals ) ;  uint112 [ ] memory reserves = getReserves ( .TypedVals ) ;  require ( amount0Out < reserves [ 0 ] && amount1Out < reserves [ 1 ] , "UniswapV2: INSUFFICIENT_LIQUIDITY" , .TypedVals ) ;  uint256 balance0 ;  uint256 balance1 ;  { address vidToken0 = token0 ;  address vidToken1 = token1 ;  require ( to != vidToken0 && to != vidToken1 , "UniswapV2: INVALID_TO" , .TypedVals ) ;  if ( amount0Out > 0 ) iERC20 ( vidToken0 , .TypedVals ) . transfer ( to , amount0Out , .TypedVals ) ;  if ( amount1Out > 0 ) iERC20 ( vidToken1 , .TypedVals ) . transfer ( to , amount1Out , .TypedVals ) ;  balance0 = iERC20 ( vidToken0 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) ;  balance1 = iERC20 ( vidToken1 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) ;  .Statements }  uint256 amount0In = balance0 > reserves [ 0 ] - amount0Out ? balance0 - ( reserves [ 0 ] - amount0Out ) : 0 ;  uint256 amount1In = balance1 > reserves [ 1 ] - amount1Out ? balance1 - ( reserves [ 1 ] - amount1Out ) : 0 ;  require ( amount0In > 0 || amount1In > 0 , "UniswapV2: INSUFFICIENT_INPUT_AMOUNT" , .TypedVals ) ;  { uint256 balance0Adjusted = balance0 * 1000 - amount0In * 3 ;  uint256 balance1Adjusted = balance1 * 1000 - amount1In * 3 ;  require ( balance0Adjusted * balance1Adjusted >= uint256 ( reserves [ 0 ] , .TypedVals ) * reserves [ 1 ] * 1000 ** 2 , "UniswapV2: K" , .TypedVals ) ;  .Statements }  fidUpdate ( balance0 , balance1 , reserves [ 0 ] , reserves [ 1 ] , .TypedVals ) ;  emit swapEvent ( msg . sender , amount0In , amount1In , amount0Out , amount1Out , to , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    sync
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    fidUpdate ( iERC20 ( token0 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) , iERC20 ( token1 , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) , reserve0 , reserve1 , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    token0
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( address )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return token0 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    token1
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( address )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return token1 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    totalSupply
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return totalSupply ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              <contract-events>
                <contract-event>
                  <contract-event-id>
                    mintEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( sender )
                    ListItem ( amount0 )
                    ListItem ( amount1 )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                  </contract-event-indexed-pos>
                </contract-event> <contract-event>
                  <contract-event-id>
                    swapEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( address )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( sender )
                    ListItem ( amount0In )
                    ListItem ( amount1In )
                    ListItem ( amount0Out )
                    ListItem ( amount1Out )
                    ListItem ( to )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 5 )
                  </contract-event-indexed-pos>
                </contract-event> <contract-event>
                  <contract-event-id>
                    syncEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( uint112 )
                    ListItem ( uint112 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( reserve0 )
                    ListItem ( reserve1 )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    .Set
                  </contract-event-indexed-pos>
                </contract-event>
              </contract-events>
            </contract> <contract>
              <contract-id>
                uniswapV2Router02
              </contract-id>
              <contract-state>
                localPairs |-> mapping ( address pairEl1 => mapping ( address pairEl2 => address  )  )
              </contract-state>
              <contract-init>
                .List
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    addLiquidity
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                    ListItem ( amountADesired )
                    ListItem ( amountBDesired )
                    ListItem ( amountAMin )
                    ListItem ( amountBMin )
                    ListItem ( to )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountsLiq )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    amountsLiq = new uint256 [ ] ( 3 , .TypedVals ) ;  uint256 [ ] memory amounts = fidAddLiquidity ( tokenA , tokenB , amountADesired , amountBDesired , amountAMin , amountBMin , .TypedVals ) ;  amountsLiq [ 0 ] = amounts [ 0 ] ;  amountsLiq [ 1 ] = amounts [ 1 ] ;  address pair = uniswapV2LibraryPairFor ( tokenA , tokenB , .TypedVals ) ;  iERC20 ( tokenA , .TypedVals ) . transferFrom ( msg . sender , pair , amounts [ 0 ] , .TypedVals ) ;  iERC20 ( tokenB , .TypedVals ) . transferFrom ( msg . sender , pair , amounts [ 1 ] , .TypedVals ) ;  amountsLiq [ 2 ] = uniswapV2Pair ( pair , .TypedVals ) . mint ( to , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidAddLiquidity
                  </contract-fn-id>
                  <contract-fn-visibility>
                    internal
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                    ListItem ( amountADesired )
                    ListItem ( amountBDesired )
                    ListItem ( amountAMin )
                    ListItem ( amountBMin )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amounts )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    amounts = new uint256 [ ] ( 2 , .TypedVals ) ;  require ( getLocalPair ( tokenA , tokenB , .TypedVals ) != address ( 0 , .TypedVals ) , .TypedVals ) ;  uint256 [ ] memory reserves = uniswapV2LibraryGetReserves ( tokenA , tokenB , .TypedVals ) ;  if ( reserves [ 0 ] == 0 && reserves [ 1 ] == 0 ) { amounts [ 0 ] = amountADesired ;  amounts [ 1 ] = amountBDesired ;  .Statements } else { uint256 amountBOptimal = uniswapV2LibraryQuote ( amountADesired , reserves [ 0 ] , reserves [ 1 ] , .TypedVals ) ;  if ( amountBOptimal <= amountBDesired ) { require ( amountBOptimal >= amountBMin , "UniswapV2Router: INSUFFICIENT_B_AMOUNT" , .TypedVals ) ;  amounts [ 0 ] = amountADesired ;  amounts [ 1 ] = amountBOptimal ;  .Statements } else { uint256 amountAOptimal = uniswapV2LibraryQuote ( amountBDesired , reserves [ 1 ] , reserves [ 0 ] , .TypedVals ) ;  assert ( amountAOptimal <= amountADesired , .TypedVals ) ;  require ( amountAOptimal >= amountAMin , "UniswapV2Router: INSUFFICIENT_A_AMOUNT" , .TypedVals ) ;  amounts [ 0 ] = amountAOptimal ;  amounts [ 1 ] = amountBDesired ;  .Statements }  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    fidSwap
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 [ ]::TypeName )
                    ListItem ( address [ ]::TypeName )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amounts )
                    ListItem ( path )
                    ListItem ( vidTo )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    { uint256 i ;  while ( i < path . length - 1 ) { { address input = path [ i ] ;  address output = path [ i + 1 ] ;  address [ ] memory tokens = uniswapV2LibrarySortTokens ( input , output , .TypedVals ) ;  uint256 amountOut = amounts [ i + 1 ] ;  uint256 amount0Out = input == tokens [ 0 ] ? uint256 ( 0 , .TypedVals ) : amountOut ;  uint256 amount1Out = input == tokens [ 0 ] ? amountOut : uint256 ( 0 , .TypedVals ) ;  address to = i < path . length - 2 ? uniswapV2LibraryPairFor ( output , path [ i + 2 ] , .TypedVals ) : vidTo ;  uniswapV2Pair ( uniswapV2LibraryPairFor ( input , output , .TypedVals ) , .TypedVals ) . swap ( amount0Out , amount1Out , to , .TypedVals ) ;  .Statements }  i ++ ;  .Statements }  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    getLocalPair
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( address )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( pair )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address [ ] memory tokens = uniswapV2LibrarySortTokens ( tokenA , tokenB , .TypedVals ) ;  pair = localPairs [ tokens [ 0 ] ] [ tokens [ 1 ] ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    localPairs
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( pairEl1 )
                    ListItem ( pairEl2 )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address pairEl1 => mapping ( address pairEl2 => address  )  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return localPairs [ pairEl1 ] [ pairEl2 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    setLocalPair
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address [ ] memory tokens = uniswapV2LibrarySortTokens ( tokenA , tokenB , .TypedVals ) ;  localPairs [ tokens [ 0 ] ] [ tokens [ 1 ] ] = address ( new uniswapV2Pair ( address ( tokens [ 0 ] , .TypedVals ) , address ( tokens [ 1 ] , .TypedVals ) , .TypedVals ) , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapExactTokensForTokens
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( address [ ]::TypeName )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountIn )
                    ListItem ( amountOutMin )
                    ListItem ( path )
                    ListItem ( to )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amounts )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    amounts = uniswapV2LibraryGetAmountsOut ( amountIn , path , .TypedVals ) ;  require ( amounts [ amounts . length - 1 ] >= amountOutMin , "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT" , .TypedVals ) ;  iERC20 ( path [ 0 ] , .TypedVals ) . transferFrom ( msg . sender , uniswapV2LibraryPairFor ( path [ 0 ] , path [ 1 ] , .TypedVals ) , amounts [ 0 ] , .TypedVals ) ;  fidSwap ( amounts , path , to , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapTokensForExactTokens
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( address [ ]::TypeName )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountOut )
                    ListItem ( amountInMax )
                    ListItem ( path )
                    ListItem ( to )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amounts )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    amounts = uniswapV2LibraryGetAmountsIn ( amountOut , path , .TypedVals ) ;  require ( amounts [ 0 ] <= amountInMax , "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT" , .TypedVals ) ;  iERC20 ( path [ 0 ] , .TypedVals ) . transferFrom ( msg . sender , uniswapV2LibraryPairFor ( path [ 0 ] , path [ 1 ] , .TypedVals ) , amounts [ 0 ] , .TypedVals ) ;  fidSwap ( amounts , path , to , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    syncLocalPair
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address [ ] memory tokens = uniswapV2LibrarySortTokens ( tokenA , tokenB , .TypedVals ) ;  uniswapV2Pair ( localPairs [ tokens [ 0 ] ] [ tokens [ 1 ] ] , .TypedVals ) . sync ( .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryGetAmountIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountOut )
                    ListItem ( reserveIn )
                    ListItem ( reserveOut )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountIn )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( amountOut > 0 , "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT" , .TypedVals ) ;  require ( reserveIn > 0 && reserveOut > 0 , "UniswapV2Library: INSUFFICIENT_LIQUIDITY" , .TypedVals ) ;  uint256 numerator = reserveIn * amountOut * 1000 ;  uint256 denominator = ( reserveOut - amountOut ) * 997 ;  amountIn = denominator != 0 ? numerator / denominator + 1 : 1 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryGetAmountOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountIn )
                    ListItem ( reserveIn )
                    ListItem ( reserveOut )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountOut )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( amountIn > 0 , "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT" , .TypedVals ) ;  require ( reserveIn > 0 && reserveOut > 0 , "UniswapV2Library: INSUFFICIENT_LIQUIDITY" , .TypedVals ) ;  uint256 amountInWithFee = amountIn * 997 ;  uint256 numerator = amountInWithFee * reserveOut ;  uint256 denominator = reserveIn * 1000 + amountInWithFee ;  amountOut = numerator / denominator ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryGetAmountsIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( address [ ]::TypeName )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountOut )
                    ListItem ( path )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amounts )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( path . length >= 2 , "UniswapV2Library: INVALID_PATH" , .TypedVals ) ;  amounts = new uint256 [ ] ( path . length , .TypedVals ) ;  amounts [ amounts . length - 1 ] = amountOut ;  { uint256 i = path . length - 1 ;  while ( i > 0 ) { { uint256 [ ] memory reserves = uniswapV2LibraryGetReserves ( path [ i - 1 ] , path [ i ] , .TypedVals ) ;  amounts [ i - 1 ] = uniswapV2LibraryGetAmountIn ( amounts [ i ] , reserves [ 0 ] , reserves [ 1 ] , .TypedVals ) ;  .Statements }  i -- ;  .Statements }  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryGetAmountsOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( address [ ]::TypeName )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountIn )
                    ListItem ( path )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amounts )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( path . length >= 2 , "UniswapV2Library: INVALID_PATH" , .TypedVals ) ;  amounts = new uint256 [ ] ( path . length , .TypedVals ) ;  amounts [ 0 ] = amountIn ;  { uint256 i ;  while ( i < path . length - 1 ) { { uint256 [ ] memory reserves = uniswapV2LibraryGetReserves ( path [ i ] , path [ i + 1 ] , .TypedVals ) ;  amounts [ i + 1 ] = uniswapV2LibraryGetAmountOut ( amounts [ i ] , reserves [ 0 ] , reserves [ 1 ] , .TypedVals ) ;  .Statements }  i ++ ;  .Statements }  .Statements }  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryGetReserves
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( reserves )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    reserves = new uint256 [ ] ( 2 , .TypedVals ) ;  address [ ] memory tokens = uniswapV2LibrarySortTokens ( tokenA , tokenB , .TypedVals ) ;  uint112 [ ] memory pairReserves = uniswapV2Pair ( uniswapV2LibraryPairFor ( tokenA , tokenB , .TypedVals ) , .TypedVals ) . getReserves ( .TypedVals ) ;  reserves [ 0 ] = tokenA == tokens [ 0 ] ? pairReserves [ 0 ] : pairReserves [ 1 ] ;  reserves [ 1 ] = tokenA == tokens [ 0 ] ? pairReserves [ 1 ] : pairReserves [ 0 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryPairFor
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( address )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( pair )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    address [ ] memory tokens = uniswapV2LibrarySortTokens ( tokenA , tokenB , .TypedVals ) ;  pair = localPairs [ tokens [ 0 ] ] [ tokens [ 1 ] ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibraryQuote
                  </contract-fn-id>
                  <contract-fn-visibility>
                    internal
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountA )
                    ListItem ( reserveA )
                    ListItem ( reserveB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountB )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    require ( amountA > 0 , "UniswapV2Library: INSUFFICIENT_AMOUNT" , .TypedVals ) ;  require ( reserveA > 0 && reserveB > 0 , "UniswapV2Library: INSUFFICIENT_LIQUIDITY" , .TypedVals ) ;  amountB = amountA * reserveB / reserveA ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    uniswapV2LibrarySortTokens
                  </contract-fn-id>
                  <contract-fn-visibility>
                    private
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( tokenA )
                    ListItem ( tokenB )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( address [ ]::TypeName )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( tokens )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    tokens = new address [ ] ( 2 , .TypedVals ) ;  require ( tokenA != tokenB , "UniswapV2Library: IDENTICAL_ADDRESSES" , .TypedVals ) ;  tokens [ 0 ] = tokenA < tokenB ? tokenA : tokenB ;  tokens [ 1 ] = tokenA < tokenB ? tokenB : tokenA ;  require ( tokens [ 0 ] != address ( 0 , .TypedVals ) , "UniswapV2Library: ZERO_ADDRESS" , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              ...
            </contract> <contract>
              <contract-id>
                uniswapV2Swap
              </contract-id>
              <contract-state>
                (dai |-> iERC20)
                (router |-> uniswapV2Router02)
                (usdc |-> iERC20)
                (weth |-> iERC20)
              </contract-state>
              <contract-init>
                .List
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    constructor
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( vidWeth )
                    ListItem ( vidDai )
                    ListItem ( vidUsdc )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    weth = iERC20 ( vidWeth , .TypedVals ) ;  dai = iERC20 ( vidDai , .TypedVals ) ;  usdc = iERC20 ( vidUsdc , .TypedVals ) ;  router = new uniswapV2Router02 ( .TypedVals ) ;  router . setLocalPair ( vidWeth , vidDai , .TypedVals ) ;  router . setLocalPair ( vidWeth , vidUsdc , .TypedVals ) ;  router . setLocalPair ( vidUsdc , vidDai , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    dai
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( iERC20 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return dai ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    router
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uniswapV2Router02 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return router ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapMultiHopExactAmountIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountIn )
                    ListItem ( amountOutMin )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountOut )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    dai . transferFrom ( msg . sender , address ( this , .TypedVals ) , amountIn , .TypedVals ) ;  dai . approve ( address ( router , .TypedVals ) , amountIn , .TypedVals ) ;  address [ ] memory path = new address [ ] ( 3 , .TypedVals ) ;  path [ 0 ] = address ( dai , .TypedVals ) ;  path [ 1 ] = address ( weth , .TypedVals ) ;  path [ 2 ] = address ( usdc , .TypedVals ) ;  uint256 [ ] memory amounts = router . swapExactTokensForTokens ( amountIn , amountOutMin , path , msg . sender , .TypedVals ) ;  return amounts [ 2 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapMultiHopExactAmountOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountOutDesired )
                    ListItem ( amountInMax )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountOut )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    dai . transferFrom ( msg . sender , address ( this , .TypedVals ) , amountInMax , .TypedVals ) ;  dai . approve ( address ( router , .TypedVals ) , amountInMax , .TypedVals ) ;  address [ ] memory path = new address [ ] ( 3 , .TypedVals ) ;  path [ 0 ] = address ( dai , .TypedVals ) ;  path [ 1 ] = address ( weth , .TypedVals ) ;  path [ 2 ] = address ( usdc , .TypedVals ) ;  uint256 [ ] memory amounts = router . swapTokensForExactTokens ( amountOutDesired , amountInMax , path , msg . sender , .TypedVals ) ;  if ( amounts [ 0 ] < amountInMax ) { dai . transfer ( msg . sender , amountInMax - amounts [ 0 ] , .TypedVals ) ;  .Statements }  return amounts [ 2 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapSingleHopExactAmountIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountIn )
                    ListItem ( amountOutMin )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountOut )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    weth . transferFrom ( msg . sender , address ( this , .TypedVals ) , amountIn , .TypedVals ) ;  weth . approve ( address ( router , .TypedVals ) , amountIn , .TypedVals ) ;  address [ ] memory path = new address [ ] ( 2 , .TypedVals ) ;  path [ 0 ] = address ( weth , .TypedVals ) ;  path [ 1 ] = address ( dai , .TypedVals ) ;  uint256 [ ] memory amounts = router . swapExactTokensForTokens ( amountIn , amountOutMin , path , msg . sender , .TypedVals ) ;  return amounts [ 1 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    swapSingleHopExactAmountOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( uint256 )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( amountOutDesired )
                    ListItem ( amountInMax )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint256 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( amountOut )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    weth . transferFrom ( msg . sender , address ( this , .TypedVals ) , amountInMax , .TypedVals ) ;  weth . approve ( address ( router , .TypedVals ) , amountInMax , .TypedVals ) ;  address [ ] memory path = new address [ ] ( 2 , .TypedVals ) ;  path [ 0 ] = address ( weth , .TypedVals ) ;  path [ 1 ] = address ( dai , .TypedVals ) ;  uint256 [ ] memory amounts = router . swapTokensForExactTokens ( amountOutDesired , amountInMax , path , msg . sender , .TypedVals ) ;  if ( amounts [ 0 ] < amountInMax ) { weth . transfer ( msg . sender , amountInMax - amounts [ 0 ] , .TypedVals ) ;  .Statements }  return amounts [ 1 ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    usdc
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( iERC20 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return usdc ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    weth
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( iERC20 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return weth ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              ...
            </contract> <contract>
              <contract-id>
                uniswapV2SwapTest
              </contract-id>
              <contract-state>
                (vidDai |-> dAIMock)
                (vidRouter |-> uniswapV2Router02)
                (vidUni |-> uniswapV2Swap)
                (vidUsdc |-> uSDCMock)
                (vidWeth |-> wETHMock)
              </contract-state>
              <contract-init>
                .List
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    setUp
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    vidWeth = new wETHMock ( .TypedVals ) ;  vidDai = new dAIMock ( .TypedVals ) ;  vidUsdc = new uSDCMock ( .TypedVals ) ;  vidUni = new uniswapV2Swap ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    testRouterAddLiquidity
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 testAmount = 131072 ;  uint256 desiredA = 10000 ;  uint256 desiredB = 10000 ;  uint256 minA = 0 ;  uint256 minB = 0 ;  vidRouter = new uniswapV2Router02 ( .TypedVals ) ;  vidRouter . setLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  vidRouter . setLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) ;  vidRouter . setLocalPair ( address ( vidUsdc , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  vidDai . mint ( address ( this , .TypedVals ) , testAmount , .TypedVals ) ;  vidDai . approve ( address ( vidRouter , .TypedVals ) , testAmount , .TypedVals ) ;  vidUsdc . mint ( address ( this , .TypedVals ) , testAmount , .TypedVals ) ;  vidUsdc . approve ( address ( vidRouter , .TypedVals ) , testAmount , .TypedVals ) ;  vidRouter . addLiquidity ( address ( vidDai , .TypedVals ) , address ( vidUsdc , .TypedVals ) , desiredA , desiredB , minA , minB , address ( this , .TypedVals ) , .TypedVals ) ;  assert ( vidDai . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) == 121072 , .TypedVals ) ;  assert ( vidUsdc . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) == 121072 , .TypedVals ) ;  assert ( vidDai . balanceOf ( vidRouter . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , .TypedVals ) == 10000 , .TypedVals ) ;  assert ( vidUsdc . balanceOf ( vidRouter . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , .TypedVals ) == 10000 , .TypedVals ) ;  assert ( uniswapV2Pair ( vidRouter . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , .TypedVals ) . balanceOf ( address ( this , .TypedVals ) , .TypedVals ) == 9000 , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    testSwapMultiHopExactAmountIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 wethAmount = 1e18 ;  vidWeth . deposit { value : 4 * wethAmount , .KeyValues } ( .TypedVals ) ;  vidWeth . approve ( address ( vidUni , .TypedVals ) , 8 * wethAmount , .TypedVals ) ;  vidDai . mint ( address ( this , .TypedVals ) , 3 * wethAmount , .TypedVals ) ;  vidDai . approve ( address ( vidUni , .TypedVals ) , 3 * wethAmount , .TypedVals ) ;  vidUsdc . mint ( address ( this , .TypedVals ) , 2 * wethAmount , .TypedVals ) ;  vidUsdc . approve ( address ( vidUni , .TypedVals ) , 2 * wethAmount , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , wethAmount , .TypedVals ) ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , wethAmount , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  uint256 daiAmountMin = 1 ;  vidUni . swapSingleHopExactAmountIn ( wethAmount , daiAmountMin , .TypedVals ) ;  uint256 daiAmountIn = 1e18 ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) , daiAmountIn , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) , daiAmountIn , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , daiAmountIn , .TypedVals ) ;  vidUsdc . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , daiAmountIn , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) ;  uint256 usdcAmountOutMin = 1 ;  uint256 usdcAmountOut = vidUni . swapMultiHopExactAmountIn ( daiAmountIn , usdcAmountOutMin , .TypedVals ) ;  assert ( usdcAmountOut >= usdcAmountOutMin , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    testSwapMultiHopExactAmountOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 wethAmount = 1e18 ;  vidWeth . deposit { value : 20 * wethAmount , .KeyValues } ( .TypedVals ) ;  vidWeth . approve ( address ( vidUni , .TypedVals ) , 20 * wethAmount , .TypedVals ) ;  vidDai . mint ( address ( this , .TypedVals ) , 20 * wethAmount , .TypedVals ) ;  vidDai . approve ( address ( vidUni , .TypedVals ) , 20 * wethAmount , .TypedVals ) ;  vidUsdc . mint ( address ( this , .TypedVals ) , 10 * wethAmount , .TypedVals ) ;  vidUsdc . approve ( address ( vidUni , .TypedVals ) , 10 * wethAmount , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , 8 * wethAmount , .TypedVals ) ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , 8 * wethAmount , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  uint256 daiAmountOut = 2 * 1e18 ;  vidUni . swapSingleHopExactAmountOut ( daiAmountOut , 4 * wethAmount , .TypedVals ) ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) , 2 * daiAmountOut , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) , 2 * daiAmountOut , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , 2 * daiAmountOut , .TypedVals ) ;  vidUsdc . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) , 2 * daiAmountOut , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidDai , .TypedVals ) , address ( vidWeth , .TypedVals ) , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidUsdc , .TypedVals ) , .TypedVals ) ;  uint256 amountOutDesired = 1e6 ;  uint256 amountOut = vidUni . swapMultiHopExactAmountOut ( amountOutDesired , daiAmountOut , .TypedVals ) ;  assert ( amountOut == amountOutDesired , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    testSwapSingleHopExactAmountIn
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 wethAmount = 1e18 ;  vidWeth . deposit { value : 2 * wethAmount , .KeyValues } ( .TypedVals ) ;  vidWeth . approve ( address ( vidUni , .TypedVals ) , 2 * wethAmount , .TypedVals ) ;  vidDai . mint ( address ( this , .TypedVals ) , wethAmount , .TypedVals ) ;  vidDai . approve ( address ( vidUni , .TypedVals ) , wethAmount , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , wethAmount , .TypedVals ) ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , wethAmount , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  uint256 daiAmountMin = 1 ;  uint256 daiAmountOut = vidUni . swapSingleHopExactAmountIn ( wethAmount , daiAmountMin , .TypedVals ) ;  assert ( daiAmountOut >= daiAmountMin , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    testSwapSingleHopExactAmountOut
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    uint256 wethAmount = 1e18 ;  vidWeth . deposit { value : 10 * wethAmount , .KeyValues } ( .TypedVals ) ;  vidWeth . approve ( address ( vidUni , .TypedVals ) , 6 * wethAmount , .TypedVals ) ;  vidDai . mint ( address ( this , .TypedVals ) , 10 * wethAmount , .TypedVals ) ;  vidDai . approve ( address ( vidUni , .TypedVals ) , 4 * wethAmount , .TypedVals ) ;  vidWeth . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , 4 * wethAmount , .TypedVals ) ;  vidDai . transfer ( vidUni . router ( .TypedVals ) . getLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) , 4 * wethAmount , .TypedVals ) ;  vidUni . router ( .TypedVals ) . syncLocalPair ( address ( vidWeth , .TypedVals ) , address ( vidDai , .TypedVals ) , .TypedVals ) ;  uint256 daiAmountDesired = 1e18 ;  uint256 daiAmountOut = vidUni . swapSingleHopExactAmountOut ( daiAmountDesired , 2 * wethAmount , .TypedVals ) ;  assert ( daiAmountOut == daiAmountDesired , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              ...
            </contract> <contract>
              <contract-id>
                wETHMock
              </contract-id>
              <contract-state>
                (allowance |-> mapping ( address wethownr => mapping ( address wethspdr => uint256  )  ))
                (balanceOf |-> mapping ( address wethact => uint256  ))
                (constUINT256MAX |-> uint256)
              </contract-state>
              <contract-init>
                ListItem ( constUINT256MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff ; )
              </contract-init>
              <contract-fns>
                <contract-fn>
                  <contract-fn-id>
                    allowance
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( wethownr )
                    ListItem ( wethspdr )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address wethownr => mapping ( address wethspdr => uint256  )  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return allowance [ wethownr ] [ wethspdr ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    approve
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( spender )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    allowance [ msg . sender ] [ spender ] = value ;  emit approvalEvent ( msg . sender , spender , value , .TypedVals ) ;  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    balanceOf
                  </contract-fn-id>
                  <contract-fn-visibility>
                    public
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( wethact )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( mapping ( address wethact => uint256  ) )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return balanceOf [ wethact ] ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    decimals
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( uint8 )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    return 18 ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    deposit
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    .List
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    .List
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    .List
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    .List
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    true
                  </contract-fn-payable>
                  <contract-fn-body>
                    balanceOf [ msg . sender ] = balanceOf [ msg . sender ] + msg . value ;  emit transferEvent ( address ( 0 , .TypedVals ) , msg . sender , msg . value , .TypedVals ) ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transfer
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    if ( to != address ( 0 , .TypedVals ) && to != address ( this , .TypedVals ) ) { uint256 balance = balanceOf [ msg . sender ] ;  require ( balance >= value , "WETH: transfer amount exceeds balance" , .TypedVals ) ;  balanceOf [ msg . sender ] = balance - value ;  balanceOf [ to ] = balanceOf [ to ] + value ;  emit transferEvent ( msg . sender , to , value , .TypedVals ) ;  .Statements } else { uint256 balance = balanceOf [ msg . sender ] ;  require ( balance >= value , "WETH: burn amount exceeds balance" , .TypedVals ) ;  balanceOf [ msg . sender ] = balance - value ;  emit transferEvent ( msg . sender , address ( 0 , .TypedVals ) , value , .TypedVals ) ;  ( bool success , ) = msg . sender . call { value : value , .KeyValues } ( "" , .TypedVals ) ;  require ( success , "WETH: ETH transfer failed" , .TypedVals ) ;  .Statements }  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn> <contract-fn>
                  <contract-fn-id>
                    transferFrom
                  </contract-fn-id>
                  <contract-fn-visibility>
                    external
                  </contract-fn-visibility>
                  <contract-fn-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-fn-arg-types>
                  <contract-fn-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-fn-param-names>
                  <contract-fn-return-types>
                    ListItem ( bool )
                  </contract-fn-return-types>
                  <contract-fn-return-names>
                    ListItem ( noId )
                  </contract-fn-return-names>
                  <contract-fn-payable>
                    false
                  </contract-fn-payable>
                  <contract-fn-body>
                    if ( from != msg . sender ) { uint256 allowed = allowance [ from ] [ msg . sender ] ;  if ( allowed != constUINT256MAX ) { require ( allowed >= value , "WETH: request exceeds allowance" , .TypedVals ) ;  uint256 reduced = allowed - value ;  allowance [ from ] [ msg . sender ] = reduced ;  emit approvalEvent ( from , msg . sender , reduced , .TypedVals ) ;  .Statements }  .Statements }  if ( to != address ( 0 , .TypedVals ) && to != address ( this , .TypedVals ) ) { uint256 balance = balanceOf [ from ] ;  require ( balance >= value , "WETH: transfer amount exceeds balance" , .TypedVals ) ;  balanceOf [ from ] = balance - value ;  balanceOf [ to ] = balanceOf [ to ] + value ;  emit transferEvent ( from , to , value , .TypedVals ) ;  .Statements } else { uint256 balance = balanceOf [ from ] ;  require ( balance >= value , "WETH: burn amount exceeds balance" , .TypedVals ) ;  balanceOf [ from ] = balance - value ;  emit transferEvent ( from , address ( 0 , .TypedVals ) , value , .TypedVals ) ;  ( bool success , ) = msg . sender . call { value : value , .KeyValues } ( "" , .TypedVals ) ;  require ( success , "WETH: ETH transfer failed" , .TypedVals ) ;  .Statements }  return true ;  .Statements
                  </contract-fn-body>
                </contract-fn>
              </contract-fns>
              <contract-events>
                <contract-event>
                  <contract-event-id>
                    approvalEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( owner )
                    ListItem ( spender )
                    ListItem ( value )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event> <contract-event>
                  <contract-event-id>
                    transferEvent
                  </contract-event-id>
                  <contract-event-arg-types>
                    ListItem ( address )
                    ListItem ( address )
                    ListItem ( uint256 )
                  </contract-event-arg-types>
                  <contract-event-param-names>
                    ListItem ( from )
                    ListItem ( to )
                    ListItem ( value )
                  </contract-event-param-names>
                  <contract-event-indexed-pos>
                    SetItem ( 0 )
                    SetItem ( 1 )
                  </contract-event-indexed-pos>
                </contract-event>
              </contract-events>
            </contract>
          </contracts>
        </compile>
      )
      [priority(40)]

endmodule
```

```k
module SOLIDITY-UNISWAP-SORTTOKENS-SUMMARY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-EXPRESSION
  imports SOLIDITY-UNISWAP-TOKENS

  rule <k> uniswapV2LibrarySortTokens:Id ( v(V1:MInt{160}, address #as T), v(V2:MInt{160}, T), .TypedVals ) => v(ListItem(V1) ListItem(V2), T[]) ...</k>
       <summarize> true </summarize>
       <store>
         S => S ListItem(V1)
                ListItem(V2)
                ListItem(default(T[]))
                ListItem(ListItem(V1) ListItem(V2))
       </store>
    requires V1 <uMInt V2 andBool V1 =/=MInt 0p160 [priority(40)]

  rule <k> uniswapV2LibrarySortTokens:Id ( v(V1:MInt{160}, address #as T), v(V2:MInt{160}, T), .TypedVals ) => v(ListItem(V2) ListItem(V1), T[]) ...</k>
       <summarize> true </summarize>
       <store>
         S => S ListItem(V1)
                ListItem(V2)
                ListItem(default(T[]))
                ListItem(ListItem(V2) ListItem(V1))
       </store>
    requires V2 <uMInt V1 andBool V2 =/=MInt 0p160 [priority(40)]

endmodule
```

```k
module SOLIDITY-UNISWAP-GETAMOUNTOUT-SUMMARY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-UNISWAP-TOKENS
  
  rule <k> uniswapV2LibraryGetAmountOut:Id ( v(V1:MInt{256}, uint256 #as T), v(V2:MInt{256}, T), v(V3:MInt{256}, T), .TypedVals ) => v((V1 *MInt 997p256  *MInt V3) /uMInt (V2 *MInt 1000p256 +MInt V1 *MInt 997p256), T) ...</k>
       <summarize> true </summarize>
       <store> S => S ListItem(V1) ListItem(V2) ListItem(V3)
                      ListItem((V1 *MInt 997p256  *MInt V3) /uMInt (V2 *MInt 1000p256 +MInt V1 *MInt 997p256) ) // amountOut
                      ListItem( V1 *MInt 997p256)                                                               // amountInWithFee
                      ListItem( V1 *MInt 997p256  *MInt V3)                                                     // numerator
                      ListItem( V2 *MInt 1000p256 +MInt V1  *MInt 997p256)                                      // denominator
       </store>
    requires V1 >uMInt 0p256 andBool V2 >uMInt 0p256 andBool V3 >uMInt 0p256 [priority(40)]

endmodule
```

```k
module SOLIDITY-UNISWAP-GETAMOUNTIN-SUMMARY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-UNISWAP-TOKENS

  rule <k> uniswapV2LibraryGetAmountIn:Id ( v(V1:MInt{256}, uint256 #as T), v(V2:MInt{256}, T), v(V3:MInt{256}, T), .TypedVals ) => v(((V2 *MInt V1 *MInt 1000p256) /uMInt ((V3 -MInt V1) *MInt 997p256)) +MInt 1p256, T) ...</k>
       <summarize> true </summarize>
       <store> S => S ListItem(V1) ListItem(V2) ListItem(V3)
                      ListItem(((V2 *MInt V1 *MInt 1000p256) /uMInt ((V3 -MInt V1) *MInt 997p256)) +MInt 1p256) // amountIn
                      ListItem(V2 *MInt V1 *MInt 1000p256)                                                      // numerator
                      ListItem((V3 -MInt V1) *MInt 997p256)                                                     // denominator
       </store>
    requires V1 >uMInt 0p256 andBool V2 >uMInt 0p256 andBool V3 >uMInt 0p256
     andBool ((V3 -MInt V1) *MInt 997p256) =/=MInt 0p256 [priority(40)]


    rule <k> uniswapV2LibraryGetAmountIn:Id ( v(V1:MInt{256}, uint256 #as T), v(V2:MInt{256}, T), v(V3:MInt{256}, T), .TypedVals ) => v(1p256, T) ...</k>
       <summarize> true </summarize>
       <store> S => S ListItem(V1) ListItem(V2) ListItem(V3)
                      ListItem(1p256)                        // amountIn
                      ListItem(V2 *MInt V1 *MInt 1000p256)   // numerator
                      ListItem((V3 -MInt V1) *MInt 997p256)  // denominator
       </store>
    requires V1 >uMInt 0p256 andBool V2 >uMInt 0p256 andBool V3 >uMInt 0p256
     andBool ((V3 -MInt V1) *MInt 997p256) ==MInt 0p256 [priority(40)]

endmodule
```

```k  
module SOLIDITY-UNISWAP-PAIRFOR-SUMMARY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-EXPRESSION
  imports SOLIDITY-UNISWAP-TOKENS

  rule <k> uniswapV2LibraryPairFor:Id ( v(V1:MInt{160}, address), v(V2:MInt{160}, address), .TypedVals ) => v(read({CS [ localPairs ] orDefault .Map}:>Value, ListItem(V1) ListItem(V2), T), address) ...</k>
       <summarize> true </summarize>
       <this> THIS </this>
       <contract-address> THIS </contract-address>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... localPairs |-> ((mapping (address _ => mapping (address _ => address ) )) #as T) ...</contract-state>
       <contract-storage> CS </contract-storage>
       <store>
         S => S ListItem(V1)
                ListItem(V2)
                ListItem(read({CS [ localPairs ] orDefault .Map}:>Value, ListItem(V1) ListItem(V2), T))
                ListItem(V1)
                ListItem(V2)
                ListItem(default(address[]))
                ListItem( ListItem(V1) ListItem(V2) )
                ListItem( ListItem(V1) ListItem(V2) )
       </store>
    requires V1 <uMInt V2 andBool V1 =/=MInt 0p160 [priority(40)]

  rule <k> uniswapV2LibraryPairFor:Id ( v(V1:MInt{160}, address), v(V2:MInt{160}, address), .TypedVals ) => v(read({CS [ localPairs ] orDefault .Map}:>Value, ListItem(V2) ListItem(V1), T), address) ...</k>
       <summarize> true </summarize>
       <this> THIS </this>
       <contract-address> THIS </contract-address>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... localPairs |-> ((mapping (address _ => mapping (address _ => address ) )) #as T) ...</contract-state>
       <contract-storage> CS </contract-storage>
       <store>
         S => S ListItem(V1)
                ListItem(V2)
                ListItem(read({CS [ localPairs ] orDefault .Map}:>Value, ListItem(V2) ListItem(V1), T))
                ListItem(V1)
                ListItem(V2)
                ListItem(default(address[]))
                ListItem( ListItem(V2) ListItem(V1) )
                ListItem( ListItem(V2) ListItem(V1) )
       </store>
    requires V2 <uMInt V1 andBool V2 =/=MInt 0p160 [priority(40)]

endmodule
```

```k
module SOLIDITY-UNISWAP-SUMMARIES
  imports SOLIDITY-UNISWAP-INIT-SUMMARY
  imports SOLIDITY-UNISWAP-SORTTOKENS-SUMMARY
  imports SOLIDITY-UNISWAP-GETAMOUNTOUT-SUMMARY
  imports SOLIDITY-UNISWAP-GETAMOUNTIN-SUMMARY
  imports SOLIDITY-UNISWAP-PAIRFOR-SUMMARY

endmodule
```
