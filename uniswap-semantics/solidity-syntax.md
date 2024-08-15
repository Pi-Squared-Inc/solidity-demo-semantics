# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity program in `examples\UniswapV2Swap.sol`

```k
module SOLIDITY-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports ID-SYNTAX

    syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*"  [token]

    syntax ElementaryTypeName ::= "uint" | "uint256" | "address" | "bool"
    syntax DataLocation ::= "memory" | "storage" | "calldata" 
    syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"

    syntax Literal ::= IntLiteral | BoolLiteral | StringLiteral
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String
    syntax IntLiteral ::= Int | Int SubDenom

    syntax TypeName ::= ElementaryTypeName | IdentifierPath | MappingType | TypeName "[" Expression "]" | TypeName "[""]" 
    syntax IdentifierPath ::= Id "." IdentifierPath | Id
    syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    syntax MappingKeyType ::= ElementaryTypeName | IdentifierPath
    syntax OptionalIdentifier ::= Id | ""

    syntax Program ::= PragmaDefinition SourceUnits 

    syntax SourceUnits ::= List{SourceUnit, ""}
    syntax SourceUnit ::= ContractDefinition | FunctionDefinition | InterfaceDefinition

    syntax ContractDefinition ::= "contract" Id "{" ContractBodyElements "}"
    syntax FunctionDefinition ::= "function" Id "(" ParameterList ")" FunctionSpecifier ReturnSpecifier FunctionBody 
    syntax InterfaceDefinition ::= "interface" Id "{" ContractBodyElements "}"

    syntax ContractBodyElements ::= List{ContractBodyElement, ""} 
    syntax ContractBodyElement ::= StateVariableDeclaration | ConstructorDefinition | FunctionDefinition | EventDefinition

    syntax StateVariableDeclaration ::= TypeName VisibilitySpecifier Id InitialAssignment ";"
    syntax ConstructorDefinition ::= "constructor" "(" ParameterList ")" Block
    syntax EventDefinition ::= "event" Id "(" EventParameters ")" ";"
    
    syntax EventParameters ::= List{EventParameter, ","}
    syntax EventParameter ::= TypeName | TypeName "indexed" | TypeName Id | TypeName "indexed" Id

    syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"
    syntax InitialAssignment ::= "=" Expression | ""

    syntax ParameterList ::= List{Parameter, ","}
    syntax Parameter ::= TypeName DataLocation Id | TypeName Id | TypeName DataLocation | TypeName 
    syntax FunctionSpecifier ::= VisibilitySpecifier | VisibilitySpecifier "virtual" | "virtual" | ""
    syntax ReturnSpecifier ::= "returns" "(" ParameterList ")" | ""
    syntax FunctionBody ::= Block | ";"

    syntax Block ::= "{" Statements "}"
    syntax Statements ::= List{Statement, ""}
    syntax Statement ::= Block 
                        | VariableDeclarationStatement
                        | ExpressionStatement
                        | IfStatement
                        | ForStatement
                        | EmitStatement
                        | ReturnStatement

    syntax ExpressionStatement ::= Expression ";"

    syntax VariableDeclarationStatement ::= VariableDeclaration ";"
                                            | VariableDeclaration "=" Expression ";"
    
    syntax IfStatement ::= "if" "(" Expression ")" Statement 
                        | "if" "(" Expression ")" Statement "else" Statement

    syntax ForStatement ::= "for" "(" InitStatement ConditionStatement PostLoopStatement ")" Statement
    syntax InitStatement ::= VariableDeclarationStatement | ExpressionStatement | ";"
    syntax ConditionStatement ::= ExpressionStatement | ";"
    syntax PostLoopStatement ::= Expression | ""

    syntax EmitStatement ::= "emit" Expression CallArgumentList ";"

    syntax ReturnStatement ::= "return" ";"
                            | "return" Expression ";"

    syntax VariableDeclaration ::= TypeName Id
                                | TypeName DataLocation Id
    
    syntax CallArgumentList ::= List{Expression, ","}

    syntax Expression ::= Id | Literal | ElementaryTypeName
                        > "(" Expression ")" [bracket]
                        | "new" TypeName "(" CallArgumentList ")" 
                        | Expression "++" | Expression "--"
                        | Expression "[" Expression "]" | Expression "[""]"
                        | Expression "." Id | Expression ".address"
                        | Expression "(" CallArgumentList ")"
                        > "++" Expression | "--" Expression
                        | "!" Expression
                        > left: Expression "**" Expression
                        > left:
                              Expression "*" Expression
                            | Expression "/" Expression
                            | Expression "%" Expression
                        > left:
                              Expression "+" Expression
                            | Expression "-" Expression
                        > left:
                              Expression "<" Expression
                            | Expression "<=" Expression
                            | Expression ">" Expression
                            | Expression ">=" Expression
                        > left:
                              Expression "==" Expression
                            | Expression "!=" Expression
                        > left: Expression "&&" Expression
                        > left: Expression "||" Expression
                        > left:
                            Expression "?" Expression ":" Expression
                            | Expression "+=" Expression
                            | Expression "-=" Expression
                            | Expression "*=" Expression
                            | Expression "/=" Expression
                            | Expression "=" Expression

endmodule
```
