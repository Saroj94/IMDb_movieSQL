use moviesana;
show tables;

-- 1.What are all Directors Names and total count of unique directors in directors' table?
SELECT COUNT(DISTINCT(DIRECTORS)) AS Total_unique_direc
FROM DIRECTORS;
 SELECT DISTINCT directors 
 FROM directors;
 
 -- 2.What are all Actors Names and total count of unique Actors in director's table?
 SELECT DISTINCT actor
 FROM actors;
 
 SELECT COUNT(DISTINCT actor) AS Unique_count_actor
 FROM actors;
 
-- 3.What is the colour, languages, country, title_year DISTRIBUTION of movies in the movies table?
SELECT color, COUNT(*) AS  color_dist
FROM movies
GROUP BY color;

SELECT languages, COUNT(*) AS lang_dist
FROM movies
GROUP BY languages
ORDER BY 2 DESC;

SELECT country, COUNT(*) AS coun_dist
FROM movies
GROUP BY country
ORDER BY 2 DESC;

SELECT title_year, COUNT(*) AS title_dist
FROM movies
GROUP BY title_year
ORDER BY 2 DESC;

-- 4.What is the highest and lowest grossing, highest and lowest budget movies in the Database?
SELECT  MAX(gross) AS higest_gross, 
		MIN(gross) AS lowest_gross,
        MAX(budget) AS highest_budget,
        MIN(budget) AS lowest_budget
FROM movies;
 
 -- 5.Retrieve a list of movie titles along with a column indicating whether the movie duration is above 140 minutes or not.
SELECT movie_title,
		CASE
			WHEN duration>140 THEN "Above 140 min"
            WHEN duration=140 THEN "Equel to 140 min"
            ELSE "Less Than 140 min"
		END move_lenght
FROM movies;

-- 6.Find the top 5 genres based on the number of movies released in the last 5 years?
SELECT genres, COUNT(genres) AS Top5_genres_last5years
FROM movies
WHERE title_year>(SELECT MAX(title_year) FROM movies)-5
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;


-- 7.Retrieve the movie titles directed by a director whose average movie duration is above the overall average duration.
SELECT AVG(duration)
FROM movies;

	SELECT Director_ID,AVG(duration)
	FROM movies
	GROUP BY Director_ID
	HAVING AVG(duration)>(SELECT AVG(duration) FROM movies)
	ORDER BY 2;

-- 8.Calculate the average budget of movies over the last 3 years, including the average budget for each movie.
SELECT movie_title, budget,title_year,
		ROUND(AVG(budget) OVER(PARTITION BY title_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS avg_budget
FROM movies
WHERE title_year IS NOT NULL
ORDER BY 3 DESC;

-- 9.Retrieve a list of movies with their genres, including only those genres that have more than 5 movies.
SELECT movie_title,genres
FROM movies
WHERE genres IN (
SELECT genres
FROM movies
GROUP BY genres
HAVING COUNT(movie_title)>5);

-- 10.Find the directors who have directed at least 3 movies and have an average IMDb score above 7.
SELECT D.directors, ROUND(AVG(M.imdb_score),1) AS avg_score, COUNT(M.movie_title) AS movie_count
FROM Directors D
JOIN Movies M ON M.director_id=D.D_id
GROUP BY D.directors
HAVING AVG(M.imdb_score)>7 AND  COUNT(M.movie_title)>3
ORDER BY 3 DESC;

-- where clause part
SELECT 
    director_id, COUNT(movie_title) AS movie_count
FROM
    movies
GROUP BY director_id
HAVING COUNT(movie_title) > 3
    AND AVG(imdb_score) > 7
ORDER BY 2 DESC;

-- 11.List the top 3 actors who have appeared in the most movies, and for each actor, provide the average IMDb score of the movies they appeared.
SELECT A.actor, ROUND(AVG(M.imdb_score),1) AS AVG_score, COUNT(M.movie_title) AS movie_count
FROM movies M
JOIN actors A ON CONCAT('|', M.actors,'|') LIKE CONCAT('%|',A.actor,'|%')
GROUP BY A.actor
ORDER BY 3 DESC LIMIT 3;

-- 12.For each year, find the movie with the highest gross, and retrieve the second highest gross in the same result set.

WITH movieRank AS (
				SELECT title_year,movie_title,gross,
                RANK() OVER(PARTITION BY title_year ORDER BY gross) AS GrossRank
                FROM movies)
SELECT title_year,
		MAX(CASE WHEN GrossRank=1 THEN movie_title END) AS  Highest_Gross,
	    MAX(CASE WHEN GrossRank=2 THEN movie_title END) AS  Second_Highest_Gross
FROM movieRank
WHERE GrossRank<=2
GROUP BY title_year
ORDER BY 1 DESC;

-- 13.Retrieve the top 3 movies based on IMDb score, and include their ranking.
SELECT movie_title, imdb_score,
		RANK() OVER(ORDER BY imdb_score DESC) AS score_ranking
FROM movies
WHERE imdb_score IS NOT NULL LIMIT 3;

-- 14.For each director, list their movies along with the IMDb score and the ranking of each movie based on IMDb score.
SELECT Movie_title,Director_id,imdb_score,
	   RANK() OVER(PARTITION BY Director_id ORDER BY imdb_score DESC) AS direct_ranking
FROM movies
WHERE imdb_score IS NOT NULL;
        
-- 15.Find the movie with the highest budget in each genre, and include the row number for each movie within its genre.
SELECT movie_title,budget,genres,
		ROW_NUMBER() OVER(PARTITION BY genres ORDER BY budget DESC) AS MovieBudget_ranking
FROM movies
WHERE genres IS NOT NULL;
select * from movies
