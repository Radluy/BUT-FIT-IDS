DROP TABLE Kuzelnik CASCADE CONSTRAINTS ;
DROP TABLE Grimoar CASCADE CONSTRAINTS ;
DROP TABLE Kuzlo CASCADE CONSTRAINTS ;
DROP TABLE Element CASCADE CONSTRAINTS ;
DROP TABLE Synergia CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_obsahuje CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_je_vlastneny CASCADE CONSTRAINTS ;
DROP TABLE Miesto_s_magiou CASCADE CONSTRAINTS ;
DROP TABLE Ucitel CASCADE CONSTRAINTS ;

--Create--

CREATE TABLE Ucitel(
    ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY
);

CREATE TABLE Kuzelnik(
    ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Uroven numeric(2) NOT NULL,
    Velkost_many numeric(3) NOT NULL,
    Ucitel_ID int DEFAULT NULL,
    CONSTRAINT Ucitel_ID_FK
    FOREIGN KEY (Ucitel_ID) REFERENCES Ucitel (ID)
    ON DELETE SET NULL
);

CREATE TABLE Element(
    ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Specializacia varchar(50)
        CHECK ( Specializacia in ('FIRE', 'ICE', 'WATER', 'AIR', 'EARTH', 'ELECTRIC', 'POISON', 'DARK', 'LIGHT')),
    Farba varchar(50)
);

CREATE TABLE Grimoar(
  ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
  Energia numeric(2) NOT NULL ,
  Autor_id int NOT NULL ,
  Primarny_element int NOT NULL ,
  FOREIGN KEY (Autor_id) REFERENCES Ucitel(ID),
  FOREIGN KEY (Primarny_element) REFERENCES Element(ID)
);

CREATE TABLE Synergia(
    Kuzelnik_id int NOT NULL ,
    Element_id int NOT NULL ,
    FOREIGN KEY (Kuzelnik_id) REFERENCES Kuzelnik(ID),
    FOREIGN KEY (Element_id) REFERENCES Element(ID),
    PRIMARY KEY (Kuzelnik_id, Element_id)
);

CREATE TABLE Kuzlo(
    ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Hlavny_element int NOT NULL ,
    Vedlajsi_element int DEFAULT NULL ,
    Zlozitost numeric(1) NOT NULL ,
    Typ varchar(50) NOT NULL ,
    Sila numeric(2) NOT NULL ,
    FOREIGN KEY (Hlavny_element) REFERENCES Element(ID),
    FOREIGN KEY (Vedlajsi_element) REFERENCES Element(ID)
);

CREATE TABLE Grimoar_obsahuje(
    Grimoar_id int ,
    Kuzlo_id int,
    PRIMARY KEY (Grimoar_id, Kuzlo_id)
);

CREATE TABLE Grimoar_je_vlastneny(
    Grimoar_id int,
    Kuzelnik_id int,
    Od date,
    Do date,
    FOREIGN KEY (Grimoar_id) REFERENCES Grimoar(ID),
    FOREIGN KEY (Kuzelnik_id) REFERENCES Kuzelnik(ID),
    PRIMARY KEY (Grimoar_id, Kuzelnik_id)
);

CREATE TABLE Miesto_s_magiou(
  ID int GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
  Miera_magie numeric(2) NOT NULL ,
  Presakujuci_element int NOT NULL ,
  FOREIGN KEY (Presakujuci_element) REFERENCES Element(ID)
);


--Insert--

INSERT INTO Ucitel
VALUES (default);
INSERT INTO Ucitel
VALUES (default);

INSERT INTO Kuzelnik (Uroven, Velkost_many)
VALUES (5, 90);
INSERT INTO Kuzelnik (Uroven, Velkost_many)
VALUES (50, 400);
INSERT INTO Kuzelnik (Uroven, Velkost_many, Ucitel_ID)
VALUES (90, 800, 1);
INSERT INTO Kuzelnik (Uroven, Velkost_many, Ucitel_ID)
VALUES (80, 750, 2);

INSERT INTO Element (Specializacia, Farba)
VALUES ('FIRE', 'RED');
INSERT INTO Element (Specializacia, Farba)
VALUES ('ICE', 'BLUE');
INSERT INTO Element (Specializacia, Farba)
VALUES ('AIR', 'WHITE');

INSERT INTO Grimoar (Energia, Autor_id, Primarny_element)
VALUES (90, 1, 2);
INSERT INTO Grimoar (Energia, Autor_id, Primarny_element)
VALUES (50, 2, 1);

INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (1, 2);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (4, 3);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (3, 3);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (2, 1);

INSERT INTO Kuzlo (Hlavny_element, Zlozitost, Typ, Sila)
VALUES (1, 6, 'OFFENSIVE', 75);
INSERT INTO Kuzlo (Hlavny_element, Vedlajsi_element, Zlozitost, Typ, Sila)
VALUES (2, 3, 8, 'DEFENSIVE', 95);

INSERT INTO Grimoar_obsahuje (Grimoar_id, Kuzlo_id)
VALUES (1, 1);
INSERT INTO Grimoar_obsahuje (Grimoar_id, Kuzlo_id)
VALUES (2, 2);
INSERT INTO Grimoar_obsahuje (Grimoar_id, Kuzlo_id)
VALUES (2, 1);

INSERT INTO Grimoar_je_vlastneny (Grimoar_id, Kuzelnik_id, Od, Do)
VALUES (1, 3, DATE '2010-10-10', DATE '2030-06-26');
INSERT INTO Grimoar_je_vlastneny (Grimoar_id, Kuzelnik_id, Od, Do)
VALUES (2, 4, DATE '2018-02-15', DATE '2019-11-26');

INSERT INTO Miesto_s_magiou (Miera_magie, Presakujuci_element)
VALUES (65, 2);
INSERT INTO Miesto_s_magiou (Miera_magie, Presakujuci_element)
VALUES (90, 1);


--Select--

-- spojenie 2 tabuliek --

-- Miesta s magiou na ktorych presakuje element so specializaciou 'ICE'
SELECT "m".Id AS "id",
       "m".Miera_magie AS "magia"
FROM Miesto_s_magiou "m"
JOIN Element "e" ON "e".ID = "m".Presakujuci_element
WHERE "e".Specializacia = 'ICE'
ORDER BY "id", "magia";

-- Grimoary vlastnene kuzelnikom s ID = 3
SELECT "v".Grimoar_id AS "id",
       "v".Od AS "od",
       "v".Do AS "do"
FROM Grimoar_je_vlastneny "v"
JOIN Kuzelnik "k" ON "v".Kuzelnik_id = "k".ID
WHERE "k".ID = 3
ORDER BY "id", "od", "do";


-- spojenie 3 tabuliek --

-- Vlastnosti grimoaru: energia, autor, element
SELECT "g".ID AS "id",
       "g".Energia AS "energia",
       "u".ID AS "autor",
       "e".ID AS "element"
FROM Grimoar "g"
JOIN Ucitel "u" ON "g".Autor_id = "u".ID
JOIN Element "e" on "g".Primarny_element = "e".ID
ORDER BY "id", "energia";


-- group by a agregacna funkcia --

-- Ktory element synerguje viac ako s 1 kuzelnikom
SELECT "s".Element_id AS "element",
       COUNT("s".Element_id) AS "pocet"
FROM Synergia "s"
JOIN Kuzelnik "k" on "s".Kuzelnik_id = "k".ID
JOIN Element "e" on "s".Element_id = "e".ID
GROUP BY "s".Element_id
HAVING COUNT("s".Element_id) > 1
ORDER BY "s".Element_id;

-- Ktory grimoar obsahuje viac ako 1 kuzlo
SELECT "o".Grimoar_id AS "grimoar",
       COUNT("o".Grimoar_id) AS "pocet kuziel"
FROM Grimoar_obsahuje "o"
JOIN Grimoar "g" on "o".Grimoar_id = "g".ID
JOIN Kuzlo "k" on "o".Kuzlo_id = "k".ID
GROUP BY "o".Grimoar_id
HAVING COUNT("o".Grimoar_id) > 1
ORDER BY "pocet kuziel";


--predikat exists

--Ktori kuzelnici su ucitelia
SELECT "k".ID AS "id",
       "k".Uroven AS "uroven",
       "k".Velkost_many AS "mana"
FROM Kuzelnik "k"
WHERE EXISTS(
        SELECT *
        FROM Ucitel "u"
        WHERE "u".ID = "k".Ucitel_ID
    )
ORDER BY "id";


--predikat in--

--Ktory grimoar ma primarny element taky ze presakuje na nejakom mieste s magiou (teda je mozne ho tam nabit energiou)
SELECT "g".ID AS "id",
       "g".Energia AS "energia",
       "g".Primarny_element AS "element"
FROM Grimoar "g"
WHERE "g".Primarny_element IN (
        SELECT "m".Presakujuci_element
        FROM Miesto_s_magiou "m"
    )
ORDER BY "energia" DESC;





