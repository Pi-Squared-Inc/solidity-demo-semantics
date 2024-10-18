# Main Configuration and Core Data Constructors

```k
requires "solidity-syntax.md"
requires "interface.md"
requires "contract.md"
requires "transaction.md"
requires "expression.md"
requires "statement.md"
requires "ulm.k"

module SOLIDITY-CONFIGURATION
  imports SOLIDITY-DATA
  imports SOLIDITY-SYNTAX
  imports ULM

  syntax Id ::= "Id" [token]

  configuration
    <solidity>
      <k parser="TXN, SOLIDITY-DATA-SYNTAX"> $PGM:Program ~> $TXN:Transactions </k>
      <summarize parser="ISUNISWAP, BOOL-SYNTAX"> $ISUNISWAP:Bool </summarize>
      <compile>
        <current-body> Id </current-body>
        <ifaces>
          <iface multiplicity="*" type="Map">
            <iface-id> Id </iface-id>
            <iface-fns>
              <iface-fn multiplicity="*" type="Map">
                <iface-fn-id> Id </iface-fn-id>
                <iface-fn-arg-types> .List </iface-fn-arg-types>
                <iface-fn-return-types> .List </iface-fn-return-types>
              </iface-fn>
            </iface-fns>
          </iface>
        </ifaces>
        <contracts>
          <contract multiplicity="*" type="Map">
            <contract-id> Id </contract-id>
            <contract-state> .Map </contract-state>
            <contract-current-sv-address> 0:Int </contract-current-sv-address>
            <contract-statevar-addresses> .Map </contract-statevar-addresses>
            <contract-init> .List </contract-init>
            <contract-fns>
              <contract-fn multiplicity="*" type="Map">
                <contract-fn-id> Id </contract-fn-id>
                <contract-fn-visibility> public </contract-fn-visibility>
                <contract-fn-arg-types> .List </contract-fn-arg-types>
                <contract-fn-param-names> .List </contract-fn-param-names>
                <contract-fn-return-types> .List </contract-fn-return-types>
                <contract-fn-return-names> .List </contract-fn-return-names>
                <contract-fn-payable> false </contract-fn-payable>
                <contract-fn-body> .Statements </contract-fn-body>
              </contract-fn>
            </contract-fns>
            <contract-events>
              <contract-event multiplicity="*" type="Map">
                <contract-event-id> Id </contract-event-id>
                <contract-event-arg-types> .List </contract-event-arg-types>
                <contract-event-param-names> .List </contract-event-param-names>
                <contract-event-indexed-pos> .Set </contract-event-indexed-pos>
              </contract-event>
            </contract-events>
          </contract>
        </contracts>
      </compile>
      <exec>
        <msg-sender> 0p160 </msg-sender>
        <msg-value> 0p256 </msg-value>
        <tx-origin> 0p160 </tx-origin>
        <block-timestamp> 0p256 </block-timestamp>
        <this> 0p160 </this>
        <this-type> Id </this-type>
        <env> .Map </env>
        <store> .List </store>
        <current-function> Id </current-function>
        <call-stack> .List </call-stack>
        <live-contracts>
          <live-contract multiplicity="*" type="Map">
            <contract-address> 0p160 </contract-address>
            <contract-type> Id </contract-type>
          </live-contract>
        </live-contracts>
        <next-address> 2p160 </next-address>
        <status> EVMC_SUCCESS </status>
        <gas> $GAS:Int </gas>
      </exec>
    </solidity>

endmodule
```

```k
module SOLIDITY-ULM-SIGNATURE-IMPLEMENTATION
  imports SOLIDITY-CONFIGURATION
  imports INT
  imports BYTES
  imports ULM-SIGNATURE

  rule getStatus(<solidity>...
                   <exec>...
                     <status> STATUS:Int </status>
                   ...</exec>
                 ...</solidity>) => STATUS

  // getOutput gets the output from the top of the K cell (as expected after
  // completion of the return statement) and encodes it to Bytes.
  // We currently handle the encoding of return values of types uint256 and bool.
  rule getOutput(<solidity>...
                   <k> v(V:MInt{256}, uint256) ...</k>
                 ...</solidity>) => Int2Bytes(32, MInt2Unsigned(V), BE)
  rule getOutput(<solidity>...
                   <k> v(true, bool) ...</k>
                 ...</solidity>) => Int2Bytes(32, 1, BE)
  rule getOutput(<solidity>...
                   <k> v(false, bool) ...</k>
                 ...</solidity>) => Int2Bytes(32, 0, BE)

  // getGasLeft returns the amount of gas left by reading it from the cell <gas>.
  // The semantics currently initialize the gas by reading the appropriate ULM
  // configuration variable, but do not update it as the computations are performed.
  // I.e., this function is always going to return the exact amount of gas that was
  // provided to begin with.
  rule getGasLeft(<solidity>...
                    <exec>...
                      <gas> GASLEFT:Int </gas>
                    ...</exec>
                  ...</solidity>) => GASLEFT

endmodule
```

```k
module SOLIDITY-DATA-SYNTAX
  imports MINT-SYNTAX
  imports STRING-SYNTAX
  imports SOLIDITY-SYNTAX

  syntax MInt{8}
  syntax MInt{32}
  syntax MInt{112}
  syntax MInt{160}
  syntax MInt{256}

  syntax Transactions ::= List{Transaction, ","}
  syntax Transaction ::= txn(from: Decimal, to: Decimal, value: Decimal, timestamp: Decimal, func: Id, args: CallArgumentList) [function]
  syntax Transaction ::= create(from: Decimal, value: Decimal, timestamp: Decimal, ctor: Id, args: CallArgumentList)
endmodule

module SOLIDITY-DATA
  imports INT
  imports MINT
  imports BOOL
  imports STRING
  imports ID
  imports LIST
  imports SET
  imports MAP
  imports SOLIDITY-DATA-SYNTAX

  syntax KItem ::= "noId"
  syntax Id ::= "constructor" [token]

  syntax TypedVal ::= v(Value, TypeName) | lv(BaseRef, List, TypeName) | Int | String | "void"
  syntax TypedVals ::= List{TypedVal, ","} [overload(exps)]
  syntax Expression ::= TypedVal
  syntax CallArgumentList ::= TypedVals
  syntax KResult ::= TypedVal | TypedVals
  syntax Value ::= MInt{8} | MInt{32} | MInt{112} | MInt{160} | MInt{256} | Bool | String | List | Map
  syntax BaseRef ::= Id | Int

  syntax List ::= getTypes(ParameterList) [function]
  rule getTypes(.ParameterList) => .List
  rule getTypes(T:TypeName _:DataLocation _:Id, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName _:Id, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName _:DataLocation, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName, Pp:ParameterList) => ListItem(T) getTypes(Pp)

  syntax List ::= getNames(ParameterList) [function]
  rule getNames(.ParameterList) => .List
  rule getNames(_:TypeName _:DataLocation X:Id, Pp:ParameterList) => ListItem(X) getNames(Pp)
  rule getNames(_:TypeName X:Id, Pp:ParameterList) => ListItem(X) getNames(Pp)
  rule getNames(_, Pp:ParameterList) => ListItem(noId) getNames(Pp) [owise]

  syntax List ::= getTypes(EventParameters) [function]
  rule getTypes(.EventParameters) => .List
  rule getTypes(T:TypeName indexed _:Id, Ep:EventParameters) => ListItem(T) getTypes(Ep)
  rule getTypes(T:TypeName _:Id, Ep:EventParameters) => ListItem(T) getTypes(Ep)
  rule getTypes(T:TypeName indexed, Ep:EventParameters) => ListItem(T) getTypes(Ep)
  rule getTypes(T:TypeName, Ep:EventParameters) => ListItem(T) getTypes(Ep)

  syntax List ::= getNames(EventParameters) [function]
  rule getNames(.EventParameters) => .List
  rule getNames(_:TypeName indexed X:Id, Ep:EventParameters) => ListItem(X) getNames(Ep)
  rule getNames(_:TypeName X:Id, Ep:EventParameters) => ListItem(X) getNames(Ep)
  rule getNames(_, Ep:EventParameters) => ListItem(noId) getNames(Ep) [owise]

  syntax Set ::= getIndexed(EventParameters)      [function]
               | getIndexed(EventParameters, Int) [function]
  rule getIndexed(Ep:EventParameters) => getIndexed(Ep, 0)
  rule getIndexed(.EventParameters, _:Int) => .Set
  rule getIndexed(_:TypeName indexed _:Id, Ep:EventParameters, N:Int) => SetItem(N) getIndexed(Ep, N +Int 1)
  rule getIndexed(_:TypeName indexed, Ep:EventParameters, N:Int) => SetItem(N) getIndexed(Ep, N +Int 1)
  rule getIndexed(_, Ep:EventParameters, N:Int) => getIndexed(Ep, N +Int 1) [owise]

  syntax Bool ::= isAggregateType(TypeName) [function]
  rule isAggregateType(_[]) => true
  rule isAggregateType(mapping(_ _ => _ _)) => true
  rule isAggregateType(_) => false [owise]

  // external frame
  syntax Frame ::= frame(continuation: K, env: Map, store: List, from: MInt{160}, type: Id, value: MInt{256}, func: Id)
  // internal frame
                 | frame(continuation: K, env: Map, func: Id)
  syntax Event ::= event(name: Id, args: TypedVals)

endmodule
```

```k
module SOLIDITY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-INTERFACE
  imports SOLIDITY-CONTRACT
  imports SOLIDITY-TRANSACTION
  imports SOLIDITY-EXPRESSION
  imports SOLIDITY-STATEMENT

  rule <k> _:PragmaDefinition Ss:SourceUnits => Ss ...</k>
  rule S:SourceUnit Ss:SourceUnits => S ~> Ss
  rule .SourceUnits => .K
  rule C:ContractBodyElement Cc:ContractBodyElements => C ~> Cc
  rule .ContractBodyElements => .K
  rule T:Transaction, Tt:Transactions => T ~> Tt
  rule .Transactions => .K
  rule S:Statement Ss:Statements => S ~> Ss
  rule .Statements => .K
  rule isKResult(.TypedVals) => true
endmodule
```
