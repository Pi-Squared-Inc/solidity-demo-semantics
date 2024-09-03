# Solidity statements

```k

module SOLIDITY-STATEMENT
  imports SOLIDITY-CONFIGURATION
  imports private SOLIDITY-EXPRESSION

  // expression statement
  rule _:TypedVal ; => .K

  // return statement
  rule <k> return V:TypedVal ; ~> _ => V ~> K </k>
       <msg-sender> THIS => FROM </msg-sender>
       <msg-value> _ => VALUE </msg-value>
       <this> _ => THIS </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => E </env>
       <store> _ => S </store>
       <call-stack>... ListItem(frame(K, E, S, FROM, TYPE, VALUE)) => .List </call-stack>

  // variable declaration
  rule <k> LT:TypeName X:Id = v(V, RT) ; => .K ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- convert(V, RT, LT) ] </store>
  rule <k> LT:TypeName X:Id = N:Int ; => .K ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- convert(N, LT) ] </store>

  // emit statement
  rule <k> emit X:Id ( ARGS ) ; => .K ...</k>
       <events>... .List => ListItem(event(X, ARGS)) </events>
    requires isKResult(ARGS)

  // if statement
  rule if ( v(true, bool ) ) S => S
  rule if ( v(false, bool ) ) _ => .K
  rule if ( v(true, bool ) ) S else _ => S
  rule if ( v(false, bool ) ) _ else S => S

  // blocks
  rule <k> { S } => S ~> restoreEnv(E) ...</k>
       <env> E </env>

  syntax KItem ::= restoreEnv(Map)
  rule <k> restoreEnv(E) => .K ...</k>
       <env> _ => E </env>

  // while statement
  rule while (Cond) Body => if (Cond) {Body while(Cond) Body} else {.Statements}

endmodule
