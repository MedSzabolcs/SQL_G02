<<<<<<< HEAD
CREATE TABLE Hazifeladat_2
(MemberID INT IDENTITY PRIMARY KEY,
teljes_nev varchar(100)	MASKED WITH (Function = 'default()'),
felhasznalonev varchar(100) MASKED WITH (Function = 'partial(1,"XYX",1)'),
email varchar(100) MASKED WITH (function = 'email()'),
foglalasok_szama int MASKED WITH (FUNCTION = 'random(1,10)'));

INSERT INTO Hazifeladat_2 (teljes_nev, felhasznalonev, email, foglalasok_szama)
SELECT V.nev, V.usernev, V.email, Count(F.FOGLALAS_PK)
FROM Vendeg V JOIN Foglalas F on V.USERNEV = f.UGYFEL_FK
GROUP BY V.NEV, V.USERNEV, V.email

CREATE USER MaszkFelahsznalo WITHOUT Login;
GRANT SELECT ON Hazifeladat_2 TO MaszkFelahsznalo

EXECUTE AS User= 'MaszkFelahsznalo';
SELECT * FROM Hazifeladat_2
=======
CREATE TABLE Hazifeladat_2
(MemberID INT IDENTITY PRIMARY KEY,
teljes_nev varchar(100)	MASKED WITH (Function = 'default()'),
felhasznalonev varchar(100) MASKED WITH (Function = 'partial(1,"XYX",1)'),
email varchar(100) MASKED WITH (function = 'email()'),
foglalasok_szama int MASKED WITH (FUNCTION = 'random(1,10)'));

INSERT INTO Hazifeladat_2 (teljes_nev, felhasznalonev, email, foglalasok_szama)
SELECT V.nev, V.usernev, V.email, Count(F.FOGLALAS_PK)
FROM Vendeg V JOIN Foglalas F on V.USERNEV = f.UGYFEL_FK
GROUP BY V.NEV, V.USERNEV, V.email

CREATE USER MaszkFelahsznalo WITHOUT Login;
GRANT SELECT ON Hazifeladat_2 TO MaszkFelahsznalo

EXECUTE AS User= 'MaszkFelahsznalo';
SELECT * FROM Hazifeladat_2
>>>>>>> eb2f132231ed3f2b5c1a5b224cce6bc3f20837a5
REVERT