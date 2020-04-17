DROP TABLE Kuzelnik CASCADE CONSTRAINTS ;
DROP TABLE Grimoar CASCADE CONSTRAINTS ;
DROP TABLE Kuzlo CASCADE CONSTRAINTS ;
DROP TABLE Element CASCADE CONSTRAINTS ;
DROP TABLE Synergia CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_obsahuje CASCADE CONSTRAINTS ;
DROP TABLE Grimoar_je_vlastneny CASCADE CONSTRAINTS ;
DROP TABLE Miesto_s_magiou CASCADE CONSTRAINTS ;
DROP TABLE Ucitel CASCADE CONSTRAINTS ;
DROP SEQUENCE PKseq;

--Create--

CREATE TABLE Ucitel(
    ID int PRIMARY KEY
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

--trigger NULL PK--

CREATE SEQUENCE PKseq;
CREATE OR REPLACE TRIGGER autoincrement
  BEFORE INSERT ON Ucitel
  FOR EACH ROW
BEGIN
  :new.ID := PKseq.nextval;
END autoincrement;

--trigger switched dates--
CREATE OR REPLACE TRIGGER date_switch
    BEFORE INSERT OR UPDATE ON Grimoar_je_vlastneny
    FOR EACH ROW
DECLARE
    tmp date;
BEGIN
    IF (:new.Od > :new.Do) THEN
        tmp := :new.Od;
        :new.Od := :new.Do;
        :new.Do := tmp;
    END IF;
END date_switch;

--Insert--

INSERT INTO Ucitel(ID)
VALUES (1);
INSERT INTO Ucitel(ID)
VALUES (2);

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
INSERT INTO Grimoar (Energia, Autor_id, Primarny_element)--TEST
VALUES (30, 2, 1);

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


--apply autoincrement trigger--

INSERT INTO Ucitel(ID)
    VALUES (NULL);

--apply date_switch trigger--
INSERT INTO GRIMOAR_JE_VLASTNENY(Grimoar_id, Kuzelnik_id, Od, Do)
VALUES (3, 3, DATE '2020-10-10', DATE '2015-06-26');

--grant permissions--

GRANT ALL ON Ucitel TO xmacak07;
GRANT ALL ON Synergia TO xmacak07;
GRANT ALL ON Miesto_s_magiou TO xmacak07;
GRANT ALL ON Kuzlo TO xmacak07;
GRANT ALL ON Kuzelnik TO xmacak07;
GRANT ALL ON Grimoar_obsahuje TO xmacak07;
GRANT ALL ON Grimoar_je_vlastneny TO xmacak07;
GRANT ALL ON Grimoar TO xmacak07;
GRANT ALL ON Element TO xmacak07;

--procedures--

