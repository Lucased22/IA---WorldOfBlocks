%declaracao dos blocos e lugares
block(a). block(b). block(c). block(d).
place(0). place(1). place(2). place(3). place(4). place(5).

%declaracao das dimensões alturaXtamanho dos blocos
alt(a,1). alt(b,1). alt(c,1). alt(d,1).
tam(a,1). tam(b,1). tam(c,2). tam(d,3).

plan(State, Goals, []):-
    satisfied(State, Goals).

plan(State, Goals, Plan):-
    append(PrePlan, [Action], Plan),
    select(State, Goals, Goal),
    achieves(Action, Goal),
    preserves(Action,Goals), 
    regress(Goals, Action, RegressedGoals),
    plan(State, RegressedGoals, PrePlan).

%definicao para bloco de tamanho 1
can(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),                                                      
    tam(Block, 1),                                                      
    alt(Block, BlockHeight),
    place(Xf),                                                         
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),                                       
    Y1 is Yf + BlockHeight,                                      
    place(Y1),                                                          
    addnew([on(Block, at(Xf, Yf)),clear(Xt, Yt)], [clear(Xf, Y1)], L).  

%definicao para bloco de tamanho 2
can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),                                                       
    tam(Block, 2),                                               
    alt(Block, BlockHeight),
    place(Xf),                
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is Xf + 1,
    X4 is Xt + 1,
    place(X3), place(X4),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, H, L1),                                 
    clearInterval(Xt, X4, Yt, L2),                                  
    append(L1, L2, L4),
    XEnd is Xt + 1,
    place(XEnd),
    addnew([clear(Xt, Yt), clear(XEnd, Yt)], L4, L).                    

%somente em blocos de comprimento impar podemos ter um bloco sustentando no meio
can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),        
    tam(Block, BlockLength),
    dif(BlockLength,1),
    dif(BlockLength,2),
    alt(Block, BlockHeight),
    place(Xf),                                                          
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is BlockLength + Xf - 1,
    X4 is BlockLength + Xt - 1,
    place(X3), place(X4),
    Par is mod(BlockLength,2),                                         
    dif(Par,0),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, Yf, L0),
    clearInterval(Xf, X3, H, L1),                                       
    clearInterval(Xt, X4, Yt, L2),                                      
    append(L1,L2,L3),
    Mid is BlockLength // 2,
    XMid is Xt + Mid,
    place(XMid),
    addnew([clear(XMid,Yt)], L3, L4),                                   
    delete_all(L4, L0, L).

can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),           
    tam(Block, BlockLength),
    dif(BlockLength,1),
    dif(BlockLength,2),
    alt(Block, BlockHeight),
    place(Xf),              
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is BlockLength + Xf - 1,
    X4 is BlockLength + Xt - 1,
    place(X3), place(X4),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, Yf, L0),
    clearInterval(Xf, X3, H, L1),                                       
    clearInterval(Xt, X4, Yt, L2),                                      
    append(L1,L2,L3),
    XEnd is Xt + BlockLength - 1,
    place(XEnd),
    addnew([clear(Xt, Yt) ,clear(XEnd, Yt)], L3, L4),                   
    delete_all(L4, L0, L).
    
%caso de blocos de tamanho 1
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, 1),
    alt(Block, BlockHeight),
    Y1 is Yt + BlockHeight,
    addnew([on(Block, at(Xt, Yt)), clear(Xt, Y1)], [clear(Xf, Yf)], L).

%caso de blocos de tamanho 2
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xt, Yt))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, 2),
    alt(Block, BlockHeight),
    X1 is Xt + 1,
    Y1 is Yt + BlockHeight,
    place(X1),
    place(Y1),
    clearInterval(Xt, X1, Y1, L1),                                 
    XMid is Xf + 1,
    place(XMid),
    addnew([clear(XMid,Yf), clear(Xf, Yf)], L1, L).

%caso geral
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xt, Yt))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, BlockLength),
    alt(Block, BlockHeight),
    X1 is Xt + BlockLength - 1,
    X2 is Xf + BlockLength - 1,
    Y1 is Yt + BlockHeight,
    Y2 is Yf + BlockHeight,
    place(X1), place(X2),
    place(Y1), place(Y2),
    clearInterval(Xf, X2, Y2, L5),
    clearInterval(Xt, X1, Y1, L1),                                     
    XEnd is Xf + BlockLength - 1,
    place(XEnd),
    clearInterval(Xf, XEnd, Yf, L2),
    clearInterval(Xt, X1, Yt, L3),
    append(L1, L2, L4),
    delete_all(L4, L3, L6),
    delete_all(L6, L5, L).

% caso bloco de tamanho 1
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, 1),
    alt(Block, BlockHeight),
    Y1 is Yf + BlockHeight,
    addnew([on(Block, at(Xf, Yf)), clear(Xf, Y1)], [clear(Xt, Yt)], L).

% caso bloco de tamanho 2
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xf, Yf))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, 2),
    alt(Block, BlockHeight),
    X1 is Xf + 1,
    Y1 is Yf + BlockHeight,
    place(X1),
    place(Y1),
    clearInterval(Xf, X1, Y1, L1),                                   
    XMid is Xt + 1,
    place(XMid),
    addnew([clear(XMid,Yt), clear(Xt, Yt)], L1, L).

%caso geral
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xf, Yf))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    tam(Block, BlockLength),
    alt(Block, BlockHeight),
    X1 is BlockLength + Xf - 1,
    Y1 is Yf + BlockHeight,
    place(X1),
    place(Y1),
    X2 is BlockLength + Xt - 1,
    Y2 is BlockHeight + Yt,
    place(X2),
    place(Y2),
    clearInterval(Xt, X2, Y2, L5),
    clearInterval(Xf, X1, Y1, L1),                                
    XEnd is Xt + BlockLength - 1,
    Y3 is Yt,
    place(XEnd),
    place(Y3),
    clearInterval(Xt, XEnd, Y3, L2),                                    
    clearInterval(Xf, X1, Yf, L3),
    append(L1,L2,L4),
    delete_all(L4, L3, L6),
    delete_all(L6, L5, L).

clearInterval(X1, X2, _, []) :- X1 > X2, !. % Intervalo vazio

clearInterval(X1, X2, Y, [clear(X1, Y) | L]) :-
    place(X1),
    Xn is X1 + 1,
    clearInterval(Xn, X2, Y, L).

%impossivel um bloco estar em 2 lugares ao mesmo tempo
impossible(on(Block,at(X1,Y1)),Goals):-
    member(on(Block2,at(X1,Y1)),Goals),
    dif(Block,Block2),
    !.

%impossivel um bloco estar em diferentes cordenadas ao mesmo tempo
impossible(on(Block,at(X1,Y1)),Goals):-
    member(on(Block,at(X2,Y2)),Goals),
    dif(at(X1,Y1),at(X2,Y2)),
    !.

%impossivel ter clear em goals se temos um bloco em goals naquela mesma posicao
impossible(clear(X1,Y1), Goals):-
    member(on(_, at(X1, Y1)), Goals),
    !.

satisfied(_, []). % caso base 

satisfied(State, [Goal|Goals]):-
    member(Goal, State), 
    satisfied(State, Goals). 


select(State, Goals, Goal):-   
    delete_all(Goals, State, GoalsNResolvidas), 
    member(Goal, GoalsNResolvidas). 

achieves(Action, Goal):-
    adds(Action, Goals),
    member(Goal, Goals).

preserves(Action , Goals):-
    deletes(Action, Relations),
    didBreak(Relations, Goals).

didBreak([H|_], Goals):-
    member(H, Goals),
    !,
    fail.

didBreak([_|T], Goals):-
    didBreak(T, Goals).

didBreak([], _).

regress(Goals, Action, RegressedGoals):-
    adds(Action, NewRelations),
    delete_all(Goals, NewRelations, RestGoals),
    deletes(Action,Condition),
    addnew(Condition, RestGoals, RegressedGoals).

addnew([], L, L).
addnew([Goal | _], Goals, _):-
    impossible(Goal, Goals),
    !,
    fail.

addnew([X|L1], L2, L3):-
    member(X,L2),
    !,
    addnew(L1, L2, L3).

addnew([X|L1], L2, [X|L3]):-
    addnew(L1,L2,L3).

delete_all([],_,[]).

delete_all([X|L1], L2, Diff):-
    member(X,L2),
    !,
    delete_all(L1, L2, Diff).

delete_all([X|L1], L2, [X|Diff]):-
    delete_all(L1, L2, Diff).


%Testar o plano (P) gerado do estado inicial até o estado final .

%caso 1
% ?- test1(X).
test1(P):-
    plan([on(a, at(0,1)), on(b,at(1,1)), on(c,at(0,0)), 
         on(d, at(2,0)), clear(0,2), clear(1,2), clear(5,0), 
         clear(3,1), clear(4,1), clear(2,1)], 
         [on(a, at(0,1)), on(b,at(1,1)), on(c,at(0,0)), 
         on(d, at(3,0)), clear(0,2), clear(1,2), clear(2,0), 
         clear(3,1), clear(4,1), clear(5,1)], P).

%caso 2
% ?- test2(X).

test2(P):-
    plan([on(a, at(0,1)), on(b,at(5,0)), on(c,at(0,0)), 
         on(d, at(2,0)), clear(0,2), clear(1,1), clear(5,1), 
         clear(3,1), clear(4,1), clear(2,1)], 
         [on(a, at(0,1)), on(b,at(1,1)), on(c,at(0,0)), 
         on(d, at(3,0)), clear(0,2), clear(1,2), clear(2,0), 
         clear(3,1), clear(4,1), clear(5,1)], P).

