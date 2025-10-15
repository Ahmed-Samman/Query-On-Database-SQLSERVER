USE VehicleMakesDB;

SELECT * FROM VehicleDetails;


--1 CREATE VIEW
CREATE VIEW VehicleMasterDetails AS
SELECT VehicleDetails.ID, VehicleDetails.MakeID, Makes.Make, VehicleDetails.ModelID, MakeModels.ModelName, VehicleDetails.SubModelID,
SubModels.SubModelName, VehicleDetails.BodyID, Bodies.BodyName, VehicleDetails.Vehicle_Display_Name, VehicleDetails.Year, 
VehicleDetails.DriveTypeID, DriveTypes.DriveTypeName, VehicleDetails.Engine, VehicleDetails.Engine_CC, VehicleDetails.Engine_Cylinders, 
VehicleDetails.Engine_Liter_Display, VehicleDetails.FuelTypeID, FuelTypes.FuelTypeName, VehicleDetails.NumDoors
FROM   FuelTypes INNER JOIN Bodies INNER JOIN Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID INNER JOIN SubModels 
ON MakeModels.ModelID = SubModels.ModelID INNER JOIN VehicleDetails 
ON Makes.MakeID = VehicleDetails.MakeID AND MakeModels.ModelID = VehicleDetails.ModelID AND SubModels.SubModelID = VehicleDetails.SubModelID 
ON Bodies.BodyID = VehicleDetails.BodyID INNER JOIN DriveTypes 
ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID 
ON FuelTypes.FuelTypeID = VehicleDetails.FuelTypeID;


SELECT * FROM VehicleMasterDetails;


--2 Get All Vehicle Made Between 1950 To 2000
SELECT * FROM VehicleDetails
Where VehicleDetails.Year BETWEEN 1950 AND 2000;
-- OR
SELECT * FROM VehicleDetails
Where VehicleDetails.Year >= 1950 AND VehicleDetails.Year <= 2000;

--3 Get Number Vehicle Made Between 1950 To 2000
SELECT Count(*) AS NumOFVehicle FROM VehicleDetails
WHERE VehicleDetails.Year BETWEEN 1950 AND 2000;


--4 Get Number Vehicle Made Between 1950 To 2000 Per Make And Order Them By Number Of Vehicle Descending
SELECT Makes.Make, Count(*) AS NumOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE VehicleDetails.Year BETWEEN 1950 AND 2000
GROUP BY Makes.Make
ORDER BY NumOfVehicle DESC;


--5 Get All Makes That Have Manufactured More Than 12000 vehicle in years 1950 To 2000
SELECT Makes.Make, Count(*) AS NumOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
HAVING COUNT(*) > 12000
ORDER BY NumOfVehicle DESC;
-- OR (Without HAVING)
SELECT * FROM(
SELECT Makes.Make, Count(*) AS NumOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
) R1
WHERE  NumOfVehicle > 12000
ORDER BY NumOfVehicle DESC;


--6 Get number of Vehicles Made Between 1950 And 2000 Per Make And Add Total Vehicles Column Beside
SELECT Makes.Make, Count(*) AS NumOfVehicle, (SELECT COUNT(*) FROM VehicleDetails) AS TotalVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE VehicleDetails.Year BETWEEN 1950 AND 2000
GROUP BY Makes.Make
ORDER BY NumOfVehicle DESC;


--7 Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it, then calculate it's percentage
SELECT *, CAST(NumOfVehicle as float) / CAST(TotalVehicle as float) AS Perc FROM 
(
SELECT Makes.Make, Count(*) AS NumOfVehicle, (SELECT COUNT(*) FROM VehicleDetails) AS TotalVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE VehicleDetails.Year BETWEEN 1950 AND 2000
GROUP BY Makes.Make  
)R1
ORDER BY NumOfVehicle DESC;


--8 Get Make, FuelTypeName and Number of Vehicles per FuelType per Make
SELECT Makes.Make, FuelTypes.FuelTypeName ,Count(*)  AS NumOfVehicle
FROM   Makes INNER JOIN VehicleDetails 
ON  Makes.MakeID = VehicleDetails.MakeID INNER JOIN FuelTypes 
ON  VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE VehicleDetails.Year BETWEEN 1950 AND 2000
GROUP BY Makes.Make, FuelTypes.FuelTypeName
ORDER BY Makes.Make ASC;


--9 Get all vehicles that runs with GAS
SELECT VehicleDetails.*, FuelTypes.FuelTypeName
FROM   VehicleDetails INNER JOIN FuelTypes 
ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE FuelTypeName = N'Gas';  --N For UniCode


--10 Get all Makes that runs with GAS
SELECT DISTINCT Makes.Make, FuelTypes.FuelTypeName
FROM   VehicleDetails INNER JOIN FuelTypes 
ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE FuelTypes.FuelTypeName = N'Gas';


--11 Get Total Makes that runs with GAS
SElECT Count(*) AS TotalMakesRunOnGas FROM
(
SELECT DISTINCT Makes.Make, FuelTypes.FuelTypeName
FROM   VehicleDetails INNER JOIN FuelTypes 
ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE FuelTypes.FuelTypeName = N'Gas'
)R1
-- OR
SELECT  Count(DISTINCT Makes.Make) AS TotalMakesRunOnGas 
FROM   VehicleDetails INNER JOIN FuelTypes 
ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE FuelTypes.FuelTypeName = N'Gas'


--12 Count Vehicles by make and order them by NumberOfVehicles from high to low
SELECT Makes.Make, COUNT(*) AS NumberOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY  Makes.Make
ORDER BY NumberOfVehicle DESC;


--13 Get all Makes/Count Of Vehicles that manufactures more than 20K Vehicles
SELECT * FROM
(
SELECT Makes.Make, COUNT(*) AS NumberOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY  Makes.Make
)R1
WHERE NumberOfVehicle > 200000
ORDER BY NumberOfVehicle DESC;
--OR
SELECT Makes.Make, COUNT(*) AS NumberOfVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY  Makes.Make
HAVING  COUNT(*) > 20000
ORDER BY NumberOfVehicle DESC;



--14 Get all Makes with make starts with 'B'
SELECT Makes.Make FROM Makes
WHERE Make LIKE 'B%';


--15 Get all Makes with make ends with 'W'
SELECT Makes.Make FROM Makes
WHERE Make LIKE '%W';


--16 Get all Makes that manufactures DriveTypeName = FWD
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName
FROM   VehicleDetails INNER JOIN
             Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
             DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
WHERE  DriveTypes.DriveTypeName = 'FWD';


--17 Get total Makes that Mantufactures DriveTypeName=FWD
SELECT COUNT(*) AS MakeWithFWD FROM
(
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName
FROM   VehicleDetails INNER JOIN
             Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
             DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
WHERE  DriveTypes.DriveTypeName = 'FWD'
)R1
--OR
SELECT COUNT(DISTINCt Makes.Make) AS MakeWithFWD 
FROM   VehicleDetails INNER JOIN
             Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
             DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
WHERE  DriveTypes.DriveTypeName = 'FWD'


--18 Get total vehicles per DriveTypeName Per Make and order them per make asc then per total Desc
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName, COUNT(*) AS TotalVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN DriveTypes 
ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
GROUP BY  Makes.Make, DriveTypes.DriveTypeName
ORDER BY  Makes.Make ASC, TotalVehicle DESC;


--19 Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName, COUNT(*) AS TotalVehicle
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN DriveTypes 
ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
GROUP BY  Makes.Make, DriveTypes.DriveTypeName
HAVING COUNT(*) > 10000
ORDER BY  Makes.Make ASC, TotalVehicle DESC;


--20 Get all Vehicles that number of doors is not specified
SELECT * FROM VehicleDetails
WHERE VehicleDetails.NumDoors IS NULL;


--21 Get Total Vehicles that number of doors is not specified
SELECT COUNT(*) AS TotalVehicle FROM VehicleDetails
WHERE VehicleDetails.NumDoors IS NULL;


--22 Get percentage of vehicles that has no doors specified
SELECT CAST((SELECT COUNT(*) FROM VehicleDetails WHERE VehicleDetails.NumDoors IS NULL) AS FLOAT )
		/ 
	   CAST((SELECT COUNT(*) FROM VehicleDetails WHERE VehicleDetails.NumDoors IS NOT NULL) AS FLOAT ) AS PercOfNoSpecifiedDoors;

	

--23  Get MakeID , Make, SubModelName for all vehicles that have SubModelName 'Elite'
SELECT DISTINCT Makes.MakeID, Makes.Make, SubModels.SubModelName
FROM   Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID INNER JOIN SubModels 
ON MakeModels.ModelID = SubModels.ModelID
WHERE (SubModels.SubModelName = 'Elite');
--OR
SELECT DISTINCT VehicleDetails.MakeID, Makes.Make, SubModelName
FROM   VehicleDetails INNER JOIN SubModels 
ON VehicleDetails.SubModelID = SubModels.SubModelID INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
where SubModelName='Elite'


--24 Get all vehicles that have Engines > 3 Liters and have only 2 doors
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_Liter_Display > 3 AND VehicleDetails.NumDoors = 2;


--25  Get make and vehicles that the engine contains 'OHV' and have Cylinders = 4
SELECT Makes.Make, VehicleDetails.*
FROM   Makes INNER JOIN VehicleDetails 
ON Makes.MakeID = VehicleDetails.MakeID
WHERE (VehicleDetails.Engine LIKE '%OHV%') AND (VehicleDetails.Engine_Cylinders = 4);


--26 Get all vehicles that their body is 'Sport Utility' and Year > 2020
SELECT VehicleDetails.*
FROM   VehicleDetails INNER JOIN Bodies 
ON VehicleDetails.BodyID = Bodies.BodyID
WHERE (Bodies.BodyName = 'Sport Utility') AND (VehicleDetails.Year > 2020);


--27 Get all vehicles that their Body is 'Coupe' or 'Hatchback' or 'Sedan'
SELECT VehicleDetails.*, Bodies.BodyName
FROM   VehicleDetails INNER JOIN Bodies 
ON VehicleDetails.BodyID = Bodies.BodyID
WHERE Bodies.BodyName in('Coupe', 'Hatchback', 'Sedan');


--28  Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' and manufactured in year 2008 or 2020 or 2021
SELECT * FROM
(
SELECT VehicleDetails.*, Bodies.BodyName
FROM   VehicleDetails INNER JOIN Bodies 
ON VehicleDetails.BodyID = Bodies.BodyID
WHERE Bodies.BodyName in('Coupe', 'Hatchback', 'Sedan')
)R1
WHERE R1.Year IN (2008, 2020, 2021)
ORDER BY R1.Year ASC;
--OR
SELECT VehicleDetails.*, Bodies.BodyName
FROM   VehicleDetails INNER JOIN Bodies 
ON VehicleDetails.BodyID = Bodies.BodyID
WHERE Bodies.BodyName in('Coupe', 'Hatchback', 'Sedan') AND VehicleDetails.Year in(2008, 2020, 2021)
ORDER BY VehicleDetails.Year ASC;


--29 Return found=1 if there is any vehicle made in year 1950
SELECT Found = 1
WHERE EXISTS
(
SELECT TOP 1 * FROM VehicleDetails
WHERE VehicleDetails.Year = 1950
)

SELECT DISTINCT NumDoors FROM VehicleDetails
ORDER BY NumDoors ASC



--30 Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words, and if door is null display 'Not Set'
SELECT Vehicle_Display_Name, NumDoors,  
CASE 
	WHEN NumDoors = 0 THEN 'ZeroDoor'
	WHEN NumDoors = 1 THEN 'OneDoor'
	WHEN NumDoors = 2 THEN 'TwoDoors'
	WHEN NumDoors = 3 THEN 'ThreeDoors'
	WHEN NumDoors = 4 THEN 'FourDoors'
	WHEN NumDoors = 5 THEN 'FiveDoors'
	WHEN NumDoors = 6 THEN 'SixDoors'
	WHEN NumDoors = 8 THEN 'EightDoors'
	ELSE 'Not Set'
END AS DoorDescribtion
FROM VehicleDetails;


--31 Get all Vehicle_Display_Name, year and add extra column to calculate the age of the car then sort the results by age desc.
SELECT Vehicle_Display_Name, Year, YEAR(GETDATE()) - VehicleDetails.Year AS AgeOfCar 
FROM   VehicleDetails
ORDER BY AgeOfCar DESC;



--32 Get all Vehicle_Display_Name, year, Age for vehicles that their age between 15 and 25 years old
SELECT * FROM
(
SELECT Vehicle_Display_Name, Year, YEAR(GETDATE()) - VehicleDetails.Year AS AgeOfCar 
FROM   VehicleDetails 
)R1
WHERE AgeOfCar BETWEEN 15 AND 25
ORDER BY AgeOfCar DESC;


--33 Get Minimum Engine CC , Maximum Engine CC , and Average Engine CC of all Vehicles
SELECT MIN(Engine_CC) AS MinimumEngineCC, 
	   MAX(Engine_CC) AS MaximumEngineCC, 
	   AVG(Engine_CC) AS AverageEngineCC
FROM VehicleDetails ;


--34 Get all vehicles that have the minimum Engine_CC
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_CC in (SELECT MIN(Engine_CC) AS MinimumEngineCC FROM VehicleDetails)
	

--35 Get all vehicles that have the Maximum Engine_CC
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_CC in (SELECT MAX(Engine_CC) AS MaximumEngineCC FROM VehicleDetails)
	

--36 Get all vehicles that have Engin_CC below average
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_CC < (SELECT AVG(Engine_CC) AS AverageEngineCC FROM VehicleDetails)
	

--37 Get total vehicles that have Engin_CC above average
SELECT COUNT(*) AS TotalVehicleAboveAverageOfEnginCC FROM
(
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_CC > (SELECT AVG(Engine_CC) AS AverageEngineCC FROM VehicleDetails)
)R1


--38 Get all unique Engin_CC and sort them Desc
SELECT  DISTINCT Engine_CC FROM VehicleDetails
ORDER BY VehicleDetails.Engine_CC DESC;


--39 Get the maximum 3 Engine CC
SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails
ORDER BY VehicleDetails.Engine_CC DESC;


--40 Get all vehicles that has one of the Max 3 Engine CC
SELECT * FROM VehicleDetails
WHERE VehicleDetails.Engine_CC in (SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails ORDER BY VehicleDetails.Engine_CC DESC)
ORDER BY VehicleDetails.Engine_CC DESC;


--41 Get all Makes that manufactures one of the Max 3 Engine CC
SELECT DISTINCT Makes.Make
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
WHERE VehicleDetails.Engine_CC in (SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails ORDER BY VehicleDetails.Engine_CC DESC);


--42 Get a table of unique Engine_CC and calculate tax per Engine CC
	-- 0 to 1000    Tax = 100
	-- 1001 to 2000 Tax = 200
	-- 2001 to 4000 Tax = 300
	-- 4001 to 6000 Tax = 400
	-- 6001 to 8000 Tax = 500
	-- Above 8000   Tax = 600
	-- Otherwise    Tax = 0
SELECT DISTINCT VehicleDetails.Engine_CC,
	CASE 
		WHEN  Engine_CC <= 1000 THEN 100
		WHEN  Engine_CC <= 2000 THEN 200
		WHEN  Engine_CC <= 4000 THEN 300
		WHEN  Engine_CC <= 6000 THEN 400
		WHEN  Engine_CC <= 8000 THEN 500
		WHEN  Engine_CC > 8000 THEN 800
		ELSE  0

	END AS TaxPerEngine_CC
FROM VehicleDetails
ORDER BY Engine_CC ASC;
--OR
select Engine_CC,

	CASE
		WHEN Engine_CC between 0 and 1000 THEN 100
		 WHEN Engine_CC between 1001 and 2000 THEN 200
		 WHEN Engine_CC between 2001 and 4000 THEN 300
		 WHEN Engine_CC between 4001 and 6000 THEN 400
		 WHEN Engine_CC between 6001 and 8000 THEN 500
		 WHEN Engine_CC > 8000 THEN 600	
		ELSE 0

	END as Tax
from 
(select distinct Engine_CC from VehicleDetails) R1
order by Engine_CC;



--43 Get Make and Total Number Of Doors Manufactured Per Make
SELECT Makes.Make, SUM(VehicleDetails.NumDoors) AS TotalNumOfDoor
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY Makes.Make
ORDER BY TotalNumOfDoor ASC;


--44 Get Total Number Of Doors Manufactured by 'Ford'
SELECT Makes.Make, SUM(VehicleDetails.NumDoors) AS TotalNumOfDoor
FROM   VehicleDetails INNER JOIN Makes 
ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY Makes.Make
HAVING Makes.Make = 'Ford';


--45 Get Number of Models Per Make
SELECT Makes.Make, COUNT(*) AS NumOfModels
FROM   Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID
GROUP BY Makes.Make;


--46 Get the highest 3 manufacturers that make the highest number of models
SELECT DISTINCT TOP 3 Make, NumOfModels FROM
(
SELECT Makes.Make, COUNT(*) AS NumOfModels
FROM   Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID
GROUP BY Makes.Make
)R1
ORDER BY NumOfModels DESC;
--OR
SELECT top 3  Makes.Make, COUNT(*) AS NumberOfModels
FROM Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID
GROUP BY Makes.Make
Order By NumberOfModels Desc;


--47 Get the highest number of models manufactured
SELECT MAX(MaxNumOfModels) AS HighestNumOfModels FROM
(
SELECT Makes.Make, COUNT(*) AS MaxNumOfModels
FROM  MakeModels INNER JOIN Makes 
ON  MakeModels.MakeID = Makes.MakeID
GROUP BY Makes.Make
)R1;


--48 Get the highest Manufacturers manufactured the highest number of models , 
-- remember that they could be more than one manufacturer have the same high number of models
SELECT Makes.Make, COUNT(*) AS MaxNumOfModels
FROM  MakeModels INNER JOIN Makes 
ON  MakeModels.MakeID = Makes.MakeID
GROUP BY Makes.Make
Having COUNT(*) = (SELECT MAX(CountMaxOfModels) AS MaxOfModels 
				   FROM (SELECT MakeModels.MakeID, COUNT(*) AS CountMaxOfModels FROM MakeModels GROUP BY MakeModels.MakeID)R1); 



--49 Get the Lowest Manufacturers manufactured the lowest number of models
-- remember that they could be more than one manufacturer have the same Lowest  number of models
SELECT Makes.Make, COUNT(*) AS LowestNumOfModels
FROM   Makes INNER JOIN MakeModels 
ON Makes.MakeID = MakeModels.MakeID
GROUP BY Makes.Make
HAVING COUNT(*) = (SELECT MIN(CountNumOfModels) AS MinNumOfModels
				   FROM (SELECT MakeModels.MakeID, COUNT(*) AS CountNumOfModels FROM MakeModels GROUP BY MakeModels.MakeID)R1);


--50 Get all Fuel Types , each time the result should be showed in random order
SELECT * FROM FuelTypes
ORDER BY NEWID();



