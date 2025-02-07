use zomato

CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-05-23'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

1.'what is the total price of each customer spend on zomato?'
select sales.userid,sum(product.price) total_amount_spend from sales
inner join product
on sales.product_id = product.product_id
group by sales.userid

2. 'How many days customer visited zomato?'
select userid,count(distinct created_date) no_of_vist from sales group by userid

3. 'what was the first product purchased by each customer?'
select * from
(select *,rank() over(partition by userid order by created_date) rnk from sales) sales where rnk = 1

4.'what is the most purchased item in the menu and how mant times it is been purchased?'
select product_id,count(product_id) from sales group by product_id order by product_id asc limit 1

5.'which item is most popular for each customer?'
SELECT *,
       RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
FROM (
    SELECT a.userid, a.product_id, COUNT(a.product_id) AS product_count, MAX(a.created_date) AS created_date
    FROM sales a  
    GROUP BY a.userid, a.product_id
) AS subquery;

6. 'which item was purchased first by customer after they became member?'
select * from
(select *,rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b
on a.userid=b.userid and created_date>= gold_signup_date)c) d where rnk =1

7. 'which item was purchased first by customer before they became member?'
select * from
(select *,rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b
on a.userid=b.userid and created_date<= gold_signup_date)c) d where rnk =1
