#!/bin/bash

krun test/examples/swaps/UniswapV2Swap.sol -cTXN=test/transactions/swaps/UniswapTest.txn -pTXN="$(dirname "$0")/kparse-txn" "$@"
