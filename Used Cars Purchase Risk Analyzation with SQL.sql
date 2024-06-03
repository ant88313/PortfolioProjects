/*
Used Car Transactions Data Exploration 

Please view the "The Used Car Project Report - SQL" file for the final report for this project.

Data that been used in this profect is "Used Car Purchase Data.csv"

*/


--	Create UsedCarTest database

USE [master]
GO

/****** Object:  Database [UsedCar]    Script Date: 11/4/2021 5:04:46 PM ******/
DROP DATABASE [UsedCarTest]
GO

/****** Object:  Database [UsedCar]    Script Date: 11/4/2021 5:04:46 PM ******/
CREATE DATABASE [UsedCarTest]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UsedCar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UsedCarTest_Data.mdf' , SIZE = 109504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'Food_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UsedCarTest_Log.ldf' , SIZE = 193536KB , MAXSIZE = 2048GB , FILEGROWTH = 1024KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

USE UsedCarTest
GO


--	Create UsedCar table

/****** Object:  Table [dbo].[UsedCar]    Script Date: 11/4/2021 5:03:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsedCar]') AND type in (N'U'))
DROP TABLE [dbo].[UsedCar]
GO

/****** Object:  Table [dbo].[UsedCarFile]    Script Date: 11/4/2021 5:03:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsedCarFile](
	[VehId][varchar] (100) NULL,
	[IsBadBuy][varchar] (100) NULL,
	[PurchDate][varchar] (100) NULL,
	[Auction][varchar] (100) NULL,
	[VehYear][varchar] (100) NULL,
	[VehicleAge][varchar] (100) NULL,
	[Make][varchar] (100) NULL,
	[Model][varchar] (100) NULL,
	[SubModel][varchar] (100) NULL,
	[Color][varchar] (100) NULL,
	[Transmission][varchar] (100) NULL,
	[WheelTypeID][varchar] (100) NULL,
	[WheelType][varchar] (100) NULL,
	[VehMeter][varchar] (100) NULL,
	[Nationality][varchar] (100) NULL,
	[Size][varchar] (100) NULL,
	[TopThreeAmericanName][varchar] (100) NULL,
	[AcquisitionAuctionAveragePrice][varchar] (100) NULL,
	[AcquisitionRetailAveragePrice][varchar] (100) NULL,
	[CurrentAuctionAveragePrice][varchar] (100) NULL,
	[CurrentRetailAveragePrice][varchar] (100) NULL,
	[PRIMEUNIT][varchar] (100) NULL,
	[AUCGUART][varchar] (100) NULL,
	[BuyerNumber][varchar] (100) NULL,
	[VehPurchState][varchar] (100) NULL,
	[VehBCost][varchar] (100) NULL,
	[IsOnlineSale][varchar] (100) NULL,
	[WarrantyCost][varchar] (100) NULL
) ON [PRIMARY]
GO

--	Load UsedCar table from .csv using BULK INSERT
--	**Change the path to where you stored the csv file**


bulk insert UsedCarFile
from 'C:\Users\chch_chen\Desktop\Amber\Master\RPI\Courses_Assignment\2023Fall\MGMT 6570 _Advanced Data Resource Management\Project\DontGetKicked.csv'
with (format = 'csv',
	  firstrow = 2)

select*
from UsedCarFile

------------------------------------
--	Create the dimension tables
------------------------------------

-- drop factSales table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'factSales') AND type in (N'U'))
DROP TABLE factSales
GO

--	create table called dimVehicle
-- drop dimVehicle table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dimVehicle') AND type in (N'U'))
DROP TABLE dimVehicle
GO

--	create dimVehicle table
CREATE TABLE dimVehicle(
	VehId Int not null
		constraint PK_dimVehicle primary key clustered (VehId),
	VehYear int,
	VehicleAge int,
	Model varchar(40),
	SubModel varchar(60),
	Color varchar(15),
	Transmission varchar(15),
	WheelTypeID varchar(15),
	WheelType varchar(15),
	VehMeter varchar(20),
	Size varchar(15),
	VehPurchState varchar(20),
	VehBCost varchar(20)
)

select*
from dimVehicle

--	insert data into the dimVehicle table from the UsedCarFile
INSERT INTO dimVehicle
select
	VehId,
	VehYear,
	VehicleAge,
	Model,
	SubModel,
	Color,
	Transmission,
	WheelTypeID,
	WheelType,
	VehMeter =
		case
			WHEN cast(vehmeter as int) >= 0 AND cast(vehmeter as int) < 20000 then '0 - 2W Miles'
			WHEN cast(vehmeter as int) >= 20000 AND cast(vehmeter as int) < 40000 then '2W - 4W Miles'
			WHEN cast(vehmeter as int) >= 40000 AND cast(vehmeter as int) < 60000 then '4W - 6W Miles'
			WHEN cast(vehmeter as int) >= 60000 AND cast(vehmeter as int) < 80000 then '6W - 8W Miles'
			WHEN cast(vehmeter as int) >= 80000 AND cast(vehmeter as int) < 100000 then '8W - 10W Miles'
			else 'Over 10W Miles'
		end,
	Size,
	VehPurchState =
		--SELECT distinct 'WHEN VehPurchState = ''' + VehPurchState + ''' THEN ' + CAST(VehPurchState AS varchar(3))
		--FROM UsedCarFile
		case
			WHEN VehPurchState = 'WV' THEN 'West Virginia'
			WHEN VehPurchState = 'NE' THEN 'Nebraska'
			WHEN VehPurchState = 'NH' THEN 'New Hampshire'
			WHEN VehPurchState = 'TN' THEN 'Tennessee'
			WHEN VehPurchState = 'AZ' THEN 'Arizona'
			WHEN VehPurchState = 'OR' THEN 'Oregon'
			WHEN VehPurchState = 'NJ' THEN 'New Jersey'
			WHEN VehPurchState = 'NC' THEN 'North Carolina'
			WHEN VehPurchState = 'UT' THEN 'Utah'
			WHEN VehPurchState = 'TX' THEN 'Texas'
			WHEN VehPurchState = 'WA' THEN 'Washington'
			WHEN VehPurchState = 'NY' THEN 'New York'
			WHEN VehPurchState = 'LA' THEN 'Louisiana'
			WHEN VehPurchState = 'NV' THEN 'Nevada'
			WHEN VehPurchState = 'FL' THEN 'Florida'
			WHEN VehPurchState = 'IA' THEN 'Iowa'
			WHEN VehPurchState = 'MS' THEN 'Mississippi'
			WHEN VehPurchState = 'SC' THEN 'South Carolina'
			WHEN VehPurchState = 'GA' THEN 'Georgia'
			WHEN VehPurchState = 'OK' THEN 'Oklahoma'
			WHEN VehPurchState = 'CO' THEN 'Colorado'
			WHEN VehPurchState = 'CA' THEN 'California'
			WHEN VehPurchState = 'AL' THEN 'Alabama'
			WHEN VehPurchState = 'ID' THEN 'Idaho'
			WHEN VehPurchState = 'IN' THEN 'Indiana'
			WHEN VehPurchState = 'AR' THEN 'Arkansas'
			WHEN VehPurchState = 'MA' THEN 'Massachusetts'
			WHEN VehPurchState = 'PA' THEN 'Pennsylvania'
			WHEN VehPurchState = 'MI' THEN 'Michigan'
			WHEN VehPurchState = 'MO' THEN 'Missouri'
			WHEN VehPurchState = 'IL' THEN 'Illinois'
			WHEN VehPurchState = 'MD' THEN 'Maryland'
			WHEN VehPurchState = 'NM' THEN 'New Mexico'
			WHEN VehPurchState = 'OH' THEN 'Ohio'
			WHEN VehPurchState = 'KY' THEN 'Kentucky'
			WHEN VehPurchState = 'VA' THEN 'Virginia'
			WHEN VehPurchState = 'MN' THEN 'Minnesota'
		end,
	VehBCost =
		case
			WHEN cast(VehBCost as float) >= 0 AND cast(VehBCost as float) < 2000 then '$0 - $2K'
			WHEN cast(VehBCost as float) >= 2000 AND cast(VehBCost as float) < 4000 then '$2K - $4K'
			WHEN cast(VehBCost as float) >= 4000 AND cast(VehBCost as float) < 6000 then '$4K - $6K'
			WHEN cast(VehBCost as float) >= 6000 AND cast(VehBCost as float) < 8000 then '$6K - $8K'
			WHEN cast(VehBCost as float) >= 8000 AND cast(VehBCost as float) < 10000 then '$8K - $10K'
			else 'Over $10K'
		end
from UsedCarFile

--select distinct vehmeter, count(vehmeter)
--from dimVehicle
--group by vehmeter
--order by vehmeter desc

--	check the dimVehicle table
select *
from dimVehicle



--	create table called dimBuyer
-- drop dimBuyer table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dimBuyer') AND type in (N'U'))
DROP TABLE dimBuyer
GO

--	create dimBuyer table
CREATE TABLE dimBuyer(
	BuyerID INT IDENTITY(1,1) not null,
		constraint PK_dimBuyer primary key clustered (BuyerID),
	BuyerNumber varchar(15),

)

--	insert data into the dimBuyer table from the UsedCarFile
INSERT INTO dimBuyer
select distinct
	BuyerNumber
from UsedCarFile



--	check the dimBuyer table
select*
from dimBuyer



--	create table called dimSeller
-- drop dimSeller table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dimSeller') AND type in (N'U'))
DROP TABLE dimSeller
GO

--	create dimSeller table
CREATE TABLE dimSeller(
	SellerID INT IDENTITY(1,1) not null,
		constraint PK_dimSeller primary key clustered (SellerID),
	Auction varchar(10)
)

--	insert data into the dimSeller table from the UsedCarFile
INSERT INTO dimSeller
select
	Auction
from UsedCarFile

--	check the dimSeller table
select *
from dimSeller



--	create table called dimManufacturer
-- drop dimManufacturer table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dimManufacturer') AND type in (N'U'))
DROP TABLE dimManufacturer
GO

--	create dimManufacturer table
CREATE TABLE dimManufacturer(
	ManufacturerID INT IDENTITY(1,1) not null,
		constraint PK_dimManufacturer primary key clustered (ManufacturerID),
	Make varchar(25),
	Nationality varchar(25),
	TopThreeAmericanName varchar(20)
)

--	insert data into the dimManufacturer table from the UsedCarFile
INSERT INTO dimManufacturer
select
	Make,
	Nationality,
	TopThreeAmericanName
from UsedCarFile

--	check the dimManufacturer table
select *
from dimManufacturer



--	create table called dimDate
-- drop dimDate table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dimDate') AND type in (N'U'))
DROP TABLE dimDate
GO

--	create dimDate table
CREATE TABLE dimDate(
	DateID INT IDENTITY(1,1) not null,
		constraint PK_dimDate primary key clustered (DateID),
	PurchDate date
)

--	insert data into the dimDate table from the UsedCarFile
INSERT INTO dimDate
select
	PurchDate
from UsedCarFile

--	check the dimDate table
select PurchDate
from dimDate






--	create table called factSales


--	create factSales table
CREATE TABLE factSales(
	DealID INT IDENTITY(1,1) not null,
		constraint PK_factSales primary key clustered (DealID),
	VehId int,
		CONSTRAINT FK_dimVehicle_factSales FOREIGN KEY (VehId)
		REFERENCES dimVehicle (VehId),
	BuyerNumberID int,
		CONSTRAINT FK_dimBuyer_factSales FOREIGN KEY (BuyerNumberID)
		REFERENCES dimBuyer (BuyerID),
	SellerAuctionType int,
		CONSTRAINT FK_dimSeller_factSales FOREIGN KEY (SellerAuctionType)
		REFERENCES dimSeller (SellerID),
	ManufacturerType int,
		CONSTRAINT FK_dimManufacturer_factSales FOREIGN KEY (ManufacturerType)
		REFERENCES dimManufacturer (ManufacturerID),
	YearID int,
		CONSTRAINT FK_dimDate_factSales FOREIGN KEY (YearID)
		REFERENCES dimDate (DateID),
	MonthID int,
	DayID int,
	IsBadBuy INT,
	IsOnlineSale varchar(5),
	AcquisitionAuctionAveragePrice money,
	AcquisitionRetailAveragePrice money,
	CurrentAuctionAveragePrice money,
	CurrentRetailAveragePrice money, 
	VehBCost money,
	PRIMEUNIT varchar(5),
	AUCGUART varchar(10),
	WarrantyCost money,             
	PurchDate date,
	VehPurchState varchar(5)                
)

--select distinct 'when Make = ''' + Make + ''' then' as ab
--from dimManufacturer
--order by ab

SELECT DISTINCT 'when day(PurchDate) = ''' + CONVERT(VARCHAR, day(PurchDate)) + ''' then ' AS ab
FROM dimDate
order by ab

--	insert data into the factSales table from the UsedCarFile
INSERT INTO factSales
select
	VehId,
	BuyerNumberID = 
		case
			when BuyerNumber =　17675　then 1 
			when BuyerNumber = 20392 then 2 
			when BuyerNumber = 20234 then 3 
			when BuyerNumber = 10430 then 4 
			when BuyerNumber = 1085 then 5 
			when BuyerNumber = 16926 then 6 
			when BuyerNumber = 19064 then 7 
			when BuyerNumber = 22808 then 8 
			when BuyerNumber = 10425 then 9 
			when BuyerNumber = 1081 then 10 
			when BuyerNumber = 53245 then 11 
			when BuyerNumber = 52646 then 12 
			when BuyerNumber = 1055 then 13 
			when BuyerNumber = 10310 then 14 
			when BuyerNumber = 8172 then 15 
			when BuyerNumber = 1125 then 16 
			when BuyerNumber = 10510 then 17 
			when BuyerNumber = 5546 then 18 
			when BuyerNumber = 16044 then 19 
			when BuyerNumber = 21973 then 20 
			when BuyerNumber = 18822 then 21 
			when BuyerNumber = 1082 then 22 
			when BuyerNumber = 1086 then 23 
			when BuyerNumber = 18091 then 24 
			when BuyerNumber = 99760 then 25 
			when BuyerNumber = 1051 then 26 
			when BuyerNumber = 1156 then 27 
			when BuyerNumber = 1157 then 28 
			when BuyerNumber = 99741 then 29 
			when BuyerNumber = 1031 then 30 
			when BuyerNumber = 3453 then 31 
			when BuyerNumber = 1191 then 32 
			when BuyerNumber = 52644 then 33 
			when BuyerNumber = 99761 then 34 
			when BuyerNumber = 22916 then 35 
			when BuyerNumber = 1041 then 36 
			when BuyerNumber = 52117 then 37 
			when BuyerNumber = 17212 then 38 
			when BuyerNumber = 18880 then 39 
			when BuyerNumber = 1231 then 40 
			when BuyerNumber = 10315 then 41 
			when BuyerNumber = 52492 then 42 
			when BuyerNumber = 21053 then 43 
			when BuyerNumber = 16369 then 44 
			when BuyerNumber = 1121 then 45 
			when BuyerNumber = 1235 then 46 
			when BuyerNumber = 18111 then 47 
			when BuyerNumber = 52598 then 48 
			when BuyerNumber = 10410 then 49 
			when BuyerNumber = 835 then 50 
			when BuyerNumber = 21047 then 51 
			when BuyerNumber = 20928 then 52 
			when BuyerNumber = 99740 then 53 
			when BuyerNumber = 11410 then 54 
			when BuyerNumber = 1152 then 55 
			when BuyerNumber = 23657 then 56 
			when BuyerNumber = 3582 then 57 
			when BuyerNumber = 11210 then 58
			when BuyerNumber = 19662 then 59
			when BuyerNumber = 1045 then 60
			when BuyerNumber = 1035 then 61
			when BuyerNumber = 23359 then 62
			when BuyerNumber = 19638 then 63
			when BuyerNumber = 8655 then 64
			when BuyerNumber = 20740 then 65
			when BuyerNumber = 20207 then 66
			when BuyerNumber = 19619 then 67
			when BuyerNumber = 25100 then 68
			when BuyerNumber = 10420 then 69
			when BuyerNumber = 99750 then 70
			when BuyerNumber = 1141 then 71
			when BuyerNumber = 1151 then 72
			when BuyerNumber = 18881 then 73
			when BuyerNumber = 20833 then 74
		end,
	SellerAuctionType =
		case
			WHEN Auction = 'ADESA' then 1
			WHEN Auction = 'MANHEIM' then 2
			WHEN Auction = 'OTHER' then 3
		end,
	ManufacturerType = 
		case
			WHEN Make = 'ACURA' then 1
			WHEN Make = 'BUICK' then 2
			WHEN Make = 'CADILLAC' then 3
			WHEN Make = 'CHEVROLET' then 4
			WHEN Make = 'CHRYSLER' then 5
			WHEN Make = 'DODGE' then 6
			WHEN Make = 'FORD' then 7
			WHEN Make = 'GMC' then 8
			WHEN Make = 'HONDA' then 9
			WHEN Make = 'HYUNDAI' then 10
			WHEN Make = 'INFINITI' then 11 
			WHEN Make = 'ISUZU' then 12
			WHEN Make = 'JEEP' then 13 
			WHEN Make = 'KIA' then 14
			WHEN Make = 'LEXUS' then 15
			WHEN Make = 'LINCOLN' then 16
			WHEN Make = 'MAZDA' then 17
			WHEN Make = 'MERCURY' then 18
			WHEN Make = 'MINI' then 19
			WHEN Make = 'MITSUBISHI' then 20 
			WHEN Make = 'NISSAN' then 21
			WHEN Make = 'OLDSMOBILE' then 22
			WHEN Make = 'PLYMOUTH' then 23
			WHEN Make = 'PONTIAC' then 24
			WHEN Make = 'SATURN' then 25
			WHEN Make = 'SCION' then 26
			WHEN Make = 'SUBARU' then 27
			WHEN Make = 'SUZUKI' then 28
			WHEN Make = 'TOYOTA SCION' then 29
			WHEN Make = 'TOYOTA' then 30
			WHEN Make = 'VOLKSWAGEN' then 31
			WHEN Make = 'VOLVO' then 32
		end,
	YearID =
		case
			WHEN year(PurchDate) = 2009 then 2009
			WHEN year(PurchDate) = 2010 then 2010
		end,
	MonthID =
		case
			when month(PurchDate) = '1' then 1
			when month(PurchDate) = '2' then 2
			when month(PurchDate) = '3' then 3
			when month(PurchDate) = '4' then 4
			when month(PurchDate) = '5' then 5
			when month(PurchDate) = '6' then 6
			when month(PurchDate) = '7' then 7
			when month(PurchDate) = '8' then 8
			when month(PurchDate) = '9' then 9
			when month(PurchDate) = '10' then 10
			when month(PurchDate) = '11' then 11
			when month(PurchDate) = '12' then 12
		end,
	DayID =
		case
			when day(PurchDate) = '1' then 1
			when day(PurchDate) = '2' then 2
			when day(PurchDate) = '3' then 3
			when day(PurchDate) = '4' then 4
			when day(PurchDate) = '5' then 5
			when day(PurchDate) = '6' then 6
			when day(PurchDate) = '7' then 7
			when day(PurchDate) = '8' then 8
			when day(PurchDate) = '9' then 9
			when day(PurchDate) = '10' then 10
			when day(PurchDate) = '11' then 11
			when day(PurchDate) = '12' then 12
			when day(PurchDate) = '13' then 13
			when day(PurchDate) = '14' then 14
			when day(PurchDate) = '15' then 15
			when day(PurchDate) = '16' then 16
			when day(PurchDate) = '17' then 17
			when day(PurchDate) = '18' then 18
			when day(PurchDate) = '19' then 19
			when day(PurchDate) = '20' then 20
			when day(PurchDate) = '21' then 21
			when day(PurchDate) = '22' then 22
			when day(PurchDate) = '23' then 23
			when day(PurchDate) = '24' then 24
			when day(PurchDate) = '25' then 25
			when day(PurchDate) = '26' then 26
			when day(PurchDate) = '27' then 27
			when day(PurchDate) = '28' then 28
			when day(PurchDate) = '29' then 29
			when day(PurchDate) = '30' then 30
			when day(PurchDate) = '31' then 31
		end,
	IsBadBuy,
	IsOnlineSale,
	AcquisitionAuctionAveragePrice,
	AcquisitionRetailAveragePrice,
	CurrentAuctionAveragePrice,
	CurrentRetailAveragePrice,
	VehBCost,
	PRIMEUNIT =
		case
			when PRIMEUNIT = 'Yes' then 1
			when PRIMEUNIT = 'No' then 2
			when PRIMEUNIT = 'OTHER' then 3
			else 0
		end,
	AUCGUART = 
		case
			when AUCGUART = 'Green' then 1
			when AUCGUART = 'Red' then 2
			else 0
		end,
	WarrantyCost,                           
	PurchDate,
	VehPurchState =
		case
			WHEN VehPurchState = 'AL' then 1
			WHEN VehPurchState = 'AR' then 2
			WHEN VehPurchState = 'AZ' then 3
			WHEN VehPurchState = 'CA' then 4
			WHEN VehPurchState = 'CO' then 5 
			WHEN VehPurchState = 'FL' then 6
			WHEN VehPurchState = 'GA' then 7
			WHEN VehPurchState = 'IA' then 8
			WHEN VehPurchState = 'ID' then 9
			WHEN VehPurchState = 'IL' then 10
			WHEN VehPurchState = 'IN' then 11 
			WHEN VehPurchState = 'KY' then 12
			WHEN VehPurchState = 'LA' then 13
			WHEN VehPurchState = 'MA' then 14
			WHEN VehPurchState = 'MD' then 15
			WHEN VehPurchState = 'MI' then 16
			WHEN VehPurchState = 'MN' then 17 
			WHEN VehPurchState = 'MO' then 18
			WHEN VehPurchState = 'MS' then 19
			WHEN VehPurchState = 'NC' then 20
			WHEN VehPurchState = 'NE' then 21
			WHEN VehPurchState = 'NH' then 22
			WHEN VehPurchState = 'NJ' then 23
			WHEN VehPurchState = 'NM' then 24
			WHEN VehPurchState = 'NV' then 25
			WHEN VehPurchState = 'NY' then 26
			WHEN VehPurchState = 'OH' then 27
			WHEN VehPurchState = 'OK' then 28
			WHEN VehPurchState = 'OR' then 29
			WHEN VehPurchState = 'PA' then 30
			WHEN VehPurchState = 'SC' then 31
			WHEN VehPurchState = 'TN' then 32
			WHEN VehPurchState = 'TX' then 33
			WHEN VehPurchState = 'UT' then 34
			WHEN VehPurchState = 'VA' then 35 
			WHEN VehPurchState = 'WA' then 36
			WHEN VehPurchState = 'WV' then 37
		end            
FROM UsedCarFile
--	check the factSales table
select *
from factSales

------------------------------------
--	Data Quality Check
------------------------------------
-- Quality Check for all columns in all tables
select distinct VehMeter
from dimVehicle

select min(VehMeter), max(VehMeter)
from dimVehicle

select color, count(color)
from dimVehicle
group by color
order by count(color)


---- dimVehicle
--select *
--from dimVehicle

--select distinct VehMeter
--from dimVehicle

--select min(VehMeter), max(VehMeter)
--from dimVehicle

--select color, count(color)
--from dimVehicle
--group by color
--order by count(color)

---- dimBuyer
select *
from dimBuyer

select BuyerID
from dimBuyer

select distinct BuyerNumber, count(BuyerNumber)
from dimBuyer
group by BuyerNumber
order by count(BuyerNumber) desc


select FS.BuyerNumberID, sum(FS.VehBCost)/count(FS.VehBCost)
from dimBuyer B inner join factSales FS on B.BuyerID = FS.BuyerNumberID
group by FS.BuyerNumberID
order by sum(FS.VehBCost)/count(FS.VehBCost) desc



select *
from dimSeller

--select distinct AUCGUART
--from dimSeller



select distinct Make
from dimManufacturer

select distinct F.Make, sum(FS.VehBCost)/count(FS.VehBCost)
from dimManufacturer F inner join factSales FS on F.ManufacturerID = FS.ManufacturerType
group by F.Make
order by sum(FS.VehBCost)/count(FS.VehBCost) desc

select distinct Nationality
from dimManufacturer



select *
from factSales


---- Create BuyerNumberID in factSales
--BuyerNumberID = 
--		case
--			when BuyerNumber =　17675　then 1 
--			when BuyerNumber = 20392 then 2 
--			when BuyerNumber = 20234 then 3 
--			when BuyerNumber = 10430 then 4 
--			when BuyerNumber = 1085 then 5 
--			when BuyerNumber = 16926 then 6 
--			when BuyerNumber = 19064 then 7 
--			when BuyerNumber = 22808 then 8 
--			when BuyerNumber = 10425 then 9 
--			when BuyerNumber = 1081 then 10 
--			when BuyerNumber = 53245 then 11 
--			when BuyerNumber = 52646 then 12 
--			when BuyerNumber = 1055 then 13 
--			when BuyerNumber = 10310 then 14 
--			when BuyerNumber = 8172 then 15 
--			when BuyerNumber = 1125 then 16 
--			when BuyerNumber = 10510 then 17 
--			when BuyerNumber = 5546 then 18 
--			when BuyerNumber = 16044 then 19 
--			when BuyerNumber = 21973 then 20 
--			when BuyerNumber = 18822 then 21 
--			when BuyerNumber = 1082 then 22 
--			when BuyerNumber = 1086 then 23 
--			when BuyerNumber = 18091 then 24 
--			when BuyerNumber = 99760 then 25 
--			when BuyerNumber = 1051 then 26 
--			when BuyerNumber = 1156 then 27 
--			when BuyerNumber = 1157 then 28 
--			when BuyerNumber = 99741 then 29 
--			when BuyerNumber = 1031 then 30 
--			when BuyerNumber = 3453 then 31 
--			when BuyerNumber = 1191 then 32 
--			when BuyerNumber = 52644 then 33 
--			when BuyerNumber = 99761 then 34 
--			when BuyerNumber = 22916 then 35 
--			when BuyerNumber = 1041 then 36 
--			when BuyerNumber = 52117 then 37 
--			when BuyerNumber = 17212 then 38 
--			when BuyerNumber = 18880 then 39 
--			when BuyerNumber = 1231 then 40 
--			when BuyerNumber = 10315 then 41 
--			when BuyerNumber = 52492 then 42 
--			when BuyerNumber = 21053 then 43 
--			when BuyerNumber = 16369 then 44 
--			when BuyerNumber = 1121 then 45 
--			when BuyerNumber = 1235 then 46 
--			when BuyerNumber = 18111 then 47 
--			when BuyerNumber = 52598 then 48 
--			when BuyerNumber = 10410 then 49 
--			when BuyerNumber = 835 then 50 
--			when BuyerNumber = 21047 then 51 
--			when BuyerNumber = 20928 then 52 
--			when BuyerNumber = 99740 then 53 
--			when BuyerNumber = 11410 then 54 
--			when BuyerNumber = 1152 then 55 
--			when BuyerNumber = 23657 then 56 
--			when BuyerNumber = 3582 then 57 
--			when BuyerNumber = 11210 then 58
--			when BuyerNumber = 19662 then 59
--			when BuyerNumber = 1045 then 60
--			when BuyerNumber = 1035 then 61
--			when BuyerNumber = 23359 then 62
--			when BuyerNumber = 19638 then 63
--			when BuyerNumber = 8655 then 64
--			when BuyerNumber = 20740 then 65
--			when BuyerNumber = 20207 then 66
--			when BuyerNumber = 19619 then 67
--			when BuyerNumber = 25100 then 68
--			when BuyerNumber = 10420 then 69
--			when BuyerNumber = 99750 then 70
--			when BuyerNumber = 1141 then 71
--			when BuyerNumber = 1151 then 72
--			when BuyerNumber = 18881 then 73
--			when BuyerNumber = 20833 then 74
--		end,


------------------------------------
--	Create View
------------------------------------
-- How many Ford cars are bad buy?

--SELECT count(M.Make) as '# of badbuys'
--FROM ((((factSales f INNER JOIN dimVehicle V ON f.VehId = V.VehId)
--                    INNER JOIN dimBuyer B ON F.BuyerNumberID = B.BuyerID)
--					INNER JOIN dimSeller S ON S.SellerID = F.SellerAuctionType)
--					INNER JOIN dimManufacturer M ON M.ManufacturerID = F.ManufacturerType)
--					INNER JOIN dimDate D ON D.DateID = F.YearID
--WHERE M.Make LIKE 'Ford'
--And F.IsBadBuy = 1
--Group by M.Make


-- Drop FordBadBuy view

-- Drop view
DROP VIEW IF EXISTS FordBadBuy
GO

-- Create FordBadBuy view

CREATE VIEW FordBadBuy
AS
SELECT count(M.Make) as '# of badbuys'
FROM ((((factSales f INNER JOIN dimVehicle V ON f.VehId = V.VehId)
                    INNER JOIN dimBuyer B ON F.BuyerNumberID = B.BuyerID)
					INNER JOIN dimSeller S ON S.SellerID = F.SellerAuctionType)
					INNER JOIN dimManufacturer M ON M.ManufacturerID = F.ManufacturerType)
					INNER JOIN dimDate D ON D.DateID = F.YearID
WHERE M.Make LIKE 'Ford'
And F.IsBadBuy = 1
Group by M.Make
GO

--SELECT *
--FROM FordBadBuy

------------------------------------
--	Create Procedures
------------------------------------
--Create FindMyCar Procedures
DROP PROCEDURE IF EXISTS FindMyCarProcedures 
GO

CREATE PROCEDURE FindMyCarProcedures
	@Make varchar(50) = '%',
	@Cost varchar(50) = '%'
AS
	SELECT V.Model, V.SubModel, V.Size, V.Transmission, V.VehBCost, V.VehMeter, V.Color, V.VehicleAge
	FROM ((((factSales f INNER JOIN dimVehicle V ON f.VehId = V.VehId)
						INNER JOIN dimBuyer B ON F.BuyerNumberID = B.BuyerID)
						INNER JOIN dimSeller S ON S.SellerID = F.SellerAuctionType)
						INNER JOIN dimManufacturer M ON M.ManufacturerID = F.ManufacturerType)
						INNER JOIN dimDate D ON D.DateID = F.YearID
	WHERE M.Make LIKE @Make
	And V.VehBCost Like @Cost
	And F.IsBadBuy = 0
	Group by V.Model, V.SubModel, V.Size, V.Transmission, V.VehBCost, V.VehMeter, V.Color, V.VehicleAge
GO

--Put in 'Make' and 'Vehicle Cost Range', where Vehicle Cost use '$0 - $2K', '$2K - $4K', '$4K - $6K', '$8K - $10K', '$6K - $8K', 'Over $10K'
EXECUTE FindMyCarProcedures 'Mazda', '$8K - $10K'


