USE coursework;

alter table atm
add constraint atm_fk
foreign key (bank_branch_id) references bank_branch(id)
on delete cascade;

alter table employee
add constraint employee_fk
foreign key (bank_branch_id) references bank_branch(id)
on delete cascade;

alter table customer_request
add constraint request_bank_fk
foreign key (bank_branch_id) references bank_branch(id)
on delete cascade;

alter table customer_request
add constraint request_customer_fk
foreign key (customer_id) references customer(id)
on delete cascade;

alter table deposit
add constraint deposit_fk
foreign key (customer_id) references customer(id)
on delete cascade;

alter table loan
add constraint loan_fk
foreign key (customer_id) references customer(id)
on delete cascade;

alter table card
add constraint card_fk
foreign key (customer_id) references customer(id)
on delete cascade;

alter table incoming_transaction
add constraint incoming_fk
foreign key (card_id) references card(id)
on delete cascade;

alter table outgoing_transaction
add constraint outgoing_fk
foreign key (card_id) references card(id)
on delete cascade;

