# Solidity Constant-Subdenom Calculations and Varaible Lookups
```k
requires "solidity-syntax.md"
requires "solidity-specs.md"

module SOLIDITY-DECLARATIONS
     imports SOLIDITY-SYNTAX
     imports SOLIDITY-SPECS
     imports LIST

     //CONTRACT DECLARATION
     rule <k> contract I:Id { C:ContractBodyElements } => C ...</k>
          <contracts> CONTS => CONTS ListItem(I)</contracts>
          <status> EVMC_SUCCESS </status>

     // STATE VARIABLE DECLARATION
     rule <k> T:ElementaryNumeralType V:VisibilitySpecifier I:Id; => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ CNAME..I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ CNAME..I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ CNAME..I <- 0 ] </stateVariableValues>
          </stateVariables>
     
     rule <k> T:ElementaryNumeralType V:VisibilitySpecifier I:Id = L:IntLiteral; => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ CNAME..I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ CNAME..I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ CNAME..I <- L ] </stateVariableValues>
          </stateVariables>

     rule <k> T:ElementaryAddressType V:VisibilitySpecifier I:Id; => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ CNAME..I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ CNAME..I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ CNAME..I <- 0x0000000000000000000000000000000000000000 ] </stateVariableValues>
          </stateVariables>
     
     rule <k> T:ElementaryAddressType V:VisibilitySpecifier I:Id = L:AddressLiteral; => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ CNAME..I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ CNAME..I <- T ] </stateVariableTypes>
               <stateVariableValues> VALUES => VALUES [ CNAME..I <- L ] </stateVariableValues>
          </stateVariables>

     rule <k> T:MappingType V:VisibilitySpecifier I:Id ; => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <stateVariables>
               <stateVariableVisibilities> VISIBILITIES => VISIBILITIES [ CNAME..I <- V ] </stateVariableVisibilities>
               <stateVariableTypes> TYPES => TYPES [ CNAME..I <- T ] </stateVariableTypes>
               ...
          </stateVariables>
     

     // FUNCTION DECLARATION
     rule <k> function I:Id ( P:ParameterList ) FS:FunctionSpecifier FB:FunctionBody => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <functions>
               <functionParameters> PARAMETERS => PARAMETERS [ CNAME..I <- P ] </functionParameters>
               <functionSpecifiers> SPECIFIERS => SPECIFIERS [ CNAME..I <- FS ] </functionSpecifiers>
               <functionBodies> BODIES => BODIES [ CNAME..I <- FB ] </functionBodies>
               <functionReturns> RETURNS => RETURNS [ CNAME..I <- "" ] </functionReturns>
          </functions>

     rule <k> function I:Id ( P:ParameterList ) FS:FunctionSpecifier returns( RP:ParameterList ) FB:FunctionBody => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <functions>
               <functionParameters> PARAMETERS => PARAMETERS [ CNAME..I <- P ] </functionParameters>
               <functionSpecifiers> SPECIFIERS => SPECIFIERS [ CNAME..I <- FS ] </functionSpecifiers>
               <functionBodies> BODIES => BODIES [ CNAME..I <- FB ] </functionBodies>
               <functionReturns> RETURNS => RETURNS [ CNAME..I <- RP ] </functionReturns>
          </functions>

     // CONSTRUCTOR DECLARATION
     rule <k> constructor ( P:ParameterList ) B:Block => .K ... </k>
          <contracts> ... ListItem(CNAME:Id)</contracts>
          <constructors>
               <constructorParameters> PARAMETERS => PARAMETERS [ CNAME <- P ] </constructorParameters>
               <constructorBody> PARAMETERS => PARAMETERS [ CNAME <- B ] </constructorBody>
          </constructors>


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
