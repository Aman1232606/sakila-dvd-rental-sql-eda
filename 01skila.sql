-- film popularity top 20 most rented films
SELECT 
	f.title,
    count(*) AS rentals_ct
from rental r 
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
group by f.title
order by rentals_ct desc
limit 20;

-- The most rented films are Bucket Brotherhood (34 rentals), Rocketeer Mother (33 rentals), and Ridgemont Submarine, Grit Clockwork, Forward Temple, and Scalawag Duck (32 rentals each). These films show consistently high demand. The store should keep more copies of these popular titles in inventory and consider promoting similar films to maximize rentals.

-- Most rented categories
select 
	c.name AS category_name,
    count(*) As rentals_ct
from rental r 
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id 
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name
order by rentals_ct desc;

-- The most rented film categories are Sports (1,179 rentals), Animation (1,166 rentals), Action (1,112 rentals), Sci-Fi (1,101 rentals), and Family (1,096 rentals). These categories have the highest customer demand. The store should prioritize stocking and promoting films from these categories to increase overall rental activity

-- Customer Behavior a)  top customer by rental frequency
select
	c.customer_id,
    concat(c.first_name,' ', c.last_name) AS customer_name,
    count(r.rental_id) AS rentals_ct
from customer c 
join rental r on c.customer_id = r.customer_id
group by c.customer_id, customer_name
order by rentals_ct desc
limit 20;

-- The most active customers based on rental frequency are Eleanor Hunt (46 rentals), Karl Seal (45 rentals), and Marcia Dean and Clara Shaw (42 rentals each). These customers rent DVDs very frequently and represent loyal, high-engagement users. The store should focus on retaining these customers through loyalty programs, special discounts, or early access to new releases.

-- b) top customer by total payments 
select 
	c.customer_id,
    concat(c.first_name, ' ',c.last_name) As customer_name,
    round(sum(p.amount), 2) AS total_paid
from customer c 
join payment p on c.customer_id = p.customer_id
group by c.customer_id, customer_name
order by total_paid desc
limit 20;

-- “The top customers based on total payments are Karl Seal ($221.55), Eleanor Hunt ($216.54), and Clara Shaw ($195.58). These customers contribute the highest revenue to the store. High-value customers should be targeted with personalized offers, loyalty rewards, and exclusive promotions to encourage continued spending.

-- c) customer segmentation(case statement)
SELECT 
    customer_id,
    customer_name,
    total_paid,
    CASE 
        WHEN total_paid >= 150 THEN 'HIGH'
        WHEN total_paid >= 75 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS spender_segment
FROM (
    SELECT 
        cv.customer_id,
        CONCAT(cv.first_name, ' ', cv.last_name) AS customer_name,
        COALESCE(SUM(p.amount), 0) AS total_paid
    FROM customer cv
    LEFT JOIN payment p 
        ON cv.customer_id = p.customer_id
    GROUP BY cv.customer_id, customer_name
) t
ORDER BY total_paid DESC;

-- Customers were segmented into three groups based on total spending: HIGH (≥ 150), MEDIUM (75 to <150), and LOW (< 75). The highest spenders include customers like Karl Seal ($221.55) and Eleanor Hunt ($216.54), who fall into the HIGH segment and contribute strongly to revenue. A large portion of customers fall into the MEDIUM segment, indicating steady regular spending, while the LOW segment includes customers spending below $75 and may need engagement offers.”
-- Recommendation: The store should focus on retaining HIGH customers using loyalty rewards, and try to convert MEDIUM customers into HIGH using bundle offers or discounts. For the LOW segment, simple reminders, new-customer promotions, or weekend deals can help increase activity

-- rental trends a) rentals per month 
SELECT
    DATE_FORMAT(rental_date, '%Y-%m') AS `year_month`,
    COUNT(*) AS rentals_ct
FROM rental
GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
ORDER BY rentals_ct DESC;

-- The busiest rental month is July 2005 (6,709 rentals), followed by August 2005 (5,686 rentals). Rentals are much lower in earlier months such as May 2005 (1,156) and June 2005 (2,311), and the lowest shown is February 2006 (182). This indicates that rentals peak strongly during mid-year, so the store should increase inventory availability and staffing during high-demand months like July and August.

-- Rentals by weekday
select 
	DAYNAME(rental_date) as day_name,
    count(*) as rentals_ct
from rental
group by day_name
order by rentals_ct desc;

-- The busiest rental day is Tuesday (2,463 rentals), followed by Sunday (2,320 rentals) and Saturday (2,311 rentals). Rentals are slightly lower on weekdays such as Thursday (2,200 rentals) and Wednesday (2,231 rentals). The store should ensure adequate staffing and inventory availability on high-traffic days, especially Tuesdays and weekends.

-- c)Rentals + revenue by months
SELECT
	DATE_FORMAT(r.rental_date, '%Y-%m') AS 'year_month',
  COUNT(DISTINCT r.rental_id) AS rentals_ct,
  ROUND(SUM(p.amount), 2) AS revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY DATE_FORMAT(r.rental_date, '%Y-%m')
ORDER BY DATE_FORMAT(r.rental_date, '%Y-%m');

-- Rental activity and revenue both peak in July 2005, with 6,709 rentals generating $28,368.91, followed by August 2005 with 5,686 rentals and $24,070.14 in revenue. Lower rental months such as May 2005 and February 2006 show significantly reduced revenue. This confirms that higher rental volume directly drives higher revenue, and the store should focus marketing efforts and inventory planning around peak months

-- Revenue Analysis a)Revenue by category
SELECT
  c.name AS category_name,
  ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC;

-- The highest revenue is generated by the Sports category ($5,314.21), followed by Sci-Fi ($4,756.98), Animation ($4,656.30), and Drama ($4,587.39). These categories contribute the most to overall revenue. The store should prioritize acquiring and promoting films from these high-earning categories to maximize profitability

-- b) Best-performing stores
SELECT
  i.store_id,
  COUNT(DISTINCT r.rental_id) AS rentals_ct,
  ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY i.store_id
ORDER BY revenue DESC;

-- Store 2 generated the highest revenue with $33,726.77 from 8,121 rentals, closely followed by Store 1, which earned $33,679.79 from 7,923 rentals. Both stores perform at a very similar level, indicating balanced operations across locations. Small improvements in inventory allocation or promotions could help further increase revenue at both stores.

-- c)Staff performance
SELECT
  s.staff_id,
  CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
  s.store_id,
  ROUND(SUM(p.amount), 2) AS revenue
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, staff_name, s.store_id
ORDER BY revenue DESC;

-- Among the staff members, Jon Stephens generated the highest revenue with $33,924.06, followed closely by Mike Hillyer, who generated $33,482.50. Both staff members show strong performance, suggesting effective customer handling and transaction processing. Recognizing and rewarding high-performing staff can help maintain motivation and service quality.

-- Late Returns + Estimated Late Fee Loss   a) Late return %
SELECT
  COUNT(*) AS total_rentals,
  SUM(CASE WHEN r.return_date IS NOT NULL
            AND DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
           THEN 1 ELSE 0 END) AS late_returns
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;


-- b)Estimate late fee loss (late_days × rental_rate)
SELECT
  ROUND(SUM(late_fee_estimate), 2) AS total_estimated_late_fees
FROM (
  SELECT
    r.rental_id,
    GREATEST(
      0,
      DATEDIFF(r.return_date, r.rental_date) - CAST(f.rental_duration AS SIGNED)
    ) AS late_days,
    GREATEST(
      0,
      DATEDIFF(r.return_date, r.rental_date) - CAST(f.rental_duration AS SIGNED)
    ) * f.rental_rate AS late_fee_estimate
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  JOIN film f ON i.film_id = f.film_id
  WHERE r.return_date IS NOT NULL
) x;

-- Late Returns Analysis:Out of 16,044 total rentals, 7,269 rentals were returned late, resulting in a late return rate of approximately 45.3%. The estimated potential revenue loss due to late returns is $58,640.08, calculated based on late days multiplied by the rental rate. This indicates a significant impact on revenue and inventory availability.

-- Recommendation:To reduce late returns and recover potential revenue, the store should implement automated return reminders, clearly communicate late fee policies, and consider incentives for on-time returns. These actions can help lower late return rates and improve overall operational efficiency.
