# Solidity expressions

```k

module SOLIDITY-EXPRESSION
  imports SOLIDITY-CONFIGURATION
  imports INT
  imports ULM

  // new contract
  rule <k> new X:Id ( ARGS ) ~> K => bind(S, PARAMS, TYPES, ARGS, .List, .List) ~> List2Statements(INIT) ~> BODY ~> return v(ADDR, X) ; </k>
       <msg-sender> FROM => THIS </msg-sender>
       <msg-value> VALUE => 0p256 </msg-value>
       <this> THIS => ADDR </this>
       <this-type> TYPE => X </this-type>
       <env> E => .Map </env>
       <store> S => .List </store>
       <current-function> FUNC => constructor </current-function>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) </call-stack>
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
       <msg-value> VALUE => 0p256 </msg-value>
       <this> THIS => ADDR </this>
       <this-type> TYPE => X </this-type>
       <env> E => .Map </env>
       <store> S => .List </store>
       <current-function> FUNC => constructor </current-function>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) </call-stack>
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

  // new array
  rule <k> new T[](Len:Int) => lv(size(S), .List, T[]) ...</k>
       <store> S => S ListItem(makeList(Len, default(T))) </store>
  rule <k> new T[](v(Len:MInt{256}, _)) => lv(size(S), .List, T[]) ...</k>
       <store> S => S ListItem(makeList(MInt2Unsigned(Len), default(T))) </store>

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

  // literal assignment to local variable
  rule <k> X:Id = N:Int => X = v(convert(N, LT), LT) ...</k>
       <env>... X |-> var(_, LT) ...</env>

  // assignment to local variable
  rule <k> X:Id = v(V, RT) => v(convert(V, RT, LT), LT) ...</k>
       <env>... X |-> var(I, LT) ...</env>
       <store> S => S [ I <- convert(V, RT, LT) ] </store>

  // reference assignment to local
  rule <k> X:Id = lv(I:Int, .List, T) => lv(I:Int, .List, T) ...</k>
       <env>... X |-> var(_ => I, T) ...</env>

  // assignment to array element
  rule <k> lv(I:Int, L, LT []) [ Idx:Int ] = v(V, RT) => v(convert(V, RT, LT), LT) ...</k>
       <store> S => S [ I <- write({S [ I ]}:>Value, L ListItem(Idx), convert(V, RT, LT), LT[]) ] </store>
  rule <k> lv(I:Int, L, LT []) [ v(Idx:MInt{256}, _) ] = v(V, RT) => v(convert(V, RT, LT), LT) ...</k>
       <store> S => S [ I <- write({S [ I ]}:>Value, L ListItem(MInt2Unsigned(Idx)), convert(V, RT, LT), LT[]) ] </store>
  rule <k> lv(X:Id, L, mapping(LT1:ElementaryTypeName _ => T2)) [ v(Key, RT1) ] = v(V, RT) => v(convert(V, RT, T2), T2) ...</k>
       <this> THIS </this>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> T ...</contract-state>
       <contract-address> THIS </contract-address>
       <contract-storage> S => S [ X <- write({S [ X ] orDefault .Map}:>Value, L ListItem(convert(Key, RT1, LT1)), convert(V, RT, T2), T) ] </contract-storage>

  syntax Value ::= write(Value, List, Value, TypeName) [function]
  rule write(_, .List, V, _) => V
  rule write(L1:List, ListItem(I:Int) L2, V, T[]) => L1 [ I <- write({L1 [ I ]}:>Value, L2, V, T) ]
  rule write(M:Map, ListItem(Key:Value) L2, V, mapping(_ _ => T2)) => M [ Key <- write({M [ Key ] orDefault default(T2)}:>Value, L2, V, T2) ]

  // type conversion
  rule uint32(v(V:MInt{256}, _)) => v(roundMInt(V)::MInt{32}, uint32)
  rule uint112(v(V:MInt{256}, _)) => v(roundMInt(V)::MInt{112}, uint112)
  rule uint256(v(V:MInt{112}, _)) => v(roundMInt(V)::MInt{256}, uint256)
  rule uint256(I:Int) => v(Int2MInt(I)::MInt{256}, uint256)
  rule address(v(ADDR:MInt{160}, _)) => v(ADDR, address)
  rule address(I:Int) => v(Int2MInt(I)::MInt{160}, address)
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
    requires notBool isAggregateType(T)

  rule <k> X:Id => lv(X, .List, T) ...</k>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> T ...</contract-state>
    requires isAggregateType(T)

  // local variable lookup
  rule <k> X:Id => v(V, T) ...</k>
       <env>... X |-> var(I, T) ...</env>
       <store> _ [ I <- V ] </store>
    requires notBool isAggregateType(T)

  rule <k> X:Id => lv(I, .List, T) ...</k>
       <env>... X |-> var(I, T) ...</env>
    requires isAggregateType(T)

  // array element lookup
  rule <k> lv(I:Int, L, T []) [ Idx:Int ] => v(read(V, L ListItem(Idx), T[]), T) ...</k>
       <store> _ [ I <- V ] </store>
    requires notBool isAggregateType(T)
  rule <k> lv(I:Int, L, T []) [ v(Idx:MInt{256}, _) ] => v(read(V, L ListItem(MInt2Unsigned(Idx)), T[]), T) ...</k>
       <store> _ [ I <- V ] </store>
    requires notBool isAggregateType(T)
  rule <k> lv(X:Id, L, mapping(T1:ElementaryTypeName _ => T2)) [ v(Key, RT) ] => v(read({S [ X ] orDefault .Map}:>Value, L ListItem(convert(Key, RT, T1)), T), T2) ...</k>
       <this> THIS </this>
       <this-type> TYPE </this-type>
       <contract-id> TYPE </contract-id>
       <contract-state>... X |-> T ...</contract-state>
       <contract-address> THIS </contract-address>
       <contract-storage> S </contract-storage>
    requires notBool isAggregateType(T2)

  rule <k> lv(R, L, T []) [ Idx:Int ] => lv(R, L ListItem(Idx), T) ...</k>
    requires isAggregateType(T)
  rule <k> lv(R, L, T []) [ v(Idx:MInt{256}, _) ] => lv(R, L ListItem(MInt2Unsigned(Idx)), T) ...</k>
    requires isAggregateType(T)
  rule <k> lv(R, L, mapping(T1:ElementaryTypeName _ => T2)) [ v(V, RT) ] => lv(R, L ListItem(convert(V, RT, T1)), T2) ...</k>
    requires isAggregateType(T2)

  syntax Value ::= read(Value, List, TypeName) [function]
  rule read(V, .List, _) => V
  rule read(L1:List, ListItem(I:Int) L2, T[]) => read({L1 [ I ]}:>Value, L2, T)
  rule read(M:Map, ListItem(V:Value) L, mapping(_ _ => T)) => read({M [ V ] orDefault default(T)}:>Value, L, T)

  // array length
  syntax Id ::= "length" [token]
  rule <k> lv(I:Int, .List, T) . length => v(Int2MInt(size({read(V, .List, T)}:>List))::MInt{256}, uint) ...</k>
       <store> _ [ I <- V ] </store>

  // external call
  rule <k> v(ADDR, _) . F:Id ( ARGS ) ~> K => bind(S, PARAMS, TYPES, ARGS, RETTYPES, RETNAMES) ~> BODY ~> return retval(RETNAMES); </k>
       <msg-sender> FROM => THIS </msg-sender>
       <msg-value> VALUE => 0p256 </msg-value>
       <this> THIS => ADDR </this>
       <this-type> TYPE => TYPE' </this-type>
       <env> E => .Map </env>
       <store> S => .List </store>
       <current-function> FUNC => F </current-function>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) </call-stack>
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

  syntax Id ::= "value" [token]

  rule <k> v(ADDR, TYPE') . F:Id { value: v(VALUE', uint256) } ( ARGS ) ~> K => bind(S, PARAMS, TYPES, ARGS, RETTYPES, RETNAMES) ~> BODY ~> return retval(RETNAMES); </k>
       <msg-sender> FROM => THIS </msg-sender>
       <msg-value> VALUE => VALUE' </msg-value>
       <this> THIS => ADDR </this>
       <this-type> TYPE => TYPE' </this-type>
       <env> E => .Map </env>
       <store> S => .List </store>
       <current-function> FUNC => F </current-function>
       <call-stack>... .List => ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) </call-stack>
       <contract-id> TYPE' </contract-id>
       <contract-fn-id> F </contract-fn-id>
       <contract-fn-payable> PAYABLE </contract-fn-payable>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
       <contract-fn-return-types> RETTYPES </contract-fn-return-types>
       <contract-fn-return-names> RETNAMES </contract-fn-return-names>
       <contract-fn-body> BODY </contract-fn-body>
       <contract-address> ADDR </contract-address>
       <contract-type> TYPE' </contract-type>
    requires isKResult(ARGS) andBool (PAYABLE orBool VALUE' ==MInt 0p256)

  // internal call
  rule <k> F:Id ( ARGS ) ~> K => bind(S, PARAMS, TYPES, ARGS, RETTYPES, RETNAMES) ~> BODY ~> return retval(RETNAMES); </k>
       <env> E => .Map </env>
       <store> S </store>
       <current-function> FUNC => F </current-function>
       <call-stack>... .List => ListItem(frame(K, E, FUNC)) </call-stack>
       <this-type> TYPE </this-type>
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


  // automatic variables
  syntax Id ::= "msg" [token] | "sender" [token] | "this" [token] | "tx" [token] | "origin" [token] | "block" [token] | "timestamp" [token] | "gaslimit" [token] | "basefee" [token] | "coinbase" [token] | "number" [token] | "difficulty" [token] | "prevrandao" [token] | "chainid" [token] | "gasprice" [token] | "data" [token] | "blockhash" [token]

  rule <k> (msg . sender)::Expression => v(FROM, address) ...</k>
       <msg-sender> FROM </msg-sender>
  rule <k> (msg . value)::Expression => v(VALUE, uint) ...</k>
       <msg-value> VALUE </msg-value>
  rule <k> this => v(THIS, TYPE) ...</k>
       <this> THIS </this>
       <this-type> TYPE </this-type>
  rule <k> (tx . origin)::Expression => v(ORIGIN, address) ...</k>
       <tx-origin> ORIGIN </tx-origin>
  rule <k> (block . timestamp)::Expression => v(NOW, uint) ...</k>
       <block-timestamp> NOW </block-timestamp>

  rule <k> (block . gaslimit)::Expression => GasLimit() ...</k>
  rule <k> (block . basefee)::Expression => BaseFee() ...</k>
  rule <k> (block . coinbase)::Expression => Coinbase() ...</k>
  rule <k> (block . number)::Expression => BlockNumber() ...</k>
  rule <k> (block . difficulty)::Expression => BlockDifficulty() ...</k>
  rule <k> (block . prevrandao)::Expression => PrevRandao() ...</k>
  rule <k> (block . chainid)::Expression => ChainId() ...</k>

  rule <k> blockhash ( X:Int ) => BlockHash(X) ...</k>

  rule <k> (tx . gasprice)::Expression => GasPrice() ...</k>
  rule <k> (msg . data)::Expression => CallData() ...</k>

  // basic arithmetic
  rule v(V1:Value, T)  + v(V2:Value, T) => v(add(V1, V2), T)
  rule v(V1:Value, T)  - v(V2:Value, T) => v(sub(V1, V2), T)
  rule v(V1:Value, T)  * v(V2:Value, T) => v(mul(V1, V2), T)
  rule v(V1:Value, T)  / v(V2:Value, T) => v(div(V1, V2), T)
  rule v(V1:Value, T)  % v(V2:Value, T) => v(mod(V1, V2), T)
  rule v(V1:Value, T) ** v(V2:Value, T) => v(exp(V1, V2), T)

  rule v(_:Value, T)  + (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T))  + v(_:Value, T)
  rule v(_:Value, T)  - (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T))  - v(_:Value, T)
  rule v(_:Value, T)  * (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T))  * v(_:Value, T)
  rule v(_:Value, T)  / (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T))  / v(_:Value, T)
  rule v(_:Value, T)  % (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T))  % v(_:Value, T)
  rule v(_:Value, T) ** (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) ** v(_:Value, T) 

  rule I1:Int  + I2:Int => I1 +Int I2
  rule I1:Int  - I2:Int => I1 -Int I2
  rule I1:Int  * I2:Int => I1 *Int I2
  rule I1:Int  / I2:Int => I1 /Int I2
  rule I1:Int  % I2:Int => I1 %Int I2
  rule I1:Int ** I2:Int => I1 ^Int I2

  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))  + v(_, uint256)
  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))  - v(_, uint256)
  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))  * v(_, uint256)
  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))  / v(_, uint256)
  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))  % v(_, uint256)
  rule (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256)) ** v(_, uint256)
  rule v(_, uint256)  + (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
  rule v(_, uint256)  - (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
  rule v(_, uint256)  * (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
  rule v(_, uint256)  / (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
  rule v(_, uint256)  % (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
  rule v(_, uint256) ** (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))
 
  // local increment and decrement
  rule <k> X:Id ++ => v(V, T) ...</k>
       <env>... X |-> var(I, T) ...</env>
       <store> _ [ I <- (V => add(V, convert(1, T))) ] </store>
  rule <k> X:Id -- => v(V, T) ...</k>
       <env>... X |-> var(I, T) ...</env>
       <store> _ [ I <- (V => sub(V, convert(1, T))) ] </store>

  // equality and inequality
  rule v(V1:Value, T) == v(V2:Value, T) => v(eq(V1, V2), bool)
  rule v(V1:Value, T) != v(V2:Value, T) => v(neq(V1, V2), bool)
  rule v(V1:Value, T) < v(V2:Value, T) => v(lt(V1, V2), bool)
  rule v(V1:Value, T) <= v(V2:Value, T) => v(leq(V1, V2), bool)
  rule v(V1:Value, T) > v(V2:Value, T) => v(gt(V1, V2), bool)
  rule v(V1:Value, T) >= v(V2:Value, T) => v(geq(V1, V2), bool)

  rule v(_, uint256) < (v(V:MInt{112}, uint112) => v(roundMInt(V)::MInt{256}, uint256))

  rule v(_:Value, T) == (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) == v(_:Value, T)
  rule v(_:Value, T) != (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) != v(_:Value, T)
  rule v(_:Value, T) <  (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) <  v(_:Value, T)
  rule v(_:Value, T) <= (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) <= v(_:Value, T)
  rule v(_:Value, T) >  (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) >  v(_:Value, T)
  rule v(_:Value, T) >= (I:Int => v(convert(I, T), T))
  rule (I:Int => v(convert(I, T), T)) >= v(_:Value, T)

  rule I1:Int == I2:Int => v(I1  ==Int I2, bool)
  rule I1:Int != I2:Int => v(I1 =/=Int I2, bool)
  rule I1:Int <  I2:Int => v(I1   <Int I2, bool)
  rule I1:Int <= I2:Int => v(I1  <=Int I2, bool)
  rule I1:Int >  I2:Int => v(I1   >Int I2, bool)
  rule I1:Int >= I2:Int => v(I1  >=Int I2, bool)

  // require expression
  syntax Id ::= "require" [token] | "assert" [token]
  rule require(v(true, bool), _) => void
  rule assert(v(true, bool)) => void
  rule <k> require(v(false, bool), _) => STUCK ...</k>
       <status> _ => EVMC_REVERT </status>
  rule <k> assert(v(false, bool)) => STUCK ...</k>
       <status> _ => EVMC_FAILURE </status>
  syntax KItem ::= "STUCK"

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

  syntax KItem ::= bind(List, List, List, CallArgumentList, List, List)
  rule bind(_, .List, .List, .CallArgumentList, .List, .List) => .K
  rule bind(STORE, ListItem(noId) PARAMS, ListItem(_) TYPES, _, ARGS, L1:List, L2:List) => bind(STORE, PARAMS, TYPES, ARGS, L1, L2)
  rule bind(STORE, .List, .List, .CallArgumentList, ListItem(_) TYPES, ListItem(noId) NAMES) => bind(STORE, .List, .List, .CallArgumentList, TYPES, NAMES)
  rule <k> bind(STORE, ListItem(X:Id) PARAMS, ListItem(T:TypeName) TYPES, lv(I:Int, .List, T:TypeName), ARGS, L1:List, L2:List) => bind(STORE, PARAMS, TYPES, ARGS, L1, L2) ...</k>
       <env> E => E [ X <- var(size(S), T) ] </env>
       <store> S => S ListItem(STORE [ I ]) </store>
  rule <k> bind(STORE, ListItem(X:Id) PARAMS, ListItem(LT:TypeName) TYPES, v(V:Value, RT:TypeName), ARGS, L1:List, L2:List) => bind(STORE, PARAMS, TYPES, ARGS, L1, L2) ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(convert(V, RT, LT)) </store>
  rule <k> bind(STORE, ListItem(X:Id) PARAMS, ListItem(LT:TypeName) TYPES, N:Int, ARGS, L1:List, L2:List) => bind(STORE, PARAMS, TYPES, ARGS, L1, L2) ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(convert(N, LT)) </store>
  rule <k> bind(STORE, .List, .List, .CallArgumentList, ListItem(LT:TypeName) TYPES, ListItem(X:Id) NAMES) => bind(STORE, .List, .List, .CallArgumentList, TYPES, NAMES) ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(default(LT)) </store>

  syntax Value ::= convert(Value, from: TypeName, to: TypeName) [function]
  rule convert(V, T, T) => V
  rule convert(V:MInt{32},   uint32, uint112) => roundMInt(V)::MInt{112}
  rule convert(V:MInt{112}, uint112, uint256) => roundMInt(V)::MInt{256}
  rule convert(V:MInt{160}, address, uint256) => roundMInt(V)::MInt{256}
  rule convert(V:MInt{256}, uint256, uint112) => roundMInt(V)::MInt{112}
  rule convert(V:MInt{256}, uint256, address) => roundMInt(V)::MInt{160}

  // this is kind of ugly, but we don't have parametric axioms.
  syntax Value ::= convert(Int, TypeName) [function]
  rule convert(I:Int, uint8)   => Int2MInt(I)::MInt{8}
  rule convert(I:Int, uint32)  => Int2MInt(I)::MInt{32}
  rule convert(I:Int, uint112) => Int2MInt(I)::MInt{112}
  rule convert(I:Int, address) => Int2MInt(I)::MInt{160}
  rule convert(I:Int, uint256) => Int2MInt(I)::MInt{256}

  syntax Value ::= add(Value, Value) [function]
                 | sub(Value, Value) [function]
                 | mul(Value, Value) [function]
                 | div(Value, Value) [function]
                 | mod(Value, Value) [function]
                 | exp(Value, Value) [function]
  rule add(V1:MInt{8},   V2:MInt{8})   => V1  +MInt V2
  rule add(V1:MInt{32},  V2:MInt{32})  => V1  +MInt V2
  rule add(V1:MInt{112}, V2:MInt{112}) => V1  +MInt V2
  rule add(V1:MInt{160}, V2:MInt{160}) => V1  +MInt V2
  rule add(V1:MInt{256}, V2:MInt{256}) => V1  +MInt V2
  rule sub(V1:MInt{8},   V2:MInt{8})   => V1  -MInt V2
  rule sub(V1:MInt{32},  V2:MInt{32})  => V1  -MInt V2
  rule sub(V1:MInt{112}, V2:MInt{112}) => V1  -MInt V2
  rule sub(V1:MInt{160}, V2:MInt{160}) => V1  -MInt V2
  rule sub(V1:MInt{256}, V2:MInt{256}) => V1  -MInt V2
  rule mul(V1:MInt{8},   V2:MInt{8})   => V1  *MInt V2
  rule mul(V1:MInt{32},  V2:MInt{32})  => V1  *MInt V2
  rule mul(V1:MInt{112}, V2:MInt{112}) => V1  *MInt V2
  rule mul(V1:MInt{160}, V2:MInt{160}) => V1  *MInt V2
  rule mul(V1:MInt{256}, V2:MInt{256}) => V1  *MInt V2
  rule div(V1:MInt{8},   V2:MInt{8})   => V1 /uMInt V2
  rule div(V1:MInt{32},  V2:MInt{32})  => V1 /uMInt V2
  rule div(V1:MInt{112}, V2:MInt{112}) => V1 /uMInt V2
  rule div(V1:MInt{160}, V2:MInt{160}) => V1 /uMInt V2
  rule div(V1:MInt{256}, V2:MInt{256}) => V1 /uMInt V2
  rule mod(V1:MInt{8},   V2:MInt{8})   => V1 %uMInt V2
  rule mod(V1:MInt{32},  V2:MInt{32})  => V1 %uMInt V2
  rule mod(V1:MInt{112}, V2:MInt{112}) => V1 %uMInt V2
  rule mod(V1:MInt{160}, V2:MInt{160}) => V1 %uMInt V2
  rule mod(V1:MInt{256}, V2:MInt{256}) => V1 %uMInt V2
  rule exp( _:MInt{8},   V2:MInt{8})          => 1p8 requires V2 ==MInt 0p8
  rule exp(V1:MInt{8},   V2:MInt{8})   => V1 *MInt {exp(V1, V2 -MInt 1p8)}:>MInt{8} [owise]
  rule exp( _:MInt{32},  V2:MInt{32})         => 1p32 requires V2 ==MInt 0p32
  rule exp(V1:MInt{32},  V2:MInt{32})  => V1 *MInt {exp(V1, V2 -MInt 1p32)}:>MInt{32} [owise]
  rule exp( _:MInt{112}, V2:MInt{112})        => 1p112 requires V2 ==MInt 0p112
  rule exp(V1:MInt{112}, V2:MInt{112}) => V1 *MInt {exp(V1, V2 -MInt 1p112)}:>MInt{112} [owise]
  rule exp( _:MInt{160}, V2:MInt{160})        => 1p160 requires V2 ==MInt 0p160
  rule exp(V1:MInt{160}, V2:MInt{160}) => V1 *MInt {exp(V1, V2 -MInt 1p160)}:>MInt{160} [owise]
  rule exp( _:MInt{256}, V2:MInt{256})        => 1p256 requires V2 ==MInt 0p256
  rule exp(V1:MInt{256}, V2:MInt{256}) => V1 *MInt {exp(V1, V2 -MInt 1p256)}:>MInt{256} [owise]

  syntax Value ::= eq (Value, Value) [function]
                 | neq(Value, Value) [function]
                 | lt (Value, Value) [function]
                 | leq(Value, Value) [function]
                 | gt (Value, Value) [function]
                 | geq(Value, Value) [function]
  rule eq (V1:MInt{8},   V2:MInt{8})   => V1  ==MInt V2
  rule eq (V1:MInt{32},  V2:MInt{32})  => V1  ==MInt V2
  rule eq (V1:MInt{112}, V2:MInt{112}) => V1  ==MInt V2
  rule eq (V1:MInt{160}, V2:MInt{160}) => V1  ==MInt V2
  rule eq (V1:MInt{256}, V2:MInt{256}) => V1  ==MInt V2
  rule neq(V1:MInt{8},   V2:MInt{8})   => V1 =/=MInt V2
  rule neq(V1:MInt{32},  V2:MInt{32})  => V1 =/=MInt V2
  rule neq(V1:MInt{112}, V2:MInt{112}) => V1 =/=MInt V2
  rule neq(V1:MInt{160}, V2:MInt{160}) => V1 =/=MInt V2
  rule neq(V1:MInt{256}, V2:MInt{256}) => V1 =/=MInt V2
  rule lt (V1:MInt{8},   V2:MInt{8})   => V1  <uMInt V2
  rule lt (V1:MInt{32},  V2:MInt{32})  => V1  <uMInt V2
  rule lt (V1:MInt{112}, V2:MInt{112}) => V1  <uMInt V2
  rule lt (V1:MInt{160}, V2:MInt{160}) => V1  <uMInt V2
  rule lt (V1:MInt{256}, V2:MInt{256}) => V1  <uMInt V2
  rule leq(V1:MInt{8},   V2:MInt{8})   => V1 <=uMInt V2
  rule leq(V1:MInt{32},  V2:MInt{32})  => V1 <=uMInt V2
  rule leq(V1:MInt{112}, V2:MInt{112}) => V1 <=uMInt V2
  rule leq(V1:MInt{160}, V2:MInt{160}) => V1 <=uMInt V2
  rule leq(V1:MInt{256}, V2:MInt{256}) => V1 <=uMInt V2
  rule gt (V1:MInt{8},   V2:MInt{8})   => V1  >uMInt V2
  rule gt (V1:MInt{32},  V2:MInt{32})  => V1  >uMInt V2
  rule gt (V1:MInt{112}, V2:MInt{112}) => V1  >uMInt V2
  rule gt (V1:MInt{160}, V2:MInt{160}) => V1  >uMInt V2
  rule gt (V1:MInt{256}, V2:MInt{256}) => V1  >uMInt V2
  rule geq(V1:MInt{8},   V2:MInt{8})   => V1 >=uMInt V2
  rule geq(V1:MInt{32},  V2:MInt{32})  => V1 >=uMInt V2
  rule geq(V1:MInt{112}, V2:MInt{112}) => V1 >=uMInt V2
  rule geq(V1:MInt{160}, V2:MInt{160}) => V1 >=uMInt V2
  rule geq(V1:MInt{256}, V2:MInt{256}) => V1 >=uMInt V2

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
  rule default(_ []) => .List
  rule default(mapping(_ _ => _ _)) => .Map

  syntax Expression ::= retval(List) [function] 
  rule retval(.List) => void
  rule retval(ListItem(noId)) => void
  rule retval(ListItem(X:Id)) => X

  // Heating and cooling rules
  syntax KItem ::= freezerAssignment(Expression)
  rule <k> E:Expression = HOLE:Expression => HOLE ~> freezerAssignment(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAssignment(E) => E = HOLE ...</k> [cool]

  syntax KItem ::= freezerTernaryOperator(Expression, Expression)
  rule <k> HOLE:Expression ? E1:Expression : E2:Expression => HOLE ~> freezerTernaryOperator(E1, E2) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerTernaryOperator(E1, E2) => HOLE ? E1 : E2 ...</k> [cool]

  syntax KItem ::= freezerOr(Expression)
  rule <k> HOLE:Expression || E:Expression => HOLE ~> freezerOr(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerOr(E) => HOLE || E ...</k> [cool]

  syntax KItem ::= freezerAnd(Expression)
  rule <k> HOLE:Expression && E:Expression => HOLE ~> freezerAnd(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAnd(E) => HOLE && E ...</k> [cool]

  syntax KItem ::= freezerEq1(Expression)
                 | freezerEq2(Expression)
  rule <k> HOLE:Expression == E:Expression => HOLE ~> freezerEq1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerEq1(E) => HOLE == E ...</k> [cool]
  rule <k> E:Expression == HOLE:Expression => HOLE ~> freezerEq2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerEq2(E) => E == HOLE ...</k> [cool]

  syntax KItem ::= freezerNeq1(Expression)
                 | freezerNeq2(Expression)
  rule <k> HOLE:Expression != E:Expression => HOLE ~> freezerNeq1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerNeq1(E) => HOLE != E ...</k> [cool]
  rule <k> E:Expression != HOLE:Expression => HOLE ~> freezerNeq2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerNeq2(E) => E != HOLE ...</k> [cool]

  syntax KItem ::= freezerLt1(Expression)
                 | freezerLt2(Expression)
  rule <k> HOLE:Expression < E:Expression => HOLE ~> freezerLt1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerLt1(E) => HOLE < E ...</k> [cool]
  rule <k> E:Expression < HOLE:Expression => HOLE ~> freezerLt2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerLt2(E) => E < HOLE ...</k> [cool]

  syntax KItem ::= freezerLeq1(Expression)
                 | freezerLeq2(Expression)
  rule <k> HOLE:Expression <= E:Expression => HOLE ~> freezerLeq1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerLeq1(E) => HOLE <= E ...</k> [cool]
  rule <k> E:Expression <= HOLE:Expression => HOLE ~> freezerLeq2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerLeq2(E) => E <= HOLE ...</k> [cool]

  syntax KItem ::= freezerGt1(Expression)
                 | freezerGt2(Expression)
  rule <k> HOLE:Expression > E:Expression => HOLE ~> freezerGt1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerGt1(E) => HOLE > E ...</k> [cool]
  rule <k> E:Expression > HOLE:Expression => HOLE ~> freezerGt2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerGt2(E) => E > HOLE ...</k> [cool]

  syntax KItem ::= freezerGeq1(Expression)
                 | freezerGeq2(Expression)
  rule <k> HOLE:Expression >= E:Expression => HOLE ~> freezerGeq1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerGeq1(E) => HOLE >= E ...</k> [cool]
  rule <k> E:Expression >= HOLE:Expression => HOLE ~> freezerGeq2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerGeq2(E) => E >= HOLE ...</k> [cool]

  syntax KItem ::= freezerAdd1(Expression)
                 | freezerAdd2(Expression)
  rule <k> HOLE:Expression + E:Expression => HOLE ~> freezerAdd1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAdd1(E) => HOLE + E ...</k> [cool]
  rule <k> E:Expression + HOLE:Expression => HOLE ~> freezerAdd2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAdd2(E) => E + HOLE ...</k> [cool]

  syntax KItem ::= freezerSub1(Expression)
                 | freezerSub2(Expression)
  rule <k> HOLE:Expression - E:Expression => HOLE ~> freezerSub1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerSub1(E) => HOLE - E ...</k> [cool]
  rule <k> E:Expression - HOLE:Expression => HOLE ~> freezerSub2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerSub2(E) => E - HOLE ...</k> [cool]

  syntax KItem ::= freezerMul1(Expression)
                 | freezerMul2(Expression)
  rule <k> HOLE:Expression * E:Expression => HOLE ~> freezerMul1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerMul1(E) => HOLE * E ...</k> [cool]
  rule <k> E:Expression * HOLE:Expression => HOLE ~> freezerMul2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerMul2(E) => E * HOLE ...</k> [cool]

  syntax KItem ::= freezerDiv1(Expression)
                 | freezerDiv2(Expression)
  rule <k> HOLE:Expression / E:Expression => HOLE ~> freezerDiv1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerDiv1(E) => HOLE / E ...</k> [cool]
  rule <k> E:Expression / HOLE:Expression => HOLE ~> freezerDiv2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerDiv2(E) => E / HOLE ...</k> [cool]

  syntax KItem ::= freezerMod1(Expression)
                 | freezerMod2(Expression)
  rule <k> HOLE:Expression % E:Expression => HOLE ~> freezerMod1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerMod1(E) => HOLE % E ...</k> [cool]
  rule <k> E:Expression % HOLE:Expression => HOLE ~> freezerMod2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerMod2(E) => E % HOLE ...</k> [cool]

  syntax KItem ::= freezerExp1(Expression)
                 | freezerExp2(Expression)
  rule <k> HOLE:Expression ** E:Expression => HOLE ~> freezerExp1(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExp1(E) => HOLE ** E ...</k> [cool]
  rule <k> E:Expression ** HOLE:Expression => HOLE ~> freezerExp2(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExp2(E) => E ** HOLE ...</k> [cool]

  syntax KItem ::= freezerNew(TypeName)
  rule <k> new T:TypeName ( HOLE:CallArgumentList ) => HOLE ~> freezerNew(T) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerNew(T) => new T ( HOLE ) ...</k> [cool]

  syntax KItem ::= freezerCallArgumentListHead(Expression)
                 | freezerCallArgumentListTail(CallArgumentList)
  rule <k> HOLE:Expression, L:CallArgumentList => HOLE ~> freezerCallArgumentListTail(L) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerCallArgumentListTail(L) => HOLE, L ...</k> [cool]
  rule <k> E:Expression, HOLE:CallArgumentList => HOLE ~> freezerCallArgumentListHead(E) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerCallArgumentListHead(E) => E, HOLE ...</k> [cool]

  syntax KItem ::= freezerTypedValsHead(TypedVal)
                 | freezerTypedValsTail(TypedVals)
  rule <k> HOLE:TypedVal, L:TypedVals => HOLE ~> freezerTypedValsTail(L) ...</k> [heat]
  rule <k> HOLE:TypedVal ~> freezerTypedValsTail(L) => HOLE, L ...</k> [cool]
  rule <k> E:TypedVal, HOLE:TypedVals => HOLE ~> freezerTypedValsHead(E) ...</k> [heat]
  rule <k> HOLE:TypedVals ~> freezerTypedValsHead(E) => E, HOLE ...</k> [cool]

  syntax KItem ::= freezerAssignmentToArrayElementBase(Expression, Expression)
                 | freezerAssignmentToArrayElementIndex(Expression, Expression)
  rule <k> HOLE:Expression [ E2:Expression ] = E3:Expression => HOLE ~> freezerAssignmentToArrayElementBase(E2, E3) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAssignmentToArrayElementBase(E2, E3) => HOLE [ E2 ] = E3 ...</k> [cool]
  rule <k> E1:Expression [ HOLE:Expression ] = E3:Expression => HOLE ~> freezerAssignmentToArrayElementIndex(E1, E3) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerAssignmentToArrayElementIndex(E1, E3) => E1 [ HOLE ] = E3 ...</k> [cool]

  syntax KItem ::= freezerCallElementaryTypeName(ElementaryTypeName)
  rule <k> T:ElementaryTypeName ( HOLE:CallArgumentList ) => HOLE ~> freezerCallElementaryTypeName(T) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerCallElementaryTypeName(T) => T ( HOLE ) ...</k> [cool]

  syntax KItem ::= freezerCallId(Id)
  rule <k> ID:Id ( HOLE:CallArgumentList ) => HOLE ~> freezerCallId(ID) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerCallId(ID) => ID ( HOLE ) ...</k> [cool]

  syntax KItem ::= freezerArrayElementLookupBase(Expression)
                 | freezerArrayElementLookupIndex(Expression)
  rule <k> HOLE:Expression [ E:Expression ] => HOLE ~> freezerArrayElementLookupBase(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerArrayElementLookupBase(E) => HOLE [ E ] ...</k> [cool]
  rule <k> E:Expression [ HOLE:Expression ] => HOLE ~> freezerArrayElementLookupIndex(E) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerArrayElementLookupIndex(E) => E [ HOLE ] ...</k> [cool]

  syntax KItem ::= freezerLength()
  rule <k> HOLE:Expression . length => HOLE ~> freezerLength() ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerLength() => HOLE . length ...</k> [cool]

  syntax KItem ::= freezerExternalCallBase(Id, CallArgumentList)
                 | freezerExternalCallArgs(Expression, Id)
  rule <k> HOLE:Expression . ID:Id ( ARGS:CallArgumentList ) => HOLE ~> freezerExternalCallBase(ID, ARGS) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExternalCallBase(ID, ARGS) => (HOLE . ID) ( ARGS ) ...</k> [cool]
  rule <k> (E:Expression . ID:Id) ( HOLE:CallArgumentList ) => HOLE ~> freezerExternalCallArgs(E, ID) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerExternalCallArgs(E, ID) => (E . ID) ( HOLE ) ...</k> [cool]

  syntax KItem ::= freezerExternalCallWithValueBase(Id, Expression, CallArgumentList)
                 | freezerExternalCallWithValueValue(Expression, Id, CallArgumentList)
                 | freezerExternalCallWithValueArgs(Expression, Id, KeyValues)
  rule <k> HOLE:Expression . ID:Id { value: V:Expression } ( ARGS:CallArgumentList ) => HOLE ~> freezerExternalCallWithValueBase(ID, V, ARGS) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExternalCallWithValueBase(ID, V, ARGS) => HOLE . ID { value : V } ( ARGS ) ...</k> [cool]
  rule <k> E:Expression . ID:Id { value: HOLE:Expression } ( ARGS:CallArgumentList ) => HOLE ~> freezerExternalCallWithValueValue(E, ID, ARGS) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExternalCallWithValueValue(E, ID, ARGS) => E . ID { value : HOLE } ( ARGS ) ...</k> [cool]
  rule <k> E:Expression . ID:Id { L:KeyValues } ( HOLE:CallArgumentList ) => HOLE ~> freezerExternalCallWithValueArgs(E, ID, L) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExternalCallWithValueArgs(E, ID, L) => E . ID { L } ( HOLE ) ...</k> [cool]

endmodule
```