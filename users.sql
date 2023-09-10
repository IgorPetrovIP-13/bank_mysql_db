use coursework;

drop role if exists administrator;
create role administrator;
grant all on coursework.* to administrator;

drop user if exists administrator@localhost;
create user administrator@localhost identified by 'administrator';
grant administrator to administrator@localhost;

drop role if exists employee;
create role employee;
grant select on coursework.* to employee;
grant insert, update, delete on table coursework.customer to employee;
grant insert, update, delete on table coursework.card to employee;
grant insert, update, delete on table coursework.loan to employee;
grant insert, update, delete on table coursework.deposit to employee;
grant insert, update, delete on table coursework.customer_request to employee;
grant select on coursework.atm to employee;
grant select on coursework.bank_branch to employee;

drop user if exists employee@localhost;
create user employee@localhost identified by 'employee';
grant employee to employee@localhost;

drop role if exists customer;
create role customer;
grant select on coursework.customer to customer;
grant select on coursework.card to customer;
grant select on coursework.loan to customer;
grant select on coursework.deposit to customer;
grant select on coursework.customer_request to customer;

drop user if exists customer@localhost;
create user customer@localhost identified by 'customer';
grant customer to customer@localhost;

