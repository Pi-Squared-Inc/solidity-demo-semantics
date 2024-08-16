# Main Configuration and Core Data Constructors

```k
requires "solidity-syntax.md"

module SOLIDITY-CONFIGURATION
  imports SOLIDITY-DATA
  imports SOLIDITY-SYNTAX

  configuration
    <solidity>
      <k> $PGM:Program ~> $TXN:Transactions </k>
    </solidity>

endmodule
```

```k
module SOLIDITY-DATA
  imports MINT
  imports BOOL
  imports STRING
  imports ID
  imports SOLIDITY-SYNTAX

  syntax MInt{160}
  syntax MInt{256}

  syntax TypedVal ::= v(Value, TypeName)
  syntax KResult ::= TypedVal
  syntax Value ::= MInt{160} | MInt{256} | Bool | String

  syntax Transactions ::= List{Transaction, ","}
  syntax Transaction ::= txn(from: MInt{160}, to: MInt{160}, value: MInt{256}, func: String, args: CallArgumentList) [strict(5)]
  syntax Transaction ::= create(from: MInt{160}, value: MInt{256}, ctor: String, args: CallArgumentList) [strict(4)]
endmodule
```

```k
module SOLIDITY
  imports SOLIDITY-CONFIGURATION
endmodule
```
