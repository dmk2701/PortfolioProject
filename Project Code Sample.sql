
--Update table cost and table revenue
update dbo.cost set Network ='Facebook' where Network = 'Facebook Newsfeed'
update dbo.cost set Network ='Facebook' where Network = 'Instagram'
update dbo.Revenue set Network ='Facebook' where Network = 'Facebook Newsfeed'
update dbo.Revenue set Network ='Facebook' where Network = 'Instagram'
update cost set date = '2021-11-11' where date is null
update revenue set date = '2021-11-11' where date is null

--Calculate ROAS by date
with cte_cost as
(select date, sum(cost) as total_cost from cost group by date),
cte_revenue as 
(select date, sum(revenue) as total_revenue from revenue group by date)

select c.date,r.total_revenue/c.total_cost as ROAS 
	from cte_cost as c, cte_revenue as r 
	where c.date = r.date

--Calculate ROAS by country
with cte_cost as
(select country, sum(cost) as total_cost from cost group by country ),
cte_revenue as 
(select country, sum(revenue) as total_revenue from revenue group by country)

select c.country, r.total_revenue/c.total_cost as ROAS 
	from cte_cost as c, cte_revenue as r 
	where c.country = r.country

--Calculate ROAS by network
with cte_cost as
(select network, sum(cost) as total_cost from cost group by network ),
cte_revenue as 
(select network, sum(revenue) as total_revenue from revenue group by network)

select c.network, r.total_revenue/c.total_cost as ROAS 
	from cte_cost as c, cte_revenue as r 
	where c.network = r.network

--Calculate ROAS by country in the calendar from 2021-09-28 to 2021-11-05
with cte_cost as
(select country, date, sum(cost) as total_cost from cost  where date between '2021-09-28' and '2021-11-05' group by date, country),
cte_revenue as 
(select country, date, sum(revenue) as total_revenue from revenue  where date between '2021-09-28' and '2021-11-05' group by date, country)

select c.date, c.country ,r.total_revenue/c.total_cost as ROAS 
	from cte_cost as c, cte_revenue as r 
	where c.date = r.date order by c.date

--Calculate ROAS by network in the calendar from 2021-09-28 to 2021-11-05
with cte_cost as
(select network, date, sum(cost) as total_cost from cost  where date between '2021-09-28' and '2021-11-05' group by date, network),
cte_revenue as 
(select network, date, sum(revenue) as total_revenue from revenue  where date between '2021-09-28' and '2021-11-05' group by date, network)

select c.date, c.network ,r.total_revenue/c.total_cost as ROAS 
	from cte_cost as c, cte_revenue as r where c.date = r.date 
	order by c.date








