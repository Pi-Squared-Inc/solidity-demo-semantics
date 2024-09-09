.PHONY: build clean test test-tokens test-staking test-lending test-swap test-erc20 test-erc1155 test-liquid test-lido test-lendingpool test-aave test-regression

SEMANTICS_DIR = src
TEST_DIR = test
EXAMPLES_DIR = $(TEST_DIR)/examples
SEMANTICS_FILE_NAME = solidity
SEMANTICS_FILE = $(SEMANTICS_FILE_NAME).md
MAIN_MODULE = SOLIDITY
OUTPUT_DIR = out

UNISWAP_PARAMS = $(EXAMPLES_DIR)/swaps/UniswapV2Swap.sol 2>&1 1>$(OUTPUT_DIR)/uniswap.ast
UNISWAPRN_PARAMS = $(EXAMPLES_DIR)/swaps/UniswapV2SwapRenamed.sol 2>&1 1>$(OUTPUT_DIR)/uniswaprn.ast
SOMETOKEN_PARAMS = $(EXAMPLES_DIR)/tokens/SomeToken.sol 2>&1 1>$(OUTPUT_DIR)/sometoken.ast
SOMEMULTITOKEN_PARAMS = $(EXAMPLES_DIR)/tokens/SomeMultiToken.sol 2>&1 1>$(OUTPUT_DIR)/somemultitoken.ast
LIQUIDSTAKING_PARAMS = $(EXAMPLES_DIR)/staking/LiquidStaking.sol 2>&1 1>$(OUTPUT_DIR)/liquidstaking.ast
LIDO_PARAMS = $(EXAMPLES_DIR)/staking/LidoStaking.sol 2>&1 1>$(OUTPUT_DIR)/lidostaking.ast
LENDINGPOOL_PARAMS = $(EXAMPLES_DIR)/lending/LendingPool.sol 2>&1 1>$(OUTPUT_DIR)/lendingpool.ast
AAVE_PARAMS = $(EXAMPLES_DIR)/lending/AaveLendingPool.sol 2>&1 1>$(OUTPUT_DIR)/aave.ast
REGRESSION_TESTS = $(patsubst %.sol, %.out, $(wildcard $(TEST_DIR)/regression/*.sol))

build: $(SEMANTICS_DIR)/$(SEMANTICS_FILE)
	kompile $(SEMANTICS_DIR)/$(SEMANTICS_FILE) --main-module $(MAIN_MODULE) --gen-glr-bison-parser -O2

clean:
	rm -Rf $(SEMANTICS_FILE_NAME)-kompiled
	rm -Rf $(OUTPUT_DIR)
	rm -Rf $(TEST_DIR)/regression/*.out

test: test-swaps test-tokens test-staking test-lending test-regression

test-swaps: test-swap test-swaprn

test-tokens: test-erc20 test-erc1155

test-staking: test-liquid test-lido

test-lending: test-lendingpool test-aave

test-swap:
	mkdir -p $(OUTPUT_DIR)
	kparse $(UNISWAP_PARAMS)

test-swaprn:
	mkdir -p $(OUTPUT_DIR)
	kparse $(UNISWAPRN_PARAMS)

test-erc20:
	mkdir -p $(OUTPUT_DIR)
	kparse $(SOMETOKEN_PARAMS)

test-erc1155:
	mkdir -p $(OUTPUT_DIR)
	kparse $(SOMEMULTITOKEN_PARAMS)

test-liquid:
	mkdir -p $(OUTPUT_DIR)
	kparse $(LIQUIDSTAKING_PARAMS)

test-lido:
	mkdir -p $(OUTPUT_DIR)
	kparse $(LIDO_PARAMS)

test-lendingpool:
	mkdir -p $(OUTPUT_DIR)
	kparse $(LENDINGPOOL_PARAMS)

test-aave:
	mkdir -p $(OUTPUT_DIR)
	kparse $(AAVE_PARAMS)

test-regression: ${REGRESSION_TESTS}

%.out: %.sol %.txn %.ref $(SEMANTICS_FILE_NAME)-kompiled/timestamp
	ulimit -s 65536 && bin/krun-sol $*.sol $*.txn > $*.out
	diff -U3 -w $*.ref $*.out
