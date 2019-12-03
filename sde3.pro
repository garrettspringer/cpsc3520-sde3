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



/* Returns weight matrix for only one stored state, used as a
warmup for the next function */

/* Add 1 to the value to Add */
addN(ValueToAdd, Result) :-
    Result is ValueToAdd + 1. 


/* Helper function 1 */

/* if AstateOrig == [], return [] */
multiplyScalarOriginal([], _, _, _, []).

/* If IndexToZeroOut == CurrentIndex, return 0.0 :: multiplyScalarOriginal */
multiplyScalarOriginal([_|AstateOrig_T], ValueToMultiply, IndexToZeroOut, CurrentIndex, [Output_H|Output_T]) :-
    IndexToZeroOut =:= CurrentIndex,
    Output_H is 0.0,
    addN(CurrentIndex, IncrementedCurrentIndex),
    multiplyScalarOriginal(AstateOrig_T, ValueToMultiply, IndexToZeroOut, IncrementedCurrentIndex, Output_T).    

multiplyScalarOriginal([AstateOrig_H|AstateOrig_T], ValueToMultiply, IndexToZeroOut, CurrentIndex, [Output_H|Output_T]) :-
    Output_H is AstateOrig_H * ValueToMultiply,
    addN(CurrentIndex, IncrementedCurrentIndex),
    multiplyScalarOriginal(AstateOrig_T, ValueToMultiply, IndexToZeroOut, IncrementedCurrentIndex, Output_T).

/* Helper function 2 */

/* If valueToMultiply == [], return an empty list */
multiplyScalarDuplicate(_, [], _, []). 

multiplyScalarDuplicate(AstateOrig, [ValueToMultiply_H|ValueToMultiply_T], IndexToZeroOut, [Output_H|Output_T]) :-
    multiplyScalarOriginal(AstateOrig, ValueToMultiply_H, IndexToZeroOut, 0, Output_H),
    addN(IndexToZeroOut, IncrementedIndexToZeroOut),
    multiplyScalarDuplicate(AstateOrig, ValueToMultiply_T, IncrementedIndexToZeroOut, Output_T).


/* hopTrainAstate(+Astate,-WforState) */
hopTrainAstate(Astate, WforState) :-
    multiplyScalarDuplicate(Astate, Astate, 0, WforState).




    
