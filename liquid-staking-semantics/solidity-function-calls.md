# Solidity Handling of Function Calls
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-FUNCTION-CALLS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports LIST

    //TODO: NOT YET READY FOR NESTED CALLS
    //TODO: TYPE CHECKING FOR RETURNS

     rule <k> .K => .K ... </k>
            <expressionStack> ESTACK ListItem(I:Id (.CallArgumentList))=> ESTACK ListItem("CALLFUNC") ListItem(I)</expressionStack>
            <localVariables>
                <localVariableTypes> _TYPES => .Map </localVariableTypes>
                <localVariableValues> _VALUES => .Map</localVariableValues>
            </localVariables>
            <functions>
                ...
                <functionParameters> ... I |-> P ...</functionParameters>
            </functions>
            <functionCallStack>
                ...
                <functionCallParameters> .ParameterList => P </functionCallParameters>
            </functionCallStack>

     rule <k> .K => .K ... </k>
            <expressionStack> ESTACK ListItem("CALLFUNC") ListItem(I:Id) => ESTACK ListItem("CALLFUNC") ListItem(I)</expressionStack>
            <localVariables>
                <localVariableTypes> LVTYPES => LVTYPES [ PID <- T ] </localVariableTypes>
                <localVariableValues> LVVALUES => LVVALUES [ PID <- L ] </localVariableValues>
            </localVariables>
            <functionCallStack>
                <functionCallValues> VALUES ListItem(L:Literal) => VALUES </functionCallValues>
                <functionCallParameters> T:ElementaryType PID:Id, P:ParameterList => P </functionCallParameters>
                ...
            </functionCallStack>


     rule <k> .K => S ~> .K ... </k>
            <expressionStack> ESTACK ListItem("CALLFUNC") ListItem(I:Id) => ESTACK </expressionStack>
            <stateVariables>
                ...
                <stateVariableTypes> SVTYPESMAP </stateVariableTypes>
                <stateVariableValues> SVVALUESMAP </stateVariableValues>
            </stateVariables>
            <localVariables>
                <localVariableTypes> LVTYPESMAP => LVTYPESMAP SVTYPESMAP</localVariableTypes>
                <localVariableValues> LVVALUESMAP => LVVALUESMAP SVVALUESMAP</localVariableValues>
            </localVariables>
            <functions>
                ...
                <functionBodies> ... I |-> S ... </functionBodies>
            </functions>
            <functionCallStack>
                <functionCallValues> .List </functionCallValues>
                <functionCallParameters> .ParameterList </functionCallParameters>
                ...
            </functionCallStack>

     rule <k> .K => .K ... </k>
          <expressionStack> ESTACK ListItem(I:Id (E:Expression, C:CallArgumentList))=> ESTACK ListItem(I:Id (C:CallArgumentList)) ListItem(E)</expressionStack>

     rule <k> .K => .K ... </k>
        <expressionStack> ESTACK ListItem(I:Id (C:CallArgumentList)) ListItem(V:Literal)=> ESTACK ListItem(I:Id (C:CallArgumentList))</expressionStack>
        <functionCallStack>
            <functionCallValues> FCSTACK => FCSTACK ListItem(V) </functionCallValues>
            <functionCallParameters> .ParameterList </functionCallParameters>
            ...
        </functionCallStack>
     
     // RETURN STATEMENTS
     rule <k> return E:Expression ; => .K ... </k>
        <expressionStack> .List => ListItem("RETURN") ListItem(E)</expressionStack>

     rule <k> .K => .K ... </k>
        <expressionStack> ListItem("RETURN") ListItem(L:Literal) => ListItem("RETURN")</expressionStack>
        <functionCallStack>
            ...
            <functionReturnValues> .List => ListItem(L) </functionReturnValues>
        </functionCallStack>


     rule <k> .K => .K ... </k>
        <expressionStack> ListItem("RETURN") => ListItem(L)</expressionStack>
        <functionCallStack>
            ...
            <functionReturnValues> ListItem(L:Literal) => .List </functionReturnValues>
        </functionCallStack>
        

     // EMPTY RETURN STATEMENTS
     rule <k> return ; => .K ... </k> 
     <expressionStack> .List </expressionStack>

endmodule
```
