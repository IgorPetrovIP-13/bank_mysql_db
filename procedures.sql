USE coursework;

drop function if exists total_loans_and_deposits;
delimiter $$
create function total_loans_and_deposits(customer_id int) returns decimal
    deterministic
begin
    declare total_loans decimal default 0;
    declare total_deposits decimal default 0;
    select count(*)
    from loan
    where customer_id = loan.customer_id
    into total_loans;
    select count(*)
    from deposit
    where customer_id = deposit.customer_id
    into total_deposits;
    return total_deposits + total_loans;
end $$
delimiter ;

drop function if exists total_cache;
delimiter $$
create function total_cache(customer_id int) returns decimal
    deterministic
begin
    declare total decimal default 0;
    select sum(card.total_cache)
    from card
    inner join customer on card.customer_id = customer.id
    where customer_id = customer.id
    into total;
    return total;
end $$
delimiter ;
select total_cache(1);

drop procedure if exists low_cache_level;
delimiter $$
create procedure low_cache_level(in cache_level float)
begin
    select concat(first_name, ' ', last_name) as full_name, total_cache(customer.id) as cache_level
    from customer
    where total_cache(customer.id) <= cache_level;
end $$
delimiter ;
call low_cache_level(15000);

drop procedure if exists month_spending;
delimiter $$
create procedure month_spending(in customer_id int)
begin
    select concat(first_name, ' ', last_name) as full_name, round(sum(ot.sum), 2) as spent
    from customer
    inner join card c on customer.id = c.customer_id
    inner join outgoing_transaction ot on c.id = ot.card_id
    where customer_id = customer.id
    group by customer.id;
end $$
delimiter ;
call month_spending(1);