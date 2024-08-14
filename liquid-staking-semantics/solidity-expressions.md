# Solidity Expression Evaluation
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-EXPRESSIONS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports LIST

     // EXPRESSIONS GO TO EXPRESSION STACK
     rule <k> E:Expression; => .K ...</k>
          <expressionStack> .List => ListItem(E) </expressionStack>
          <computationStack> .List </computationStack>

     // ARITHMETIC OPERATIONS ARE KEPT PREFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression + E2:Expression) => ESTACK ListItem("+") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression - E2:Expression) => ESTACK ListItem("-") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression * E2:Expression) => ESTACK ListItem("*") ListItem(E1)</expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression / E2:Expression) => ESTACK ListItem("/") ListItem(E1)</expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // COMPARISON OPERATIONS ARE KEPT PREFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression > E2:Expression) => ESTACK ListItem(">") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression >= E2:Expression) => ESTACK ListItem(">=") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression < E2:Expression) => ESTACK ListItem("<") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression <= E2:Expression) => ESTACK ListItem("<=") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>
     
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression == E2:Expression) => ESTACK ListItem("==") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(E1:Expression != E2:Expression) => ESTACK ListItem("!=") ListItem(E1) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // MOVE THE LATEST EXPRESSION TO THE TOP OF THE EXPRESSION STACK FOR EVALUATION
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(V:Int) => ESTACK ListItem(V) ListItem(E)</expressionStack>
          <computationStack> CSTACK ListItem(E:Expression) => CSTACK </computationStack>

     
endmodule
```
