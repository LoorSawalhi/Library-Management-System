-- List of Borrowed Books: Retrieve all books borrowed by a specific borrower, including those currently unreturned.

select book.id, book.title, book.author, book.state
from Borrower brw, Books book, loan l
where brw.id = l.borrower_id and book.id = l.book_id and brw.id = 200;
