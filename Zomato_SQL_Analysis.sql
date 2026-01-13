# to see the tables of Zomato Dataset
select * from main;
select * from country;
select * from currency;


# Important KPIs


-- Total Restaurants

select count(restaurantid) as "Total Restaurants" from main;


-- Total Countries

select count(countryID) as "Countries" from country;


-- Total Cities

select count(distinct City) as "Total Cities" from main;


-- Total Votes

select sum(votes) as "Total Votes" from main;


-- Average rating

select avg(rating) as "Average Rating" from main;


-- Average cost for two in USD

select round(avg(Average_Cost_for_two * USD_Rate)) as "Average Cost for two in USD"
from main join currency using(currency); 


-- Total Number of Cuisines

Select count(distinct cuisines) as "Total Cuisines" from main;


-- Percentage of restaurants that has table booking

select Has_Table_booking, 
concat(round((count(RestaurantID)/(select count(restaurantid) from main)*100),2)," %")
as "Percentage" from main group by Has_Table_booking;


-- Percentage of restaurants that has Online Delivery

select Has_Online_delivery, 
concat(round((count(RestaurantID)/(select count(restaurantid) from main)*100),2)," %")
as "Percentage" from main group by Has_Online_delivery;


-- Countrywise Average Cost for two

select aa.countryname as "Country",
round(avg(Average_Cost_for_two * USD_Rate)) as "Average Cost for two in USD"
from (select countryname,Average_Cost_for_two,currency 
       from main join country on main.CountryCode=country.CountryID)aa
join currency using(currency) 
group by country order by round(avg(Average_Cost_for_two * USD_Rate)) desc;


-- Rating wise number of Restaurants

select rating, count(restaurantID) as "Number of Restaurants" 
from main group by rating order by rating;


-- Number of Restaurants based on Average cost for two in USD

select case
when USDcost between 0 and 40 then "0-40"
when USDcost between 40 and 80 then "40-80"
when USDcost between 80 and 120 then "80-120"
else "Above 120"
end
as "Price_Range_in_USD",count(RestaurantID) as "Number of Restaurants"
from (select RestaurantID,round(Average_Cost_for_two * USD_Rate) as "USDcost"
from main join currency using(currency))bb group by Price_Range_in_USD ;


-- Year wise number of Restaurants Opened

select Year_Opening, count(restaurantID) from main group by Year_Opening;


-- Month wise Number of Resaturants Opened

select MONTHNAME(STR_TO_DATE(CONCAT(`year_opening`, '-', `month_opening`, '-', `Day_Opening`), '%Y-%m-%d')) as "Month",
Count(RestaurantID) as "Number_Of_Restaurants" from main group by Month order by Number_Of_Restaurants desc ;


-- Financial Quarter wise number of Restuarants Opened

select case
when Month_Opening<4 then "Q4"
when Month_Opening<7 then "Q1"
when Month_Opening<10 then "Q2"
Else "Q3"
end
as "Financial_Quarter" ,count(restaurantID) as "Number of Restaurants" from main 
group by Financial_Quarter order by Financial_Quarter;


-- Top 10 Cuisines Restaurants Wise

select cuisines,count(*) as "Number_of_Restaurants" from main group by cuisines order by Number_of_Restaurants desc limit 5;


-- To see Country Wise details
-- Type the Country of which you wish to see details

call countryKPI("India");
