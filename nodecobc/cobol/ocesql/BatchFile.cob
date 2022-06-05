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
       
OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC. 
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
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC. 
       
OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(049) VALUE "SELECT COUNT( * ) FROM app_cli"
OCESQL  &  "ents WHERE dni = $1".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0002.
OCESQL     02  FILLER PIC X(068) VALUE "INSERT INTO app_clients(dni, n"
OCESQL  &  "ame, created_at) VALUES ( $1, $2, $3 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0003.
OCESQL     02  FILLER PIC X(067) VALUE "INSERT INTO balances(dni, amou"
OCESQL  &  "nt, created_at) VALUES ( $1, $2, $3 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0004.
OCESQL     02  FILLER PIC X(014) VALUE "DISCONNECT ALL".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
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
           
OCESQL*    EXEC SQL
OCESQL*       CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME 
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLConnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE USERNAME
OCESQL          BY VALUE 30
OCESQL          BY REFERENCE PASSWD
OCESQL          BY VALUE 10
OCESQL          BY REFERENCE DBNAME
OCESQL          BY VALUE 32
OCESQL     END-CALL.

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
              
OCESQL*       EXEC SQL
OCESQL*          SELECT COUNT(*) INTO :LENEX
OCESQL*          FROM app_clients
OCESQL*          WHERE dni=:R_DNI
OCESQL*       END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetResultParams" USING
OCESQL          BY VALUE 1
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE LENEX
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 8
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_DNI
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecSelectIntoOne" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL          BY VALUE 1
OCESQL          BY VALUE 1
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
              
              
              
              IF LENEX = ZERO THEN
OCESQL*          EXEC SQL 
OCESQL*             INSERT INTO app_clients(dni, "name", created_at)
OCESQL*             VALUES (:R_DNI, :R_NAME, :R_DATE)
OCESQL*          END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 8
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_DNI
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 48
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_NAME
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_DATE
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0002
OCESQL          BY VALUE 3
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
              END-IF
              MOVE R_AMOUNT  TO AMOUNT
OCESQL*       EXEC SQL
OCESQL*          INSERT INTO balances(dni, amount, created_at)
OCESQL*          VALUES (:R_DNI, :AMOUNT, :R_DATE)
OCESQL*       END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 8
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_DNI
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 3
OCESQL          BY VALUE 12
OCESQL          BY VALUE -2
OCESQL          BY REFERENCE AMOUNT
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE R_DATE
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0003
OCESQL          BY VALUE 3
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
              
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
OCESQL*    EXEC SQL 
OCESQL*       COMMIT
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
       SQLROLLBACK.
           DISPLAY "ROLLBACKING..."
OCESQL*    EXEC SQL
OCESQL*        ROLLBACK 
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "ROLLBACK" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
       SQLDISCONNECT.
           DISPLAY "DISCONNECTING.."
OCESQL*    EXEC SQL
OCESQL*        DISCONNECT ALL
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLDisconnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL     END-CALL.
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
OCESQL*          EXEC SQL
OCESQL*              ROLLBACK
OCESQL*          END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "ROLLBACK" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
              WHEN  OTHER
                 DISPLAY "Undefined error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
           END-EVALUATE.
       



