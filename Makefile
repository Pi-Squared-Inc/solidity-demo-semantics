SYNTAX_DIR = solidity-lite-syntax
EXAMPLES_DIR = $(SYNTAX_DIR)/examples
SYNTAX_FILE_NAME = solidity-syntax
SYNTAX_FILE = $(SYNTAX_FILE_NAME).md
MAIN_MODULE = SOLIDITY
OUTPUT_DIR = out

UNISWAP_PARAMS = $(EXAMPLES_DIR)/swaps/UniswapV2Swap.sol 2>&1 1>$(OUTPUT_DIR)/uniswap.ast
SOMETOKEN_PARAMS = $(EXAMPLES_DIR)/tokens/SomeToken.sol 2>&1 1>$(OUTPUT_DIR)/sometoken.ast
SOMEMULTITOKEN_PARAMS = $(EXAMPLES_DIR)/tokens/SomeMultiToken.sol 2>&1 1>$(OUTPUT_DIR)/somemultitoken.ast
LIQUIDSTAKING_PARAMS = $(EXAMPLES_DIR)/staking/LiquidStaking.sol 2>&1 1>$(OUTPUT_DIR)/liquidstaking.ast
LIDO_PARAMS = $(EXAMPLES_DIR)/staking/LidoStaking.sol 2>&1 1>$(OUTPUT_DIR)/lidostaking.ast
LENDINGPOOL_PARAMS = $(EXAMPLES_DIR)/lending/LendingPool.sol 2>&1 1>$(OUTPUT_DIR)/lendingpool.ast
AAVE_PARAMS = $(EXAMPLES_DIR)/lending/AaveLendingPool.sol 2>&1 1>$(OUTPUT_DIR)/aave.ast

build: $(SYNTAX_DIR)/$(SYNTAX_FILE)
	kompile $(SYNTAX_DIR)/$(SYNTAX_FILE) --main-module $(MAIN_MODULE) 

build-bison: $(SYNTAX_DIR)/$(SYNTAX_FILE)
	kompile $(SYNTAX_DIR)/$(SYNTAX_FILE) --main-module $(MAIN_MODULE) --gen-glr-bison-parser

clean:
	rm -Rf $(SYNTAX_FILE_NAME)-kompiled
	rm -Rf $(OUTPUT_DIR)

test: test-swap test-tokens test-staking test-lending

test-tokens: test-erc20 test-erc1155

test-staking: test-liquid test-lido

test-lending: test-lendingpool test-aave

test-swap: 
	mkdir -p $(OUTPUT_DIR)
	kast $(UNISWAP_PARAMS)

test-erc20: 
	mkdir -p $(OUTPUT_DIR)
	kast $(SOMETOKEN_PARAMS)

test-erc1155: 
	mkdir -p $(OUTPUT_DIR)
	kast $(SOMEMULTITOKEN_PARAMS)

test-liquid: 
	mkdir -p $(OUTPUT_DIR)
	kast $(LIQUIDSTAKING_PARAMS)

test-lido: 
	mkdir -p $(OUTPUT_DIR)
	kast $(LIDO_PARAMS)

test-lendingpool: 
	mkdir -p $(OUTPUT_DIR)
	kast $(LENDINGPOOL_PARAMS)

test-aave: 
	mkdir -p $(OUTPUT_DIR)
	kast $(AAVE_PARAMS)

test-bison: test-bison-swap test-bison-tokens test-bison-staking test-bison-lending

test-bison-tokens: test-bison-erc20 test-bison-erc1155

test-bison-staking: test-bison-liquid test-bison-lido

test-bison-lending: test-bison-lendingpool test-bison-aave

test-bison-swap:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(UNISWAP_PARAMS)

test-bison-erc20:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(SOMETOKEN_PARAMS)

test-bison-erc1155:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(SOMEMULTITOKEN_PARAMS)

test-bison-liquid:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(LIQUIDSTAKING_PARAMS)

test-bison-lido:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(LIDO_PARAMS)

test-bison-lendingpool:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(LENDINGPOOL_PARAMS)

test-bison-aave:
	mkdir -p $(OUTPUT_DIR)
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(AAVE_PARAMS)
