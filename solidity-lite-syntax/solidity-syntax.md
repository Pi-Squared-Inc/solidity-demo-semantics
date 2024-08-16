# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity program in `examples\UniswapV2Swap.sol`

```k
module SOLIDITY-SYNTAX
    imports BOOL-SYNTAX
    imports STRING-SYNTAX
    imports ID-SYNTAX

    syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*"                     [token]
    syntax HexNumber ::= r"0x[A-Fa-f0-9]+"                                    [token]
    syntax Decimal ::= r"(([0-9][_]?)+|([0-9][_]?)*[\\.]([0-9][_]?)+)([eE][\\-]?([0-9][_]?)+)?"    [token]

    syntax ElementaryTypeName ::= "uint" | "uint256" | "address" | "bool"
    syntax DataLocation ::= "memory" | "storage" | "calldata"
    syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"

    syntax Literal ::= NumberLiteral | BoolLiteral | StringLiteral
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String
    syntax NumberLiteral ::= DecimalNumber | HexNumber
    syntax DecimalNumber ::= Decimal
    syntax LiteralWithSubDenom ::= DecimalNumber SubDenom

    syntax TypeName ::= ElementaryTypeName | IdentifierPath | MappingType | TypeName "[" Expression "]" | TypeName "[""]"
    syntax IdentifierPath ::= Id "." IdentifierPath | Id
    syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    syntax MappingKeyType ::= ElementaryTypeName | IdentifierPath
    syntax OptionalIdentifier ::= Id | ""

    syntax Program ::= PragmaDefinition SourceUnits

    syntax SourceUnits ::= List{SourceUnit, ""}
    syntax SourceUnit ::= ContractDefinition
                        | FunctionDefinition
                        | InterfaceDefinition
                        | ErrorDefinition
                        | StructDefinition
                        | EnumDefinition

    syntax ContractDefinition ::= "contract" Id "{" ContractBodyElements "}"
    syntax FunctionDefinition ::= "function" Id "(" ParameterList ")" FunctionSpecifiers ReturnSpecifier FunctionBody
    syntax InterfaceDefinition ::= "interface" Id "{" ContractBodyElements "}"
    syntax ErrorDefinition ::= "error" Id "(" ErrorParameters ")" ";"

    syntax ContractBodyElements ::= List{ContractBodyElement, ""}
    syntax ContractBodyElement ::= StateVariableDeclaration
                                 | ConstructorDefinition
                                 | FunctionDefinition
                                 | EventDefinition
                                 | ErrorDefinition
                                 | StructDefinition
                                 | EnumDefinition

    syntax StateVariableDeclaration ::= TypeName VisibilitySpecifier Id ";"
                                      | TypeName VisibilitySpecifier Id  "=" Expression ";"

    syntax ConstructorDefinition ::= "constructor" "(" ParameterList ")" Block
    syntax EventDefinition ::= "event" Id "(" EventParameters ")" ";"
    syntax StructDefinition ::= "struct" Id "{" StructMembers "}"
    syntax EnumDefinition ::= "enum" Id "{" IdentifierList "}"

    syntax EventParameters ::= List{EventParameter, ","}
    syntax EventParameter ::= TypeName | TypeName "indexed" | TypeName Id | TypeName "indexed" Id

    syntax ErrorParameters ::= List{ErrorParameter, ","}
    syntax ErrorParameter ::= TypeName | TypeName Id

    syntax StructMembers ::= List{StructMember, ""}
    syntax StructMember ::= TypeName Id ";"

    syntax IdentifierList ::= List{Id, ","}

    syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"

    syntax ParameterList ::= List{Parameter, ","}
    syntax Parameter ::= TypeName DataLocation Id | TypeName Id | TypeName DataLocation | TypeName
    syntax FunctionSpecifiers ::= List{FunctionSpecifier, ""}
    syntax FunctionSpecifier ::= VisibilitySpecifier | "virtual" | "payable"
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
                        | RevertStatement

    syntax ExpressionStatement ::= Expression ";"

    syntax VariableDeclarationStatement ::= VariableDeclaration ";"
                                            | VariableDeclaration "=" Expression ";"

    syntax IfStatement ::= "if" "(" Expression ")" Statement
                         | "if" "(" Expression ")" Statement "else" Statement

    syntax ForStatement ::= "for" "(" InitStatement ConditionStatement PostLoopStatement ")" Statement
    syntax InitStatement ::= VariableDeclarationStatement | ExpressionStatement | ";"
    syntax ConditionStatement ::= ExpressionStatement | ";"
    syntax PostLoopStatement ::= Expression | ""

    syntax EmitStatement ::= "emit" Expression "(" CallArgumentList ")" ";"

    syntax ReturnStatement ::= "return" ";"
                            | "return" Expression ";"

    syntax RevertStatement ::= "revert" "(" CallArgumentList ")" ";"
                             | "revert" Id "(" CallArgumentList ")" ";"

    syntax VariableDeclaration ::= TypeName Id
                                | TypeName DataLocation Id

    syntax CallArgumentList ::= List{Expression, ","}

    syntax KeyValues ::= List{KeyValue, ","}
    syntax KeyValue ::= Id ":" Expression

    syntax Expression ::= Id | Literal | LiteralWithSubDenom | ElementaryTypeName
                        > "(" Expression ")" [bracket]
                        | "[" CallArgumentList "]"
                        | "new" TypeName "(" CallArgumentList ")"
                        | Expression "++" | Expression "--"
                        | Expression "[" Expression "]" | Expression "[""]"
                        | Expression "." Id | Expression ".address"
                        | Expression "{" KeyValues "}"
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

module SOLIDITY
  imports SOLIDITY-SYNTAX
endmodule
```
