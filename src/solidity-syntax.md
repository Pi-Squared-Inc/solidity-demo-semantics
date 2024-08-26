# Parser Definition

Following contains a subset of the [Solidity Language Grammar](https://docs.soliditylang.org/en/latest/grammar.html) that can be used to parse the example solidity programs in `examples\` folder.

```k
module SOLIDITY-SYNTAX
```

## Imported Modules

We use `bool`, `string` and `id` modules, `int`s are defined in a custom way due to the solidity decimal syntax, described via `Decimal` token below

```k
    imports BOOL-SYNTAX
    imports STRING-SYNTAX
    imports ID-SYNTAX
```

## Tokens-keywords

We use tokens for the `pragma` definition in the header, hexadecimal numbers used as address literals and `address()` casts and, decimal notation used by solidity.

```k
    syntax PragmaDefinition ::= r"pragma ([^;]+)*;[\\s]*"                                           [token]
    syntax HexNumber ::= r"0x[A-Fa-f0-9]+"                                                          [token]
    syntax Decimal ::= r"(([0-9][_]?)+|([0-9][_]?)*[\\.]([0-9][_]?)+)([eE][\\-]?([0-9][_]?)+)?"     [token]

    syntax ElementaryTypeName ::= "uint" [function] | "uint8" | "uint32" | "uint112" | "uint256" | "address" | "bool"
    syntax DataLocation ::= "memory" | "storage" | "calldata"
    syntax SubDenom ::= "wei" | "gwei" | "ether" | "seconds" | "minutes" | "hours" | "days" | "weeks" | "years"
    rule uint => uint256
```

## Literals

Custom decimal number literals (as described above), built-in boolean and string literals are used. Subdenominators can also be appended to number literals to factor time, etc.

```k
    syntax Literal ::= NumberLiteral | BoolLiteral | StringLiteral
    syntax NumberLiteral ::= DecimalNumber | HexNumber
    syntax DecimalNumber ::= Decimal
    syntax BoolLiteral ::= Bool
    syntax StringLiteral ::= String

    syntax LiteralWithSubDenom ::= DecimalNumber SubDenom

```

## Types

A type identifier can be either `ElementaryTypeName` (see above), a single `Id` or a period separated path, a mapping or an array type.

```k
    syntax TypeName ::= ElementaryTypeName | IdentifierPath | MappingType | TypeName "[" Expression "]" | TypeName "[""]"
    syntax IdentifierPath ::= Id "." IdentifierPath | Id
    syntax MappingType ::= "mapping" "(" MappingKeyType OptionalIdentifier "=>" TypeName OptionalIdentifier ")"
    syntax MappingKeyType ::= ElementaryTypeName | IdentifierPath
    syntax OptionalIdentifier ::= Id | ""

```

## Root

Parsing starts from `Program` rule. A program is a pragma definition followed by some `SourceUnit`s

```k
    syntax Program ::= PragmaDefinition SourceUnits

```

## Top level source units

A contract file consists of a series of contract definitions listed as follows.

```k

    syntax SourceUnits ::= List{SourceUnit, ""}
    syntax SourceUnit ::= ContractDefinition
                        | FunctionDefinition
                        | InterfaceDefinition
                        | ErrorDefinition
                        | StructDefinition
                        | EnumDefinition

    syntax ContractDefinition ::= "contract" Id "{" ContractBodyElements "}"
    syntax FunctionDefinition ::= "function" Id "(" ParameterList ")" FunctionSpecifiers ReturnSpecifier FunctionBody
                                | "function" Id "(" ParameterList ")" FunctionSpecifiers FunctionBody
    syntax InterfaceDefinition ::= "interface" Id "{" ContractBodyElements "}"
    syntax ErrorDefinition ::= "error" Id "(" ErrorParameters ")" ";"
    syntax StructDefinition ::= "struct" Id "{" StructMembers "}"
    syntax EnumDefinition ::= "enum" Id "{" IdentifierList "}"

    syntax IdentifierList ::= List{Id, ","}
```

## Contract

A contract is a series of contract body elements listed as follows.

```k
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
```

## Function definition

A Function definition contains a parameter list and some specifiers. Supported list of specifiers is provided below. There's no induced order of specifiers due to the grammar definition of solidity.

```k
    syntax ParameterList ::= List{Parameter, ","}
    syntax Parameter ::= TypeName DataLocation Id | TypeName Id | TypeName DataLocation | TypeName
    syntax FunctionSpecifiers ::= List{FunctionSpecifier, ""}
    syntax FunctionSpecifier ::= VisibilitySpecifier | "virtual" | "payable"
    syntax ReturnSpecifier ::= "returns" "(" ParameterList ")"
    syntax FunctionBody ::= Block | ";"

    syntax VisibilitySpecifier ::= "internal" | "external" | "private" | "public"
```

## Error definition

An error can be defined with a set of parameters separated with commas.

```k
    syntax ErrorParameters ::= List{ErrorParameter, ","}
    syntax ErrorParameter ::= TypeName | TypeName Id
```

## Event definition

An event can be defined with a set of parameters separated with commas, additionally each parameter can be annotated with "indexed" keyword.

```k
    syntax EventParameters ::= List{EventParameter, ","}
    syntax EventParameter ::= TypeName | TypeName "indexed" | TypeName Id | TypeName "indexed" Id
```

## Struct definition

A struct can be defined with a set of members (a special case of variable declaration) separated with semicolons.

```k
    syntax StructMembers ::= List{StructMember, ""}
    syntax StructMember ::= TypeName Id ";"
```

## Block definition

In each code block, various statments and nested blocks can be present.

```k
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
```

## Statements

Following is a list of supported statements.

```k
    syntax ExpressionStatement ::= Expression ";" [strict]

    syntax VariableDeclarationStatement ::= VariableDeclaration ";"
                                            | VariableDeclaration "=" Expression ";" [strict(2)]
                                            | "(" VariableDeclaration "," ")" "=" Expression ";" [strict(2)]

    syntax IfStatement ::= "if" "(" Expression ")" Statement [strict(1)]
                         | "if" "(" Expression ")" Statement "else" Statement [avoid, strict(1)]

    syntax ForStatement ::= "for" "(" InitStatement ConditionStatement PostLoopStatement ")" Statement
    syntax InitStatement ::= VariableDeclarationStatement | ExpressionStatement | ";"
    syntax ConditionStatement ::= ExpressionStatement | ";"
    syntax PostLoopStatement ::= Expression | ""

    syntax EmitStatement ::= "emit" Expression "(" CallArgumentList ")" ";" [strict(2)]

    syntax ReturnStatement ::= "return" ";"
                            | "return" Expression ";" [strict]

    syntax RevertStatement ::= "revert" "(" CallArgumentList ")" ";"
                             | "revert" Id "(" CallArgumentList ")" ";"

    syntax VariableDeclaration ::= TypeName Id
                                | TypeName DataLocation Id
```

`CallArgumentList` keeps a list of arguments for function calls and such (`revert()`, `emit()`, etc.)

```k
    syntax CallArgumentList ::= List{Expression, ","} [overload(exps), strict, hybrid]

```

For this subset `KeyValue` pairs are only used preceding function argument lists for `payable` functions and such.

```k
    syntax KeyValues ::= List{KeyValue, ","}
    syntax KeyValue ::= Id ":" Expression

```

## Expressions

Following is a list of supported expressions. Operator precendences are taken from [here](https://docs.soliditylang.org/en/latest/cheatsheet.html).

```k
    syntax Expression ::= Id | Literal | LiteralWithSubDenom | ElementaryTypeName
                        > "(" Expression ")" [bracket]
                        | "[" CallArgumentList "]"
                        | "new" TypeName "(" CallArgumentList ")" [strict(2)]
                        | Expression "++" | Expression "--"
                        | Expression "[" Expression "]" | Expression "[""]"
                        | Expression "." Id | Expression ".address"
                        | Expression "{" KeyValues "}"
                        | Expression "(" CallArgumentList ")"
                        > "++" Expression | "--" Expression
                        | "!" Expression
                        > left: Expression "**" Expression
                        > left:
                              Expression "*" Expression [strict]
                            | Expression "/" Expression [strict]
                            | Expression "%" Expression [strict]
                        > left:
                              Expression "+" Expression [strict]
                            | Expression "-" Expression [strict]
                        > left:
                              Expression "<" Expression [strict]
                            | Expression "<=" Expression [strict]
                            | Expression ">" Expression [strict]
                            | Expression ">=" Expression [strict]
                        > left:
                              Expression "==" Expression [strict]
                            | Expression "!=" Expression [strict]
                        > left: Expression "&&" Expression [strict(1)]
                        > left: Expression "||" Expression [strict(1)]
                        > right:
                            Expression "?" Expression ":" Expression [strict(1)]
                            | Expression "+=" Expression [strict(2)]
                            | Expression "-=" Expression [strict(2)]
                            | Expression "*=" Expression [strict(2)]
                            | Expression "/=" Expression [strict(2)]
                            | Expression "=" Expression [strict(2)]

endmodule

```
