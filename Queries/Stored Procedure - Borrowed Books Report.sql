- 11. **Stored Procedure - Borrowed Books Report**:
--     - **Procedure Name**: **`sp_BorrowedBooksReport`**
--     - **Purpose**: Generate a report of books borrowed within a specified date range.
--     - **Parameters**: **`StartDate`**, **`EndDate`**
--     - **Implementation**: Retrieve all books borrowed within the given range, with details like borrower name and borrowing date.
--     - **Return**: Tabulated report of borrowed books.


CREATE OR ALTER PROCEDURE sp_BorrowedBooksReport(
    @start_date VARCHAR(32),
    @end_date VARCHAR(32))
AS BEGIN
    SELECT brw.id, brw.first_name, brw.last_name, book.id, book.title, l.date_borrowed, l.date_returned
    FROM Loan l
    JOIN Books book ON l.book_id = book.id
    JOIN Borrower brw ON l.borrower_id = brw.id
    WHERE l.date_borrowed >= @start_date AND l.date_returned <= COALESCE(@end_date, GETDATE())
END;


EXEC sp_BorrowedBooksReport '2024-04-01', '2024-04-15'

SELECT *
FROM report;
