# Contract definitions

```k
module SOLIDITY-CONTRACT
  imports SOLIDITY-CONFIGURATION

  rule <k> contract X:Id { Body } => Body ...</k>
       <current-body> _ => X </current-body>
       <contracts>
         .Bag => <contract> <contract-id> X </contract-id> ...</contract>
         ...
       </contracts>

  rule <k> function X ( Params ) V:VisibilitySpecifier { Body } => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> V </contract-fn-visibility>
                   <contract-fn-arg-types> getTypes(Params) </contract-fn-arg-types>
                   <contract-fn-param-names> getNames(Params) </contract-fn-param-names>
                   <contract-fn-body> Body </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> function X ( Params ) V:VisibilitySpecifier returns ( Rets ) { Body } => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> V </contract-fn-visibility>
                   <contract-fn-arg-types> getTypes(Params) </contract-fn-arg-types>
                   <contract-fn-param-names> getNames(Params) </contract-fn-param-names>
                   <contract-fn-return-types> getTypes(Rets) </contract-fn-return-types>
                   <contract-fn-body> Body </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> constructor ( Params ) { Body } => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> constructor </contract-fn-id>
                   <contract-fn-arg-types> getTypes(Params) </contract-fn-arg-types>
                   <contract-fn-param-names> getNames(Params) </contract-fn-param-names>
                   <contract-fn-body> Body </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> T:TypeName public X:Id ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> public </contract-fn-visibility>
                   <contract-fn-return-types> ListItem(T) </contract-fn-return-types>
                   <contract-fn-body> return X ; </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> T:TypeName private X:Id ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>

   rule <k> T:TypeName public X:Id = E ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-init>... .List => ListItem(X = E;) </contract-init>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> public </contract-fn-visibility>
                   <contract-fn-return-types> ListItem(T) </contract-fn-return-types>
                   <contract-fn-body> return X ; </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> T:TypeName private X:Id = E ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-init>... .List => ListItem(X = E;) </contract-init>
 
  rule <k> event X ( EventParams ) ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-events>
         .Bag => <contract-event>
                   <contract-event-id> X </contract-event-id>
                   <contract-event-arg-types> getTypes(EventParams) </contract-event-arg-types>
                   <contract-event-param-names> getNames(EventParams) </contract-event-param-names>
                   <contract-event-indexed-pos> getIndexed(EventParams) </contract-event-indexed-pos>
                   ...
                 </contract-event>
         ...
       </contract-events>

endmodule
```
