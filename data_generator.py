from faker import Faker
import random
from datetime import datetime, timedelta
from enum import Enum
import csv


# Initialize a Faker generator
fake = Faker()

# Define a list to hold our fake flight and booking data
books = []
borrowers = []
loans = []

# Generate fake data
num_books = 1000
num_borrowers = 1000
num_loans = 1000


def state(index):
    if index % 2:
        return "Available"
    else:
        return "Borrowed"


for i in range(num_books):
    book = {
        "id": i + 1,
        "title": fake.text(max_nb_chars=32),
        "author": fake.text(max_nb_chars=32),
        "ISBN": fake.text(max_nb_chars=32),
        "published_date": fake.date_between(datetime.now() - timedelta(5000), datetime.now() - timedelta(4000)),
        "genre": fake.text(max_nb_chars=32),
        "location": fake.text(max_nb_chars=32),
        "state": state(i)
    }
    books.append(book)

for i in range(num_borrowers):
    borrower = {
        "id": i + 1,
        "first name": fake.text(max_nb_chars=32),
        "last name": fake.text(max_nb_chars=32),
        "email": fake.text(max_nb_chars=32),
        "date of birth": fake.date_between(datetime.now() - timedelta(10000), datetime.now() - timedelta(9000)),
        "mambership  date": fake.date_between(datetime.now() - timedelta(1000), datetime.now())
    }
    borrowers.append(borrower)


for i in range(num_loans):
    due_date = fake.date_between(datetime.now() + timedelta(10), datetime.now() + timedelta(20))
    date_borrowed = fake.date_between(datetime.now() - timedelta(30), datetime.now() + timedelta(9))
    date_returned = fake.date_time_between_dates(date_borrowed, due_date)
    loan = {
        "id": i + 1,
        "book id": books[i]["id"],
        "borrower id": borrowers[i]["id"],
        "due date": due_date,
        "date borrower": date_borrowed,
        "date returned": fake.date_between(date_borrowed, due_date)
    }
    loans.append(loan)


base_query_books = "INSERT INTO Books (id, title, author, ISBN, published_date, genre, shelf_location, state) VALUES "
values_books = ', '.join(f"({book['id']}, '{book['title']}', '{book['author']}', '{book['ISBN']}', '{book['published_date']}', '{book['genre']}', '{book['location']}', '{book['state']}')" for book in books)
data_books = base_query_books + values_books + ";"

base_query_borrowers = "INSERT INTO Borrower (id, first_name, last_name, email, date_of_birth, membership_date) VALUES "
values_borrowers = ', '.join(f"({borrower['id']}, '{borrower['first name']}', '{borrower['last name']}', '{borrower['email']}', '{borrower['date of birth']}', '{borrower['mambership  date']}')" for borrower in borrowers)
data_borrowers = base_query_borrowers + values_borrowers + ";"

base_query_loans = "INSERT INTO Loan (id, book_id, borrower_id, due_date, date_borrowed, date_returned) VALUES "
values_loans = ', '.join(f"({loan['id']}, '{loan['book id']}', '{loan['borrower id']}', '{loan['due date']}', '{loan['date borrower']}', '{loan['date returned']}')" for loan in loans)
data_Loan = base_query_loans + values_loans + ";"

file1 = open('Books.txt', 'w')
file1.write(data_books)
file1.close()

file1 = open('Borrowers.txt', 'w')
file1.write(data_borrowers)
file1.close()

file1 = open('Loans.txt', 'w')
file1.write(data_Loan)
file1.close()
