# Solidity transactions

```k

module SOLIDITY-TRANSACTION
  imports SOLIDITY-CONFIGURATION
  imports INT
  imports private SOLIDITY-EXPRESSION

  rule <k> create(FROM, VALUE, CTOR, ARGS) => bind(PARAMS, ARGS) ~> List2Statements(INIT) ~> BODY ...</k>
       <msg-sender> _ => Int2MInt(Number2Int(FROM)) </msg-sender>
       <msg-value> _ => Int2MInt(Number2Int(VALUE)) </msg-value>
       <tx-origin> _ => Int2MInt(Number2Int(FROM)) </tx-origin>
       <env> _ => .Map </env>
       <store> _ => .Map </store>
       <contract-id> CTOR </contract-id>
       <contract-init> INIT </contract-init>
       <contract-fn-id> constructor </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-body> BODY </contract-fn-body>
       <live-contracts>
         .Bag => <live-contract>
                   <contract-address> ADDR </contract-address>
                   <contract-type> CTOR </contract-type>
                   ...
                 </live-contract>
         ...
       </live-contracts>
       <next-address> ADDR => ADDR +MInt 1p160 </next-address>
    requires isKResult(ARGS)

  rule <k> create(FROM, VALUE, CTOR, .TypedVals) => List2Statements(INIT) ...</k>
       <msg-sender> _ => Int2MInt(Number2Int(FROM)) </msg-sender>
       <msg-value> _ => Int2MInt(Number2Int(VALUE)) </msg-value>
       <tx-origin> _ => Int2MInt(Number2Int(FROM)) </tx-origin>
       <env> _ => .Map </env>
       <store> _ => .Map </store>
       <contract-id> CTOR </contract-id>
       <contract-init> INIT </contract-init>
       <live-contracts>
         .Bag => <live-contract>
                   <contract-address> ADDR </contract-address>
                   <contract-type> CTOR </contract-type>
                   ...
                 </live-contract>
         ...
       </live-contracts>
       <next-address> ADDR => ADDR +MInt 1p160 </next-address>
    [owise]

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
