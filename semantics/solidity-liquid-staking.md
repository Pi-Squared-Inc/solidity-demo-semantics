```k
requires "solidity-liquid-staking-syntax.md"

module SOLIDITY-LIQUID-STAKING
    imports SOLIDITY-LIQUID-STAKING-SYNTAX
    imports BOOL
    imports INT
    imports STRING
    imports LIST
    //imports K-EQUAL

    //syntax TypeName ::= String2TypeName(String) [function, hook(STRING.string2token)]
    //syntax String ::= TypeName2String(ElementaryType) [function, hook(STRING.token2string)]

    configuration   <Sol>
                    <k> $PGM:Block </k>
                    <localVariables>
                         <variableTypes>.Map</variableTypes>
                         <variableValues>.Map</variableValues>
                    </localVariables>
                    <expressionStack> .List </expressionStack>
                    <computationStack> .List </computationStack>
                    <debug> .List </debug>
                    </Sol>

    rule <k> { P:Statements } => P ...</k>
    rule <k> S:Statement P:Statements => S ~> P ...</k>

    /* VARIABLE DECLARATION */
    rule <k> T:ElementaryType I:Id ; => .K ... </k>
         <localVariables>
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
               <variableValues> VALUES => VALUES [ I <- 0 ] </variableValues>
         </localVariables>

    rule <k> T:MappingType I:Id ; => .K ... </k>
         <localVariables>
               ...
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
         </localVariables>

    rule <k> T:ElementaryType I:Id = E:Expression; => .K ...</k>
         <localVariables>
               <variableTypes> TYPES => TYPES [ I <- T ] </variableTypes>
               <variableValues> VALUES => VALUES [ I <- 0 ] </variableValues>
         </localVariables>
         <expressionStack> .List => ListItem(I = E) </expressionStack>
     /* VARIABLE DECLARATION */

    rule <k> E:Expression; => .K ...</k>
         <expressionStack> .List => ListItem(E) </expressionStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem(I1:Id = E:Expression) => ESTACK ListItem(I1) ListItem("=") ListItem(E) </expressionStack>
         <computationStack> .List </computationStack>


    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem(I1:Id [ I2:Id ] = E:Expression) => ESTACK ListItem( I1[I2] ) ListItem("=") ListItem(E) </expressionStack>
         <computationStack> .List </computationStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I <- V ] </variableValues>
          </localVariables>
         <expressionStack> ListItem(I:Id) ListItem("=") ListItem(V:Int) => .List  </expressionStack>
         <computationStack> .List </computationStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> ... I2 |-> V2 ... </variableValues>
          </localVariables>
         <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> ... I2 |-> V2 ... </variableValues>
          </localVariables>
         <expressionStack> ListItem(I1:Id[I2:Id]) ListItem("=") ListItem(V:Int) => ListItem(I1[V2]) ListItem("=") ListItem(V:Int) </expressionStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I[A] <- V ] </variableValues>
          </localVariables>
         <expressionStack> ListItem(I:Id[A:Literal]) ListItem("=") ListItem(V:Int) => .List </expressionStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> VALUES => VALUES [ I <- A ] </variableValues>
          </localVariables>
         <expressionStack> ListItem(I:Id) ListItem("=") ListItem(A:AddressLiteral) => .List  </expressionStack>
         <computationStack> .List </computationStack>

    rule <k> .K => .K ... </k>
          <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
         <expressionStack> ESTACK ListItem(I:Id += E2:Expression) => ESTACK ListItem(I:Id) ListItem("=") ListItem("+") ListItem(V) </expressionStack>
         <computationStack> CSTACK => CSTACK ListItem(E2) </computationStack>

    rule <k> .K => .K ... </k>
         <localVariables>
               ...
               <variableValues> ... I2 |-> V2 ... </variableValues>
          </localVariables>
         <expressionStack> ESTACK ListItem(I1:Id[I2:Id] += E2:Expression) => ESTACK ListItem(I1[V2]) ListItem("=") ListItem("+") ListItem(I1[V2]) </expressionStack>
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

    rule <k> .K => .K ... </k>
         <localVariables> ...
               <variableValues> ... I |-> V ... </variableValues>
          </localVariables>
         <expressionStack> ESTACK ListItem(I:Id) => ESTACK ListItem(V)</expressionStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem(_B:BlockTimestampLiteral) => ESTACK ListItem(0)</expressionStack>

    rule <k> .K => .K ... </k>
         <localVariables> ...
               <variableValues> ... I[A] |-> V ... </variableValues>
          </localVariables>
         <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(V)</expressionStack>

    rule <k> .K => .K ... </k>
         <localVariables> ...
               <variableValues> VALUES </variableValues>
          </localVariables>
         <expressionStack> ESTACK ListItem(I:Id[A:Literal]) => ESTACK ListItem(0)</expressionStack>
          requires notBool I[A] in_keys(VALUES)

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem(V:Int) => ESTACK ListItem(V) ListItem(E)</expressionStack>
         <computationStack> CSTACK ListItem(E:Expression)=> CSTACK </computationStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem("+") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 +Int V2) </expressionStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem("-") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 -Int V2) </expressionStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem("*") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 *Int V2) </expressionStack>

    rule <k> .K => .K ... </k>
         <expressionStack> ESTACK ListItem("/") ListItem(V1:Int) ListItem(V2:Int) => ESTACK ListItem(V1 /Int V2) </expressionStack>

    rule <k> .Statements => .K ...</k>

endmodule
```
