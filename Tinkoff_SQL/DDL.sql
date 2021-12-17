
-- таблица самолетов

CREATE TABLE planes
(
 plane_id  int NOT NULL,
 capacity  int NOT NULL,
 cargo_flg int NOT NULL,
 CONSTRAINT PK_43 PRIMARY KEY ( plane_id )
);

-- таблица пилотов

CREATE TABLE Pilots
(
 pilot_id        int NOT NULL,
 name            varchar(50) NOT NULL,
 age             int NOT NULL,
 runk            int NOT NULL,
 education_level int NOT NULL,
 CONSTRAINT PK_36 PRIMARY KEY ( pilot_id )
);


-- таблица полетов

CREATE TABLE Flights
(
 plane_id        int NOT NULL,
 first_pilot_id  int NOT NULL,
 second_pilot_id int NOT NULL,
 destination     varchar(50) NOT NULL,
 quantity        int NOT NULL,
 flight_id       int NOT NULL,
 flight_dt       date NOT NULL,
 CONSTRAINT PK_48 PRIMARY KEY ( flight_id, flight_dt ),
 CONSTRAINT FK_52 FOREIGN KEY ( plane_id ) REFERENCES planes ( plane_id ),
 CONSTRAINT FK_64 FOREIGN KEY ( first_pilot_id ) REFERENCES Pilots ( pilot_id ),
 CONSTRAINT FK_68 FOREIGN KEY ( second_pilot_id ) REFERENCES Pilots ( pilot_id )
);

CREATE INDEX FK_54 ON Flights
(
 plane_id
);

CREATE INDEX FK_66 ON Flights
(
 first_pilot_id
);

CREATE INDEX FK_70 ON Flights
(
 second_pilot_id
);







