--Az adatbázis kódja--
CREATE TABLE diak (
    diak_id INTEGER NOT NULL,
    nev     NVARCHAR(32),
    lakcim  NVARCHAR(32),
    telefon CHAR(13),
    szulev  DATE
);

ALTER TABLE diak ADD CONSTRAINT diak_pk PRIMARY KEY ( diak_id );

CREATE TABLE foglalas (
    foglalas_id      INTEGER NOT NULL,
    orak_ora_id      INTEGER NOT NULL,
    diak_diak_id     INTEGER NOT NULL,
    foglalas_idopont DATE,
    statusz          NVARCHAR(32)
);

CREATE UNIQUE INDEX foglalas__idx ON
    foglalas (
        orak_ora_id
    ASC );

ALTER TABLE foglalas ADD CONSTRAINT foglalas_pk PRIMARY KEY ( foglalas_id );

CREATE TABLE jarmu (
    jarmu_id INTEGER NOT NULL,
    tipus    NVARCHAR(32),
    valto    NVARCHAR(10),
    rendszam VARCHAR(10),
    ar       DECIMAL
);

ALTER TABLE jarmu ADD CONSTRAINT jarmu_pk PRIMARY KEY ( jarmu_id );

CREATE TABLE oktató (
    oktato_id     INTEGER NOT NULL,
    nev           NVARCHAR(32),
    telefon       CHAR(13),
    email         VARCHAR(32),
    engedely_szam VARCHAR(32)
);

ALTER TABLE oktató ADD CONSTRAINT oktató_pk PRIMARY KEY ( oktato_id );

CREATE TABLE orak (
    ora_id           INTEGER NOT NULL,
    oktató_oktato_id INTEGER,
    kezdes           DATETIME,
    veg              DATETIME,
    jarmu_jarmu_id   INTEGER NOT NULL
);

ALTER TABLE orak ADD CONSTRAINT orak_pk PRIMARY KEY ( ora_id );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_diak_fk FOREIGN KEY ( diak_diak_id )
        REFERENCES diak ( diak_id );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_orak_fk FOREIGN KEY ( orak_ora_id )
        REFERENCES orak ( ora_id );

ALTER TABLE orak
    ADD CONSTRAINT orak_jarmu_fk FOREIGN KEY ( jarmu_jarmu_id )
        REFERENCES jarmu ( jarmu_id );

ALTER TABLE orak
    ADD CONSTRAINT orak_oktató_fk FOREIGN KEY ( oktató_oktato_id )
        REFERENCES oktató ( oktato_id );



--A teszt adatok feltöltésének kódja--



INSERT INTO diak (diak_id, nev, lakcim, szulev, telefon)
VALUES
(1,'Kovács Anna', '1234 Budapest, Kossuth utca 1.', '1995-07-15', '06-30-1234567'),
(2,'Nagy Péter', '5678 Debrecen, Bajnok utca 2.', '1998-03-22', '06-20-9876543'),
(3,'Szabó János', '9100 Sopron, Ady Endre utca 3.', '2000-11-10', '06-70-5551234'),
(4,'Kiss Mariann', '3456 Miskolc, Jókai utca 4.', '1996-05-20','06-30-1112222'),
(5,'Tóth László', '7890 Székesfehérvár, Béke tér 5.', '1999-12-18','06-70-3334444')

INSERT INTO jarmu (jarmu_id, tipus, valto, rendszam, ar)
VALUES 
(111, 'Opel', 'Manuális', 'ABC-123', 5000),
(112, 'Volkswagen', 'Automata', 'DEF-456', 8500),
(113, 'Ford', 'Automata', 'XYZ-789', 9000),
(114, 'Suzuki', 'Manuális', 'GHI-789', 5500),
(115, 'Toyota', 'Manuális', 'JKL-012', 6000),
(116, 'BMW', 'Automata', 'KGT-769', 11000),
(117, 'Mercedes', 'Automata', 'ATU-197', 10000)

INSERT INTO oktató (oktato_id, nev, telefon, email, engedely_szam)
VALUES
(1, 'Kiss Éva', '06-20-1112222', 'kisseva@example.com', 'K123456'),
(2, 'Tóth István', '06-70-3334444', 'tothistvan@example.com', 'K654321'),
(3, 'Horváth Gábor', '06-30-5556666', 'horvathgabor@example.com', 'K987654'),
(4, 'Nagy Orsolya', '06-30-7778888', 'nagyorsolya@example.com', 'K234567'),
(5, 'Szabó András', '06-70-9990000', 'szaboandras@example.com', 'K765432')

INSERT INTO orak (ora_id, oktató_oktato_id, kezdes, veg, jarmu_jarmu_id)
VALUES
(1237, 2, '2018-06-07 08:00:00', '2018-06-07 10:00:00', 113),
(7643, 5, '2019-11-29 13:30:00', '2019-11-29 15:30:00', 115),
(3456, 3, '2024-01-21 09:00:00', '2024-01-21 11:00:00', 111),
(9862, 1, '2024-03-14 16:45:00', '2024-03-14 18:45:00', 112),
(7346, 4, '2020-08-29 08:00:00', '2020-08-29 10:00:00', 114),
(2575, 5, '2021-04-13 10:30:00', '2021-04-15 12:00:00', 115),
(4353, 3, '2023-09-10 20:00:00', '2023-09-10 21:00:00', 111)

INSERT INTO foglalas (foglalas_id, orak_ora_id, diak_diak_id, foglalas_idopont, statusz)
VALUES 
(54, 7346, 4, '2020-08-20 08:13:00', 'Visszaigazolt'),
(68, 9862, 5, '2024-02-28 01:12:00', 'Visszaigazolt'),
(94, 3456, 2, '2024-01-19 09:47:00', 'Visszaigazolt'),
(35, 7643, 1, '2019-11-22 01:12:00', 'Visszaigazolt'),
(19, 1237, 3, '2018-05-30 01:12:00', 'Visszaigazolt'),
(17, 2575, 2, '2021-04-12 10:30:00', 'Visszaigazolt'),
(78, 4353, 4, '2023-09-01 21:13:00', 'Visszaigazolt')



-- A lekérdezések kódjai--


--1 - Az összes foglalás adatainak áttekintése
SELECT F.foglalas_id AS 'Foglalás azonosítója', 
       D.nev AS 'Tanuló neve', 
       F.foglalas_idopont AS 'Foglalás ideje', 
       F.statusz AS 'Foglalás státusza',
       OK.nev AS 'Oktató neve'
FROM diak D JOIN foglalas F ON D.diak_id = F.diak_diak_id
			JOIN orak O ON F.orak_ora_id = O.ora_id
            JOIN oktató OK ON O.oktató_oktato_id = OK.oktato_id


--2 - az oktató neve és teljes bevétele
SELECT O.nev AS 'Oktató neve', 
	   O.engedely_szam,
	   SUM(J.ar) AS 'Teljes bevétel'
FROM oktató O JOIN orak R ON O.oktato_id = R.oktató_oktato_id
			  JOIN foglalas F ON R.ora_id = F.orak_ora_id
			  JOIN jarmu J ON R.jarmu_jarmu_id = J.jarmu_id
GROUP BY O.nev, O.engedely_szam;


--3 - a járművek adatai és a legtöbbet a járművön tanult diák
SELECT j.jarmu_id AS 'Jármű azonosítója',
	   j.tipus AS 'Jármű tipusa',
       j.ar AS 'Óránkénti ára',
	   MAX(R.kezdes) AS 'Utolsó használat időpontja', 
       f.statusz AS 'A foglalás státusza',
       MAX(F.diak_diak_id) AS 'Az autón legtöbbet tanult diák azonosítója'
FROM foglalas F JOIN orak R ON F.orak_ora_id = R.ora_id
				JOIN jarmu J ON J.jarmu_id = R.jarmu_jarmu_id
GROUP BY j.jarmu_id, j.tipus, j.ar, f.statusz


-- 4 Szabó Adnrásnál tanult diákok és az általuk használt különféle járművek
SELECT D.nev AS 'Diák neve', 
	   COUNT(DISTINCT J.jarmu_id) AS 'Különböző járművek száma'
FROM diak D JOIN foglalas F ON D.diak_id = F.diak_diak_id
			JOIN orak O ON F.orak_ora_id = O.ora_id
			JOIN jarmu j ON O.jarmu_jarmu_id = J.jarmu_id
WHERE O.oktató_oktato_id = (
  SELECT oktato_id 
  FROM oktató 
  WHERE nev = 'Szabó András')
GROUP BY D.nev;


-- 5 Az egyes foglalások csoportosítása fizetett összeg alapján
SELECT
    F.foglalas_id AS 'Foglalás azonosító',
    F.foglalas_idopont AS 'Foglalás időpont',
    J.ar AS 'Foglalás egységára',
    CASE
        WHEN J.ar < 5500 THEN 'Alacsony ár'
        WHEN J.ar BETWEEN 5500 AND 7000 THEN 'Közepes ár'
        WHEN J.ar BETWEEN 7000 AND 8500 THEN 'Magas ár'
        ELSE 'Nagyon magas ár'
    END AS 'Ár kategória'
FROM diak D JOIN foglalas F ON D.diak_id = F.diak_diak_id
			JOIN orak O ON F.orak_ora_id = O.ora_id
			JOIN jarmu j ON O.jarmu_jarmu_id = J.jarmu_id

-- 6 A 90 percnél hosszabb órát tartott oktatók
SELECT O.nev AS 'Oktató neve', 
       COUNT(R.ora_id) AS 'Összes 90 percnél hosszabb óra'
FROM oktató O JOIN orak R ON O.oktato_id = R.oktató_oktato_id
			  JOIN foglalas F ON R.ora_id = F.orak_ora_id
WHERE DATEDIFF(minute, r.kezdes, r.veg) > 90
GROUP BY o.nev;
	