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
    cell(Matrix,Row1,Col,Val),
    not(Row1 is Row),
    getColumn(Matrix,Row,Col,RowR1,_),
    getColumn(Matrix,Row1,Col,RowR2,_),
    RowR1 =:= RowR2,
    asserta(columnRepeatedValue(RowR1,Matrix,Col,Val)),
    cell(Matrix,Row,Col1,Val),
    not(Col1 is Col),
    getRow(Matrix,Row,Col,ColR1,_),
    getRow(Matrix,Row,Col1,ColR2,_),
    ColR1 =:= ColR2,
    asserta(rowRepeatedValue(ColR1,Matrix,Row,Val)),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,Val)).

placeNumber(Matrix,Row,Col,Val):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,OldVal),
    not(OldVal is -1),
    cell(Matrix,Row,Col1,Val),
    not(Col1 is Col),
    getRow(Matrix,Row,Col,ColR1,_),
    getRow(Matrix,Row,Col1,ColR2,_),
    ColR1 =:= ColR2,
    asserta(rowRepeatedValue(ColR1,Matrix,Row,Val)),
    replaceFact(cell(Matrix,Row,Col,_),cell(Matrix,Row,Col,Val)).

placeNumber(Matrix,Row,Col,Val):- 
    isValidCell(Row,Col),
    cell(Matrix,Row,Col,OldVal),
    not(OldVal is -1),
    /*retract(repeatedRow(Matrix,Row,Col,_,OldVal)),*/
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
    getRowsSumsAux(Matrix,Row,0,[],R),
    Res = R,!.

/*

*/
getRowsSumsAux(_,0,_,List,Res):- Res = List.

getRowsSumsAux(Matrix,Row,Column,List,Res):-
    getRowBlankCloser(Matrix,Row,Column,Col),
    row(Matrix,Row,Col,ColFin),
    getRowSum(Matrix,Row,Col,Sum),
    ColSig is ColFin+1,
    getRowsSumsAux(Matrix,Row,ColSig,[[Row,Col,Sum]|List],Res),!.



getRowsSumsAux(Matrix,Row,_,List,Res):-
    RowSig is Row-1,
    getRowsSumsAux(Matrix,RowSig,0,List,Res).

/*

*/
getColumnSum(Matrix,Row,Col,Res):-
    getColumnUsedNumbers(Matrix,Row,Col,List),
    sum_list(List,Sum),
    Res = Sum.

/*

*/
getColumnsSums(Matrix,Res):-
    dimensions(_,MaxCol),
    Col is MaxCol-1,
    getColumnsSumsAux(Matrix,0,Col,[],R),
    Res = R,!.

/*

*/
getColumnsSumsAux(_,_,0,List,Res):- Res = List.

getColumnsSumsAux(Matrix,Row,Column,List,Res):-
    getColumnBlankCloser(Matrix,Row,Column,Row1),
    column(Matrix,Row1,RowFin,Column),
    getColumnSum(Matrix,Row1,Column,Sum),
    RowSig is RowFin+1,
    getColumnsSumsAux(Matrix,RowSig,Column,[[Row1,Column,Sum]|List],Res),!.


getColumnsSumsAux(Matrix,_,Col,List,Res):-
    ColSig is Col-1,
    getColumnsSumsAux(Matrix,0,ColSig,List,Res).

/*

*/
isRepeatedRow(Matrix,Row,Val):-
        cell(Matrix,Row,Col1,Val),
        cell(Matrix,Row,Col2,Val),
        not(Col1 is Col2).

deleteNotRepeatedRowCells(Matrix,Row):- 
    current_predicate(rowRepeatedValue/4),
    rowRepeatedValue(Col,Matrix,Row,Val),
    not(isRepeatedRow(Matrix,Row,Val)),
    retract(rowRepeatedValue(Col,Matrix,Row,Val)).


/*

*/
getInvalidFullRowsCells(Matrix,Res):-
    dimensions(MaxRow,_),
    Row is MaxRow-1,
    getInvalidFullRowsCellsAux(Matrix,Row,[],R),
    Res = R.
    
getInvalidFullRowsCellsAux(_,0,List,Res):- sort(List,Sorted),Res = Sorted.
getInvalidFullRowsCellsAux(Matrix,Row,List,Res):-
    deleteNotRepeatedRowCells(Matrix,Row),
    getInvalidFullRowCells(Matrix,Row,R),
    RowSig is Row-1,
    getInvalidFullRowsCellsAux(Matrix,RowSig,[[Row,R]|List],Res).

getInvalidFullRowsCellsAux(Matrix,Row,List,Res):-
    getInvalidFullRowCells(Matrix,Row,R),
    RowSig is Row-1,
    getInvalidFullRowsCellsAux(Matrix,RowSig,[[Row,R]|List],Res).

/*

*/
getInvalidFullRowCells(Matrix,Row,Res):-
    findall(ID,row(Matrix,Row,ID,_),IDS),
    getInvalidFullRowCellsAux(Matrix,Row,IDS,[],R),
    sort(R,Sorted),
    Res = Sorted.

getInvalidFullRowCellsAux(_,_,[],List,Res):- Res = List.
getInvalidFullRowCellsAux(Matrix,Row,[IniID|IDS],List,Res):-
    getInvalidRowCells(Matrix,Row,IniID,R),
    sort(R,Sorted),
    getInvalidFullRowCellsAux(Matrix,Row,IDS,[Sorted|List],Res).

/*

*/

getInvalidRowCells(Matrix,Row,ID,Res):-
    current_predicate(rowRepeatedValue/4),
    findall(Val,rowRepeatedValue(ID,Matrix,Row,Val),Repeateds),
    sort(Repeateds,Values),
    getInvalidRowCellsAux(Matrix,Row,ID,Values,[],R),
    Res = R.

getInvalidRowCellsAux(_,_,_,[],Temp,Res):- Res = Temp.
getInvalidRowCellsAux(Matrix,Row,ID,[Val|List],Temp,Res):- 
    Val > 0,
    findall(Col,(cell(Matrix,Row,Col,Val),getRow(Matrix,Row,Col,ColID,_),ColID is ID),Columns),
    sort(Columns,Cols),
    getInvalidRowCellsAux(Matrix,Row,ID,List,[Cols|Temp],Res).

getInvalidRowCellsAux(Matrix,Row,ID,[Val|List],Temp,Res):- 
    Val =< 0,
    getInvalidRowCellsAux(Matrix,Row,ID,List,Temp,Res).

/*

*/
getInvalidRowsCells(Matrix,Res):-
    dimensions(MaxRow,_),
    Row is MaxRow-1,
    getInvalidRowsCells(Matrix,Row,[],R),
    Res = R.

getInvalidRowsCells(_,0,List,Res):- Res = List.
getInvalidRowsCells(Matrix,Row,List,Res):-
    getInvalidRowCells(Matrix,Row,Cols),
    RowSig is Row-1,
    getInvalidRowsCells(Matrix,RowSig,[Cols|List],Res).

/*
****************************************************************************************************************
*/

isRepeatedColumn(Matrix,Col,Val):-
        cell(Matrix,Row1,Col,Val),
        cell(Matrix,Row2,Col,Val),
        not(Row1 is Row2).

deleteNotRepeatedColumnCells(Matrix,Col):- 
    current_predicate(columnRepeatedValue/4),
    columnRepeatedValue(Row,Matrix,Col,Val),
    not(isRepeatedColumn(Matrix,Col,Val)),
    retractall(columnRepeatedValue(Row,Matrix,Col,Val)).

/**/
getInvalidFullColumnsCells(Matrix,Res):-
    dimensions(_,MaxCol),
    Col is MaxCol-1,
    getInvalidFullColumnsCellsAux(Matrix,Col,[],R),
    Res = R.
    
getInvalidFullColumnsCellsAux(_,0,List,Res):- sort(List,Sorted),Res = Sorted.
getInvalidFullColumnsCellsAux(Matrix,Col,List,Res):-
    deleteNotRepeatedColumnCells(Matrix,Col),
    getInvalidFullColumnCells(Matrix,Col,R),
    ColSig is Col-1,
    getInvalidFullColumnsCellsAux(Matrix,ColSig,[[Col,R]|List],Res).

getInvalidFullColumnsCellsAux(Matrix,Col,List,Res):-
    getInvalidFullColumnCells(Matrix,Col,R),
    ColSig is Col-1,
    getInvalidFullColumnsCellsAux(Matrix,ColSig,[[Col,R]|List],Res).
/*

*/
getInvalidFullColumnCells(Matrix,Col,Res):-
    findall(ID,column(Matrix,ID,_,Col),IDS),
    getInvalidFullColumnCellsAux(Matrix,Col,IDS,[],R),
    sort(R,Sorted),
    Res = Sorted.

getInvalidFullColumnCellsAux(_,_,[],List,Res):- Res = List.
getInvalidFullColumnCellsAux(Matrix,Col,[IniID|IDS],List,Res):-
    getInvalidColumnCells(Matrix,Col,IniID,R),
    sort(R,Sorted),
    getInvalidFullColumnCellsAux(Matrix,Col,IDS,[Sorted|List],Res).

/*

*/
getInvalidColumnCells(Matrix,Col,ID,Res):-
    current_predicate(columnRepeatedValue/4),
    findall(Val,columnRepeatedValue(ID,Matrix,Col,Val),Repeateds),
    sort(Repeateds,Values),
    getInvalidColumnCellsAux(Matrix,Col,ID,Values,[],R),
    Res = R.

getInvalidColumnCellsAux(_,_,_,[],Temp,Res):- Res = Temp.
getInvalidColumnCellsAux(Matrix,Col,ID,[Val|List],Temp,Res):- 
    Val > 0,
    findall(Row,(cell(Matrix,Row,Col,Val),getColumn(Matrix,Row,Col,RowID,_),RowID is ID),Columns),
    sort(Columns,Cols),
    getInvalidColumnCellsAux(Matrix,Col,ID,List,[Cols|Temp],Res).

getInvalidColumnCellsAux(Matrix,Col,ID,[Val|List],Temp,Res):- 
    Val =< 0,
    getInvalidColumnCellsAux(Matrix,Col,ID,List,Temp,Res).

/*

*/
getInvalidColumsCells(Matrix,Res):-
    dimensions(_,MaxCol),
    Col is MaxCol-1,
    getInvalidColumsCells(Matrix,Col,[],R),
    Res = R.

getInvalidColumsCells(_,0,List,Res):- Res = List.
getInvalidColumsCells(Matrix,Col,List,Res):-
    getInvalidColumnCells(Matrix,Col,Cols),
    ColSig is Col-1,
    getInvalidColumsCells(Matrix,ColSig,[Cols|List],Res).

validateSum(Matrix,Row,Col):-
    getRowSum(Matrix,Row,Col,SumRes),
    getRowSum(solution,Row,Col,SolRes),
    SolRes is SumRes.

validateRowSum(Matrix):-
    row(Matrix,Rw,Col,_),
    not(validateSum(Matrix,Rw,Col)).


won(Matrix):-
    not(validateRowSum(Matrix)).
    
resetMatrix(Matrix):-
    cell(Matrix,Row,Col,Val),
    not(Val is -1),
    placeNumber(Matrix,Row,Col,0),
    retractall(rowRepeatedValue(_,Matrix,_,_)),
    retractall(columnRepeatedValue(_,Matrix,_,_)),fail.

deleteGame():-
    retract(cell(_,_,_,_)),
    retractall(rowRepeatedValue(_,_,_,_)),
    retractall(columnRepeatedValue(_,_,_,_)),
    retractall(dimensions(_,_)),
    retractall(row(_,_,_,_)),
    retractall(column(_,_,_,_)).

suggestion(Res):-
    dimensions(MaxRow,MaxCol),
    random_between(1,MaxRow,Row),
    random_between(1,MaxCol,Col),
    cell(solution,Row,Col,Val),
    Val is -1,
    suggestion(Res).
    
suggestion(Res):-
    dimensions(MaxRow,MaxCol),
    random_between(1,MaxRow,Row),
    random_between(1,MaxCol,Col),
    cell(solution,Row,Col,Val),
    not(Val is -1),
    Res = [Row,Col,Val].


