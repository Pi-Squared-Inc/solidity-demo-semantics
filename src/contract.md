# Contract definitions

```k
module SOLIDITY-CONTRACT
  imports SOLIDITY-CONFIGURATION
  imports SOLIDITY-UTILS-SYNTAX

  rule <k> contract X:Id { Body } => Body ...</k>
       <current-body> _ => X </current-body>
       <contracts>
         .Bag => <contract> <contract-id> X </contract-id> ...</contract>
         ...
       </contracts>

  rule <k> function X ( Params ) F:FunctionSpecifiers { Body } => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> getVisibility(F) </contract-fn-visibility>
                   <contract-fn-payable> getPayable(F) </contract-fn-payable>
                   <contract-fn-arg-types> getTypes(Params) </contract-fn-arg-types>
                   <contract-fn-param-names> getNames(Params) </contract-fn-param-names>
                   <contract-fn-body> Body </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> function X ( Params ) F:FunctionSpecifiers returns ( Rets ) { Body } => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> getVisibility(F) </contract-fn-visibility>
                   <contract-fn-payable> getPayable(F) </contract-fn-payable>
                   <contract-fn-arg-types> getTypes(Params) </contract-fn-arg-types>
                   <contract-fn-param-names> getNames(Params) </contract-fn-param-names>
                   <contract-fn-return-types> getTypes(Rets) </contract-fn-return-types>
                   <contract-fn-return-names> getNames(Rets) </contract-fn-return-names>
                   <contract-fn-body> Body </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  syntax VisibilitySpecifier ::= getVisibility(FunctionSpecifiers) [function]
  rule getVisibility(private _) => private
  rule getVisibility(public _) => public
  rule getVisibility(external _) => external
  rule getVisibility(internal _) => internal
  rule getVisibility(_ F) => getVisibility(F) [owise]

  syntax Bool ::= getPayable(FunctionSpecifiers) [function]
  rule getPayable(.FunctionSpecifiers) => false
  rule getPayable(payable _) => true
  rule getPayable(_ F) => getPayable(F) [owise]

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
       <contract-current-sv-address> A => A +Int addressRangeSize(T) </contract-current-sv-address>
       <contract-statevar-addresses> B => B [ X <- A ] </contract-statevar-addresses>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> public </contract-fn-visibility>
                   <contract-fn-arg-types> accessorTypes(T) </contract-fn-arg-types>
                   <contract-fn-param-names> accessorNames(T, 0) </contract-fn-param-names>
                   <contract-fn-return-types> ListItem(T) </contract-fn-return-types>
                   <contract-fn-return-names> ListItem(noId) </contract-fn-return-names>
                   <contract-fn-body> return accessor(X, T, 0) ; </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  syntax List ::= accessorTypes(TypeName) [function]
  rule accessorTypes(_:ElementaryTypeName) => .List
  rule accessorTypes(_:Id) => .List
  rule accessorTypes(mapping(T1 _ => T2 _)) => ListItem(T1) accessorTypes(T2)
  rule accessorTypes(T []) => ListItem(T)

  syntax List ::= accessorNames(TypeName, Int) [function]
  rule accessorNames(_:ElementaryTypeName, _) => .List
  rule accessorNames(_:Id, _) => .List
  rule accessorNames(mapping(_ X:Id => T2 _), I) => ListItem(X) accessorNames(T2, I)
  rule accessorNames(mapping(_ => T2 _), I) => ListItem(String2Id("$" +String Int2String(I))) accessorNames(T2, I +Int 1)
  rule accessorNames(T [], I) => ListItem(String2Id("$" +String Int2String(I))) accessorNames(T, I +Int 1)

  syntax Expression ::= accessor(Expression, TypeName, Int) [function]
  rule accessor(X, _:ElementaryTypeName, _) => X
  rule accessor(X, _:Id, _) => X
  rule accessor(X, mapping(_ Y:Id => T2 _), I) => accessor(X [ Y ], T2, I)
  rule accessor(X, mapping(_ => T2 _), I) => accessor(X [ String2Id("$" +String Int2String(I)) ], T2, I +Int 1)
  rule accessor(X, T [], I) => accessor(X [ String2Id("$" +String Int2String(I)) ], T, I +Int 1)

  rule <k> T:TypeName private X:Id ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-current-sv-address> A => A +Int addressRangeSize(T) </contract-current-sv-address>
       <contract-statevar-addresses> B => B [ X <- A ] </contract-statevar-addresses>

   rule <k> T:TypeName public X:Id = E ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-current-sv-address> A => A +Int addressRangeSize(T) </contract-current-sv-address>
       <contract-statevar-addresses> B => B [ X <- A ] </contract-statevar-addresses>
       <contract-init>... .List => ListItem(X = E;) </contract-init>
       <contract-fns>
         .Bag => <contract-fn>
                   <contract-fn-id> X </contract-fn-id>
                   <contract-fn-visibility> public </contract-fn-visibility>
                   <contract-fn-arg-types> accessorTypes(T) </contract-fn-arg-types>
                   <contract-fn-param-names> accessorNames(T, 0) </contract-fn-param-names>
                   <contract-fn-return-types> ListItem(T) </contract-fn-return-types>
                   <contract-fn-return-names> ListItem(noId) </contract-fn-return-names>
                   <contract-fn-body> return accessor(X, T, 0) ; </contract-fn-body>
                   ...
                 </contract-fn>
         ...
       </contract-fns>

  rule <k> T:TypeName private X:Id = E ; => .K ...</k>
       <current-body> C </current-body>
       <contract-id> C </contract-id>
       <contract-state> Env => Env [ X <- T ] </contract-state>
       <contract-current-sv-address> A => A +Int addressRangeSize(T) </contract-current-sv-address>
       <contract-statevar-addresses> B => B [ X <- A ] </contract-statevar-addresses>
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
