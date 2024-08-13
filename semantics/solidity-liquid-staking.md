```k
requires "solidity-liquid-staking-syntax.md"
requires "network.md"

module SOLIDITY-LIQUID-STAKING
     imports SOLIDITY-LIQUID-STAKING-SYNTAX
     imports BOOL
     imports INT
     imports STRING
     imports LIST
     imports NETWORK
     //imports K-EQUAL

     //syntax TypeName ::= String2TypeName(String) [function, hook(STRING.string2token)]
     //syntax String ::= TypeName2String(ElementaryType) [function, hook(STRING.token2string)]

     configuration  <Sol>
                         <k> $PGM:Block </k>
                         <localVariables>
                              <variableTypes> .Map </variableTypes>
                              <variableValues> .Map </variableValues>
                         </localVariables>
                         <expressionStack> .List </expressionStack>
                         <computationStack> .List </computationStack>
                         <status> EVMC_SUCCESS </status>
                         <output> "" </output>
                         <debug> .List </debug>
                    </Sol>

     // STATEMENT(S) EXECUTION
     rule <k> { P:Statements } => P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> S:Statement P:Statements => S ~> P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> _P:Statements ~> .K => .K </k>
          <status> EVMC_REVERT </status>

     // ELEMANTARY VARIABLE DECLARATION
     rule <k> T:ElementaryType I:Id ; => .K ... </k>
          <localVariables>
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
               <variableValues> VALUES => VALUES [ I <- 0 ] </variableValues>
          </localVariables>

     // MAPPING DECLARATION
     rule <k> T:MappingType I:Id ; => .K ... </k>
          <localVariables>
               ...
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
          </localVariables>

     // ELEMANTARY VARIABLE DECLARATION AND ASSIGNMENT
     rule <k> T:ElementaryType I:Id = E:Expression; => .K ...</k>
          <localVariables>
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
               <variableValues> VALUES => VALUES [ I <- 0 ] </variableValues>
          </localVariables>
          <expressionStack> .List => ListItem(I = E) </expressionStack>

     // EXPRESSIONS GO TO EXPRESSION STACK
     rule <k> E:Expression; => .K ...</k>
          <expressionStack> .List => ListItem(E) </expressionStack>

     // REQUIRE OPERATIONS KEPT INFIX
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(require(E:Expression, L:StringLiteral)) => ESTACK ListItem("require") ListItem(L) ListItem(E) </expressionStack>
          <computationStack> .List </computationStack>

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
               <variableValues> ... I2 |-> V2 ... </variableValues>
          </localVariables>
          <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>

     // ASSIGNMENT DONE IF RHS IS LITERAL
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I <- V ] </variableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List  </expressionStack>
          <computationStack> .List </computationStack>

     // ASSIGNMENT DONE IF RHS IS LITERAL 
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I[A] <- V ] </variableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id[A:Literal]) ListItem("=") ListItem(V:Int) => .List </expressionStack>

     // ASSIGNMENT DONE IF RHS IS ADDRESS LITERAL 
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I <- A ] </variableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(A:AddressLiteral) => .List  </expressionStack>
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

     // OPERATION-ASSIGNMENTS ARE EXPANDED FOR ID LHS
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id += E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("+") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id -= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("-") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id *= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("*") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id /= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("/") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // ADDITION-ASSIGNMENT IS EXPANDED FOR MAPPING LHS
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <variableValues> ... I2 |-> V2 ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I1:Id[I2:Id] += E2:Expression) => ESTACK ListItem(I1[V2]) ListItem("=") ListItem("+") ListItem(I1[V2]) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // VARIABLE LOOKUP
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id) => ESTACK ListItem(V)</expressionStack>

     // MAPPING LOOKUP
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I[A] |-> V ... </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(V)</expressionStack>

     // MAPPING DEFAULT LOOKUP - 0
     rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> VALUES </variableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(0)</expressionStack>
          requires notBool I[A] in_keys(VALUES)


     // BLOCK.TIMSTAMP LOOKUP (TODO: TREATED AS 0, CHANGE LATER)
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(_B:BlockTimestampLiteral) => ESTACK ListItem(0)</expressionStack>

     // MOVE THE LATEST EXPRESSION TO THE TOP OF THE EXPRESSION STACK FOR EVALUATION
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(V:Int) => ESTACK ListItem(V) ListItem(E)</expressionStack>
          <computationStack> CSTACK ListItem(E:Expression) => CSTACK </computationStack>

     // ARITHMETIC COMPUTATION
     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("+") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 +Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("-") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 -Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("*") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 *Int V2) </expressionStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem("/") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 /Int V2) </expressionStack>

     // COMPARISON COMPUTATION
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

     rule <k> .Statements => .K ...</k>
     
endmodule
```
