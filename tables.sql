create table Books (
    id int primary key,
    title varchar(32),
    author varchar(32),
    ISBN varchar(32) unique ,
    published_date date,
    genre varchar(32),
    shelf_location varchar(32),
    state varchar(32)
    check (state IN ('Available','Borrowed'))
);

create table Borrower (
    id int primary key,
    first_name varchar(32),
    last_name varchar(32),
    email varchar(32) unique ,
    date_of_birth date,
    membership_date date
);

create table Loan (
    id int primary key,
    book_id int,
    borrower_id int,
    due_date date,
    date_borrowed date,
    date_returned date default NULL,
    foreign key (book_id) references Books(id),
    foreign key (borrower_id) references Borrower(id)
);
