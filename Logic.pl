use_module(library(random)).
/*
    Are the minimun dimensions for the matrix 
*/
/*minDim(Matrix,Rows,Columns):- Rows > 0, Columns > 0, asserta(minDimensions(Matrix,Rows,Columns)).*/
minDimensions(3,3).
/*
    Creates a row from the entered value to MaxCol
*/
createRow(Matrix,0,Column):- 
    dimensions(_,MaxCol),
    Column < MaxCol,
    asserta(cell(Matrix,0,Column,-1)),
    NewColumn is Column+1,
    createRow(Matrix,0,NewColumn).

createRow(Matrix,Rows,0):- 
    Rows > 0,
    asserta(cell(Matrix,Rows,0,-1)),
    createRow(Matrix,Rows,1).

createRow(Matrix,Rows,Column):- 
    dimensions(_,MaxCol),
    Rows > 0,
    Column > 0,
    Column < MaxCol,
    asserta(cell(Matrix,Rows,Column,0)),
    NewColumn is Column+1,
    createRow(Matrix,Rows,NewColumn).

/*
    Creates a column from the entered value to MaxRow
*/
createColumns(Matrix,Row):-
    dimensions(MaxRow,_),
    Row < MaxRow,
    not(createRow(Matrix,Row,0)),
    NewRow is Row+1,
    createColumns(Matrix,NewRow).

/*
    Get a matrix with the specified dimensions and name
*/
createMatrix(Matrix,Row,Col):-
    minDimensions(MinRow,MinCol),
    Row >= MinRow,
    Col >= MinCol,
    asserta(dimensions(Row,Col)),
    not(createColumns(Matrix,0)),
    setRandomCells(Matrix,12).


/*
    Get the values of the row of a matrix, the end to end
*/
getRow(Matrix,Number,Row):- 
    Number > -1,
    dimensions(_,Col),
    Number < Col,
    getRowAux(Matrix,Number,0,[],R),
    Row = R,!.

getRowAux(Matrix,Row,Col,List,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    NewCol is Col+1,
    getRowAux(Matrix,Row,NewCol,[Val|List],Res),!.

getRowAux(_,_,_,List,Res):- reverse(List,Rev),Res = Rev.

/*
    Get the matrix made of cells
*/
getMatrix(Matrix,Res):-
    dimensions(_,Col),
    N is Col-1,
    getMatrixAux(Matrix,N,[],M),
    Res = M,!.

getMatrixAux(_,Row,L,R):- Row < 0, R = L. 

getMatrixAux(Matrix,Row,L,Res):- 
    Row > -1,
    getRow(Matrix,Row,R),
    N is Row-1,
    getMatrixAux(Matrix,N,[R|L],Res).

/*
    Check if a cell has a correct position
*/
isValidCell(Row,Col):-
    dimensions(MaxRow,MaxCol),
    Row < MaxRow, Row >= 0,
    Col < MaxCol, Col >= 0.


/*
    Replaces the value in the specified position
*/
placeNumber(Matrix,Row,Col,Val):- 
    isValidCell(Row,Col),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,Val)).

placeBlack(Matrix,Row,Col):- 
    isValidCell(Row,Col),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,-1)).

/*
    Replaces any fact with the other
*/
replaceFact(Old,New):- 
    call(Old),retract(Old),asserta(New),!.
replaceFact(_,New):- asserta(New),!.

/*

*/
setRandomCells(_,0).
setRandomCells(Matrix,Count):- 
    dimensions(MaxX,MaxY),
    random_between(2,MaxX,X),
    random_between(2,MaxY,Y),
    X1 is X-1,
    Y1 is Y-1,
    placeBlack(Matrix,X1,Y1),
    Count2 is Count-1,
    setRandomCells(Matrix,Count2).

getBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    ColSig is Col+1,
    getBlankCloser(Matrix,Row,ColSig,Res).

getBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    not(Val is -1),
    placeNumber(Matrix,Row,Col,9),
    Res = Col,!.

getBlankCloser(_,_,_,Res):- Res is -1.


getBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    dimensions(MaxRow,MaxCol),
    LimitCol is MaxCol-1,
    cell(Matrix,Row,Col,Val),
    Col < LimitCol,
    not(Val is -1),
    ColSig is Col+1,
    getBlackCloser(Matrix,Row,ColSig,Res).

getBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    Res = Col,!.

getBlackCloser(Matrix,Row,Col,Res):- 
    dimensions(MaxRow,MaxCol),
    LimitCol is MaxCol-1,
    Col is LimitCol,
    Res = Col,!.

getBlackCloser(_,_,_,Res):- Res is -1.

