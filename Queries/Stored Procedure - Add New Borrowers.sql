-- Stored Procedure - Add New Borrowers:
--     - Procedure Name: `sp_AddNewBorrower`
--     - Purpose**: Streamline the process of adding a new borrower.
--     - Parameters**: **`FirstName`**, **`LastName`**, **`Email`**, **`DateOfBirth`**, **`MembershipDate`**.
--     - Implementation**: Check if an email exists; if not, add to **`Borrowers`**. If existing, return an error message.
--     - Return: The new **`BorrowerID`** or an error message.

CREATE OR ALTER PROCEDURE sp_AddNewBorrower(
@first_name VARCHAR(32),
@last_name VARCHAR(32),
@email VARCHAR(32),
@date_of_birth VARCHAR(32),  -- Assuming the actual data type in DB is DATE
@membership_date VARCHAR(32))  -- Corrected the typo and assumed DATE type
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @temp VARCHAR(32);

        SELECT @temp = email
        FROM Borrower
        WHERE email = @email;

        IF @temp IS NULL
        BEGIN
            INSERT INTO Borrower ( first_name, last_name, email, date_of_birth, membership_date)
            VALUES ( @first_name, @last_name, @email, @date_of_birth, @membership_date);
        END
        ELSE
        BEGIN
             RAISERROR('ERROR: Employee email already exists!', 16, 1);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;  -- Re-throw the error to the caller
    END CATCH
END;


EXEC sp_AddNewBorrower  'Loor', 'Sawalhi', 'loorwael@yahoo.com', '28-09-2001', '28-09-2001';
