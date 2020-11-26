/*
    Are the minimun dimensions for the matrix 
*/
minDimensions(3,3).

/*
    Create a row with the row value entered from Column to dimensions(_,Row)
*/
createRow(Rows,Column):- 
    dimensions(_,MaxCol),
    Column < MaxCol,
    asserta(cell(Rows,Column,0)),
    NewColumn is Column+1,
    createRow(Rows,NewColumn).


createColumns(Row):-
    dimensions(MaxRow,_),
    Row < MaxRow,
    not(createRow(Row,0)),
    NewRow is Row+1,
    createColumns(NewRow).

createMatrix(Row,Col):-
    minDimensions(MinRow,MinCol),
    Row >= MinRow,
    Col >= MinCol,
    asserta(dimensions(Row,Col)),
    createColumns(0).

getRow(Number,Row):- 
    Number > -1,
    dimensions(_,Col),
    Number < Col,
    getRowAux(Number,0,[],R),Row = R,!.

getRowAux(Row,Col,List,Res):- 
    isValidCell(Row,Col),
    cell(Row,Col,Val),
    NewCol is Col+1,
    getRowAux(Row,NewCol,[Val|List],Res),!.
getRowAux(_,_,List,Res):- reverse(List,Rev),Res = Rev.

getMatrix(Matrix):-
    dimensions(_,Col),
    N is Col-1,
    getMatrixAux(N,[],M),
    Matrix = M.

getMatrixAux(Row,L,R):- Row < 0, R = L. 

getMatrixAux(Row,L,Res):- 
    Row > -1,
    getRow(Row,R),
    N is Row-1,
    getMatrixAux(N,[R|L],Res).

showMatrix([]).
showMatrix([R|M]):- 
    write(R),nl,
    showMatrix(M).

isValidCell(Row,Col):-
    dimensions(MaxRow,MaxCol),
    Row < MaxRow, Row >= 0,
    Col < MaxCol, Col >= 0.

placeNumber(Row,Col,Val):- 
    isValidCell(Row,Col),
    replaceFact(cell(Row,Col,_),cell(Row,Col,Val)).

replaceFact(Old,New):- 
    call(Old),retract(Old),asserta(New),!.
replaceFact(_,New):- asserta(New),!.