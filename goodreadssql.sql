
/*Tables*/

DROP TABLE IF EXISTS ratings_summary;
DROP TABLE IF EXISTS listofbooks;

/*Books table*/
CREATE TABLE listofbooks (
    book_id INT IDENTITY (1,1) PRIMARY KEY, /*Assigns a number to each row so that they can be distinguished and there can't be nulls */
    title NVARCHAR(200), /*Allows for title, authors, & genres to have all characters up to 200 in length*/
    authors NVARCHAR(200),
    genre NVARCHAR(200),
    pages INT
);
/*ratings summary table */
CREATE TABLE ratings_summary (
    book_id INT PRIMARY KEY, /*book_id helps us join it to listofbooks table later*/
    avg_rating FLOAT,
    ratings_count INT,
    fivestar_count INT,
    fourstar_count INT,
    threestar_count INT,
    twostar_count INT,
    onestar_count INT,
    FOREIGN KEY (book_id) REFERENCES listofbooks(book_id)
);

/*Inserting data into tables*/
INSERT INTO listofbooks(title, authors, genre, pages) VALUES
('My Friends', 'Fredrik Backman', 'Fiction', 448),
('Atmosphere', 'Taylor Jenkins Reid', 'Historical Fiction', 352),
('Not Quite Dead Yet', 'Holly Jackson', 'Mystery', 430),
('Great Big Beautiful Life', 'Emily Henry', 'Romance', 416),
('Onyx Storm', 'Rebecca Yarros', 'Romantasy & Audiobook', 544),
('Bury Our Bones in the Midnight Soil', 'V.E. Schwab', 'Fantasy', 533),
('The Compound', 'Aisling Rawle', 'Science Fiction', 352),
('Witchcraft for Wayward Girls', 'Grady Hendrix', 'Horror', 477),
('Alchemised', 'SenLinYu', 'Debut Novel', 1040),
('Sunrise on the Reaping', 'Suzanne Collins', 'YA Fantasy & Sci-Fi', 400),
('Fake Skating', 'Lynn Painter', 'YA Fiction', 368),
('Everything is Tuberculosis', 'John Green', 'Nonfiction', 198),
('The House of my Mother', 'Shari Franke', 'Memoir', 297),
('How to Kill a Witch', 'Zoe Venditozzi, Claire Mitchell', 'History & Biography', 304);

INSERT INTO ratings_summary(book_id, avg_rating, ratings_count, fivestar_count, fourstar_count, threestar_count, twostar_count, onestar_count) VALUES
(1, 4.38, 359030, 201764, 107077, 38551, 8692, 2946),
(2, 4.34, 670218, 340363, 233489, 80365, 12807, 3194),
(3, 4.04, 140994, 48348, 58933, 26631, 5637, 1482),
(4, 3.96, 697441, 203836, 300561, 160966, 27257, 4821),
(5, 4.21, 1675559, 787510, 543134, 269506, 60603, 14887),
(6, 3.95, 157689, 47066, 67185, 33896, 7585, 1957),
(7, 3.56, 98200, 13063, 40723, 34288, 8590, 1536),
(8, 3.90, 121051, 34229, 50683, 28040, 6591, 1508),
(9, 4.39, 186670, 114740, 44783, 17123, 5908, 4116),
(10, 4.50, 1073200, 654651, 321200, 82113, 12878, 2358),
(11, 4.26, 63937, 28992, 24280, 9016, 1352, 297),
(12, 4.35, 202319, 97971, 81657, 19715, 2302, 674),
(13, 4.30, 182761, 85788, 70487, 22930, 3045, 526),
(14, 4.07, 4287, 1541, 1770, 765, 152, 59);

/*To compare list of books and their genres that were less than 4 stars*/
SELECT b.genre AS "Genre", b.title AS "Title", rat.avg_rating AS "Average Ratings"
FROM listofbooks AS b
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
WHERE rat.avg_rating < 4.0 
ORDER BY rat.avg_rating DESC;

/*Shows highest rated book that was less than 4 stars*/
SELECT TOP 1 b.genre AS "Genre", b.title AS "Title", rat.avg_rating AS "Average Ratings"
FROM listofbooks AS b
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
WHERE rat.avg_rating < 4.0 
ORDER BY rat.avg_rating DESC;

/*To compare list of books and their genres that were more than 4 stars*/
SELECT b.genre AS "Genre", b.title AS "Title", rat.avg_rating AS "Average Rating" 
FROM listofbooks AS b  
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
WHERE rat.avg_rating >= 4.0
ORDER BY rat.avg_rating DESC;

/*Top 3 books based on average ratings*/
SELECT TOP 3 b.genre AS "Genre", b.title AS "Title", rat.avg_rating AS "Average Rating" 
FROM listofbooks AS b  
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
WHERE rat.avg_rating >= 4.0
ORDER BY rat.avg_rating DESC;


/*To compare how many people rate the books and their average ratings*/
SELECT b.genre AS "Genre", b.title AS "Title", rat.avg_rating AS "Average Rating", rat.ratings_count AS "Ratings Count"
FROM listofbooks AS b 
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
ORDER BY rat.ratings_count DESC;

/*To see the correlation of length of book and average ratings, if there is any*/
SELECT b.title AS "Title", b.authors AS "Author(s)", b.genre AS "Genre", b.pages AS "Page Count", rat.avg_rating AS "Average Rating"
FROM listofbooks AS b
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
ORDER BY pages DESC;

/*Shows number of titles/genres in Goodreads Choice Awards 2025, which is where this data is from*/
SELECT COUNT(title) AS "Number of Genre Awards in Goodreads Choice Awards 2025"
FROM listofbooks;

/*Categorizes books as big or small depending if it's > 400 pages or < 400 pages*/
SELECT title, pages,
CASE WHEN pages > 400 THEN 'big'
ELSE 'small' END AS "big or small book?"
FROM listofbooks;

/*Shows title, total ratings count, and five star count for each book from most total ratings to least*/
SELECT b.title, rat.ratings_count AS "ratings count", rat.fivestar_count AS "five star count"
FROM listofbooks AS b 
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
ORDER BY rat.ratings_count DESC;

/*Shows how much of total ratings is five star count*/
SELECT b.title, rat.ratings_count AS "ratings count", rat.fivestar_count AS "five star count",
CAST(ROUND(((rat.fivestar_count * 1.0 /rat.ratings_count) * 100), 2) AS DECIMAL(5,2)) AS "percentage of five star votes"
FROM listofbooks AS b 
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
ORDER BY "percentage of five star votes" DESC;

/*Shows percentage of votes per star*/
SELECT b.title,
CAST(ROUND(((rat.fivestar_count * 1.0 /rat.ratings_count) * 100), 2) AS DECIMAL(5,2)) AS "five star votes (%)",
CAST(ROUND(((rat.fourstar_count * 1.0 / rat.ratings_count) * 100), 2) AS DECIMAL (5,2)) AS "four star votes (%)",
CAST(ROUND(((rat.threestar_count * 1.0 / rat.ratings_count) * 100), 2) AS DECIMAL (5,2)) AS "three star votes (%)",
CAST(ROUND(((rat.twostar_count * 1.0/ rat.ratings_count) * 100), 2) AS DECIMAL (5,2)) AS "two star votes (%)",
CAST(ROUND(((rat.onestar_count * 1.0 / rat.ratings_count) * 100), 2) AS DECIMAL (5,2)) AS "one star votes (%)"
FROM listofbooks AS b 
JOIN ratings_summary AS rat ON b.book_id = rat.book_id
ORDER BY "five star votes (%)" DESC;
