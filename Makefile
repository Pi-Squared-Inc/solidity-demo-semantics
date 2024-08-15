SYNTAX_DIR = uniswap-semantics
EXAMPLES_DIR = $(SYNTAX_DIR)/examples
SYNTAX_FILE_NAME = solidity-syntax
SYNTAX_FILE = $(SYNTAX_FILE_NAME).md
EXAMPLE_FILE = UniswapV2Swap.sol
MAIN_MODULE = SOLIDITY-SYNTAX

build: $(SYNTAX_DIR)/$(SYNTAX_FILE)
	kompile $(SYNTAX_DIR)/$(SYNTAX_FILE) --main-module $(MAIN_MODULE) 

build-bison: $(SYNTAX_DIR)/$(SYNTAX_FILE)
	kompile $(SYNTAX_DIR)/$(SYNTAX_FILE) --main-module $(MAIN_MODULE) --gen-glr-bison-parser

clean:
	rm -Rf $(SYNTAX_FILE_NAME)-kompiled

test:
	kast $(EXAMPLES_DIR)/$(EXAMPLE_FILE)

test-bison:
	./$(SYNTAX_FILE_NAME)-kompiled/parser_PGM $(EXAMPLES_DIR)/$(EXAMPLE_FILE)