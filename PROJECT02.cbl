      ******************************************************************
      * Author: Mingzi Xu
      * Date: NOV.13.2023
      * Purpose: project 02
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. project02.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-INPUT-FILE
           ASSIGN TO "..\STUFILE.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PROGRAM-INPUT-FILE
           ASSIGN TO "..\PROGRAM.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT RECORD-OUTPUT-FILE
           ASSIGN TO "..\STUDENT_REPORT.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
      ****************************
      *INPUT DATA OF STUDENT FILE*
      ****************************
       FD STUDENT-INPUT-FILE.
       01 STUDENT-INPUT.
           02 STUDENT-NUMBER        PIC 9(6).
           02 TUITION-OWED          PIC 9(4)V99.
           02 STUDENT-NAME          PIC X(40).
           02 PROGRAM-OF-STUDY      PIC X(6).

      ****************************
      * LOOPS X 5 COURSE AND AVE *
      ****************************
           02 COURSES               OCCURS 5 TIMES.
             03 COURSE-CODE         PIC X(7).
             03 COURSE-AVERAGE      PIC 9(3).

      ****************************
      *INPUT DATA OF PROHRAM FILE*
      ****************************
       FD PROGRAM-INPUT-FILE.
       01 PROGRAM-INPUT-TABLE.
           02 PROGRAM-CODE          PIC X(6).
           02 PROGRAM-NAME          PIC X(20).

      ****************************
      *       OUTPUT DATA        *
      ****************************
       FD RECORD-OUTPUT-FILE.
       01 OUTPUT-LINE                PIC X(86).

      *------------------ WORKING-STORAGE -----------------------

       WORKING-STORAGE SECTION.
       01 WS-FIELDS.
           05 SUB-1                  PIC 9(2).
           05 SUB-2                  PIC 9(2).
           05 EOF-PRG-FLG            PIC X VALUE 'N'.
           05 EOF-STU-FLG            PIC X VALUE 'N'.
           05 FOUND-FLAG             PIC XXX VALUE 'NO'.
           05 WS-AVERAGE             PIC 999V.
           05 WS-PROGRAM-NAME        PIC X(20).
           05 WS-PROGRAM-CODE        PIC X(6).
           05 WS-TUITION-OWD         PIC 9(6).99.

       01 COLUMN-HEADER.
           05 FILLER                 PIC X(4)  VALUE 'NAME'.
           05 FILLER                 PIC X(36) VALUE SPACES.
           05 FILLER                 PIC X(7)  VALUE 'AVERAGE'.
           05 FILLER                 PIC X(4) VALUE SPACES.
           05 FILLER                 PIC X(7)  VALUE 'PROGRAM'.
           05 FILLER                 PIC X(16) VALUE SPACES.
           05 FILLER                 PIC X(12) VALUE 'TUITION OWED'.

       01 STUDENT-RECORD-LINE.
           05 STUDENT-NAME-REPORT    PIC X(40).
           05 FILLER                 PIC X(4) VALUE SPACES.
           05 STUDENT-AVERAGE-REPORT PIC Z(3).
           05 FILLER                 PIC X(4) VALUE SPACES.
           05 PROGRAM-NAME-REPORT    PIC X(20).
           05 FILLER                 PIC X(6) VALUE SPACES.
           05 TUITION-OWED-REPORT    PIC $Z,ZZZ.99.

       01 WS-STUDENT-RECORD-TABLE.
         02 STUDENT-RECORD-LEVEL  OCCURS 20 TIMES.
           05 PROGRAM-RECORD-LEVEL  OCCURS 20 TIMES.
               10 PROGRAM-CODE-RECORD      PIC X(6).
               10 PROGRAM-NAME-RECORD      PIC X(20).

       01 STUDENT-COUNTER             PIC 9(5) VALUE 0.
       01 REPORT-COUNTER              PIC 9(5) VALUE 0.
       01 WS-COURSE-INDEX             PIC 9(3) VALUE 0.

      *--------------------- PROCEDURE DIVISION ---------------------

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM 100-INITIATE-FILE.
           MOVE 1 TO SUB-1.
           DISPLAY "-----ALL THE STUDENT INFO LOADED SUCCSSFULLY----"
           PERFORM 100-FINISH-REPORT.
      *********************
      *  DEFINED METHODS  *
      *********************
       100-INITIATE-FILE.
           OPEN INPUT STUDENT-INPUT-FILE.
           OPEN INPUT PROGRAM-INPUT-FILE.
           OPEN OUTPUT RECORD-OUTPUT-FILE.
           PERFORM READ-PRGRAM-FILE UNTIL EOF-PRG-FLG = 'Y'.
           PERFORM INITIATE-REPORT-HEADER.
           PERFORM READ-STUDENT-FILE UNTIL  EOF-STU-FLG = 'Y'.
      * read program file and load data to the table--work
           READ-PRGRAM-FILE.
             PERFORM LOAD-RTN
                 VARYING SUB-1 FROM 1 BY 1
                 UNTIL SUB-1 > 20
                   AFTER SUB-2 FROM 1 BY 1
                     UNTIL SUB-2 >20 OR EOF-PRG-FLG = 'Y'.
           LOAD-RTN.
             READ PROGRAM-INPUT-FILE
               AT END MOVE "Y" TO EOF-PRG-FLG
               NOT AT END
                 MOVE PROGRAM-INPUT-TABLE
                 TO PROGRAM-RECORD-LEVEL(SUB-1,SUB-2).

      * load required data to the table
           READ-STUDENT-FILE.
               READ STUDENT-INPUT-FILE
                    AT END MOVE 'Y' TO  EOF-STU-FLG
                    NOT AT END
                       PERFORM 200-CALCULATE-STUDENT-AVERAGE
                       PERFORM 200-WRITE-RECORD

               END-READ.
      * initialize the output report--work
           INITIATE-REPORT-HEADER.
               MOVE COLUMN-HEADER TO OUTPUT-LINE.
               DISPLAY OUTPUT-LINE.
               WRITE OUTPUT-LINE BEFORE ADVANCING 1 LINE.

      * Calculate the students average grade
       200-CALCULATE-STUDENT-AVERAGE.
           MOVE 0 TO WS-AVERAGE.
           PERFORM VARYING WS-COURSE-INDEX FROM 1 BY 1
           UNTIL WS-COURSE-INDEX > 5
               ADD COURSE-AVERAGE(WS-COURSE-INDEX) TO WS-AVERAGE
           END-PERFORM.
           DIVIDE 5 INTO WS-AVERAGE GIVING WS-AVERAGE ROUNDED.

      * load data to thereport
       200-WRITE-RECORD.
           MOVE STUDENT-NAME TO STUDENT-NAME-REPORT.
           MOVE WS-AVERAGE TO STUDENT-AVERAGE-REPORT.
           PERFORM 300-GET-PROGRAM-NAME.
           MOVE TUITION-OWED TO TUITION-OWED-REPORT.
           MOVE STUDENT-RECORD-LINE TO OUTPUT-LINE.
           DISPLAY OUTPUT-LINE.
               WRITE OUTPUT-LINE AFTER ADVANCING 1 LINE.

      * Extrapolate Program Name
       300-GET-PROGRAM-NAME.
           MOVE  'NO'  TO FOUND-FLAG.
           PERFORM SEARCH-RTN
                   VARYING SUB-1 FROM 1 BY 1
                       UNTIL FOUND-FLAG = 'YES' OR SUB-1 > 20
                       AFTER SUB-2 FROM 1 BY 1
                           UNTIL FOUND-FLAG = 'YES'
                           OR SUB-2 >20.
      * search for program code--work
       SEARCH-RTN.
           MOVE  'NO'  TO FOUND-FLAG.
           IF PROGRAM-OF-STUDY  =  PROGRAM-CODE-RECORD(SUB-1,SUB-2)
                   MOVE 'YES' TO FOUND-FLAG

               MOVE PROGRAM-NAME-RECORD(SUB-1,SUB-2)
                 TO PROGRAM-NAME-REPORT

           END-IF.
      *close all files--work
       100-FINISH-REPORT.
           CLOSE STUDENT-INPUT-FILE.
           CLOSE PROGRAM-INPUT-FILE.
           CLOSE RECORD-OUTPUT-FILE.
           STOP RUN.

       END PROGRAM project02.
