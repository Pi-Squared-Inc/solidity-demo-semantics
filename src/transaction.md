# Solidity transactions

```k

module SOLIDITY-TRANSACTION
  imports SOLIDITY-CONFIGURATION
  imports INT
  imports private SOLIDITY-EXPRESSION

  rule <k> create(_FROM, _VALUE, _NOW, CTOR, ARGS) => bind(.List, PARAMS, TYPES, ARGS, .List, .List) ~> List2Statements(INIT) ~> BODY ...</k>
       <msg-sender> _ => Int2MInt(Caller()) </msg-sender>
       <msg-value> _ => Int2MInt(CallValue()) </msg-value>
       <tx-origin> _ => Int2MInt(Origin()) </tx-origin>
       <block-timestamp> _ => Int2MInt(BlockTimestamp()) </block-timestamp>
       <this> _ => ADDR </this>
       <this-type> _ => CTOR </this-type>
       <env> _ => .Map </env>
       <store> _ => .List </store>
       <current-function> _ => constructor </current-function>
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

  rule <k> create(_FROM, _VALUE, _NOW, CTOR, .TypedVals) => List2Statements(INIT) ...</k>
       <msg-sender> _ => Int2MInt(Caller()) </msg-sender>
       <msg-value> _ => Int2MInt(CallValue()) </msg-value>
       <tx-origin> _ => Int2MInt(Origin()) </tx-origin>
       <block-timestamp> _ => Int2MInt(BlockTimestamp()) </block-timestamp>
       <this> _ => ADDR </this>
       <this-type> _ => CTOR </this-type>
       <env> _ => .Map </env>
       <store> _ => .List </store>
       <current-function> _ => constructor </current-function>
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

  syntax Transaction ::= txn(from: Decimal, to: MInt{160}, value: Decimal, timestamp: Decimal, func: Id, args: CallArgumentList)
  rule txn(FROM, TO, VALUE, NOW, FUNC, ARGS) => txn(FROM, Int2MInt(Number2Int(TO)), VALUE, NOW, FUNC, ARGS)

  rule <k> txn(_FROM, TO, _VALUE, _NOW, FUNC, ARGS) => bind(.List, PARAMS, TYPES, ARGS, .List, .List) ~> BODY ...</k>
       <msg-sender> _ => Int2MInt(Caller()) </msg-sender>
       <msg-value> _ => Int2MInt(CallValue()) </msg-value>
       <tx-origin> _ => Int2MInt(Origin()) </tx-origin>
       <block-timestamp> _ => Int2MInt(BlockTimestamp()) </block-timestamp>
       <this> _ => TO </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => .Map </env>
       <store> _ => .List </store>
       <current-function> _ => FUNC </current-function>
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

  syntax KItem ::= freezerTransactionCreate(Decimal, Decimal, Decimal, Id)
                 | freezerTransactionTxn(Decimal, MInt{160}, Decimal, Decimal, Id)
  rule <k> create(FROM, VALUE, NOW, CTOR, HOLE:CallArgumentList) => HOLE ~> freezerTransactionCreate(FROM, VALUE, NOW, CTOR) ...</k> [heat]
  rule <k> HOLE ~> freezerTransactionCreate(FROM, VALUE, NOW, CTOR) => create(FROM, VALUE, NOW, CTOR, HOLE) ...</k> [cool]
  rule <k> txn(FROM, TO, VALUE, NOW, FUNC, HOLE:CallArgumentList) => HOLE ~> freezerTransactionTxn(FROM, TO, VALUE, NOW, FUNC) ...</k> [heat]
  rule <k> HOLE:CallArgumentList ~> freezerTransactionTxn(FROM, TO, VALUE, NOW, FUNC) => txn(FROM, TO, VALUE, NOW, FUNC, HOLE) ...</k> [cool]

endmodule
