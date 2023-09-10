DROP DATABASE IF EXISTS COURSEWORK;
CREATE DATABASE IF NOT EXISTS COURSEWORK;
USE COURSEWORK;

drop table if exists atm;
drop table if exists employee;
drop table if exists bank_branch;
drop table if exists customer_request;
drop table if exists customer;
drop table if exists deposit;
drop table if exists loan;
drop table if exists card;
drop table if exists incoming_transaction;
drop table if exists outgoing_transaction;

create table atm
(
    id int not null auto_increment,
    bank_branch_id int not null,
    cache_amount float not null,
    cache_lower_limit float not null,
    cache_upper_limit float not null,
    refill_date date not null,
    controller enum('sensor', 'mechanical') not null,
    last_transaction_datetime datetime,
    primary key (id)
);

create table employee
(
    id int not null auto_increment,
    bank_branch_id int not null,
    first_name nvarchar(255) not null,
    last_name nvarchar(255) not null,
    phone_number nvarchar(15) not null,
    experience tinyint not null,
    email nvarchar(255) unique not null,
    salary int not null,
    primary key (id)
);

create table bank_branch
(
    id int not null auto_increment,
    address nvarchar(255) not null,
    opening_time time not null,
    closing_time time not null,
    primary key (id)
);

create table customer_request
(
    id int not null auto_increment,
    customer_id int not null,
    bank_branch_id int not null,
    application_time datetime not null,
    purpose nvarchar(255) not null,
    short_description nvarchar(255) not null,
    primary key (id)
);

create table customer
(
    id int not null auto_increment,
    first_name nvarchar(255) not null,
    last_name nvarchar(255) not null,
    phone_number nvarchar(15) not null,
    email nvarchar(255) unique not null,
    address nvarchar(255),
    credit_score int not null,
    primary key (id)
);

create table deposit
(
    id int not null auto_increment,
    customer_id int not null,
    start_sum int not null,
    interest_rate int not null,
    months_in_bank int not null,
    primary key (id)
);

create table loan
(
    id int not null auto_increment,
    customer_id int not null,
    total_interest_rate int not null,
    monthly_payment int not null,
    total_months int not null,
    total_months_paid int not null,
    object nvarchar(255) not null,
    primary key (id)
);

create table card
(
    id int not null auto_increment,
    customer_id int not null,
    type enum('debit', 'credit'),
    total_cache float unsigned not null,
    credit_limit int unsigned not null,
    card_number nvarchar(255) unique not null,
    cvv nvarchar(3) not null,
    pin nvarchar(4) not null,
    expiration_date date not null,
    primary key (id)
);

create table incoming_transaction
(
    id int not null auto_increment,
    card_id int not null,
    sender nvarchar(255) not null,
    sum float not null,
    purpose nvarchar(255) not null,
    transaction_time datetime not null,
    primary key (id)
);

create table outgoing_transaction
(
    id int not null auto_increment,
    card_id int not null,
    recipient nvarchar(255) not null,
    sum float not null,
    purpose nvarchar(255) not null,
    transaction_time datetime not null,
    primary key (id)
);