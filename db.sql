-- `IGI-3014-TD10s-GP4`
CREATE DATABASE IF NOT EXISTS `IGI-3014-TD10s-GP4`;
USE `IGI-3014-TD10s-GP4`;
DROP TABLE IF EXISTS Responsable;
DROP TABLE IF EXISTS Epoque;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Coordonnees;
DROP TABLE IF EXISTS Operation;
DROP TABLE IF EXISTS Decouverte;
DROP TABLE IF EXISTS Appartenir;
-- * Fait
CREATE TABLE IF NOT EXISTS Responsable(
  idResponsable INT AUTO_INCREMENT,
  nomResponsable VARCHAR(50),
  prenomResponsable VARCHAR(50),
  PRIMARY KEY(idResponsable)
) AUTO_INCREMENT = 0;
-- TODO: créer le csv des époques
CREATE TABLE IF NOT EXISTS Epoque(
  idEpoque INT AUTO_INCREMENT,
  libelleEpoque VARCHAR(50) NOT NULL,
  PRIMARY KEY(idEpoque)
) AUTO_INCREMENT = 0;
-- * Insérer : fait
CREATE TABLE IF NOT EXISTS Adresse(
  idAdresse INT AUTO_INCREMENT,
  codePostaleAdresse DECIMAL(5, 0),
  adresseAdresse VARCHAR(100),
  communeAdresse VARCHAR(100),
  PRIMARY KEY(idAdresse)
) AUTO_INCREMENT = 0;
-- * Insérer : fait
CREATE TABLE IF NOT EXISTS Coordonnees(
  idCoordonnees INT AUTO_INCREMENT,
  xCoordonnees DOUBLE NOT NULL,
  yCoordonnees DOUBLE NOT NULL,
  geoShapeCoordonnees JSON,
  geoPoint2DCoordonnees TEXT,
  PRIMARY KEY(idCoordonnees)
) AUTO_INCREMENT = 0;
-- TODO: Créer un script 
CREATE TABLE IF NOT EXISTS Operation(
  idOperation INT AUTO_INCREMENT,
  dateOperation DECIMAL(4, 0),
  natureOperation VARCHAR(50),
  idResponsable_organise INT NOT NULL,
  PRIMARY KEY(idOperation),
  FOREIGN KEY(idResponsable_organise) REFERENCES Responsable(idResponsable)
) AUTO_INCREMENT = 0;
-- TODO: créer un script
CREATE TABLE IF NOT EXISTS Decouverte(
  idDecouverte SMALLINT,
  syntheseDecouverte VARCHAR(8000),
  idCoordonnees_localise INT,
  idOperation_decouvre INT NOT NULL,
  idAdresse_situe INT,
  PRIMARY KEY(idDecouverte),
  FOREIGN KEY(idCoordonnees_localise) REFERENCES Coordonnees(idCoordonnees),
  FOREIGN KEY(idOperation_decouvre) REFERENCES Operation(idOperation),
  FOREIGN KEY(idAdresse_situe) REFERENCES Adresse(idAdresse)
);
-- TODO: 
CREATE TABLE IF NOT EXISTS Appartenir(
  idEpoque_appartient INT,
  idDecouverte_a_appartenu SMALLINT,
  PRIMARY KEY(idEpoque_appartient, idDecouverte_a_appartenu),
  FOREIGN KEY(idEpoque_appartient) REFERENCES Epoque(idEpoque),
  FOREIGN KEY(idDecouverte_a_appartenu) REFERENCES Decouverte(idDecouverte)
);