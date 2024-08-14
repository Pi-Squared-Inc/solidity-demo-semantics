# Solidity Configuration Specs

```k
requires "solidity-syntax.md"
requires "network.md"

module SOLIDITY-SPECS
     imports SOLIDITY-SYNTAX
     imports LIST
     imports NETWORK

     configuration  <Sol>
                         <k> $PGM:Program </k>
                         
                         <stateVariables>
                              <stateVariableVisibilities> .Map </stateVariableVisibilities>
                              <stateVariableTypes> .Map </stateVariableTypes>
                              <stateVariableValues> .Map </stateVariableValues>
                         </stateVariables>

                         <contracts> .List </contracts>
                         <runningContract> .K </runningContract>

                         <functions>
                              <functionParameters> .Map </functionParameters>
                              <functionSpecifiers> .Map </functionSpecifiers>
                              <functionBodies> .Map </functionBodies>
                              <functionReturns> .Map </functionReturns>
                         </functions>

                         <constructors>
                              <constructorParameters> .Map </constructorParameters>
                              <constructorBody> .Map </constructorBody>
                         </constructors>


                         <localVariables>
                              <localVariableTypes> .Map </localVariableTypes>
                              <localVariableValues> .Map </localVariableValues>
                         </localVariables>

                         <expressionStack> .List </expressionStack>
                         <computationStack> .List </computationStack>

                         <functionCallStack>
                              <functionCallValues> .List </functionCallValues>
                              <functionCallParameters> .ParameterList </functionCallParameters>
                              <functionReturnValues> .List </functionReturnValues>
                         </functionCallStack>

                         <status> EVMC_SUCCESS </status>
                         <output> "" </output>
                         <debug> .List </debug>
                    </Sol>

     syntax IdTuple ::= Id ".." Id
                      | Id ".." Id "[" Literal "]"
     
endmodule
```
