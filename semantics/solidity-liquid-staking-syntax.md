# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity program in `examples\LiquidStaking.sol`

```k
module SOLIDITY-LIQUID-STAKING-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports ID-SYNTAX

    syntax ElementaryTypeName ::= "uint" | "uint256" | "address" | "bool"
    syntax DataLocation ::= "memory" | "storage" | "calldata"
    //syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String
    //syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*" [token]

    syntax TypeName ::= ElementaryTypeName
    //syntax TypeName ::= ElementaryTypeName | IdentifierPath | MappingType
    //syntax IdentifierPath ::= Id "." IdentifierPath | Id
    //syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    //syntax MappingKeyType ::= ElementaryTypeName | IdentifierPath
    //syntax OptionalIdentifier ::= Id | ""
    syntax Literal ::= IntLiteral | BoolLiteral | StringLiteral
    //syntax IntLiteral ::= Int | Int SubDenom
    syntax IntLiteral ::= Int

    //syntax Program ::= PragmaDefinition SourceUnits

    //syntax SourceUnits ::= List{SourceUnit, ""}
    //syntax SourceUnit ::= ContractDefinition | FunctionDefinition | InterfaceDefinition

    //syntax InterfaceDefinition ::= "interface" Id "{" ContractBodyElements "}"

    //syntax ContractDefinition ::= "contract" Id "{" ContractBodyElements "}"
    //syntax ContractBodyElements ::= List{ContractBodyElement, ""}
    //syntax ContractBodyElement ::= StateVariableDeclaration | ConstructorDefinition | FunctionDefinition

    //syntax ConstructorDefinition ::= "constructor" "(" ParameterList ")" Block

    //syntax StateVariableDeclaration ::= TypeName VisibilitySpecifier Id InitialAssignment ";"
    //syntax InitialAssignment ::= "=" Expression | ""
    //syntax FunctionDefinition ::= "function" Id "(" ParameterList ")" FunctionSpecifier ReturnSpecifier FunctionBody
    //syntax ParameterList ::= List{Parameter, ","}
    //syntax Parameter ::= TypeName DataLocation Id | TypeName Id | TypeName DataLocation | TypeName
    //syntax FunctionSpecifier ::= VisibilitySpecifier | "virtual" | ""
    //syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"
    //syntax ReturnSpecifier ::= "returns" "(" ParameterList ")" | ""
    //syntax FunctionBody ::= Block | ";"

    syntax Block ::= "{" Statements "}"
    syntax Statements ::= List{Statement, ""}
    //syntax Statement ::= Block
    syntax Statement ::= VariableDeclarationStatement
                       | ExpressionStatement
                       | IfStatement
    //                    | ReturnStatement

    syntax ExpressionStatement ::= Expression ";"

    syntax VariableDeclarationStatement ::= VariableDeclaration ";"
                                          | VariableDeclaration "=" Expression ";"

    syntax IfStatement ::= "if" "(" Expression ")" Statement
                         | "if" "(" Expression ")" Statement "else" Statement

    //syntax ReturnStatement ::= "return" ";"
    //                         | "return" Expression ";"

    syntax VariableDeclaration ::= TypeName Id
                                 | TypeName DataLocation Id

    syntax CallArgumentList ::= List{Expression, ","}

    //Operator precedences set according to: https://docs.soliditylang.org/en/latest/cheatsheet.html
    syntax Expression ::= Id | Literal | ElementaryTypeName
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
                            | Expression "=" Expression

endmodule
```

To try the example in a system with a K instance present run the following:

```
kompile <path-to>/liquid-staking-syntax.md --main-module SOLIDITY-LIQUID-STAKING-SYNTAX
kast --output json <path-to>/LiquidStaking.sol > LiquidStakingAST.json
```
