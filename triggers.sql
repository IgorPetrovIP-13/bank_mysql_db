use coursework;

drop trigger if exists low_credit_score;
delimiter $$
create trigger low_credit_score before insert on loan for each row
begin
    if new.customer_id in (select id
                from customer
                where customer.credit_score < 500) then
        signal sqlstate '45000'
            set message_text = 'Credit score is too low to get a loan.';
    end if;
end $$
delimiter ;
insert into loan(id, customer_id,total_interest_rate,monthly_payment,total_months,total_months_paid,object) value (null,8,8,40000,96,0,'house');

drop trigger if exists removing_client;
delimiter $$
create trigger removing_client before delete on customer for each row
begin
    if ((total_loans_and_deposits(old.id) > 0)
            or (total_cache(old.id)) > 4000) then
        signal sqlstate '45000'
            set message_text = 'Cant delete customer from database';
    end if;
end $$
delimiter ;
delete from customer where customer.id = 8;