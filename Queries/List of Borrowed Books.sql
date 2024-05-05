-- List of Borrowed Books: Retrieve all books borrowed by a specific borrower, including those currently unreturned.

select book.id, book.title, book.author, book.state
from Borrower brw
join loan l on brw.id = l.borrower_id
join Books book on l.book_id = book.id
where brw.id = l.borrower_id and book.id = l.book_id and brw.id = 200;
