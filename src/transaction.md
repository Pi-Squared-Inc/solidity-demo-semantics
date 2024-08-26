# Solidity transactions

```k

module SOLIDITY-TRANSACTION
  imports SOLIDITY-CONFIGURATION
  imports INT
  imports private SOLIDITY-EXPRESSION

  rule <k> create(FROM, VALUE, CTOR, ARGS) => bind(PARAMS, TYPES, ARGS, .List, .List) ~> List2Statements(INIT) ~> BODY ...</k>
       <msg-sender> _ => Int2MInt(Number2Int(FROM)) </msg-sender>
       <msg-value> _ => Int2MInt(Number2Int(VALUE)) </msg-value>
       <tx-origin> _ => Int2MInt(Number2Int(FROM)) </tx-origin>
       <this> _ => ADDR </this>
       <this-type> _ => CTOR </this-type>
       <env> _ => .Map </env>
       <store> _ => .Map </store>
       <contract-id> CTOR </contract-id>
       <contract-init> INIT </contract-init>
       <contract-fn-id> constructor </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
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
       <this> _ => ADDR </this>
       <this-type> _ => CTOR </this-type>
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

  syntax Transaction ::= txn(from: Decimal, to: MInt{160}, value: Decimal, func: Id, args: CallArgumentList) [strict(5)]
  rule txn(FROM, TO, VALUE, FUNC, ARGS) => txn(FROM, Int2MInt(Number2Int(TO)), VALUE, FUNC, ARGS)

  rule <k> txn(FROM, TO, VALUE, FUNC, ARGS) => bind(PARAMS, TYPES, ARGS, .List, .List) ~> BODY ...</k>
       <msg-sender> _ => Int2MInt(Number2Int(FROM)) </msg-sender>
       <msg-value> _ => Int2MInt(Number2Int(VALUE)) </msg-value>
       <tx-origin> _ => Int2MInt(Number2Int(FROM)) </tx-origin>
       <this> _ => TO </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => .Map </env>
       <store> _ => .Map </store>
       <live-contracts>
         <contract-address> TO </contract-address>
         <contract-type> TYPE </contract-type>
         ...
       </live-contracts>
       <contract-id> TYPE </contract-id>
       <contract-fn-id> FUNC </contract-fn-id>
       <contract-fn-param-names> PARAMS </contract-fn-param-names>
       <contract-fn-arg-types> TYPES </contract-fn-arg-types>
       <contract-fn-body> BODY </contract-fn-body>
    requires isKResult(ARGS)

endmodule
