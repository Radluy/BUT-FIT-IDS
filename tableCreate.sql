DROP TABLE Kuzelnik CASCADE CONSTRAINTS ;
DROP TABLE Grimoar CASCADE CONSTRAINTS ;
DROP TABLE Kuzlo CASCADE CONSTRAINTS ;
DROP TABLE Element CASCADE CONSTRAINTS ;
DROP TABLE Synergia CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_obsahuje CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_je_vlastneny CASCADE CONSTRAINTS ;
DROP TABLE Miesto_s_magiou CASCADE CONSTRAINTS ;
DROP TABLE Ucitel CASCADE CONSTRAINTS ;

CREATE TABLE Ucitel(
    ID int NOT NULL PRIMARY KEY
);

CREATE TABLE Kuzelnik(
    ID int NOT NULL PRIMARY KEY,
    Uroven numeric(2) NOT NULL,
    Velkost_many numeric(3) NOT NULL,
    Ucitel_ID int DEFAULT NULL,
    CONSTRAINT Ucitel_ID_FK
    FOREIGN KEY (Ucitel_ID) REFERENCES Ucitel (ID)
    ON DELETE SET NULL
);

CREATE TABLE Element(
    ID int NOT NULL PRIMARY KEY,
    Specializacia varchar(50)
        CHECK ( Specializacia in ('FIRE', 'ICE', 'WATER', 'AIR', 'EARTH', 'ELECTRIC', 'POISON', 'DARK', 'LIGHT')),
    Farba varchar(50)
);

CREATE TABLE Grimoar(
  ID int NOT NULL PRIMARY KEY,
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
    ID int NOT NULL PRIMARY KEY,
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
  ID int NOT NULL PRIMARY KEY,
  Miera_magie numeric(2) NOT NULL ,
  Presakujuci_element int NOT NULL ,
  FOREIGN KEY (Presakujuci_element) REFERENCES Element(ID)
);


--Insert--

INSERT INTO Ucitel (ID)
VALUES (1);
INSERT INTO Ucitel (ID)
VALUES (2);

INSERT INTO Kuzelnik (ID, Uroven, Velkost_many)
VALUES (3, 5, 90);
INSERT INTO Kuzelnik (ID, Uroven, Velkost_many)
VALUES (4, 50, 400);
INSERT INTO Kuzelnik (ID, Uroven, Velkost_many, Ucitel_ID)
VALUES (1, 90, 800, 1);
INSERT INTO Kuzelnik (ID, Uroven, Velkost_many, Ucitel_ID)
VALUES (5, 80, 750, 2);

INSERT INTO Element (ID, Specializacia, Farba)
VALUES (1, 'FIRE', 'RED');
INSERT INTO Element (ID, Specializacia, Farba)
VALUES (2, 'ICE', 'BLUE');
INSERT INTO Element (ID, Specializacia, Farba)
VALUES (3, 'AIR', 'WHITE');

INSERT INTO Grimoar (ID, Energia, Autor_id, Primarny_element)
VALUES (1, 90, 1, 2);
INSERT INTO Grimoar (ID, Energia, Autor_id, Primarny_element)
VALUES (2, 50, 2, 1);

INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (1, 2);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (4, 3);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (3, 3);
INSERT INTO Synergia (Kuzelnik_id, Element_id)
VALUES (5, 1);

INSERT INTO Kuzlo (ID, Hlavny_element, Zlozitost, Typ, Sila)
VALUES (1, 1, 6, 'OFFENSIVE', 75);
INSERT INTO Kuzlo (ID, Hlavny_element, Vedlajsi_element, Zlozitost, Typ, Sila)
VALUES (2, 2, 3, 8, 'DEFENSIVE', 95);

INSERT INTO Grimoar_obsahuje (Grimoar_id, Kuzlo_id)
VALUES (1, 1);
INSERT INTO Grimoar_obsahuje (Grimoar_id, Kuzlo_id)
VALUES (2, 2);

INSERT INTO Grimoar_je_vlastneny (Grimoar_id, Kuzelnik_id, Od, Do)
VALUES (1, 3, DATE '2010-10-10', DATE '2030-06-26');
INSERT INTO Grimoar_je_vlastneny (Grimoar_id, Kuzelnik_id, Od, Do)
VALUES (2, 4, DATE '2018-02-15', DATE '2019-11-26');

INSERT INTO Miesto_s_magiou (ID, Miera_magie, Presakujuci_element)
VALUES (1, 65, 2);


