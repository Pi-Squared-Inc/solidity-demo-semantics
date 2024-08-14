# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity program in `examples\LiquidStaking.sol`

```k
module SOLIDITY-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports ID-SYNTAX

    syntax ElementaryType ::= ElementaryNumeralType | ElementaryAddressType
    syntax ElementaryNumeralType ::= "uint256"
    syntax ElementaryAddressType ::= "address"
    syntax DataLocation ::= "memory" | "storage" | "calldata"
    syntax VisibilitySpecifier ::= "public" | "private" | "external" | "internal"
    syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String
    syntax IntLiteral ::= Int | Int SubDenom
    syntax AddressLiteral ::= r"0x[A-Fa-f0-9]{39,41}"       [token]
    syntax RequireLiteral ::= "require"                     [token]
    syntax BlockTimestampLiteral ::= "block.timestamp"
    //syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*" [token]

    syntax TypeName ::= ElementaryType | IdentifierPath | MappingType
    syntax IdentifierPath ::= Id "." IdentifierPath | Id
    syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    syntax MappingKeyType ::= ElementaryType | IdentifierPath
    syntax OptionalIdentifier ::= Id | ""
    syntax Literal ::= IntLiteral | BoolLiteral | StringLiteral | AddressLiteral | BlockTimestampLiteral | RequireLiteral


    //syntax Program ::= PragmaDefinition SourceUnits
    syntax Program ::= ContractDefinition Block

    //syntax SourceUnits ::= List{SourceUnit, ""}
    //syntax SourceUnit ::= ContractDefinition | FunctionDefinition | InterfaceDefinition

    //syntax InterfaceDefinition ::= "interface" Id "{" ContractBodyElements "}"

    syntax ContractDefinition ::= "contract" Id "{" ContractBodyElements "}"
    syntax ContractBodyElements ::= List{ContractBodyElement, ""}
    syntax ContractBodyElement ::= StateVariableDeclaration | FunctionDefinition | ConstructorDefinition
    syntax ConstructorDefinition ::= "constructor" "(" ParameterList ")" Block

    syntax StateVariableDeclaration ::= TypeName VisibilitySpecifier Id InitialAssignment ";"
    syntax InitialAssignment ::= "=" Expression | ""
    syntax FunctionDefinition ::= "function" Id "(" ParameterList ")" FunctionSpecifier ReturnSpecifier FunctionBody
    syntax ParameterList ::= List{Parameter, ","}
    syntax Parameter ::= TypeName DataLocation Id | TypeName Id | TypeName DataLocation | TypeName
    syntax FunctionSpecifier ::= VisibilitySpecifier | "virtual" | ""
    //syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"
    syntax ReturnSpecifier ::= "returns" "(" ParameterList ")" | ""
    syntax FunctionBody ::= Block | ";"

    syntax Block ::= "{" Statements "}"
    syntax Statements ::= List{Statement, ""}
    //syntax Statement ::= Block
    syntax Statement ::= VariableDeclarationStatement
                       | ExpressionStatement
                       | IfStatement
                       | ReturnStatement

    syntax ExpressionStatement ::= Expression ";"

    syntax VariableDeclarationStatement ::= VariableDeclaration ";"
                                          | VariableDeclaration "=" Expression ";"

    syntax IfStatement ::= "if" "(" Expression ")" Statement
                         | "if" "(" Expression ")" Statement "else" Statement

    syntax ReturnStatement ::= "return" ";"
                             | "return" Expression ";"

    syntax VariableDeclaration ::= TypeName Id
                                 | TypeName DataLocation Id

    syntax CallArgumentList ::= List{Expression, ","}

    //Operator precedences set according to: https://docs.soliditylang.org/en/latest/cheatsheet.html
    syntax Expression ::= Id | Literal | ElementaryType
                        > "(" Expression ")" [bracket]
                        > Expression "++" | Expression "--"
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
                              Expression "+=" Expression
                            | Expression "-=" Expression
                            | Expression "*=" Expression
                            | Expression "/=" Expression
                            | Expression "=" Expression

endmodule
```

To try the example in a system with a K instance present run the following:

```
kompile <path-to>/liquid-staking-syntax.md --main-module SOLIDITY-LIQUID-STAKING-SYNTAX
kast --output json <path-to>/LiquidStaking.sol > LiquidStakingAST.json
```
