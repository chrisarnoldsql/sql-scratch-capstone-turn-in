-- Query for part 2c 

SELECT *
FROM survey
LIMIT 10;

-- Query for part 2d

SELECT question, 
	COUNT(DISTINCT user_id) AS '#_of_responses'
FROM survey
GROUP BY 1;

-- Query for part 2dii

SELECT question, 
	response, 
	COUNT(DISTINCT user_id) AS '#_of_responses'
FROM survey
WHERE question LIKE '%3%'
GROUP BY 2
ORDER BY 3 DESC;

-- Query for part 2diii

SELECT question, 
	response, 
	COUNT(DISTINCT user_id) AS '#_of_responses'
FROM survey
WHERE question LIKE '%exam%'
GROUP BY 2
ORDER BY 3 DESC;

-- Query for part 3b

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

SELECT COUNT(DISTINCT quiz.user_id) AS '#_of_quiz_takers',
	COUNT(DISTINCT home_try_on.user_id) AS '#_of_users',
	COUNT(DISTINCT purchase.user_id) AS '#_of_buyers'
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
	ON home_try_on.user_id = purchase.user_id;

-- Query for part 3d

WITH funnel AS(
SELECT DISTINCT quiz.user_id,
	home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
  home_try_on.number_of_pairs,
  purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
	ON quiz.user_id = purchase.user_id
)

SELECT number_of_pairs,
	CASE
  WHEN number_of_pairs IS NULL
  THEN COUNT(funnel.user_id)
  ELSE 0
  END AS 'lost_quiz_takers',
	SUM(is_home_try_on) AS 'number_of_users',
  SUM(is_purchase) AS 'number_of_buyers'
FROM funnel
GROUP BY 1
ORDER BY 4 DESC;

-- Query for part 4a


SELECT style, 
	COUNT(user_id) AS '#_of_responses'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT fit, 
	COUNT(user_id) AS '#_of_responses'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT shape, 
	COUNT(user_id) AS '#_of_responses'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT color, 
	COUNT(user_id) AS '#_of_responses'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

-- Query for part 4b

SELECT product_id, 
	style,
	model_name,
	color,
	price,
	COUNT(*) AS '#_sold',
	SUM(price) AS 'total_revenue'
FROM purchase
GROUP BY 1
ORDER BY 6 DESC;

-- Query for part 4c

SELECT
	CASE
	WHEN purchase.color LIKE "%tortoise%" THEN 'Tortoise'
	WHEN purchase.color LIKE '%black%' THEN 'Black'
	WHEN purchase.color LIKE '%crystal%' THEN 'Crystal'
	ELSE 'Other'
	END AS purchase_color,
	COUNT(*)
FROM quiz
LEFT JOIN purchase
	ON quiz.user_id = purchase.user_id
WHERE purchase.user_id IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

SELECT quiz.color,
	COUNT(*)
FROM quiz
LEFT JOIN purchase
	ON quiz.user_id = purchase.user_id
WHERE purchase.user_id IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

WITH color_check AS(
SELECT quiz.color AS 'quiz_color',
	CASE
	WHEN purchase.color LIKE "%tortoise%" THEN 'Tortoise'
	WHEN purchase.color LIKE '%black%' THEN 'Black'
	WHEN purchase.color LIKE '%crystal%' THEN 'Crystal'
	ELSE 'Other'
	END AS purchase_color
FROM quiz
LEFT JOIN purchase
	ON quiz.user_id = purchase.user_id
WHERE purchase.user_id IS NOT NULL
)

SELECT quiz_color, 
	purchase_color,
	COUNT(*) AS '#_of_color_committers'
FROM color_check
WHERE quiz_color = purchase_color
GROUP BY 1
ORDER BY 3 DESC;



