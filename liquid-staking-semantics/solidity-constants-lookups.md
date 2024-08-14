# Solidity Constant-Subdenom Calculations and Varaible Lookups
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-LOOKUPS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports BOOL
     imports INT
     imports LIST


     // VARIABLE LOOKUP
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id) => ESTACK ListItem(V)</expressionStack>
          

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I2 |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I1:Id[I2:Id]) => ESTACK ListItem(I1[V])</expressionStack>

     // SUBDENOM CALCULATE
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(V:Int days) => ESTACK ListItem(V *Int 86400)</expressionStack>

     // MAPPING LOOKUP
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I[A] |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(V)</expressionStack>

     // MAPPING DEFAULT LOOKUP - 0
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> VALUES </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(0)</expressionStack>
          requires notBool I[A] in_keys(VALUES)


     // BLOCK.TIMSTAMP LOOKUP (TODO: TREATED AS 0, CHANGE LATER)
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(_B:BlockTimestampLiteral) => ESTACK ListItem(1800000000)</expressionStack>

     
endmodule
```
