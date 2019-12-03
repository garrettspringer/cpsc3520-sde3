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
nextState([_|_], [], _, []).

/* nextState(+CurrentState, +WeightMatrix, +Alpha, -Next) */
nextState([A|B], [C|D], Alpha, [E|F]) :-
    netAll([A|B], [C|D], [G|_]),
    hop11Activation(G, Alpha, A, E),
    nextState([A|B], D, Alpha, F).

/* Returns network state after n time steps */

/* Subtract 1 from the value to subtract */
subtractN(ValueToSubtract, Result) :-
    Result is ValueToSubtract - 1. 

/* If N == 0, return the currentState */
updateN(CurrState, _, _, 0, CurrState). 

/* If N == 1, return nextState() */
updateN(CurrState, WeightMatrix, Alpha, 1, ResultState) :-
    nextState(CurrState, WeightMatrix, Alpha, ResultState).

/* updateN(+CurrentState,+WeightMatrix,+Alpha,+N,-ResultState) */
updateN(CurrState, WeightMatrix, Alpha, N, ResultState) :-
    nextState(CurrState, WeightMatrix, Alpha, ResultState),
    subtractN(N, UpdatedN),
    updateN(ResultState, WeightMatrix, Alpha, UpdatedN, ResultState).


    
