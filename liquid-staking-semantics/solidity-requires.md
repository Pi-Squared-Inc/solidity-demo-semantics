# Solidity Handling of `require()` statement
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-REQUIRES
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports BOOL
     imports LIST

     // REQUIRE OPERATIONS KEPT INFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(require(E:Expression, L:StringLiteral)) => ESTACK ListItem("require") ListItem(L) ListItem(E) </expressionStack>
          <computationStack> .List </computationStack>


     // REQUIRE EVALUATES TRUE
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("require") ListItem(_L:StringLiteral) ListItem(true) => ESTACK </expressionStack>
          <computationStack> .List </computationStack>
     
     // REQUIRE EVALUATES FALSE (TODO: HANDLE REVERTS) (TODO: HANDLE last line require)
     rule <k> _S:Statement => .K ... </k>
          <expressionStack> _ESTACK ListItem("require") ListItem(L:StringLiteral) ListItem(false) => .List </expressionStack>
          <status> _STAT => EVMC_REVERT </status>
          <output> _OUT => L </output>
          <computationStack> .List </computationStack>
     
endmodule
```
