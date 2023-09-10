use coursework;

drop temporary table if exists index_test;
create temporary table index_test AS
select customer.id, customer.first_name, customer. last_name, c.card_number, c.expiration_date
from customer
cross join card c;

explain analyze
select distinct card_number
FROM index_test
where card_number = '5108758923625902';

drop index index_view_test on index_test;
create index index_view_test
ON index_test(card_number);

explain analyze
select distinct card_number
FROM index_test
where card_number = '5108758923625902';