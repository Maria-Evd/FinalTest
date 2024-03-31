-- 7.2   - В ранее подключенном MySQL создать базу данных с названием "Human Friends".
--   - Создать таблицы, соответствующие иерархии из вашей диаграммы классов.
--   - Заполнить таблицы данными о животных, их командах и датами рождения.


CREATE DATABASE human_friends;
USE human_friends;

DROP TABLE IF EXISTS Class_MyAnimals;
CREATE TABLE Class_MyAnimals
(
	id INT AUTO_INCREMENT PRIMARY KEY, 
	view_name VARCHAR(20)
);
INSERT INTO Class_MyAnimals (view_name)
VALUES ('Pets'), ('PackAnimals'); 

DROP TABLE IF EXISTS Pets;
CREATE TABLE Pets
(
	id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR (20),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES Class_MyAnimals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Pets (type_name, class_id)
VALUES ('Cat', 1), ('Dog', 1), ('Humster', 1); 

DROP TABLE IF EXISTS PackAnimals;
CREATE TABLE PackAnimals
(
	id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR (20),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES Class_MyAnimals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO PackAnimals (type_name, class_id)
VALUES ('Horse', 2), ('Camel', 2), ('Donkey', 2); 

DROP TABLE IF EXISTS Cats;
CREATE TABLE Cats 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
    FOREIGN KEY (type_id) REFERENCES Pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Cats (name, birthday, commands, type_id)
VALUES 
('Whiskers', '2019-05-15', 'Sit, Pounce', 1), 
('Smudge', '2020-02-20', 'Sit, Pounce, Scratch', 1), 
('Oliver', '2020-06-30', 'Meow, Scratch, Jump', 1); 

DROP TABLE IF EXISTS Dogs;
CREATE TABLE Dogs 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
	FOREIGN KEY (type_id) REFERENCES Pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Dogs (name, birthday, commands, type_id)
VALUES 
('Fido', '2020-01-01', 'Sit, Stay, Fetch', 2),
('Buddy', '2018-12-10', 'Sit, Paw, Bark', 2),  
('Bella', '2019-11-11', 'Sit, Stay, Roll', 2);

DROP TABLE IF EXISTS Hamsters;
CREATE TABLE Hamsters 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
    FOREIGN KEY (type_id) REFERENCES Pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Hamsters (name, birthday, commands, type_id)
VALUES 
('Hammy', '2021-03-10', 'Roll, Hide', 3),
('Peanut', '2021-08-01', 'Roll, Spin', 3);

DROP TABLE IF EXISTS Horses;
CREATE TABLE Horses 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
    FOREIGN KEY (type_id) REFERENCES PackAnimals (id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Horses (name, birthday, commands, type_id)
VALUES 
('Thunder', '2015-07-21', 'Trot, Canter, Gallop', 1),
('Storm', '2014-05-05', 'Trot, Canter', 1),  
('Blaze', '2016-02-29', 'Trot, Jump, Gallop', 1);

DROP TABLE IF EXISTS Camels;
CREATE TABLE Camels 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
    FOREIGN KEY (TYPE_id) REFERENCES PackAnimals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Camels (name, birthday, commands, type_id)
VALUES 
('Sandy', '2016-11-03', 'Walk, Carry Load', 2),
('Dune', '2018-12-12', 'Walk, Sit', 2),  
('Sahara', '2015-08-14', 'Walk, Run', 2);

DROP TABLE IF EXISTS Donkeys;
CREATE TABLE Donkeys 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(20), 
    birthday DATE,
    commands VARCHAR(50),
    type_id int,
    FOREIGN KEY (type_id) REFERENCES PackAnimals (id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Donkeys (name, birthday, commands, type_id)
VALUES 
('Eeyore', '2017-09-18', 'Walk, Carry Load, Bray', 3),
('Burro', '2019-01-23', 'Walk, Bray, Kick', 3);


-- - Удалить записи о верблюдах и объединить таблицы лошадей и ослов.

DELETE FROM Camels;
SELECT name, birthday, commands FROM Horses
UNION SELECT  name, birthday, commands FROM Donkeys;

-- - Создать новую таблицу для животных в возрасте от 1 до 3 лет и вычислить их возраст с точностью до месяца.

DROP TABLE IF EXISTS animals;
CREATE TEMPORARY TABLE animals AS 
SELECT *, 'Horse' as type FROM Horses
UNION SELECT *, 'Donkey' AS type FROM Donkeys
UNION SELECT *, 'Dog' AS type FROM Dogs
UNION SELECT *, 'Cat' AS type FROM Cats
UNION SELECT *, 'Hamster' AS type FROM Hamsters;

CREATE TABLE yang_animal AS
SELECT name, birthday, commands, type, TIMESTAMPDIFF(MONTH, birthday, CURDATE()) AS Age_month
FROM animals WHERE birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);
 
SELECT * FROM yang_animal;

--   - Объединить все созданные таблицы в одну, сохраняя информацию о принадлежности к исходным таблицам.

SELECT h.name, h.birthday, h.commands, pa.type_name, ya.Age_month 
FROM Horses h
LEFT JOIN yang_animal ya ON ya.name = h.name
LEFT JOIN PackAnimals pa ON pa.id = h.type_id
UNION 
SELECT d.name, d.birthday, d.commands, pa.type_name, ya.Age_month 
FROM Donkeys d 
LEFT JOIN yang_animal ya ON ya.name = d.name
LEFT JOIN PackAnimals pa ON pa.id = d.type_id
UNION
SELECT c.name, c.birthday, c.commands, pe.type_name, ya.Age_month 
FROM Cats c
LEFT JOIN yang_animal ya ON ya.name = c.name
LEFT JOIN Pets pe ON pe.id = c.type_id
UNION
SELECT d.name, d.birthday, d.commands, pe.type_name, ya.Age_month 
FROM Dogs d
LEFT JOIN yang_animal ya ON ya.name = d.name
LEFT JOIN Pets pe ON pe.id = d.type_id
UNION
SELECT hm.name, hm.birthday, hm.commands, pe.type_name, ya.Age_month 
FROM Hamsters hm
LEFT JOIN yang_animal ya ON ya.name = hm.name
LEFT JOIN Pets pe ON pe.id = hm.type_id;