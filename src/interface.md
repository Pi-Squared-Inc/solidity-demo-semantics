# Interface definitions

```k
module SOLIDITY-INTERFACE
  imports SOLIDITY-CONFIGURATION

  rule <k> interface X:Id { Body } => Body ...</k>
       <current-body> _ => X </current-body>
       <ifaces>
         .Bag => <iface> <iface-id> X </iface-id> ...</iface>
         ...
       </ifaces>

  rule <k> function X ( Params ) external ; => .K ...</k>
       <current-body> I </current-body>
       <iface-id> I </iface-id>
       <iface-fns>
         .Bag => <iface-fn>
                   <iface-fn-id> X </iface-fn-id>
                   <iface-fn-arg-types> getTypes(Params) </iface-fn-arg-types>
                   ...
                 </iface-fn>
         ...
       </iface-fns>

   rule <k> function X ( Params ) external returns ( Rets ) ; => .K ...</k>
       <current-body> I </current-body>
       <iface-id> I </iface-id>
       <iface-fns>
         .Bag => <iface-fn>
                   <iface-fn-id> X </iface-fn-id>
                   <iface-fn-arg-types> getTypes(Params) </iface-fn-arg-types>
                   <iface-fn-return-types> getTypes(Rets) </iface-fn-return-types>
                   ...
                 </iface-fn>
         ...
       </iface-fns>
       
endmodule
```
