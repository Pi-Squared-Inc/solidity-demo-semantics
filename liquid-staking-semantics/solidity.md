```k
requires "solidity-arithmetics.md"
requires "solidity-assignments.md"
requires "solidity-constants-lookups.md"
requires "solidity-declarations.md"
requires "solidity-expressions.md"
requires "solidity-function-calls.md"
requires "solidity-requires.md"
requires "solidity-specs.md"
requires "solidity-syntax.md"

requires "network.md"

// TODO: SIMPLE SINGLE FUNCTION CALL
// TODO: CONTRACT DECLARATION
// TODO: TEST CALL: BODY AFTER CONTRACTS
// TODO: NESTED FUNCTION CALL
// TODO: INTERFACE DECLARATION
// TODO: CASTING TO INTERFACE
// TODO: NETWORK INTERACTIONS

module SOLIDITY
     imports SOLIDITY-ARITHMETICS
     imports SOLIDITY-ASSIGNMENTS
     imports SOLIDITY-DECLARATIONS
     imports SOLIDITY-EXPRESSIONS
     imports SOLIDITY-FUNCTION-CALLS
     imports SOLIDITY-LOOKUPS
     imports SOLIDITY-REQUIRES
     imports SOLIDITY-SPECS
     imports SOLIDITY-SYNTAX
     imports NETWORK

     // ALL DECLARATIONS
     rule <k> S:StateVariableDeclaration C:ContractBodyElements => S ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> F:FunctionDefinition C:ContractBodyElements => F ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> CD:ConstructorDefinition C:ContractBodyElements => CD ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> B:Block C:ContractBodyElements => B ~> C ...</k>
          <status> EVMC_SUCCESS </status>

     // STATEMENT(S) EXECUTION
     rule <k> { P:Statements } => P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> S:Statement P:Statements => S ~> P ...</k>
          <status> EVMC_SUCCESS </status>

     rule <k> _P:Statements ~> .K => .K </k>
          <status> EVMC_REVERT </status>

     rule <k> .ContractBodyElements ~> .K => .K </k>          
     rule <k> .Statements => .K ...</k>
     
endmodule
```
