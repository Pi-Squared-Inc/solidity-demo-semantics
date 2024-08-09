```k
requires "solidity-liquid-staking-syntax.md"

module SOLIDITY-LIQUID-STAKING
    imports SOLIDITY-LIQUID-STAKING-SYNTAX
    imports BOOL
    imports INT
    imports STRING
    imports LIST

    configuration   <Sol>
                    <k> $PGM:Block </k>
                    <locals> .Map </locals>
                    <stack> .List </stack>
                    <expressionStack> .List </expressionStack>
                    </Sol>

    rule <k> { P:Statements } => P ...</k>
    rule <k> S:Statement P:Statements => S ~> P ...</k>

    rule <k> _T:TypeName I:Id ; => .K ... </k>
         <locals> STATE => STATE [ I <- 0 ]  </locals>

    rule <k> _T:TypeName I:Id = E:Expression; => .K ...</k>
         <locals> STATE => STATE [ I <- 0 ] </locals>
         <stack> .List => ListItem(I:Id = E:Expression) </stack>

    rule <k> E:Expression; => .K ...</k>
         <stack> .List => ListItem(E) </stack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(I1:Id = E:Expression) => STACK ListItem(I1) ListItem("=") ListItem(E) </stack>
         <expressionStack> .List </expressionStack>

    rule <k> .K => .K ... </k>
         <locals> STATE => STATE [ I <- V ] </locals>
         <stack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List  </stack>
         <expressionStack> .List </expressionStack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(E1:Expression + E2:Expression) => STACK ListItem("+") ListItem(E1) </stack>
         <expressionStack> ESTACK => ESTACK ListItem(E2) </expressionStack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(E1:Expression - E2:Expression) => STACK ListItem("-") ListItem(E1) </stack>
         <expressionStack> ESTACK => ESTACK ListItem(E2) </expressionStack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(E1:Expression * E2:Expression) => STACK ListItem("*") ListItem(E1)</stack>
         <expressionStack> ESTACK => ESTACK ListItem(E2) </expressionStack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(E1:Expression / E2:Expression) => STACK ListItem("/") ListItem(E1)</stack>
         <expressionStack> ESTACK => ESTACK ListItem(E2) </expressionStack>

    rule <k> .K => .K ... </k>
         <locals> ... I |-> V ... </locals>
         <stack> STACK ListItem(I:Id) => STACK ListItem(V)</stack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem(V:Int) => STACK ListItem(V) ListItem(E)</stack>
         <expressionStack> ESTACK ListItem(E:Expression)=> ESTACK </expressionStack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem("+") ListItem(V1:Int) ListItem(V2:Int) => STACK ListItem(V1 +Int V2) </stack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem("-") ListItem(V1:Int) ListItem(V2:Int) => STACK ListItem(V1 -Int V2) </stack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem("*") ListItem(V1:Int) ListItem(V2:Int) => STACK ListItem(V1 *Int V2) </stack>

    rule <k> .K => .K ... </k>
         <stack> STACK ListItem("/") ListItem(V1:Int) ListItem(V2:Int) => STACK ListItem(V1 /Int V2) </stack>


    rule <k> .Statements => .K ...</k>

endmodule
```
