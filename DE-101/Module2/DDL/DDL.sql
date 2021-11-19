-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** calendar

CREATE TABLE calendar
(
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 year       int4range NOT NULL,
 quarter    varchar(5) NOT NULL,
 month      int4range NOT NULL,
 week       int4range NOT NULL,
 week_day   int4range NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( order_date, ship_date )
);


-- ************************************** geography

CREATE TABLE geography
(
 geo_id      serial NOT NULL,
 country     varchar(13) NOT NULL,
 city        varchar(17) NOT NULL,
 "state"       varchar(11) NOT NULL,
 region      varchar(7) NOT NULL,
 postal_code int4range NOT NULL,
 CONSTRAINT PK_49 PRIMARY KEY ( geo_id )
);


-- ************************************** product

CREATE TABLE product
(
 product_id   serial NOT NULL,
 category     varchar(13) NOT NULL,
 subcategory  varchar(11) NOT NULL,
 segment      varchar(11) NOT NULL,
 product_name varchar(137) NOT NULL,
 CONSTRAINT PK_29 PRIMARY KEY ( product_id )
);


-- ************************************** shipping

CREATE TABLE shipping
(
 ship_id   serial NOT NULL,
 ship_mode varchar(14) NOT NULL,
 CONSTRAINT PK_69 PRIMARY KEY ( ship_id )
);


-- ***************************************************;


-- ************************************** sales_fact

CREATE TABLE sales_fact
(
 order_id   varchar(14) NOT NULL,
 sales      numeric(9,4) NOT NULL,
 quantity   int4range NOT NULL,
 discount   numeric(4, 2) NOT NULL,
 profit     numeric(21,16) NOT NULL,
 order_date date NOT NULL,
 ship_id    serial NOT NULL,
 product_id serial NOT NULL,
 geo_id     serial NOT NULL,
 ship_date  date NOT NULL,
 row_id     int4range NOT NULL,
 CONSTRAINT PK_16 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_24 FOREIGN KEY ( order_date, ship_date ) REFERENCES calendar ( order_date, ship_date ),
 CONSTRAINT FK_38 FOREIGN KEY ( product_id ) REFERENCES product ( product_id ),
 CONSTRAINT FK_61 FOREIGN KEY ( geo_id ) REFERENCES geography ( geo_id ),
 CONSTRAINT FK_70 FOREIGN KEY ( ship_id ) REFERENCES shipping ( ship_id )
);

CREATE INDEX FK_26 ON sales_fact
(
 order_date,
 ship_date
);

CREATE INDEX FK_40 ON sales_fact
(
 product_id
);

CREATE INDEX FK_63 ON sales_fact
(
 geo_id
);

CREATE INDEX FK_72 ON sales_fact
(
 ship_id
);