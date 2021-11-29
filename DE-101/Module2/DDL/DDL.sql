/* создание таблицы calendar_dim */
drop table if exist calendar_dim cascade
CREATE TABLE calendar_dim
(
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 year       int NOT NULL,
 quarter    varchar(5) NOT NULL,
 month      int NOT NULL,
 week       int NOT NULL,
 week_day   int NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( order_date, ship_date )
);

/* добавление записей в таблицу calendar_dim */
insert into calendar_dim 
select order_date, ship_date, 
date_part('year', order_date) as year, 
date_part('quarter', order_date) as quarter, 
date_part('month', order_date) as month, 
date_part('week', order_date) as week, 
EXTRACT(ISODOW FROM order_date) as week_day
from (select distinct order_date, ship_date from stg.orders) a;

/* создание таблицы product_dim */
CREATE TABLE main.product_dim
(
 prod_id      serial NOT NULL,
 product_id   varchar(25) NOT NULL,
 category     varchar(25) NOT NULL,
 subcategory  varchar(20) NOT NULL,
 segment      varchar(20) NOT NULL,
 product_name varchar(137) NOT NULL,
 CONSTRAINT PK_29 PRIMARY KEY ( prod_id )
);

/* добавление уникальных записей товаров в таблицу product_dim */
insert into main.product_dim
select row_number() over (),
product_id, category, subcategory, segment, product_name 
from (select distinct on (product_id) product_id, category, subcategory, segment, product_name from stg.orders) a;

/* создание таблицы geopraphy_dim */
CREATE TABLE geography_dim
(
 geo_id      serial NOT NULL,
 country     varchar(13) NOT NULL,
 city        varchar(17) NOT NULL,
 "state"       varchar(20) NOT NULL,
 region      varchar(7) NOT NULL,
 postal_code int NULL,
 CONSTRAINT PK_49 PRIMARY KEY ( geo_id )
);

/* добавление уникальных записей географических данных в таблицу geography_dim_dim. в postal_code был NOT NULL и int4range -> выдавал ошибку, поменял на NULL и int*/
insert into main.geography_dim
select row_number () over (), country, city, state, region, postal_code
from (select distinct country, city, state, region, postal_code from stg.orders) a;

/* создание shipping_dim */
CREATE TABLE shipping_dim
(
 ship_id   serial NOT NULL,
 ship_mode varchar(14) NOT NULL,
 CONSTRAINT PK_69 PRIMARY KEY ( ship_id )
);

/* добавлению уникальных способов доставки, всего 4 */
insert into main.shipping_dim
select row_number () over (), ship_mode
from (select distinct ship_mode from stg.orders o) a;


/* создание таблицы клиентов */
CREATE TABLE sales_fact
(
 row_id     integer NOT NULL,
 order_id   varchar(14) NOT NULL,
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 ship_id    serial NOT NULL,
 cust_key   integer NOT NULL,
 geo_id     serial NOT NULL,
 prod_id    serial NOT NULL,
 sales      numeric(9,4) NOT NULL,
 quantity   integer NOT NULL,
 discount   numeric(4, 2) NOT NULL,
 profit     numeric(21,16) NOT NULL,
 CONSTRAINT PK_16 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_24 FOREIGN KEY ( order_date, ship_date ) REFERENCES calendar_dim ( order_date, ship_date ),
 CONSTRAINT FK_38 FOREIGN KEY ( prod_id ) REFERENCES product_dim ( prod_id ),
 CONSTRAINT FK_61 FOREIGN KEY ( geo_id ) REFERENCES geography_dim ( geo_id ),
 CONSTRAINT FK_70 FOREIGN KEY ( ship_id ) REFERENCES shipping_dim ( ship_id ),
 CONSTRAINT FK_89 FOREIGN KEY ( cust_key ) REFERENCES customer_dim ( cust_key )
);

CREATE INDEX FK_26 ON sales_fact
(
 order_date,
 ship_date
);

CREATE INDEX FK_40 ON sales_fact
(
 prod_id
);

CREATE INDEX FK_63 ON sales_fact
(
 geo_id
);

CREATE INDEX FK_72 ON sales_fact
(
 ship_id
);

CREATE INDEX FK_91 ON sales_fact
(
 cust_key
);


/* добавлению записей в результирующую таблицу */
insert into sales_fact
select row_id, order_id, order_date, ship_date, ship_id, cust_key, geo_id, prod_id, sales, quantity, discount, profit
from (
select o.row_id, o.order_id, o.order_date, o.ship_date, s.ship_id, c.cust_key, p.prod_id, g.geo_id, o.sales, o.quantity,
o.discount, o.profit
from stg.orders as o 
left join main.shipping_dim as s  on o.ship_mode = s.ship_mode
left join main.customer_dim as c  on o.customer_id  = c.customer_id
left join main.product_dim as p  on o.product_id  = p.product_id
left join main.geography_dim as g on o.city  = g.city and o.postal_code = g.postal_code) a;
