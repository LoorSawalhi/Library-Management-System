-- 6. **Database Function - Calculate Overdue Fees**:
--     - **Function Name**: **`fn_CalculateOverdueFees`**
--     - **Purpose**: Compute overdue fees for a given loan.
--     - **Parameter**: **`LoanID`**
--     - **Implementation**: Charge fees based on overdue days: $1/day for up to 30 days, $2/day after.
--     - **Return**: Overdue fee for the **`LoanID`**.


CREATE OR ALTER FUNCTION fn_CalculateOverdueFees (@id INT)
RETURNS DECIMAL AS
BEGIN
    DECLARE @days INT, @dept DECIMAL;

    SELECT @days = DATEDIFF(day, l.date_borrowed, COALESCE(l.date_returned, GETDATE()))
    FROM loan l
    WHERE l.id = @id;

    IF @days > 30
    BEGIN
        SET @dept = ((@days - 30) * 2) + 30;
    END
    ELSE IF @days >= 0
    BEGIN
        SET @dept = @days;
    END

    RETURN @dept;
END;

SELECT id, dbo.fn_CalculateOverdueFees(id) as fees
FROM Loan
ORDER BY fees DESC ;

select * from fn_CalculateOverdueFees(1)
