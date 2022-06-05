       IDENTIFICATION DIVISION. 
       PROGRAM-ID. BatchFile.
       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
           SELECT BalancesFile ASSIGN TO FilePath
              ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION. 
       FILE SECTION.
       FD  BalancesFile.
       01 FB_Record   PIC X(90).
           88 EOFBalances VALUE HIGH-VALUES.
       WORKING-STORAGE SECTION. 
       
       EXEC SQL BEGIN DECLARE SECTION END-EXEC. 
       01  PARAM.
           05  DBNAME         PIC X(32) VALUE SPACE.
           05  FilePath       PIC X(48) VALUE SPACE.
       01  USERNAME       PIC X(30) VALUE SPACE.
       01  PASSWD         PIC X(10) VALUE SPACE.
       01  LENEX          PIC 9(10) VALUE ZEROS.
       01  BalanceRecord.
           05 FILLER      PIC X.
           05 R_DNI       PIC X(8).
           05 FILLER      PIC X.
           05 R_NAME      PIC X(48).
           05 FILLER      PIC X.
           05 R_DATE      PIC X(10).
           05 FILLER      PIC X.
           05 R_AMOUNT    PIC X(14) VALUES ZEROS.
           05 FILLER      PIC X.
       01  AMOUNT         PIC S9(10)V9(2).
       EXEC SQL END DECLARE SECTION END-EXEC. 
       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       MAIN-RTN.
           MOVE "/usr/src/app/files/template.data" TO FilePath.
           ACCEPT PARAM FROM COMMAND-LINE

           DISPLAY ""
           DISPLAY PARAM
           DISPLAY DBNAME
           DISPLAY FilePath
           MOVE "postgres" TO USERNAME.
           MOVE "postgres" TO PASSWD.
           
           EXEC SQL
              CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME 
           END-EXEC.

           IF SQLCODE NOT = ZERO 
              PERFORM ERROR-RTN STOP RUN
           ELSE 
              DISPLAY "CONNECTION SUCCESSFUL"
           END-IF.
           
           OPEN INPUT BalancesFile

           READ BalancesFile INTO BalanceRecord 
              AT END SET EOFBalances TO TRUE
           END-READ

           PERFORM UNTIL EOFBalances 
              DISPLAY "INSERT: " WITH NO ADVANCING  
              DISPLAY BalanceRecord 
              
              EXEC SQL
                 SELECT COUNT(*) INTO :LENEX
                 FROM app_clients
                 WHERE dni=:R_DNI
              END-EXEC
              
              
              
              IF LENEX = ZERO THEN
                 EXEC SQL 
                    INSERT INTO app_clients(dni, "name", created_at)
                    VALUES (:R_DNI, :R_NAME, :R_DATE)
                 END-EXEC
              END-IF
              MOVE R_AMOUNT  TO AMOUNT
              EXEC SQL
                 INSERT INTO balances(dni, amount, created_at)
                 VALUES (:R_DNI, :AMOUNT, :R_DATE)
              END-EXEC
              
              IF SQLCODE NOT = ZERO THEN
                  PERFORM ERROR-RTN
                  PERFORM SQLROLLBACK
                  PERFORM SQLDISCONNECT
                  CLOSE BalancesFile
                  STOP RUN          
              END-IF


              READ BalancesFile INTO BalanceRecord 
                 AT END SET EOFBalances TO TRUE
              END-READ
           END-PERFORM
           PERFORM SQLCOMMIT
           PERFORM SQLDISCONNECT
           CLOSE BalancesFile      
           STOP RUN.
       SQLCOMMIT.
           DISPLAY "COMMIT..."
           EXEC SQL 
              COMMIT
           END-EXEC.
       SQLROLLBACK.
           DISPLAY "ROLLBACKING..."
           EXEC SQL
               ROLLBACK 
           END-EXEC.
       SQLDISCONNECT.
           DISPLAY "DISCONNECTING.."
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
       ERROR-RTN.
           DISPLAY "*** SQL ERROR ***".
           DISPLAY "SQLCODE: " SQLCODE " " NO ADVANCING.
           EVALUATE SQLCODE
              WHEN  +10
                 DISPLAY "Record not found"
              WHEN  -01
                 DISPLAY "Connection falied"
              WHEN  -20
                 DISPLAY "Internal error"
              WHEN  -30
                 DISPLAY "PostgreSQL error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
                 EXEC SQL
                     ROLLBACK
                 END-EXEC
              WHEN  OTHER
                 DISPLAY "Undefined error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
           END-EVALUATE.
       

