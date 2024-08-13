```k
requires "solidity-liquid-staking-syntax.md"
requires "network.md"

// TODO: SIMPLE SINGLE FUNCTION CALL
// TODO: CONTRACT DECLARATION
// TODO: TEST CALL: BODY AFTER CONTRACTS
// TODO: NESTED FUNCTION CALL
// TODO: INTERFACE DECLARATION
// TODO: CASTING TO INTERFACE
// TODO: NETWORK INTERACTIONS

module SOLIDITY-LIQUID-STAKING
     imports SOLIDITY-LIQUID-STAKING-SYNTAX
     imports BOOL
     imports INT
     imports STRING
     imports LIST
     imports NETWORK

     configuration  <Sol>
                         <k> $PGM:ContractBodyElements </k>
                         
                         <stateVariables>
                              <stateVariableVisibilities> .Map </stateVariableVisibilities>
                              <stateVariableTypes> .Map </stateVariableTypes>
                              <stateVariableValues> .Map </stateVariableValues>
                         </stateVariables>

                         <localVariables>
                              <localVariableTypes> .Map </localVariableTypes>
                              <localVariableValues> .Map </localVariableValues>
                         </localVariables>

                         <functions>
                              <functionParameters> .Map </functionParameters>
                              <functionSpecifiers> .Map </functionSpecifiers>
                              <functionBodies> .Map </functionBodies>
                              <functionReturns> .Map </functionReturns>
                         </functions>

                         <constructor>
                              <constructorParameters> .K </constructorParameters>
                              <constructorBody> .K </constructorBody>
                         </constructor>

                         <expressionStack> .List </expressionStack>
                         <computationStack> .List </computationStack>
                         <status> EVMC_SUCCESS </status>
                         <output> "" </output>
                         <debug> .List </debug>
                    </Sol>


     // ALL DECLARATIONS
     rule <k> S:StateVariableDeclaration C:ContractBodyElements => S ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> F:FunctionDefinition C:ContractBodyElements => F ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> CD:ConstructorDefinition C:ContractBodyElements => CD ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> B:Block C:ContractBodyElements => B ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     // STATE VARIABLE DECLARATION
     rule <k> T:ElementaryNumeralType V:VisibilitySpecifier I:Id; => .K ... </k>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ I <- 0 ] </stateVariableValues>
          </stateVariables>
     
     rule <k> T:ElementaryNumeralType V:VisibilitySpecifier I:Id = L:IntLiteral; => .K ... </k>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ I <- L ] </stateVariableValues>
          </stateVariables>

     rule <k> T:ElementaryAddressType V:VisibilitySpecifier I:Id; => .K ... </k>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ I <- 0x0000000000000000000000000000000000000000 ] </stateVariableValues>
          </stateVariables>
     
     rule <k> T:ElementaryAddressType V:VisibilitySpecifier I:Id = L:AddressLiteral; => .K ... </k>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ I <- L ] </stateVariableValues>
          </stateVariables>

     rule <k> T:MappingType V:VisibilitySpecifier I:Id ; => .K ... </k>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ I <- T ] </stateVariableTypes>
               ...
          </stateVariables>
     

     // FUNCTION DECLARATION
     rule <k> function I:Id ( P:ParameterList ) FS:FunctionSpecifier FB:FunctionBody => .K ... </k>
          <functions>
               <functionParameters> PARAMETERS => PARAMETERS [ I <- P ] </functionParameters>
               <functionSpecifiers> SPECIFIERS => SPECIFIERS [ I <- FS ] </functionSpecifiers>
               <functionBodies> BODIES => BODIES [ I <- FB ] </functionBodies>
               <functionReturns> RETURNS => RETURNS [ I <- "" ] </functionReturns>
          </functions>

     rule <k> function I:Id ( P:ParameterList ) FS:FunctionSpecifier returns( RP:ParameterList ) FB:FunctionBody => .K ... </k>
          <functions>
               <functionParameters> PARAMETERS => PARAMETERS [ I <- P ] </functionParameters>
               <functionSpecifiers> SPECIFIERS => SPECIFIERS [ I <- FS ] </functionSpecifiers>
               <functionBodies> BODIES => BODIES [ I <- FB ] </functionBodies>
               <functionReturns> RETURNS => RETURNS [ I <- RP ] </functionReturns>
          </functions>

     // CONSTRUCTOR DECLARATION
     rule <k> constructor ( P:ParameterList ) B:Block => .K ... </k>
          <constructor>
               <constructorParameters> .K => P </constructorParameters>
               <constructorBody> .K => B </constructorBody>
          </constructor>

     // STATEMENT(S) EXECUTION
     rule <k> { P:Statements } => P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> S:Statement P:Statements => S ~> P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> _P:Statements ~> .K => .K </k>
          <status> EVMC_REVERT </status>

     // ELEMANTARY VARIABLE DECLARATION
     rule <k> T:ElementaryNumeralType I:Id ; => .K ... </k>
          <localVariables>
               <localVariableTypes> TYPES => TYPES [ I <- T ] </localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- 0 ] </localVariableValues>
          </localVariables>
     
     rule <k> T:ElementaryAddressType I:Id ; => .K ... </k>
          <localVariables>
               <localVariableTypes> TYPES => TYPES [ I <- T ] </localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- 0x0000000000000000000000000000000000000000 ] </localVariableValues>
          </localVariables>

     // MAPPING DECLARATION
     rule <k> T:MappingType I:Id ; => .K ... </k>
          <localVariables>
               ...
               <localVariableTypes> TYPES => TYPES [ I <- T ] </localVariableTypes>
          </localVariables>

     // ELEMANTARY VARIABLE DECLARATION AND ASSIGNMENT
     rule <k> T:ElementaryType I:Id = E:Expression; ~> P:Statements => T I; ~> I = E; P ...</k>

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
               <localVariableValues> ... I2 |-> V2 ... </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>

     // ASSIGNMENT DONE IF RHS IS LITERAL
     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> _T:ElementaryNumeralType ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- V ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List  </expressionStack>
          <computationStack> .List </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> _T:ElementaryAddressType ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I <- A ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id) ListItem("=") ListItem(A:AddressLiteral) => .List  </expressionStack>
          <computationStack> .List </computationStack>

     // ASSIGNMENT DONE IF RHS IS LITERAL 
     rule <k> .K => .K ... </k>
          <localVariables>
               <localVariableTypes> ... I |-> mapping ( address => uint256 ) ...</localVariableTypes>
               <localVariableValues> VALUES => VALUES [ I[A] <- V ] </localVariableValues>
          </localVariables>
          <expressionStack> ListItem(I:Id[A:Literal]) ListItem("=") ListItem(V:Int) => .List </expressionStack>

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
               <localVariableValues> ... I |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id += E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("+") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id -= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("-") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id *= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("*") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     rule <k> .K => .K ... </k>
          <localVariables> ...
               <localVariableValues> ... I |-> V ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I:Id /= E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("/") ListItem(V) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

     // ADDITION-ASSIGNMENT IS EXPANDED FOR MAPPING LHS
     rule <k> .K => .K ... </k>
          <localVariables>
               ...
               <localVariableValues> ... I2 |-> V2 ... </localVariableValues>
          </localVariables>
          <expressionStack> ESTACK ListItem(I1:Id[I2:Id] += E2:Expression) => ESTACK ListItem(I1[V2]) ListItem("=") ListItem("+") ListItem(I1[V2]) </expressionStack>
          <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

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


     rule <k> .ContractBodyElements ~> .K => .K </k>          
     rule <k> .Statements => .K ...</k>
     
endmodule
```
