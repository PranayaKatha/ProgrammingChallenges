-- 1) Write a query to get the sum of impressions by day.

select 
CONVERT(VARCHAR(10), date, 111) as Day, 
sum(impressions) as Sum_Of_Impressions 
from [PMG_Assesment].[dbo].[marketing_performance] 
group by date;

-- 2) Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

select state, Revenue_Sum 
from (select 
state, 
sum(revenue) as Revenue_Sum, 
DENSE_RANK() over (order by sum(revenue) desc) as Rank 
from [PMG_Assesment].[dbo].[website_revenue] 
group by state) a
where Rank <=3;
-- Third best state, OH generated revenue of 37577

-- 3) Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

select a.name, 
sum(b.cost) as Total_Cost, 
sum(b.impressions) as Total_Impressions, 
sum(b.clicks) as Total_Clicks, 
sum(c.revenue) as Total_Revenue
from [PMG_Assesment].[dbo].[campaign_info] a 
left join [PMG_Assesment].[dbo].[marketing_performance] b on a.id=b.campaign_id
left join [PMG_Assesment].[dbo].[website_revenue] c on a.id=c.campaign_id
group by a.name;

-- 4) Write a query to get the number of conversions of Campaign 5 by state. Which state generated the most conversions for this campaign?

select Right(b.geo,2) as State, 
sum(b.conversions) as Total_Conversions 
from [PMG_Assesment].[dbo].[campaign_info] a 
left join [PMG_Assesment].[dbo].[marketing_performance] b on a.id=b.campaign_id
where a.name='Campaign5'
group by Right(b.geo,2)
order by sum(b.conversions) desc;
-- GA state generated the most conversions (672) for Campaign 5.

-- 5) In your opinion, which campaign was the most efficient, and why?

select a.name, 
sum(b.cost) as Total_Cost, 
sum(c.revenue) as Total_Revenue,
sum(c.revenue)/sum(b.cost) as Profit
from [PMG_Assesment].[dbo].[campaign_info] a 
left join [PMG_Assesment].[dbo].[marketing_performance] b on a.id=b.campaign_id
left join [PMG_Assesment].[dbo].[website_revenue] c on a.id=c.campaign_id
group by a.name
order by sum(c.revenue)/sum(b.cost) desc ;
-- Campaign 4 is the efficient campaign as it generated highest profit ( Revenue = 41.15 times the cost)

-- 6) Bonus Question : Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

 select FORMAT(CAST(date AS DATE), 'ddd') as Day, sum(conversions) as Total_Conversions , sum(Impressions) as Total_Impressions, sum(clicks) as Total_Clicks
 FROM [PMG_Assesment].[dbo].[marketing_performance]
 group by FORMAT(CAST(date AS DATE), 'ddd')
 order by sum(conversions) desc
-- Friday has the highest conversions (3457 Value). So, its the best day to run-ads


