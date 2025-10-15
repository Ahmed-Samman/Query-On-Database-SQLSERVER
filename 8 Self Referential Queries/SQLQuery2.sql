USE EmployeesDB;

SELECT * FROM Employees;


--1 Get all employees that have manager along with Manager's name.
SELECT Employees.*, Managers.Name AS MangerName
FROM   Employees INNER JOIN Employees AS Managers 
ON Employees.ManagerID = Managers.EmployeeID;



--2 Get all employees that have manager or does not have manager along with Manager's name, incase no manager name show null
SELECT Employees.*, Managers.Name AS MangerName
FROM   Employees LEFT OUTER JOIN Employees AS Managers 
ON Employees.ManagerID = Managers.EmployeeID;


--3 Get all employees that have manager or does not have manager along with Manager's name, 
--  incase no manager name the same employee name as manager to himself 
SELECT Employees.*, 
CASE 
	WHEN Managers.Name IS NULL THEN Employees.Name
	ELSE Managers.Name
END AS MangerName
FROM   Employees LEFT OUTER JOIN Employees AS Managers 
ON Employees.ManagerID = Managers.EmployeeID;


--4 Get All Employees managed by 'Mohammed'
SELECT Employees.*, Managers.Name AS MangerName
FROM   Employees JOIN Employees AS Managers 
ON Employees.ManagerID = Managers.EmployeeID
WHERE Managers.Name ='Mohammed';
