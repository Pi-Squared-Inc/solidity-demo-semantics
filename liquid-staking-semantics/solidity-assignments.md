# Solidity Assignment evaluations
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-ASSIGNMENTS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports LIST
     imports BOOL


     // ELEMENTARY ASSIGNMENTS KEPT INFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I1:Id = E:Expression) => ESTACK ListItem(I1) ListItem("=") ListItem(E) </expressionStack>
          <computationStack> .List </computationStack>

     // MAPPING ASSIGNMENTS KEPT INFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I1:Id [ I2:Id ] = E:Expression) => ESTACK ListItem( I1[I2] ) ListItem("=") ListItem(E) </expressionStack>
          <computationStack> .List </computationStack>

     // INDEXING FOR LHS MAPPING (TODO: NEED TO HANDLE EXPRESSIONS)
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <localVariableValues> ... I2 |-> V2 ... </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>

     rule <k> .K => .K ... </k>
          <runningContract> C:Id </runningContract>
          <localVariables> ...
               <localVariableValues> VALUES </localVariableValues>
          </localVariables>
          <stateVariables>...
               <stateVariableValues> ... C..I2 |-> V2 ... </stateVariableValues>
          </stateVariables>
          <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>
          requires notBool I2 in_keys(VALUES)
          
     // ASSIGNMENT DONE IF RHS IS LITERAL
     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> _T:ElementaryNumeralType ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- V ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List </expressionStack>
          <computationStack> .List </computationStack>

     rule <k> .K => .K ... </k>
          <runningContract> C:Id </runningContract>
          <localVariables> ...
               <localVariableValues> LOCALVALUES </localVariableValues>
          </localVariables>
          <stateVariables>...
               <stateVariableTypes> ... C..I |-> _T:ElementaryNumeralType ...</stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ C..I <- V ] </stateVariableValues>
          </stateVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List </expressionStack>
          <computationStack> .List </computationStack>
          requires notBool I in_keys(LOCALVALUES)


     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> _T:ElementaryAddressType ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- A ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(A:AddressLiteral) => .List </expressionStack>
          <computationStack> .List </computationStack>


     rule <k> .K => .K ... </k>
          <runningContract> C:Id </runningContract>
          <localVariables> ...
               <localVariableValues> LOCALVALUES </localVariableValues>
          </localVariables>
          <stateVariables>...
               <stateVariableTypes> ... C..I |-> _T:ElementaryAddressType ...</stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ C..I <- V ] </stateVariableValues>
          </stateVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:AddressLiteral) => .List </expressionStack>
          <computationStack> .List </computationStack>
          requires notBool I in_keys(LOCALVALUES)


     // ASSIGNMENT DONE IF RHS IS LITERAL 
     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> mapping ( address => uint256 ) ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I[A] <- V ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id[A:Literal]) ListItem("=") ListItem(V:Int) => .List </expressionStack>
     
     rule <k> .K => .K ... </k>
          <runningContract> C:Id </runningContract>
          <localVariables> ...
               <localVariableValues> LOCALVALUES </localVariableValues>
          </localVariables>
          <stateVariables>...
               <stateVariableTypes> ... C..I |-> mapping ( address => uint256 ) ...</stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ C..I[A] <- V ] </stateVariableValues>
          </stateVariables>
          <expressionStack> ListItem(I:Id[A:Literal]) ListItem("=") ListItem(V:Int) => .List </expressionStack>
          requires notBool I in_keys(LOCALVALUES)


     // OPERATION-ASSIGNMENTS ARE EXPANDED FOR ID LHS
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I:Id += E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("+") ListItem(I) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I:Id -= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("-") ListItem(I) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I:Id *= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("*") ListItem(I) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I:Id /= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("/") ListItem(I) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // ADDITION-ASSIGNMENT IS EXPANDED FOR MAPPING LHS
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <localVariableValues> ... I2 |-> V2 ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I1:Id[I2:Id] += E2:Expression) => ESTACK ListItem(I1[V2]) ListItem("=") ListItem("+") ListItem(I1[V2]) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <runningContract> C:Id </runningContract>
          <localVariables> ...
               <localVariableValues> VALUES </localVariableValues>
          </localVariables>
          <stateVariables>...
               <stateVariableValues> ... C..I2 |-> V2 ... </stateVariableValues>
          </stateVariables>
          <expressionStack> ESTACK ListItem(I1:Id[I2:Id] += E2:Expression) => ESTACK ListItem(I1[V2]) ListItem("=") ListItem("+") ListItem(I1[V2]) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>
          requires notBool I2 in_keys(VALUES)

endmodule
```
