USE coursework;

#1 total cards
drop view if exists customer_data;
create or replace view customer_data as
select concat(first_name, ' ', last_name) as full_name,
       email,
       phone_number,
       count(card_number)                 as total_cards,
       sum(c.total_cache) as total_cache
from customer
         inner join card c on customer.id = c.customer_id
group by full_name, email, phone_number;
select *
from customer_data;

#2 request data
drop view if exists request_data;
create or replace view request_data as
select concat(first_name, ' ', last_name) as full_name,
       phone_number,
       purpose,
       short_description,
       bb.address                         as bank_address
from customer_request
         inner join customer c on customer_request.customer_id = c.id
         inner join bank_branch bb on customer_request.bank_branch_id = bb.id;
select *
from request_data;

#3 Atms which will need refill soon
select atm.id as atm_id, refill_date, cache_amount, cache_lower_limit, bb.address
from atm
         inner join bank_branch bb on atm.bank_branch_id = bb.id
where (cache_amount - cache_lower_limit) < 1000;

#4 loan information
drop view if exists loan_information;
create view loan_information as
select c.id as customer_id,
       concat(first_name, ' ', last_name)                                   as full_name,
       monthly_payment * total_months                                       as total_loan,
       total_months_paid * monthly_payment                                  as already_paid,
       monthly_payment * total_months - total_months_paid * monthly_payment as need_to_pay
from loan
         inner join customer c on loan.customer_id = c.id;
select *
from loan_information;

#5 deposit information
drop view if exists deposit_information;
create view deposit_information as
select c.id as customer_id,
       concat(first_name, ' ', last_name)                             as full_name,
       start_sum,
       start_sum + start_sum * (interest_rate / 100 * months_in_bank) as current_sum,
       start_sum * (interest_rate / 100 * months_in_bank)             as earned
from deposit
         inner join customer c on deposit.customer_id = c.id;
select *
from deposit_information;

#6 active cards
select card.id as card_id, card_number, count(*) as transfer_count, sum(sum) as outgoing_sum
from card
         inner join customer c on card.customer_id = c.id
         inner join outgoing_transaction ot on card.id = ot.card_id
where ot.transaction_time between date_sub(now(), interval 3 month) and now()
group by card.id;

#7 employees with bank branches
drop view if exists bank_employees;
create view bank_employees as
select bank_branch.id as bank_id, address, concat(first_name, ' ', last_name) as full_name, experience
from bank_branch
         inner join employee e on bank_branch.id = e.bank_branch_id;
select *
from bank_employees;

#8 chief employees
select be1.bank_id,
       be1.full_name as chief_employee,
       be1.experience
from bank_employees be1
         join (select bank_id, max(experience) as experience
               from bank_employees
               group by bank_id) AS be2
              on be1.bank_id = be2.bank_id and be1.experience = be2.experience
order by bank_id;

#9 debit and credit total cache
select type, COUNT(*) as total_cards, round(SUM(total_cache), 2) as total_cache
from card
         join customer on card.customer_id = customer.id
where customer.credit_score > 500
group by type;

#10 atm cache
select bank_branch.address, count(distinct atm.id) as total_atms, sum(cache_amount) as total_cache
from atm
         join bank_branch on atm.bank_branch_id = bank_branch.id
group by bank_branch.address;

#11 average property prices
select object,
       COUNT(*) as total_loans,
       avg(monthly_payment) as avg_monthly_payment,
       round(avg(monthly_payment * total_months - monthly_payment * total_months *
                                                  (total_interest_rate / 100))) as average_price
from loan
group by object;

#12 total credits paid
select first_name, last_name, credit_score, SUM(total_months_paid * loan.monthly_payment) as total_paid
from loan
         join customer on loan.customer_id = customer.id
group by first_name, last_name, credit_score;

#13 last outgoing transaction
select concat(first_name, ' ', last_name) as full_name, card_number, max(transaction_time) as last_transaction_time
from customer
         join card c2 on customer.id = c2.customer_id
         join outgoing_transaction ot on c2.id = ot.card_id
group by card_number;

#14 total salary for each branch
select bank_branch.id, address, sum(salary) as total_salary
from bank_branch
         join employee e on bank_branch.id = e.bank_branch_id
group by bank_branch.id, address;

#15 total requests for each branch
select bank_branch.id, address, count(*) as total_requests
from bank_branch
join customer_request cr on bank_branch.id = cr.bank_branch_id
group by bank_branch.id, address;

#16 the most popular outgoing operations
select purpose, count(*) as total_operations, count(distinct card_number) as total_unique_cards
from card
join outgoing_transaction ot on card.id = ot.card_id
group by purpose
order by total_operations desc;

#17 the most popular incoming operations
select purpose, count(*) as total_operations, count(distinct card_number) as total_unique_cards
from card
join incoming_transaction it on card.id = it.card_id
group by purpose
order by total_operations desc;

#18 cards expire soon
select concat(first_name, ' ', last_name) as full_name, card_number, total_cache, expiration_date
from card
join customer c on card.customer_id = c.id
where card.expiration_date between now() and date_add(now(), interval 1 year);

#19 month incoming transactions sum
select concat(first_name, ' ', last_name) as full_name, round(sum(it.sum), 2) as received
from customer
inner join card c on customer.id = c.customer_id
inner join incoming_transaction it on c.id = it.card_id
group by customer.id;

#20 last loans
select concat(first_name, ' ', last_name) as full_name, credit_score, total_months_paid
from customer
inner join loan l on customer.id = l.customer_id
where total_months_paid <= 12 and total_months > 12;