# Solidity expressions

```k

module SOLIDITY-EXPRESSION
  imports SOLIDITY-CONFIGURATION
  imports INT

  // cast literal to address
  rule address ( I:NumberLiteral ) => v(Int2MInt(Number2Int(I))::MInt{160}, address)

  syntax Int ::= Number2Int(NumberLiteral) [function]
  rule Number2Int(X:HexNumber) => HexNumberString2Int(HexNumber2String(X))
  rule Number2Int(X:Decimal) => DecimalString2Int(Decimal2String(X))

  syntax String ::= HexNumber2String(HexNumber) [function, hook(STRING.token2string)]

  syntax Int ::= HexNumberString2Int(String) [function]
  rule HexNumberString2Int(S) => String2Base(substrString(S, 2, lengthString(S)), 16)

  syntax String ::= Decimal2String(Decimal) [function, hook(STRING.token2string)]

  syntax Int ::= DecimalString2Int(String) [function]
  rule DecimalString2Int(S) => String2Int(replaceAll(S, "_", ""))
    requires findChar(S, "eE.", 0) ==Int -1

  syntax Statements ::= List2Statements(List) [function]
  rule List2Statements(.List) => .Statements
  rule List2Statements(ListItem(S) L) => S List2Statements(L)

  syntax KItem ::= bind(List, CallArgumentList)
  rule bind(.List, .CallArgumentList) => .K
  rule bind(ListItem(noId) PARAMS, _, ARGS) => bind(PARAMS, ARGS)
  rule <k> bind(ListItem(X:Id) PARAMS, v(V:Value, _), ARGS) => bind(PARAMS, ARGS) ...</k>
       <env> E => E [ X <- !I:Int ] </env>
       <store> S => S [ !I <- V ] </store>
endmodule
