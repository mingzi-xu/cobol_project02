Program Requirements
     A program is required to read student records and course records from external files, produce a student report for each student using the data on each student record, and produce the audit trail for the process (records read and records written). 
  
     The specifics for the input student records (from the Student File – STUFILE.txt), the processes required for each record, and the output format for each student report card are described below. 
     The Program of Studies records (from the Program of Studies file -- PROGRAM.txt) contains the program code and the Program Name (e.g. Computer Programmer, Computer Technician etc.)
     For each record read in from the Student File, a Student Report Record is be printed as described below.    
     Once all records have been processed, counters should be printed to indicate the number of Student Records read and the number of Student Report records written. 
    
 Both files (STUFILE.txt and PROGRAM.txt) will be provided.


Input Record Structures
The structure for each student record is below. The file to be used to test your code will be provided with the file name STUFILE.txt for the student records, and PROGRAM.txt for the different Programs of Study. There are five courses for each student record. Each course record (1 through 5) contains the Course Code followed by the average for that course. 

Program of Studies file  (PROGRAM.txt) 
Record structure
           ( Note – there will be a maximum of 20 occurrences of records)
PROGRAM CODE     6 bytes alphanumeric   
PROGRAM NAME    20 bytes  alphanumeric
(Note – This file is to be loaded into a table for use in the program)

Student Record     (STUFILE.txt)
     STUDENT NUMBER        6   bytes numeric            
     TUITION OWED               6 bytes numeric (including 2 assumed decimals)
     STUDENT NAME             40 bytes alphanumeric.. 
     PROGRAM OF STUDY    6 bytes alphanumeric   
      COURSE CODE 1           7 bytes alphanumeric
     COURSE AVERAGE 1     3 bytes numeric
     COURSE CODE 2            7 bytes alphanumeric
     COURSE AVERAGE 2     3 bytes numeric
     COURSE CODE 3            7 bytes alphanumeric
     COURSE AVERAGE 3     3 bytes numeric
     COURSE CODE 4            7 bytes alphanumeric
     COURSE AVERAGE 4     3 bytes numeric
     COURSE CODE 5            7 bytes alphanumeric
     COURSE AVERAGE 5     3 bytes numeric


 
Output Record Structure (Student Report Record)     
     The output record will be a structured on a single line as described below. You must use the ORGANIZATION clause as LINE SEQUENTIAL in the SELECT ASSIGN statement.           

STUDENT NAME 
filler (3 spaces)
STUDENT AVERAGE (This field must be rounded to a whole integer)
filler  (4 spaces)
PROGRAM NAME ( retrieved from the table)
filler  4 spaces
TUITION OWED  (this field must be edited with inserted decimal point, commas as suppression of leading zeros)

Output Record Structure (Column Header)
     You must have a Column Header Record at the top of the report with the words NAME, AVERAGE, PROGRAM, TIUTION OWED in line with the beginning of each field.
Processing Notes 
The Student Average to be computed is the average mark from all 5 courses. Assume that all course averages contain valid values including zero.
The Tuition Owed value on output must be edited as noted above.
The Student Average is to be rounded to be an integer
The records from the Program of Studies file are to be loaded into a table for use in the Student Report Records. 
Assume a maximum of 20 occurrences required for the table. 
Hints
Open all three files during Initialization
Load the Table during Initialization
Use the PERFORM … VARYING code to load the table during initialization and to search the table in the main line process.
Increment the counters for student records read and student report records written within the module for the READ and the WRITE as appropriate.
