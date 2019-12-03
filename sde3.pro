/* Returns 'squashed' unit output. Implements Hopfield activation 
function corresponding to Eqn (3) for single (-1,1) unit */

/* if net activation is negative, return -1 */
hop11ActHelper(Net, Alpha, _, 1.0) :-
    Net > Alpha, !.

/* if net activation is positive, return 1 */
hop11ActHelper(Net, Alpha, _, -1.0) :-
    Net < Alpha, !.

/* if net activation is zero, return original value */
hop11ActHelper(Net, Alpha, Oldo, Oldo) :-
    Net =:= Alpha, !.

/* hop11Activation(+Net, +Alpha, +Oldo, -Output) */
hop11Activation(Net, Alpha, Oldo, Output) :-
    hop11ActHelper(Net, Alpha, Oldo, Output).

/* Returns net activation for a single unit using our
list-based input and weight representation and Eqn (1) */

/* If the inputs or weights is empty, return a 0 */
netUnit([], [], 0).

/* netUnit(+Inputs, +Weights, -Net) */
netUnit([A|B], [C|D], Net) :-
    netUnit(B, D, Cumulative),
    Net is A*C + Cumulative.

/* Returns net activation computation for entire network
as a vector of individual unit activations */

/* If weight matrix is empty, return an empty list */
netAll(_, [], []).

/* netAll(+State, +Weights, -NetEntire) */
netAll(State, [A|B], [C|D]) :-
    netUnit(State, A, C),
    netAll(State, B, D).

/* Returns next state vector */

/* If the weight matrix is empty, return an empty list */
nextState([State_H|State_T], [Weight_H|[]], Alpha, Output) :-
    write("Base Case"),
    netAll([State_H|State_T], [Weight_H], [Netall_H|_]),
    hop11Activation(Netall_H, Alpha, State_H, Activation_Output),
    Output = [Activation_Output].

/* nextState(+CurrentState, +WeightMatrix, +Alpha, -Next) */
nextState([State_H|State_T], [Weight_H|Weight_T], Alpha, Output) :-
    write("Good!"),
    netAll([State_H|State_T], [Weight_H|Weight_T], [Netall_H|_]),
    hop11Activation(Netall_H, Alpha, State_H, Activation_Output),
    nextState([State_H|State_T], Weight_T, Alpha, Next_State_Output),
    append([Activation_Output], Next_State_Output, Output).

/* Returns weight matrix for only one stored state, used
as a warmup for the next function */

/* hopTrainAState(+Astate, -WforState) */
    
