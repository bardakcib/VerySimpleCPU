0: CP 600 500  //first number is MAX
1: CP 200 600  //LOOP 
2: CPI 201 599
3: LT 200 201  //check if  MAX>array[i]
4: BZJ 401 200 //skip uptade if true
5: CPI 600 599 //uptade MAX if false
6: ADDi 599 1  //incretment array counter
7: CP 200 599
8: LTi 200 510 //check if arrayCounter<arraySize
9: BZJ 402 200 //exit if false
10: BZJi 400 1 //loop if true
11: CP 600 600 //print MAX number.
200: 0  //ACC1
201: 0  //ACC2
400: 0  //branch uncond
401: 6  //branch
402: 11 //exit
//ARRAY BEGIN
500: 5 
501: 6
502: 3
503: 2
504: 11
505: 1
506: 4
507: 9
508: 8
509: 7
//ARRAY END
599: 501 //array counter
600: 0   