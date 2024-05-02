- 12. **Trigger Implementation**
-- - Design a trigger to log an entry into a separate **`AuditLog`** table whenever a book's status changes from
-- Available' to 'Borrowed' or vice versa. The **`AuditLog`** should capture **`BookID`**, **`StatusChange`**, and **`ChangeDate`**.

CREATE TABLE AuditLog
(BookID INT,
 StatusChange VARCHAR(32),
 ChangeDate DATE,
PRIMARY KEY (BookID, StatusChange,ChangeDate));



CREATE TRIGGER BookStatusTrigger
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(state)
    BEGIN

        INSERT INTO AuditLog
        SELECT
            i.id,
            i.state,
            GETDATE()
        FROM INSERTED i
        LEFT JOIN DELETED d ON i.id = d.id
        WHERE i.state <> d.state OR d.state IS NULL;
    END
END;


INSERT INTO Loan
VALUES (1000,1,'2024-05-14','2024-5-03', null)

UPDATE Books
SET state = 'Borrowed'
WHERE id = 1000;
