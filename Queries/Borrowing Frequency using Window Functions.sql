with borrowing_Frequency AS(
    SELECT  L.borrower_id,
             COUNT(*) OVER(PARTITION BY L.borrower_id) AS borrowing_frequency
    FROM loan L
    )

SELECT L.borrower_id,
       BF.borrowing_frequency ,
       RANK() OVER(ORDER BY BF.borrowing_frequency ) AS rank
FROM Borrower b
JOIN loan L ON b.id = L.borrower_id
JOIN borrowing_Frequency BF ON BF.borrower_id = L.borrower_id;
