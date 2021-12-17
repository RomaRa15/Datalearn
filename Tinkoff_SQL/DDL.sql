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

