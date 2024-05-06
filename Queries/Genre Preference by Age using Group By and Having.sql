-- Genre Preference by Age using Group By and Having: Determine the preferred genre of different age groups of borrowers. (Groups are (0,10), (11,20), (21,30)…)
WITH AgeGroups AS (
    SELECT
        CASE
            WHEN AgeYears BETWEEN 0 AND 20 THEN '0-20'
            WHEN AgeYears BETWEEN 21 AND 22 THEN '21-22'
            WHEN AgeYears BETWEEN 23 AND 24 THEN '23-24'
            WHEN AgeYears BETWEEN 24 AND 25 THEN '24-25'
            WHEN AgeYears BETWEEN 26 AND 40 THEN '26-40'
            ELSE 'Over 40'
        END AS AgeRange,
        id
    FROM
        (SELECT DATEDIFF(year, b.date_of_birth, GETDATE()) AS AgeYears, b.id
         FROM Borrower b  ) AS BorrowerAge
), GenreGroups AS (
    SELECT ag.AgeRange, book.genre, COUNT(*) AS genreCount
    FROM AgeGroups ag
    JOIN Loan l ON l.borrower_id = ag.id
    JOIN Books book ON book.id = l.book_id
    GROUP BY AgeRange, book.genre)

SELECT AgeRange, genreCount,genre
FROM GenreGroups g
GROUP BY AgeRange, genre, genreCount
HAVING genreCount = (SELECT MAX(genreCount)
                      FROM GenreGroups gg WHERE gg.AgeRange = g.AgeRange);
