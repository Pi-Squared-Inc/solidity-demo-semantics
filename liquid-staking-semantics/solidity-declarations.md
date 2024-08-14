# Solidity Constant-Subdenom Calculations and Varaible Lookups
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-DECLARATIONS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports LIST


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
     
     
endmodule
```
