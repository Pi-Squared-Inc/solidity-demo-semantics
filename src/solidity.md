# Main Configuration and Core Data Constructors

```k
requires "solidity-syntax.md"
requires "interface.md"

module SOLIDITY-CONFIGURATION
  imports SOLIDITY-DATA
  imports SOLIDITY-SYNTAX

  syntax Id ::= "Id" [token]

  configuration
    <solidity>
      <k parser="TXN, SOLIDITY-DATA-SYNTAX"> $PGM:Program ~> $TXN:Transactions </k>
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
    </solidity>

endmodule
```

```k
module SOLIDITY-DATA-SYNTAX
  imports MINT-SYNTAX
  imports STRING-SYNTAX
  imports SOLIDITY-SYNTAX

  syntax MInt{160}
  syntax MInt{256}

  syntax Transactions ::= List{Transaction, ","}
  syntax Transaction ::= txn(from: Decimal, to: Decimal, value: Decimal, func: Id, args: CallArgumentList) [strict(5)]
  syntax Transaction ::= create(from: Decimal, value: Decimal, ctor: Id, args: CallArgumentList) [strict(4)]
endmodule

module SOLIDITY-DATA
  imports MINT
  imports BOOL
  imports STRING
  imports ID
  imports LIST
  imports SOLIDITY-DATA-SYNTAX

  syntax TypedVal ::= v(Value, TypeName)
  syntax TypedVals ::= List{TypedVal, ","} [overload(exps), hybrid, strict]
  syntax Expression ::= TypedVal
  syntax CallArgumentList ::= TypedVals
  syntax KResult ::= TypedVal
  syntax Value ::= MInt{160} | MInt{256} | Bool | String

  syntax List ::= getTypes(ParameterList) [function]
  rule getTypes(.ParameterList) => .List
  rule getTypes(T:TypeName _:DataLocation _:Id, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName _:Id, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName _:DataLocation, Pp:ParameterList) => ListItem(T) getTypes(Pp)
  rule getTypes(T:TypeName, Pp:ParameterList) => ListItem(T) getTypes(Pp)

endmodule
```

```k
module SOLIDITY
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-INTERFACE

  rule _:PragmaDefinition Ss:SourceUnits => Ss
  rule S:SourceUnit Ss:SourceUnits => S ~> Ss
  rule .SourceUnits => .K
  rule C:ContractBodyElement Cc:ContractBodyElements => C ~> Cc
  rule .ContractBodyElements => .K
endmodule
```
