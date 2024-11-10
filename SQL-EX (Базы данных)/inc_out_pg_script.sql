-- select * from income
drop table Income;
drop table Outcome;
drop table Outcome_o;
drop table Income_o;

CREATE TABLE Income (
	code int NOT NULL ,
	point smallint NOT NULL ,
	date timestamp NOT NULL ,
	inc decimal(12,2) NOT NULL 
) 
;

CREATE TABLE Outcome (
	code int NOT NULL ,
	point smallint NOT NULL ,
	date timestamp NOT NULL ,
	out decimal(12,2) NOT NULL 
) 
;

CREATE TABLE Income_o (
	point smallint NOT NULL ,
	date timestamp NOT NULL ,
	inc decimal(12,2) NOT NULL 
) 
;

CREATE TABLE Outcome_o (
	point smallint NOT NULL ,
	date timestamp NOT NULL ,
	out decimal(12,2) NOT NULL 
) 
;

ALTER TABLE Income  ADD 
	CONSTRAINT PK_Income PRIMARY KEY 
	(
		code
	)   
;

ALTER TABLE Outcome  ADD 
	CONSTRAINT PK_Outcome PRIMARY KEY 
	(
		code
	)   
;

ALTER TABLE Income_o  ADD 
	CONSTRAINT PK_Income_o PRIMARY KEY 
	(
		point,
		date
	)   
;

ALTER TABLE Outcome_o  ADD 
	CONSTRAINT PK_Outcome_o PRIMARY KEY 
	(
		point,
		date
	)   
;
                                                                                                                                                                                                                                                                 
----Income------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
insert into Income values(1,1,'20010322 00:00:00.000','15000.00');
insert into Income values(2,1,'20010323 00:00:00.000','15000.00');
insert into Income values(3,1,'20010324 00:00:00.000','3600.00');
insert into Income values(4,2,'20010322 00:00:00.000','10000.00');
insert into Income values(5,2,'20010324 00:00:00.000','1500.00');
insert into Income values(6,1,'20010413 00:00:00.000','5000.00');
insert into Income values(7,1,'20010511 00:00:00.000','4500.00');
insert into Income values(8,1,'20010322 00:00:00.000','15000.00');
insert into Income values(9,2,'20010324 00:00:00.000','1500.00');
insert into Income values(10,1,'20010413 00:00:00.000','5000.00');
insert into Income values(11,1,'20010324 00:00:00.000','3400.00');
insert into Income values(12,3,'20010913 00:00:00.000','1350.00');
insert into Income values(13,3,'20010913 00:00:00.000','1750.00');

                                                                                                                                                                                                                                                                 
---------Outcome-----------------
insert into Outcome values(1,1,'20010314 00:00:00.000','15348.00');
insert into Outcome values(2,1,'20010324 00:00:00.000','3663.00');
insert into Outcome values(3,1,'20010326 00:00:00.000','1221.00');
insert into Outcome values(4,1,'20010328 00:00:00.000','2075.00');
insert into Outcome values(5,1,'20010329 00:00:00.000','2004.00');
insert into Outcome values(6,1,'20010411 00:00:00.000','3195.04');
insert into Outcome values(7,1,'20010413 00:00:00.000','4490.00');
insert into Outcome values(8,1,'20010427 00:00:00.000','3110.00');
insert into Outcome values(9,1,'20010511 00:00:00.000','2530.00');
insert into Outcome values(10,2,'20010322 00:00:00.000','1440.00');
insert into Outcome values(11,2,'20010329 00:00:00.000','7848.00');
insert into Outcome values(12,2,'20010402 00:00:00.000','2040.00');
insert into Outcome values(13,1,'20010324 00:00:00.000','3500.00');
insert into Outcome values(14,2,'20010322 00:00:00.000','1440.00');
insert into Outcome values(15,1,'20010329 00:00:00.000','2006.00');
insert into Outcome values(16,3,'20010913 00:00:00.000','1200.00');
insert into Outcome values(17,3,'20010913 00:00:00.000','1500.00');
insert into Outcome values(18,3,'20010914 00:00:00.000','1150.00');

                                                                                                                                                                                                                                                                 
--------Income_o --------------
insert into Income_o values(1,'20010322 00:00:00.000','15000.00');
insert into Income_o values(1,'20010323 00:00:00.000','15000.00');
insert into Income_o values(1,'20010324 00:00:00.000','3400.00');
insert into Income_o values(1,'20010413 00:00:00.000','5000.00');
insert into Income_o values(1,'20010511 00:00:00.000','4500.00');
insert into Income_o values(2,'20010322 00:00:00.000','10000.00');
insert into Income_o values(2,'20010324 00:00:00.000','1500.00');
insert into Income_o values(3,'20010913 00:00:00.000','11500.00');
insert into Income_o values(3,'20011002 00:00:00.000','18000.00');


                                                                                                                                                                                                                                                                 
---------Outcome_o -----------
insert into Outcome_o values(1,'20010314 00:00:00.000','15348');
insert into Outcome_o values(1,'20010324 00:00:00.000','3663');
insert into Outcome_o values(1,'20010326 00:00:00.000','1221');
insert into Outcome_o values(1,'20010328 00:00:00.000','2075');
insert into Outcome_o values(1,'20010329 00:00:00.000','2004');
insert into Outcome_o values(1,'20010411 00:00:00.000','3195.04');
insert into Outcome_o values(1,'20010413 00:00:00.000','4490');
insert into Outcome_o values(1,'20010427 00:00:00.000','3110');
insert into Outcome_o values(1,'20010511 00:00:00.000','2530');
insert into Outcome_o values(2,'20010322 00:00:00.000','1440');
insert into Outcome_o values(2,'20010329 00:00:00.000','7848');
insert into Outcome_o values(2,'20010402 00:00:00.000','2040');
insert into Outcome_o values(3,'20010913 00:00:00.000','1500');
insert into Outcome_o values(3,'20010914 00:00:00.000','2300');
insert into Outcome_o values(3,'20020916 00:00:00.000','2150');