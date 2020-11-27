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

    not(createColumns(solution,0)),
    
    not(createColumns(Matrix,0)),
    setRandomCells(Matrix,17),
    makeValidMatrix(Matrix),
    makeValidMatrix(solution),!.


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
    cell(Matrix,Row,Col,OldVal),
    not(OldVal is -1),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,Val)).

placeBlack(Matrix,Row,Col):- 
    isValidCell(Row,Col),
    current_predicate(row/4),
    getRow(Matrix,Row,Col,Col1,Col2),
    retract(row(Matrix,Row,Col1,Col2)),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,-1)).

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
    placeBlack(solution,X1,Y1),
    Count2 is Count-1,
    setRandomCells(Matrix,Count2).

/*

*/
getRowBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    ColSig is Col+1,
    getRowBlankCloser(Matrix,Row,ColSig,Res).

getRowBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    not(Val is -1),
    Res = Col,!.

getRowBlankCloser(_,_,Col,Res):- 
    dimensions(_,MaxCol),
    LimitCol is MaxCol-1,
    Col is LimitCol,
    Res = Col,!.

getRowBlankCloser(_,_,_,Res):- Res is -1.

/*

*/
getColumnBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    RowSig is Row+1,
    getColumnBlankCloser(Matrix,RowSig,Col,Res).

getColumnBlankCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    not(Val is -1),
    Res = Row,!.

getColumnBlankCloser(_,Row,_,Res):- 
    dimensions(MaxRow,_),
    LimitRow is MaxRow-1,
    Row is LimitRow,
    Res = Row,!.

getColumnBlankCloser(_,_,_,Res):- Res is -1.

/*

*/
getRowBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    dimensions(_,MaxCol),
    LimitCol is MaxCol-1,
    cell(Matrix,Row,Col,Val),
    Col < LimitCol,
    not(Val is -1),
    ColSig is Col+1,
    getRowBlackCloser(Matrix,Row,ColSig,Res).

getRowBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    Res = Col,!.

getRowBlackCloser(_,_,Col,Res):- 
    dimensions(_,MaxCol),
    LimitCol is MaxCol-1,
    Col is LimitCol,
    Res = MaxCol,!.

getRowBlackCloser(_,_,_,Res):- Res is -1.

/*

*/
getColumnBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    dimensions(MaxRow,_),
    LimitRow is MaxRow-1,
    cell(Matrix,Row,Col,Val),
    Row < LimitRow,
    not(Val is -1),
    RowSig is Row+1,
    getColumnBlackCloser(Matrix,RowSig,Col,Res).

getColumnBlackCloser(Matrix,Row,Col,Res):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,Val),
    Val is -1,
    Res = Row,!.

getColumnBlackCloser(_,Row,_,Res):- 
    dimensions(MaxRow,_),
    LimitRow is MaxRow-1,
    Row is LimitRow,
    Res = MaxRow,!.

getColumnBlackCloser(_,_,_,Res):- Res is -1.

/*

*/
makeValidMatrix(Matrix):-
    dimensions(MaxRow,MaxCol),
    makeValidMatrixAux(Matrix,MaxRow,MaxCol),
    makeValidMatrixAux(Matrix,MaxRow,MaxCol).

makeValidMatrixAux(Matrix,Row,Column):- 
    Row >= 0,
    Column >=  0,
    not(makeValidRows(Matrix,Row,0)),
    not(makeValidColumn(Matrix,0,Column)),
    Row1 is Row-1,
    Column1 is Column-1,
    makeValidMatrixAux(Matrix,Row1,Column1).
makeValidMatrixAux(_,0,0):-!.


/*

*/
makeValidRows(Matrix,Row,Ini):- 
    getRowBlankCloser(Matrix,Row,Ini,ColIni),
    getRowBlackCloser(Matrix,Row,ColIni,ColFin),
    Distance is ColFin - ColIni,
    Distance >= 2,
    asserta(row(Matrix,Row,ColIni,ColFin)),
    makeValidRows(Matrix,Row,ColFin).

makeValidRows(Matrix,Row,Ini):- 
    getRowBlankCloser(Matrix,Row,Ini,ColIni),
    getRowBlackCloser(Matrix,Row,ColIni,ColFin),
    Distance is ColFin - ColIni,
    Distance is 1,
    placeBlack(Matrix,Row,ColIni),
    makeValidRows(Matrix,Row,ColFin).

/*

*/
makeValidColumn(Matrix,Ini,Col):- 
    getColumnBlankCloser(Matrix,Ini,Col,RowIni),
    getColumnBlackCloser(Matrix,RowIni,Col,RowFin),
    Distance is RowFin - RowIni,
    Distance >= 2,
    asserta(column(Matrix,RowIni,RowFin,Col)),
    makeValidColumn(Matrix,RowFin,Col).

makeValidColumn(Matrix,Ini,Col):- 
    getColumnBlankCloser(Matrix,Ini,Col,RowIni),
    getColumnBlackCloser(Matrix,RowIni,Col,RowFin),
    Distance is RowFin - RowIni,
    Distance is 1,
    placeBlack(Matrix,RowIni,Col),
    makeValidColumn(Matrix,RowFin,Col).

/*

*/
getRow(Matrix,Row,Col,Res1,Res2):- 
    row(Matrix,Row,Col1,Col2),
    Col < Col2,
    Col >= Col1,
    Res1 = Col1,
    Res2 = Col2.

/*

*/
getColumn(Matrix,Row,Col,Res1,Res2):- 
    column(Matrix,Row1,Row2,Col),
    Row < Row2,
    Row >= Row1,
    Res1 = Row1,
    Res2 = Row2.

/*

*/
getRowUsedNumbers(Matrix,Row,Col,Res):-
    getRow(Matrix,Row,Col,Col1,Col2),
    getRowUsedNumbersAux(Matrix,Row,Col1,Col2,[],Res),!.

getRowUsedNumbersAux(_,_,Col2,Col2,List,List).
getRowUsedNumbersAux(Matrix,Row,Col1,Col2,List,Res):-
    isValidCell(Row,Col1),
    cell(Matrix,Row,Col1,Val),
    ColSig is Col1+1,
    getRowUsedNumbersAux(Matrix,Row,ColSig,Col2,[Val|List],Res),!.

/*

*/
getColumnUsedNumbers(Matrix,Row,Col,Res):-
    getColumn(Matrix,Row,Col,Row1,Row2),
    getColumnUsedNumbersAux(Matrix,Row1,Row2,Col,[],Res),!.

getColumnUsedNumbersAux(_,Row2,Row2,_,List,List).
getColumnUsedNumbersAux(Matrix,Row1,Row2,Col,List,Res):-
    isValidCell(Row1,Col),
    cell(Matrix,Row1,Col,Val),
    RowSig is Row1+1,
    getColumnUsedNumbersAux(Matrix,RowSig,Row2,Col,[Val|List],Res),!.

/*

*/
getRemainingNumbers(Matrix,Row,Col,Res):-
    AllNumbers = [1,2,3,4,5,6,7,8,9],
    getRowUsedNumbers(Matrix,Row,Col,Values),
    subtract(AllNumbers,Values,RemainingsRow),
    getColumnUsedNumbers(Matrix,Row,Col,V),
    subtract(RemainingsRow,V,Remainings),
    Res = Remainings,!.

/*

*/
fillRandomMatrix(Matrix):- 
    cell(Matrix,X,Y,0),
    getRemainingNumbers(Matrix,X,Y,Remainings),
    length(Remainings,L),
    random_between(0,L,Rnd),
    nth0(Rnd, Remainings, Val),
    placeNumber(Matrix,X,Y,Val),
    fillRandomMatrix(Matrix).


/*

*/
getRowSum(Matrix,Row,Col,Res):-
    getRowUsedNumbers(Matrix,Row,Col,List),
    sum_list(List,Sum),
    Res = Sum.

/*

*/
getRowsSums(Matrix,Res):-
    dimensions(MaxRow,_),
    Row is MaxRow-1,
    getRowsSumsAux(Matrix,Row,[],R),
    Res = R,!.


getRowsSumsAux(Matrix,Row,List,Res):-
    row(Matrix,Row,Col,_),
    getRowSum(Matrix,Row,Col,Sum),
    RowSig is Row-1,
    getRowsSumsAux(Matrix,RowSig,[[Col,Sum]|List],Res),!.
getRowsSumsAux(_,0,List,Res):- Res = List.

