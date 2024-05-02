-- Active Borrowers with CTEs: Identify borrowers who've borrowed 2 or more books but haven't returned any using CTEs.

with active_borrowers as (
    select brw.id
    from Borrower brw
    join loan l on brw.id = l.borrower_id
    join Books book on book.id = l.book_id
    and brw.id not in (
        select l2.borrower_id
        from Books book2,
             loan l2
        where book2.state = 'Available' and l2.borrower_id = brw.id and book2.id = book.id
        )
), count_borrowed_books as (
    select  actibeB.id,
            count(*) as count
    from active_borrowers actibeB
    join  loan l on l.borrower_id = actibeB.id
    group by actibeB.id)

select brw.id,
       brw.first_name,
       brw.last_name,
       brw.email,
       borrowed.count
from count_borrowed_books borrowed
join Borrower brw on borrowed.id = brw.id
where borrowed.count >= 2;
