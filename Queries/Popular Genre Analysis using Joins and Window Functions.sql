WITH generForMonth AS (
    SELECT book.genre,
           MONTH(l.date_borrowed) as month,
           YEAR(l.date_borrowed) as year,
           COUNT(*) AS genre_count
    FROM Loan l
    JOIN Books book on l.book_id = book.id
    GROUP BY book.genre,
             MONTH(l.date_borrowed),
             YEAR(l.date_borrowed)
),  genreCount AS (
    SELECT genre,
           month,
           year,
           genre_count,
           ROW_NUMBER() OVER (PARTITION BY month, year ORDER BY genre_count DESC ) AS rowN
    FROM generForMonth
)

    SELECT genre, month, year, genre_count
    FROM genreCount
    WHERE rowN = 1;
