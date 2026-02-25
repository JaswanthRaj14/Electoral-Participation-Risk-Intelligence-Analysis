-- Q1. How manu constituencies are there in dataset?

select count(*) as Total_constituencies from election;

-- Q2. How many states are covered?

select count(distinct state_name) as total_states from election;

-- Q3. What is the Average voter turnout overall?

select round(cast(avg(turnout_percentage) as numeric), 2) as avg_turnout
from election;

-- Q4. Which state have Highest Average turnout?

select round(cast(avg(turnout_percentage) as numeric), 2) as avg_turnout
from election group by state_name order by avg_turnout Desc;

-- Q5. Which constituencies show declining turnout?

select state_name, ac_name, turnout_change, future_decline_flag
from election where future_decline_flag = 1 order by turnout_change asc;

-- Q6. Does higher number of candidates increase turnout?

select ac_total_candidates, round(cast(avg(turnout_percentage) as numeric), 2) as avg_turnout
from election group by ac_total_candidates order by ac_total_candidates;

-- Q7. Which constituencies should be prioritised?

select state_name, ac_name, risk_score
from election order by risk_score desc limit 20;

-- Q8. Which states have highest participation volatility?

select state_name, round(cast(avg(turnout_volatility)as numeric), 2) as avg_volatility
from election  group by state_name  order by avg_volatility desc;

-- Q9. High electorate but low participation (Impact Zones)

select state_name, ac_name, total_electors, turnout_percentage
from election where turnout_percentage < (select avg(turnout_percentage) from election)
and total_electors > (select avg(total_electors) from election)
order by total_electors desc;

-- Q10. Top 3 risky constituencies per state

select * from ( select state_name, ac_name, risk_score, row_number()
over(partition by state_name order by  risk_score desc) as rank_in_state from election) ranked
where rank_in_state <= 3;

-- Q11. Risk Category Segmentation
select state_name, ac_name, risk_score,
case 
     when risk_score >= 80 then 'Critical'
     when risk_score >= 60 then 'High'
	 when risk_score >= 40 then 'Moderate'
     else 'low'
end as risk_category
from election
order by risk_score desc;
