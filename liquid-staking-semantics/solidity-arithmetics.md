# Solidity Arithmetic Operations
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-ARITHMETICS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports BOOL
     imports INT
     imports LIST


     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("+") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 +Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("-") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 -Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("*") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 *Int V2) </expressionStack>
          
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("/") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 /Int V2) </expressionStack>


     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(">") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 >Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(">=") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 >=Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("<") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 < V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("<=") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 <=Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("==") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 ==Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("!=") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 =/=Int V2) </expressionStack>

     
endmodule
```
