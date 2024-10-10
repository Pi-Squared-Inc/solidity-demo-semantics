# Solidity statements

```k

module SOLIDITY-STATEMENT
  imports SOLIDITY-CONFIGURATION
  imports private SOLIDITY-EXPRESSION
  imports private STRING-BUFFER
  imports private K-IO

  // expression statement
  rule _:TypedVal ; => .K

  // return statement
  rule <k> return v(V, T) ; ~> _ => v(V, T) ~> K </k>
       <msg-sender> THIS => FROM </msg-sender>
       <msg-value> _ => VALUE </msg-value>
       <this> _ => THIS </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => E </env>
       <store> _ => S </store>
       <current-function> _ => FUNC </current-function>
       <call-stack>... ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) => .List </call-stack>

  rule <k> return void ; ~> _ => void ~> K </k>
       <msg-sender> THIS => FROM </msg-sender>
       <msg-value> _ => VALUE </msg-value>
       <this> _ => THIS </this>
       <this-type> _ => TYPE </this-type>
       <env> _ => E </env>
       <store> _ => S </store>
       <current-function> _ => FUNC </current-function>
       <call-stack>... ListItem(frame(K, E, S, FROM, TYPE, VALUE, FUNC)) => .List </call-stack>

  rule <k> return lv(I:Int, .List, T) ; => return v(L, T) ; ...</k>
       <store> _ [ I <- L ] </store>

  rule <k> return V:TypedVal ; ~> _ => V ~> K </k>
       <env> _ => E </env>
       <current-function> _ => FUNC </current-function>
       <call-stack>... ListItem(frame(K, E, FUNC)) => .List </call-stack> [owise]

  // variable declaration
  rule <k> LT:TypeName X:Id = v(V, RT) ; => .K ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(convert(V, RT, LT)) </store>
  rule <k> LT:TypeName X:Id = N:Int ; => .K ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(convert(N, LT)) </store>
  rule <k> LT:TypeName memory X:Id = v(V, RT) ; => .K ...</k>
       <env> E => E [ X <- var(size(S), LT) ] </env>
       <store> S => S ListItem(convert(V, RT, LT)) </store>
  rule <k> T:TypeName memory X:Id = lv(I:Int, .List, T) ; => .K ...</k>
       <env> E => E [ X <- var(I, T) ] </env>
  rule <k> T:TypeName X:Id ;::VariableDeclarationStatement => .K ...</k>
       <env> E => E [ X <- var(size(S), T) ] </env>
       <store> S => S ListItem(default(T)) </store>

  // emit statement
  rule <k> emit X:Id ( ARGS ) ; => discard(Event2String(ARGS, ((.StringBuffer +String Id2String(X)) +String "("))) ...</k>
    requires isKResult(ARGS)

  syntax String ::= Event2String(CallArgumentList, StringBuffer) [function]
  rule Event2String(.CallArgumentList, SB) => StringBuffer2String(SB +String ")")
  rule Event2String(v(V:MInt{112}, _), SB) => Event2String(.CallArgumentList, SB +String Int2String(MInt2Unsigned(V)))
  rule Event2String(v(V:MInt{160}, _), SB) => Event2String(.CallArgumentList, SB +String Int2String(MInt2Unsigned(V)))
  rule Event2String(v(V:MInt{256}, _), SB) => Event2String(.CallArgumentList, SB +String Int2String(MInt2Unsigned(V)))
  rule Event2String(v(V:MInt{112}, _), ARGS, SB) => Event2String(ARGS, (SB +String Int2String(MInt2Unsigned(V))) +String ", ") [owise]
  rule Event2String(v(V:MInt{160}, _), ARGS, SB) => Event2String(ARGS, (SB +String Int2String(MInt2Unsigned(V))) +String ", ") [owise]
  rule Event2String(v(V:MInt{256}, _), ARGS, SB) => Event2String(ARGS, (SB +String Int2String(MInt2Unsigned(V))) +String ", ") [owise]
  syntax K ::= discard(String) [function]
  rule discard(_) => .K

  // if statement
  rule if ( v(true, bool ) ) S => S
  rule if ( v(false, bool ) ) _ => .K
  rule if ( v(true, bool ) ) S else _ => S
  rule if ( v(false, bool ) ) _ else S => S

  // blocks
  rule <k> { S } => S ~> restoreEnv(E) ...</k>
       <env> E </env>

  syntax KItem ::= restoreEnv(Map)
  rule <k> restoreEnv( _:Map ) ~> .Statements ~> restoreEnv( E:Map ) => restoreEnv(E) ...</k>
  rule <k> restoreEnv(E) => .K ...</k>
       <env> _ => E </env> [owise]

  // while statement
  rule while (Cond) Body => if (Cond) {Body while(Cond) Body} else {.Statements}

  // Heating and cooling rules
  syntax KItem ::= freezerExpressionStatement()
  rule <k> HOLE:Expression ; => HOLE ~> freezerExpressionStatement() ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerExpressionStatement() => HOLE ; ...</k> [cool]

  syntax KItem ::= freezerVariableDeclarationStatementA(VariableDeclaration)
  rule <k> D:VariableDeclaration = HOLE:Expression ; => HOLE ~> freezerVariableDeclarationStatementA(D) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerVariableDeclarationStatementA(D) => D = HOLE ; ...</k> [cool]

  syntax KItem ::= freezerVariableDeclarationStatementB(VariableDeclaration)
  rule <k> ( D:VariableDeclaration , ) = HOLE:Expression ; => HOLE ~> freezerVariableDeclarationStatementB(D) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerVariableDeclarationStatementB(D) => ( D , ) = HOLE ; ...</k> [cool]

  syntax KItem ::= freezerIfStatement(Statement)
  rule <k> if ( HOLE:Expression ) S:Statement => HOLE ~> freezerIfStatement(S) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerIfStatement(S) => if ( HOLE ) S ...</k> [cool]

  syntax KItem ::= freezerIfElseStatement(Statement, Statement)
  rule <k> if ( HOLE:Expression ) S1:Statement else S2:Statement => HOLE ~> freezerIfElseStatement(S1, S2) ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerIfElseStatement(S1, S2) => if ( HOLE ) S1 else S2 ...</k> [cool]

  syntax KItem ::= freezerEmitStatement(Expression)
  rule <k> emit E:Expression ( HOLE:CallArgumentList ) ; => HOLE ~> freezerEmitStatement(E) ...</k> [heat]
  rule <k> HOLE ~> freezerEmitStatement(E) => emit E ( HOLE ) ; ...</k> [cool]

  syntax KItem ::= freezerReturnStatement()
  rule <k> return HOLE:Expression ; => HOLE ~> freezerReturnStatement() ...</k> [heat]
  rule <k> HOLE:Expression ~> freezerReturnStatement() => return HOLE ; ...</k> [cool]

endmodule
