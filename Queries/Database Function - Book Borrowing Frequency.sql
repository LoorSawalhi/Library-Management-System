-- 7. **Database Function - Book Borrowing Frequency**:
--     - **Function Name**: **`fn_BookBorrowingFrequency`**
--     - **Purpose**: Gauge the borrowing frequency of a book.
--     - **Parameter**: **`BookID`**
--     - **Implementation**: Count the number of times the book has been issued.
--     - **Return**: Borrowing count of the book.


CREATE OR ALTER FUNCTION fn_BookBorrowingFrequency (@id INT)
RETURNS DECIMAL AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM loan l
    WHERE l.book_id = @id;

    RETURN @count;
END;

SELECT id, dbo.fn_BookBorrowingFrequency(id) as frequency
FROM Books
ORDER BY frequency DESC ;
 
