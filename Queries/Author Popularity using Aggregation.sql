-- Author Popularity using Aggregation: Rank authors by the borrowing frequency of their books.

with borrowing_Frequency AS(
    SELECT  b.author,
             COUNT(*) OVER(PARTITION BY b.author) AS borrowing_frequency
    FROM Books b
    JOIN loan L ON b.id = L.book_id
    )

SELECT b.author,
       BF.borrowing_frequency ,
       RANK() OVER(ORDER BY BF.borrowing_frequency ) AS rank
FROM Books b
JOIN borrowing_Frequency BF ON BF.author = b.author;
