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

    //CLEAR LOCAL VARS AND MOVE PARAMS TO STACK
     rule <k> .K => .K ... </k>
            <expressionStack> ListItem(C:Id . I:Id (.CallArgumentList)) => ListItem("CALLFUNC") ListItem(C) ListItem(I)</expressionStack>
            <localVariables>
                <localVariableTypes> _TYPES => .Map </localVariableTypes>
                <localVariableValues> _VALUES => .Map</localVariableValues>
            </localVariables>
            <functions>
                ...
                <functionParameters> ... C..I |-> P ...</functionParameters>
            </functions>
            <functionCallStack>
                ...
                <functionCallParameters> .ParameterList => P </functionCallParameters>
            </functionCallStack>
            
    //INIT LOCAL VARS FROM PARAMS
     rule <k> .K => .K ... </k>
            <expressionStack> ListItem("CALLFUNC") ListItem(C:Id) ListItem(I:Id) => ListItem("CALLFUNC") ListItem(C) ListItem(I)</expressionStack>
            <localVariables>
                <localVariableTypes> LVTYPES => LVTYPES [ PID <- T ] </localVariableTypes>
                <localVariableValues> LVVALUES => LVVALUES [ PID <- L ] </localVariableValues>
            </localVariables>
            <functionCallStack>
                <functionCallValues> VALUES ListItem(L:Literal) => VALUES </functionCallValues>
                <functionCallParameters> T:ElementaryType PID:Id, P:ParameterList => P </functionCallParameters>
                ...
            </functionCallStack>

    //COPY STATE VARIABLES TO LOCAL VARIABLES AND FUNCTIONS TO STACK
     rule <k> .K => S ~> .K ... </k>
            <expressionStack> ListItem("CALLFUNC") ListItem(C:Id) ListItem(I:Id) => .List </expressionStack>
            <runningContract> .K => C </runningContract>
            <functions>
                ...
                <functionBodies> ... C..I |-> S ... </functionBodies>
            </functions>
            <functionCallStack>
                <functionCallValues> .List </functionCallValues>
                <functionCallParameters> .ParameterList </functionCallParameters>
                ...
            </functionCallStack>


     // FUNCTION CALL
     rule <k> .K => .K ... </k>
          <expressionStack> ListItem(CON:Id . I:Id (E:Expression, C:CallArgumentList)) => ListItem(CON . I (C)) ListItem(E) </expressionStack>

     rule <k> .K => .K ... </k>
        <expressionStack> ListItem(CON:Id . I:Id (C:CallArgumentList)) ListItem(V:Literal)=> ListItem(CON . I (C))</expressionStack>
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
        <runningContract> _C => .K </runningContract>
        

     // EMPTY RETURN STATEMENTS
     rule <k> return ; => .K ... </k> 
            <expressionStack> .List </expressionStack>
            <runningContract> _C => .K </runningContract>

endmodule
```
