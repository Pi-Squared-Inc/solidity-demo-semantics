# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity program in `examples\LiquidStaking.sol`

```k
module SOLIDITY-LIQUID-STAKING-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX


    syntax ElementaryTypeName ::= "uint" | "uint256" | "address" | "bool"
    syntax DataLocation ::= "memory" | "storage" | "calldata"
    syntax Identifier ::= r"[a-zA-Z$_][a-zA-Z0-9$_]*" [token]
    syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String
    syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*"  [token]

    syntax TypeName ::= ElementaryTypeName | IdentifierPath | MappingType
    syntax IdentifierPath ::= Identifier "." IdentifierPath | Identifier
    syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    syntax MappingKeyType ::= ElementaryTypeName | IdentifierPath
    syntax OptionalIdentifier ::= Identifier | ""
    syntax Literal ::= IntLiteral | BoolLiteral | StringLiteral
    syntax IntLiteral ::= Int | Int SubDenom

    syntax Program ::= PragmaDefinition SourceUnits

    syntax SourceUnits ::= List{SourceUnit, ""}
    syntax SourceUnit ::= ContractDefinition | FunctionDefinition | InterfaceDefinition

    syntax InterfaceDefinition ::= "interface" Identifier "{" ContractBodyElements "}"

    syntax ContractDefinition ::= "contract" Identifier "{" ContractBodyElements "}"
    syntax ContractBodyElements ::= List{ContractBodyElement, ""}
    syntax ContractBodyElement ::= StateVariableDeclaration | ConstructorDefinition | FunctionDefinition

    syntax ConstructorDefinition ::= "constructor" "(" ParameterList ")" Block

    syntax StateVariableDeclaration ::= TypeName VisibilitySpecifier Identifier InitialAssignment ";"
    syntax InitialAssignment ::= "=" Expression | ""
    syntax FunctionDefinition ::= "function" Identifier "(" ParameterList ")" FunctionSpecifier ReturnSpecifier FunctionBody
    syntax ParameterList ::= List{Parameter, ","}
    syntax Parameter ::= TypeName DataLocation Identifier | TypeName Identifier | TypeName DataLocation | TypeName
    syntax FunctionSpecifier ::= VisibilitySpecifier | "virtual" | ""
    syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"
    syntax ReturnSpecifier ::= "returns" "(" ParameterList ")" | ""
    syntax FunctionBody ::= Block | ";"

    syntax Block ::= "{" Statements "}"
    syntax Statements ::= List{Statement, ""}
    syntax Statement ::= Block
                        | VariableDeclarationStatement
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

    syntax VariableDeclaration ::= TypeName Identifier
                                | TypeName DataLocation Identifier

    syntax CallArgumentList ::= List{Expression, ","}

    syntax Expression ::= Identifier | Literal | ElementaryTypeName
                        | "(" Expression ")" [bracket]
                        | Expression "[" Expression "]" | Expression "[""]"
                        | Expression "." Identifier | Expression ".address"
                        | Expression "(" CallArgumentList ")"
                        > "!" Expression [function]
                        > "++" Expression | "--" Expression [function]
                        > Expression "++" | Expression "--" [function]
                        > left: Expression "<" Expression [function]
                        > left: Expression "<=" Expression [function]
                        > left: Expression ">" Expression [function]
                        > left: Expression ">=" Expression [function]
                        > left: Expression "==" Expression [function]
                        > left: Expression "!=" Expression [function]
                        > left: Expression "&&" Expression [function]
                        > left: Expression "^" Expression [function]
                        > left: Expression "||" Expression [function]
                        > left: Expression "**" Expression [function]
                        > left: Expression "*" Expression [function]
                        > left: Expression "/" Expression [function]
                        > left: Expression "+" Expression [function]
                        > left: Expression "-" Expression [function]
                        > left: Expression "+=" Expression [function]
                        > left: Expression "=" Expression [function]

endmodule
```

To try the example in a system with a K instance present run the following:

```
kompile <path-to>/liquid-staking-syntax.md --main-module SOLIDITY-LIQUID-STAKING-SYNTAX
kast --output json <path-to>/LiquidStaking.sol > LiquidStakingAST.json
```
