# Solidity Configuration Specs

```k
requires "solidity-syntax.md"
requires "network.md"

module SOLIDITY-SPECS
     imports SOLIDITY-SYNTAX
     imports LIST
     imports NETWORK

     configuration  <Sol>
                         <k> $PGM:ContractBodyElements </k>
                         
                         <stateVariables>
                              <stateVariableVisibilities> .Map </stateVariableVisibilities>
                              <stateVariableTypes> .Map </stateVariableTypes>
                              <stateVariableValues> .Map </stateVariableValues>
                         </stateVariables>

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

     
endmodule
```
