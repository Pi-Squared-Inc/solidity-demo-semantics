## Configuration of ULM-Version of Solidity Lite Semantics

We first explain the main cells of the configuration of the solidity semantics.
```
  configuration
```
The contents of the k cell are explained in more detail later, in the section
about handling creation and call.
```
      // The program and the transaction to be executed.
      <k> decodeProgram($PGM:Bytes) ~> execute($CREATE:Bool, #if $CREATE:Bool #then $PGM:Bytes #else CallData() #fi) </k>
      // The compile cell contains information about the solidity program, e.g.
      // its contracts and interfaces. It is populated as rules match and
      // execute decodeProgram($PGM:Bytes)
      <compile>
        // Contains the type of the contract whose body we are currently in.
        <current-body> Id </current-body>
        // Cell containing a subcell per interface in the program.
        <ifaces>
          // Maintain information related to an interface
          <iface multiplicity="*" type="Map">
            <iface-id> Id </iface-id> // Interface type
            <iface-fns> // Interface functions
              // A cell per interface function
              <iface-fn multiplicity="*" type="Map">
                <iface-fn-id> Id </iface-fn-id> // Interface function name
                // Interface function argument types
                <iface-fn-arg-types> .List </iface-fn-arg-types>
                // Interface function return types
                <iface-fn-return-types> .List </iface-fn-return-types>
              </iface-fn>
            </iface-fns>
          </iface>
        </ifaces>
        // Cell containing a subcell per contract in the program.
        <contracts>
          // Maintain information related to a contract
          <contract multiplicity="*" type="Map">
            // Contract type
            <contract-id> Id </contract-id>
            // Map from contract state variable names to their types
            <contract-state> .Map </contract-state>
```
The usage of the cells `<contract-current-sv-address>` and `<contract-statevar-addresses>`
is explained in more detail below, in the section about changing the storage according
to the ULM interface.
```
            // Contains the next available Int that will correspond to a state variable
            <contract-current-sv-address> 0:Int </contract-current-sv-address>
            // Map from contract state variables to their corresponding unique Int.
            <contract-statevar-addresses> .Map </contract-statevar-addresses>
            // Code initializing the contract state variables.
            <contract-init> .List </contract-init>
            // Map from computed function selectors to their corresponding contract functions.
            <function-selector> .Map </function-selector>
            <contract-fns> // Contract functions
              // A cell per contract function
              <contract-fn multiplicity="*" type="Map">
               // Contract function name
                <contract-fn-id> Id </contract-fn-id>
                <contract-fn-visibility> public </contract-fn-visibility>
                <contract-fn-arg-types> .List </contract-fn-arg-types>
                <contract-fn-param-names> .List </contract-fn-param-names>
                <contract-fn-return-types> .List </contract-fn-return-types>
                <contract-fn-return-names> .List </contract-fn-return-names>
                <contract-fn-payable> false </contract-fn-payable>
                // Statements corresponding to the function's body.
                <contract-fn-body> .Statements </contract-fn-body>
              </contract-fn>
            </contract-fns>
            <contract-events> // Events defined within the contract
              // A cell per event
              <contract-event multiplicity="*" type="Map">
                // Event name
                <contract-event-id> Id </contract-event-id>
                <contract-event-arg-types> .List </contract-event-arg-types>
                <contract-event-param-names> .List </contract-event-param-names>
                // A set containing Ints corresponding to the positions, in the
                // argument list of the event, of indexed parameters.
                <contract-event-indexed-pos> .Set </contract-event-indexed-pos>
              </contract-event>
            </contract-events>
          </contract>
        </contracts>
      </compile>
      // The exec cell maintains information about the transaction being executed.
      <exec>
        // Sender, value, origin, timestamp. Inititialized using the ULM interface.
        <msg-sender> Int2MInt(Caller())::MInt{160} </msg-sender>
        <msg-value> Int2MInt(CallValue())::MInt{256} </msg-value>
        <tx-origin> Int2MInt(Origin())::MInt{160} </tx-origin>
        <block-timestamp> Int2MInt(BlockTimestamp())::MInt{256} </block-timestamp>
        // Address of this (active contract)
        <this> Int2MInt($ACCTCODE:Int)::MInt{160} </this>
        // Type of this (active contract)
        <this-type> Id </this-type>
        // Enviroment: a map from Identifiers for variables to Ints, representing locations in the store
        <env> .Map </env>
        // Store: a list, that in each position holds an Int representing a Value
        <store> .List </store>
        // Name of function that is currently being executed
        <current-function> Id </current-function>
        <call-stack> .List </call-stack> // Stack of call frames
        <status> EVMC_SUCCESS </status> // Status code to be returned
        <gas> $GAS:Int </gas> // Available gass
      </exec>
```

## ULM Integration for Solidity Lite Semantics

The next sections describe the main steps taken to integrate the ULM
functionality with the solidity semantics.

### Removing all summarization
This is specific to the solidity semantics alone. Before starting the ULM
integration we had applied manual CSE for the contract UniswapV2SwapRenamed.sol,
a process that resulted in additional rules (in src/uniswap-summaries.md). As
part of the ULM integration, we removed all changes related to summarization,
which included:
- importing the module that included the summarized rules, `imports SOLIDITY-UNISWAP-SUMMARIES`,
  from the module SOLIDITY in src/solidity.md.
- removing the `requires "uniswap-summaries.md"` from src/solidity.md.
- removed the cell `<summarize>`, and all its uses.

### Change contract storage to correspond to the ULM interface. Implement assignment and access of state variables accordingly.
The ULM interfaces to access and edit a contract's storage are
```
syntax Int ::= GetAccountStorage(key: Int)
syntax K ::= SetAccountStorage(key: Int, value: Int)
```
. They provide an Int as a key to the storage, as per the EVM memory model, and
store an Int value. In contrast, the Solidity semantics were implemented
- with Identifiers as keys to each contract's storage.
- Sort Value as values. Aggregate types, e.g. arrays and mappings, were stored
  as K Lists and K Maps respectively, still with a single key.
Therefore, in order to be able to make use of the ULM interface, we needed to
reimplement the layout of mappings (arrays are TODO, as they were not needed for
the demo) as well as access and assignement to state variables in a way that
stored values are of sort Int and each stored value would correspond to a unique
integer address. To that end, we implemented a hash-based schema, where we
assign a unique integer `I` to each state variable `V`. If `V` is scalar, then
`I` is its address. If `V` is a mapping, then `V[i]` is accessed by appending
`i` to `I` and obtaining the keccack hash. For a multidimensional mapping, the
process of appending the next index and hashing is repeated.
The cell `<contract-current-sv-address>` is used to track which unique number
should be assigned to a state variable. The cell `contract-statevar-addresses`
maps the variable Identifiers to their assigned addresses.

### Removing all the maintained/emulated "blockchain" and use ULM interface instead
The solidity lite semantics were initially designed to "emulate", or locally
maintain, the blockchain state needed to execute the requested transactions. The
live contracts were maintained in a cell (`<live-contracts>`) that, for each
contract contained a cell `<live-contract>` with its address (`<contract-address>`),
its type (`<contract-type>`), and its storage (`<contract-storage>`). These
cells were used by the rules for assignment and lookup, in order to find the
appropriate contract's storage, and either update it or return a value.
As part of the ULM integration, we removed this locally maintained state from
the configuration, because we would now be accessing it instead through the ULM
interface.
We edited the rule for assignment to state variables to no longer match the
removed cells, using the `SetAccountStorage(key: Int, value: Int)` instead. The
key to the store DB is the unique address for each state variable/mapping
element, the computation of which is described in the previous section. The
value is the value to be assigned (which is the same as in the assignment rule
prior to the ULM integration modifications) converted to Int. There are
different rules to match and convert to Int from differend types. Currrently, we
handle assignment to state variables that are of type uint8, unit32, uint112,
uint256/uint, address (uint160), bool, contract, and mapping with uint256 or
address value types.
We similarly edit the rule for state variable lookup to also not match the
removed cells and instead use `GetAccountStorage(key: Int)`with the same key.
The Int obtained by `GetAccountStorage` is converted to a Value of the
appropriate type. Currently, we support lookup of state variables of type uint8,
unit32, uint112, uint256/uint, address (uint160), bool, contract, and mapping
with uint256 or address value types.

NOTE: There are additional rules in the semantics that need to be updated by
removing the usage of the `<live-contracts>` cell and instead use ULM interfaces
(e.g., rules for new, external call). They have been commented out and are
TODO, since they were not needed for the demo.

### Compute and store function selectors for public/external functions.
In order to be able to call a function `F` with function selector `S`, provided
as part of the calldata, the solidity semantics needs to precompute the function
selectors for all public/external functions of the contracts in `$PGM`. This
includes the contract functions with public/external visibility, and the
automatically generated getter functions for public state variables. The
function selectors are stored per contract in the subcell `<function-selector>`,
which contains a Map with function selectors as keys and Identifiers
(corresponding to function names) as values.
For a function `F`, we construct its function selector according to the solidity
ABI, as follows:
- We first create the function signature `Sig`, by combining the function name
  `F`, `"("`, the canonical name of the formal parameter types followed by `","`
  unless it is the last, and `")"`. We properly handle geneating the correct
  canonical type name for uint256/uint, uint112, uint32, uint8, address and
  bool, needed for the demo.
- We compute the keccak hash of `Sig`.
- We get the first four bytes.


### Implement getGasLeft
We added a cell `<gas>`, and initialize it with the gas sent with the
transaction. We then implement the function `getGasLeft` of ULM, making it match
and return the contents of the `<gas>` cell.
Note that the Solidity semantics does not do gas computation. Therefore, at the
moment the returned gas is always equal to the gas that was sent.

### Implement getStatus
We added a cell `<status>`, and initialize it with the status code for
successfull execution, `EVMC_SUCCESS`. We also edit the rules for a failed
`require` and `assert` to include rewriting the contents of the `<status>` cell
to `EVMC_REVERT` and `EVMC_FAILURE` respectively. Finally, we implement the
function `getStatus` of ULM, making it match and return the contents of the
`<status>` cell.

### Implement getOutput
We implement the function `getOutput` of ULM, making it match and return the top
of the `<k>` cell, encoded as required by the Solidity ABI. We handle return
types of Bytes, uint8, uint256, bool, and string (limited to returning a single
string of length < 32).

### Handle creation ($CREATE=true) and call ($SREATE=false)

The k cell comprises (1) the contract(s) and (2) the requested transaction.
1. The contracts are contained in the conriguration variable `$PGM` as Bytes.
   `$PGM` is decoded using `decodeProgram`, which simply hooks into
   `ULM.decode` and returns Sort Program. The rewrite rules executing the
   provided Program result in updating the contents of the `<compile>` cell as
   needed to represent the provided contract(s). We require that, while `$PGM`
   may contain one or more contracts, the active contract must be the last on
   the list. This ensures that the cell `<current-body>` ends up containing the
   type of the active contract.
2. The requested transaction is either a contract creation or a function call,
   as dictated by the value of the cponfiguration variable `$CREATE`. If
   `$CREATE==true`, this is a contract creation and the contract bytes is
   provided to the `execute` function. If `$CREATE==false`, this is a call and
   the calldata is provided to `execute` instead.

#### execute function
- case `true`
  This is a contract creation, thus `execute(true, B)` must be rewritten to
  initializing the contract and return the resulting Bytes. The contracts for
  the demo do not have constructors, therefore we did not need to add a call to
  the constructor. We only need to match and execute `INIT`, which is the code
  initializing the contract's state variables, and return the contract bytes.
- case `false`
  This is a call to one of the functions of the active contract.
  `execute(false, B)` identifies the called function `F` of the active contract
  using the function selector (first four bytes of `B`). It decodes the provided
  arguments (remaining `B`) using the types of the parameters of `F`. We
  currently support decoding for the types uint256/uint, uint112, uint32, uint8
  and bool.

### Event logging

We handle event encoding (as needed for the demo), restricting ourselves to the
following cases:
- no unnamed events. In this case, topic 0 is the keccak hash of the event
  signature, computed the same way as the function signature above.
- event argument types of only uint256 and uint160 (address).

We use the cell `<contract-event-indexed-pos>` that contains the indexed
parameters. If a parameter is indexed, we create an Int for its value and it
will become a topic. Otherwise we append its value to the end of an initially
empty byte string with all other non indexed parameters. Depending on the number
of topics, we call the appropriate ULM interface `Log1`, `Log2`, `Log3`, or
`Log4`.
