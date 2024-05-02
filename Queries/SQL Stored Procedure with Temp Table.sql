
-- 14. **SQL Stored Procedure with Temp Table**:
-- - Design a stored procedure that retrieves all borrowers who have overdue books. Store these borrowers in a temporary table,
-- then join this temp table with the **`Loans`** table to list out the specific overdue books for each borrower.


CREATE OR ALTER PROCEDURE sp_OverDueBooks
AS BEGIN

    DROP TABLE IF EXISTS #overDueBorrowers;

    CREATE TABLE #overDueBorrowers (
        id INT IDENTITY (1,1) PRIMARY KEY ,
        borrower_id INT,
        first_name VARCHAR(32),
        last_name VARCHAR(32),
        book_id INT,
        book_title VARCHAR(32),
        due_date DATE,
        date_returned DATE
    );

    INSERT  INTO #overDueBorrowers (borrower_id, first_name, last_name, book_id, book_title, due_date, date_returned)
    SELECT brw.id, brw.first_name, brw.last_name, book.id, book.title, l.due_date, l.date_returned

    FROM Loan l
    JOIN Books book ON l.book_id = book.id
    JOIN Borrower brw ON l.borrower_id = brw.id
    WHERE COALESCE(l.date_returned, GETDATE()) > l.due_date;

    SELECT *
    FROM #overDueBorrowers;
END;


EXEC sp_OverDueBooks
