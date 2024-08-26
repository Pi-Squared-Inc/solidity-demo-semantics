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
       <this> _ => THIS </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => E </env>
       <store> _ => S </store>
       <call-stack>... ListItem(frame(K, E, S, FROM, TYPE)) => .List </call-stack>

  // variable declaration
  rule <k> LT:TypeName X:Id = v(V, RT) ; => .K ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- convert(V, RT, LT) ] </store>
  rule <k> LT:TypeName X:Id = N:NumberLiteral ; => .K ...</k>
       <env> E => E [ X <- var(!I:Int, LT) ] </env>
       <store> S => S [ !I <- convert(Number2Int(N), LT) ] </store>

  // emit statement
  rule <k> emit X:Id ( ARGS ) ; => .K ...</k>
       <events>... .List => ListItem(event(X, ARGS)) </events>
    requires isKResult(ARGS)

endmodule
