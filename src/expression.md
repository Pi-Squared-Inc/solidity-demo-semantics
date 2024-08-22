# Solidity expressions

```k

module SOLIDITY-EXPRESSION
  imports SOLIDITY-CONFIGURATION
  imports INT

  // new contract
  rule <k> new X:Id ( ARGS ) ~> K => bind(PARAMS, TYPES, ARGS, .List, .List) ~> List2Statements(INIT) ~> BODY ~> return v(ADDR, X) ; </k>
       <msg-sender> FROM => THIS </msg-sender>
       <this> THIS => ADDR </this>
       <this-type> TYPE => X </this-type>
       <env> E => .Map </env>
       <store> S => .Map </store>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE)) </call-stack>
       <contract-id> X </contract-id>
       <contract-init> INIT </contract-init>
       <contract-fn-id> constructor </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
       <contract-fn-body> BODY </contract-fn-body>
       <live-contracts>
         .Bag => <live-contract>
                   <contract-address> ADDR </contract-address>
                   <contract-type> X </contract-type>
                   ...
                 </live-contract>
         ...
       </live-contracts>
       <next-address> ADDR => ADDR +MInt 1p160 </next-address>
    requires isKResult(ARGS)

  rule <k> new X:Id ( .TypedVals ) ~> K => List2Statements(INIT) ~> return v(ADDR, X) ; </k>
       <msg-sender> FROM => THIS </msg-sender>
       <this> THIS => ADDR </this>
       <this-type> TYPE => X </this-type>
       <env> E => .Map </env>
       <store> S => .Map </store>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE)) </call-stack>
       <contract-id> X </contract-id>
       <contract-init> INIT </contract-init>
       <live-contracts>
         .Bag => <live-contract>
                   <contract-address> ADDR </contract-address>
                   <contract-type> X </contract-type>
                   ...
                 </live-contract>
         ...
       </live-contracts>
       <next-address> ADDR => ADDR +MInt 1p160 </next-address>

  // literal assignment to state variable
  rule <k> X:Id = N:Int => X = v(convert(N, LT), LT) ...</k>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> LT </contract-state>

  // assignment to state variable
  rule <k> X:Id = v(V, RT) => v(convert(V, RT, LT), LT) ...</k>
       <this> THIS </this>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> LT </contract-state>
       <contract-address> THIS </contract-address>
       <contract-storage> S => S [ X <- convert(V, RT, LT) ] </contract-storage>

  // assignment to local variable
  rule <k> X:Id = v(V, RT) => v(convert(V, RT, LT), LT) ...</k>
       <env>... X |-> var(I, LT) ...</env>
       <store> S => S [ I <- convert(V, RT, LT) ] </store>

  // type conversion
  context _:ElementaryTypeName ( HOLE:CallArgumentList )
  context _:Id ( HOLE:CallArgumentList )
  rule address(v(ADDR:MInt{160}, _)) => v(ADDR, address)
  rule address ( I:Int ) => v(Int2MInt(I)::MInt{160}, address)
  rule <k> TYPE(v(ADDR:MInt{160}, _)) => v(ADDR, TYPE) ...</k>
       <contract-id> TYPE </contract-id>
  rule <k> TYPE(v(ADDR:MInt{160}, _)) => v(ADDR, TYPE) ...</k>
       <iface-id> TYPE </iface-id>

  // state variable lookup
  rule <k> X:Id => v({S[X] orDefault default(T)}:>Value, T) ...</k>
       <this> THIS </this>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> T ...</contract-state>
       <contract-address> THIS </contract-address>
       <contract-storage> S </contract-storage>

  // local variable lookup
  rule <k> X:Id => v(V, T) ...</k>
       <env>... X |-> var(I, T) ...</env>
       <store>... I |-> V ...</store>

  // external call
  context HOLE . _ ( _:CallArgumentList )
  context (_ . _) ( HOLE:CallArgumentList )
  rule <k> v(ADDR, TYPE') . F:Id ( ARGS ) ~> K => bind(PARAMS, TYPES, ARGS, RETTYPES, RETNAMES) ~> BODY ~> return retval(RETNAMES); </k>
       <msg-sender> FROM => THIS </msg-sender>
       <this> THIS => ADDR </this>
       <this-type> TYPE => TYPE' </this-type>
       <env> E => .Map </env>
       <store> S => .Map </store>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE)) </call-stack>
       <contract-id> TYPE' </contract-id>
       <contract-fn-id> F </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
       <contract-fn-return-types> RETTYPES </contract-fn-return-types>
       <contract-fn-return-names> RETNAMES </contract-fn-return-names>
       <contract-fn-body> BODY </contract-fn-body>
       <contract-address> ADDR </contract-address>
       <contract-type> TYPE' </contract-type>
    requires isKResult(ARGS)

  // internal call
  rule <k> F:Id ( ARGS ) ~> K => bind(PARAMS, TYPES, ARGS, RETTYPES, RETNAMES) ~> BODY ~> return retval(RETNAMES); </k>
       <msg-sender> FROM </msg-sender>
       <this-type> TYPE </this-type>
       <env> E => .Map </env>
       <store> S => .Map </store>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE)) </call-stack>
       <contract-id> TYPE </contract-id>
       <contract-fn-id> F </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
       <contract-fn-return-types> RETTYPES </contract-fn-return-types>
       <contract-fn-return-names> RETNAMES </contract-fn-return-names>
       <contract-fn-body> BODY </contract-fn-body>
    requires isKResult(ARGS)

  // boolean literal
  rule B:Bool => v(B, bool)

  // integer literal
  rule N:NumberLiteral => Number2Int(N)

  // equality and inequality
  rule v(V1:MInt{160}, _) == v(V2, _) => v(V1 ==MInt V2, bool)
  rule v(V1:MInt{160}, _) != v(V2, _) => v(V1 =/=MInt V2, bool)
  rule v(V1:MInt{160}, _) < v(V2, _) => v(V1 <uMInt V2, bool)
  rule v(V1:MInt{160}, _) <= v(V2, _) => v(V1 <=uMInt V2, bool)
  rule v(V1:MInt{160}, _) > v(V2, _) => v(V1 >uMInt V2, bool)
  rule v(V1:MInt{160}, _) >= v(V2, _) => v(V1 >=uMInt V2, bool)

  // require expression
  syntax Id ::= "require" [token]
  rule require(v(true, bool), _) => void

  // ternary expression
  rule v(true, bool) ? X : _ => X
  rule v(false, bool) ? _ : X => X

  // boolean and/or
  rule v(true, bool) && E => E
  rule v(false, bool) && _ => v(false, bool)
  rule v(true, bool) || _ => v(true, bool)
  rule v(false, bool) || E => E

  // helpers
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
  rule DecimalString2Int(S) => String2Int(replaceAll(substrString(S, 0, findChar(S, "eE", 0)), "_", "")) *Int 10 ^Int String2Int(replaceAll(substrString(S, findChar(S, "eE", 0) +Int 1, lengthString(S)), "_", ""))
    requires findChar(S, ".", 0) ==Int -1 [owise]

  syntax Statements ::= List2Statements(List) [function]
  rule List2Statements(.List) => .Statements
  rule List2Statements(ListItem(S) L) => S List2Statements(L)

  syntax KItem ::= var(Int, TypeName)

  syntax KItem ::= bind(List, List, CallArgumentList, List, List)
  rule bind(.List, .List, .CallArgumentList, .List, .List) => .K
  rule bind(ListItem(noId) PARAMS, ListItem(_) TYPES, _, ARGS, L1:List, L2:List) => bind(PARAMS, TYPES, ARGS, L1, L2)
  rule bind(.List, .List, .CallArgumentList, ListItem(_) TYPES, ListItem(noId) NAMES) => bind(.List, .List, .CallArgumentList, TYPES, NAMES)
  rule <k> bind(ListItem(X:Id) PARAMS, ListItem(LT:TypeName) TYPES, v(V:Value, RT:TypeName), ARGS, L1:List, L2:List) => bind(PARAMS, TYPES, ARGS, L1, L2) ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- convert(V, RT, LT) ] </store>
  rule <k> bind(.List, .List, .CallArgumentList, ListItem(LT:TypeName) TYPES, ListItem(X:Id) NAMES) => bind(.List, .List, .CallArgumentList, TYPES, NAMES) ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- default(LT) ] </store>

  syntax Value ::= convert(Value, from: TypeName, to: TypeName) [function]
  rule convert(V, T, T) => V

  syntax Value ::= convert(Int, TypeName) [function]
  rule convert(I:Int, uint112) => Int2MInt(I)::MInt{112}
  rule convert(I:Int, uint256) => Int2MInt(I)::MInt{256}

  syntax Value ::= default(TypeName) [function]
  rule default(uint8)   => 0p8
  rule default(uint32)  => 0p32
  rule default(uint112) => 0p112
  rule default(address) => 0p160
  rule [[ default(X:Id) => 0p160 ]]
       <contract-id> X </contract-id>
  rule [[ default(X:Id) => 0p160 ]]
       <iface-id> X </iface-id>
  rule default(uint256) => 0p256

  syntax Expression ::= retval(List) [function] 
  rule retval(.List) => void
  rule retval(ListItem(noId)) => void
  rule retval(ListItem(X:Id)) => X
endmodule
