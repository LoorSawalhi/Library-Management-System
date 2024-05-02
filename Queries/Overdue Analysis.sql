-- Overdue Analysis: List all books overdue by more than 30 days with their associated borrowers.


CREATE OR ALTER FUNCTION fn_OverDueBooks (@id INT)
RETURNS DECIMAL AS
BEGIN
    DECLARE @days INT;

    SELECT @days = SUM( DATEDIFF(day, l.date_borrowed, COALESCE(l.date_returned, GETDATE())))
    FROM loan l
    WHERE l.book_id = @id
    Group By l.book_id;

    RETURN @days;
END;


SELECT book.id, dbo.fn_OverDueBooks(book.id) AS overDueDays, brw.id
FROM Books book
JOIN loan l ON book.id = l.book_id
JOIN Borrower Brw ON l.borrower_id = Brw.id
WHERE dbo.fn_OverDueBooks(book.id) >= 30;
