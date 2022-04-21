CREATE DATABASE IF NOT EXISTS `IGI-3014-TD10s-GP4`;
USE `IGI-3014-TD10s-GP4`;
DROP TABLE IF EXISTS Responsable;
DROP TABLE IF EXISTS Epoque;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Coordonnees;
DROP TABLE IF EXISTS Operation;
DROP TABLE IF EXISTS Decouverte;
DROP TABLE IF EXISTS Appartenir;
CREATE TABLE IF NOT EXISTS Responsable(
  idResponsable INT AUTO_INCREMENT,
  nomResponsable VARCHAR(50),
  prenomResponsable VARCHAR(50),
  PRIMARY KEY(idResponsable)
) AUTO_INCREMENT = 0;
CREATE TABLE IF NOT EXISTS Epoque(
  idEpoque INT AUTO_INCREMENT,
  libelleEpoque VARCHAR(50) NOT NULL,
  PRIMARY KEY(idEpoque)
) AUTO_INCREMENT = 0;
CREATE TABLE IF NOT EXISTS Adresse(
  idAdresse INT AUTO_INCREMENT,
  codePostaleAdresse DECIMAL(5, 0),
  adresseAdresse VARCHAR(100),
  communeAdresse VARCHAR(100),
  PRIMARY KEY(idAdresse)
) AUTO_INCREMENT = 0;
CREATE TABLE IF NOT EXISTS Coordonnees(
  idCoordonnees INT AUTO_INCREMENT,
  xCoordonnees DOUBLE NOT NULL,
  yCoordonnees DOUBLE NOT NULL,
  geoShapeCoordonnees JSON,
  geoPoint2DCoordonnees TEXT,
  PRIMARY KEY(idCoordonnees)
) AUTO_INCREMENT = 0;
CREATE TABLE IF NOT EXISTS Operation(
  idOperation INT AUTO_INCREMENT,
  dateOperation DECIMAL(4, 0),
  natureOperation VARCHAR(50),
  idResponsable_organise INT NOT NULL,
  PRIMARY KEY(idOperation),
  FOREIGN KEY(idResponsable_organise) REFERENCES Responsable(idResponsable)
) AUTO_INCREMENT = 0;
CREATE TABLE IF NOT EXISTS Decouverte(
  idDecouverte SMALLINT,
  syntheseDecouverte VARCHAR(15000),
  idCoordonnees_localise INT,
  idOperation_decouvre INT NOT NULL,
  idAdresse_situe INT,
  PRIMARY KEY(idDecouverte),
  FOREIGN KEY(idCoordonnees_localise) REFERENCES Coordonnees(idCoordonnees),
  FOREIGN KEY(idOperation_decouvre) REFERENCES Operation(idOperation),
  FOREIGN KEY(idAdresse_situe) REFERENCES Adresse(idAdresse)
);
CREATE TABLE IF NOT EXISTS Appartenir(
  idEpoque_appartient INT,
  idDecouverte_a_appartenu SMALLINT,
  PRIMARY KEY(idEpoque_appartient, idDecouverte_a_appartenu),
  FOREIGN KEY(idEpoque_appartient) REFERENCES Epoque(idEpoque),
  FOREIGN KEY(idDecouverte_a_appartenu) REFERENCES Decouverte(idDecouverte)
);
INSERT INTO Epoque(libelleEpoque)
VALUES ("Préhistoire"),
  ("Protohistoire"),
  ("Antiquité"),
  ("Moyen-Age"),
  ("Temps modernes"),
  ("Epoque contemporaine");
USE `IGI-3014-TD10s-GP4`;
SELECT *
FROM Decouverte
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu
WHERE idEpoque_appartient = 4
ORDER BY (
    SELECT Operation.dateOperation
    FROM Operation
    WHERE Operation.idOperation = Decouverte.idOperation_decouvre
  ) ASC;
-- * OK
-- Sélectionne les découverte de l'époque "Moyen-Age" par ordre chronologique croissant
USE `IGI-3014-TD10s-GP4`;
SELECT dateOperation,
  natureOperation,
  syntheseDecouverte
FROM Decouverte
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu
  INNER JOIN Operation ON Decouverte.idOperation_decouvre = Operation.idOperation
WHERE idEpoque_appartient = 4
ORDER BY dateOperation ASC;
-- * OK
-- Compte le nombre de découvertes par époque
USE `IGI-3014-TD10s-GP4`;
SELECT libelleEpoque,
  COUNT(idEpoque) AS nbDecouverte
FROM Epoque
  INNER JOIN Appartenir ON Epoque.idEpoque = Appartenir.idEpoque_appartient
GROUP BY idEpoque;
-- * OK
-- Sélectionner la première découverte de chaque époque
USE `IGI-3014-TD10s-GP4`;
SELECT libelleEpoque,
  dateOperation,
  natureOperation,
  syntheseDecouverte
FROM Decouverte
  INNER JOIN Operation ON Decouverte.idOperation_decouvre = Operation.idOperation
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu
  INNER JOIN Epoque ON Appartenir.idEpoque_appartient = Epoque.idEpoque
GROUP BY idEpoque_appartient
ORDER BY dateOperation ASC;
-- Sélectionner la première découverte archéologique recensée à Paris
USE `IGI-3014-TD10s-GP4`;
SELECT *
FROM Decouverte
  JOIN Adresse ON Decouverte.idAdresse_situe = Adresse.idAdresse
  JOIN Operation ON Decouverte.idOperation_decouvre = Operation.idOperation
WHERE communeAdresse = "Paris"
ORDER BY dateOperation ASC
LIMIT 1;
-- Sélectionner toutes les découvertes qui traversent l’époque du Moyen-Age et la Renaissance
USE `IGI-3014-TD10s-GP4`;
SELECT *
FROM Decouverte
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu;
-- Nombre d'époques pour chaque découverte
USE `IGI-3014-TD10s-GP4`;
SELECT idDecouverte,
  syntheseDecouverte,
  COUNT(idEpoque_appartient) as nbDecouvertes
FROM Decouverte
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu
GROUP BY idEpoque_appartient;
-- Toutes les découvertes dont le responsable est Théodore Vacquer
USE `IGI-3014-TD10s-GP4`;
SELECT CONCAT(prenomResponsable, " ", nomResponsable) AS responsable,
  syntheseDecouverte,
  dateOperation,
  natureOperation,
  adresseAdresse,
  communeAdresse
FROM Decouverte
  INNER JOIN Operation ON Decouverte.idOperation_decouvre = Operation.idOperation
  INNER JOIN Responsable ON Operation.idResponsable_organise = Responsable.idResponsable
  INNER JOIN Adresse ON Decouverte.idAdresse_situe = Adresse.idAdresse
WHERE nomResponsable = "Vacquer"
  AND prenomResponsable = "Théodore";
-- Nombre moyen d'opérations par responsable
USE `IGI-3014-TD10s-GP4`;
SELECT CONCAT(prenomResponsable, " ", nomResponsable) AS responsable,
  COUNT(idOperation) AS nbOperations
FROM Responsable
  INNER JOIN Operation ON Responsable.idResponsable = Operation.idResponsable_organise
GROUP BY prenomResponsable;
-- Année moyenne, min, max de découverte pour chaque époque
USE `IGI-3014-TD10s-GP4`;
SELECT libelleEpoque,
  AVG(dateOperation) AS anneeMoyenne,
  MIN(dateOperation) AS anneeMin,
  MAX(dateOperation) AS anneeMax,
  COUNT(idOperation) AS nbOperations
FROM Decouverte
  INNER JOIN Appartenir ON Decouverte.idDecouverte = Appartenir.idDecouverte_a_appartenu
  INNER JOIN Operation ON Decouverte.idOperation_decouvre = Operation.idOperation
  INNER JOIN Epoque ON Appartenir.idEpoque_appartient = Epoque.idEpoque
WHERE dateOperation != 9999
GROUP BY idEpoque_appartient;