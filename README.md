# **Library Management System: Database Project**

## **Background**:

 A local library wishes to transition from their traditional book-keeping to a more robust digital system. They want a platform to efficiently track books, borrowers, loans, returns, and offer insights into borrowing trends.

## **Requirements**:

### **1. Design an Entity Relationship Model (ERM) Diagram**:

- **Entities**: Illustrate entities: **`Books`**, **`Borrowers`**, and **`Loans`**.
- **Attributes**: Detail attributes for each entity.
- **Relationships**: Exhibit connections between entities.
- **Connectivity and Cardinality**: Notate the relationship type between entities.
- **Keys**: Mark primary (PK) and foreign keys (FK).
- **Tools**: Opt for ERDPlus, Lucidchart, or similar tools. Include the diagram in the repository.

  ![Alt text](https://github.com/LoorSawalhi/Library-Management-System/blob/main/ERM.png "ER Diagram")

### **2. Design the Relational Schema using MS SQL**:

- **Books**:
    - BookID (PK)
    - Title
    - Author
    - ISBN
    - Published Date
    - Genre
    - Shelf Location
    - Current Status ('Available' or 'Borrowed')
- **Borrowers**:
    - BorrowerID (PK)
    - First Name
    - Last Name
    - Email
    - Date of Birth
    - Membership Date
- **Loans**:
    - LoanID (PK)
    - BookID (FK)
    - BorrowerID (FK)
    - Date Borrowed
    - Due Date
    - Date Returned (NULL if not returned yet)

### **3. Complex Queries and Procedures**:

1. **List of Borrowed Books**: Retrieve all books borrowed by a specific borrower, including those currently unreturned.

    A simple select query is used along with join for each of the tables based on the borrower id.

3. **Active Borrowers with CTEs**: Identify borrowers who've borrowed 2 or more books but haven't returned any using CTEs.

    Two CTEs were used, the first named active_borrowers that returns all the borrowers ids who have never returned any borrowed book. The second CTE named count_borrowed_books counts the number of borrowed books for each borrower. This is followed by a select query for the borrowers how their borrowing count is 2 or more.

5. **Borrowing Frequency using Window Functions**: Rank borrowers based on borrowing frequency.

    A CTE was used for returning the borrowing frequency for each borrower, this was done by partitioning the loan table by the borrower ID, then the rank function was used to rank the borrowers over their borrowing frequency.

6. **Popular Genre Analysis using Joins and Window Functions**: Identify the most popular genre for a given month.

   Two CTEs were used, the first returned the count of occurrences for a book genre in a given month and year. The result was then used in another CTE to return the row number for these genres grouped by month and year ordered by the genre count. Finally, the result was to select the rows with row number = 1 that represents the most popular genre for a given month and year. 

7. **Stored Procedure - Add New Borrowers**:
    - **Procedure Name**: **`sp_AddNewBorrower`**
    - **Purpose**: Streamline the process of adding a new borrower.
    - **Parameters**: **`FirstName`**, **`LastName`**, **`Email`**, **`DateOfBirth`**, **`MembershipDate`**.
    - **Implementation**: Check if an email exists; if not, add to **`Borrowers`**. If existing, return an error message.
    - **Return**: The new **`BorrowerID`** or an error message.

    A stored procedure was created in order to add a new borrower, this procedure took five parameters. A select query is first performed to check if there exists any borrower with such email, if yes an error message is raised, if not the new borrower is inserted.

8. **Database Function - Calculate Overdue Fees**:
    - **Function Name**: **`fn_CalculateOverdueFees`**
    - **Purpose**: Compute overdue fees for a given loan.
    - **Parameter**: **`LoanID`**
    - **Implementation**: Charge fees based on overdue days: $1/day for up to 30 days, $2/day after.
    - **Return**: Overdue fee for the **`LoanID`**.
  
    A function is created to calculate the overdue fees for a borrower. It takes the borrower id as a parameter, then calculates the difference between the borrowed date and the returned date. In cases where the returned date is null, the current date is taken. The calculation is then based on a simple equation and a decimal number is returned.

   This function can then be used in simple sql queries to return the fees and order the borrowers based on them.

9. **Database Function - Book Borrowing Frequency**:
    - **Function Name**: **`fn_BookBorrowingFrequency`**
    - **Purpose**: Gauge the borrowing frequency of a book.
    - **Parameter**: **`BookID`**
    - **Implementation**: Count the number of times the book has been issued.
    - **Return**: Borrowing count of the book.

    A function is created to calculate the number of times it has been borrowed, the function will simply take the book id and return the count of which it has been borrowed using a simple select over the loan table.

10. **Overdue Analysis**: List all books overdue by more than 30 days with their associated borrowers.

    A function is created to return the number of days between the expected return day of a book and the actual one (Unreturned books will be assumed to be returned at the current day to calculate the overdue days till now). A simple select query will take the result of the function and select the books with count more or equal to 30.

11. **Author Popularity using Aggregation**: Rank authors by the borrowing frequency of their books.

A CTE was used to count the frequency of borrowing a book for a specific author, the result was then ordered based on the count to display the popularity of each author.

12. **Genre Preference by Age using Group By and Having**: Determine the preferred genre of different age groups of borrowers. (Groups are (0,10), (11,20), (21,30)…)

A CTE was used to create groups out of age, these groups were then used to group the borrowed books by age and then by genre to count a genre popularity based on the age groups. This was followed with a select statement to display out the preferred genre for each age group.

15. **Stored Procedure - Borrowed Books Report**:
    - **Procedure Name**: **`sp_BorrowedBooksReport`**
    - **Purpose**: Generate a report of books borrowed within a specified date range.
    - **Parameters**: **`StartDate`**, **`EndDate`**
    - **Implementation**: Retrieve all books borrowed within the given range, with details like borrower name and borrowing date.
    - **Return**: Tabulated report of borrowed books.

A stored procedure was used to print out the join of the three tables in order to give a detailed report of the borrowing actions.

16. **Trigger Implementation**
- Design a trigger to log an entry into a separate **`AuditLog`** table whenever a book's status changes from 'Available' to 'Borrowed' or vice versa. The **`AuditLog`** should capture **`BookID`**, **`StatusChange`**, and **`ChangeDate`**.

A trigger was created to insert a new record into the AuditLog table each time the state of a book changes.

15. **SQL Stored Procedure with Temp Table**:
- Design a stored procedure that retrieves all borrowers who have overdue books. Store these borrowers in a temporary table, then join this temp table with the **`Loans`** table to list out the specific overdue books for each borrower.

A tempo table was used inside of a stored procedure in order to save the result data into it.
