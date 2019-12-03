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
    netUnit(B, D, Cumulative).
    Net is A*C + Cumulative.
    
