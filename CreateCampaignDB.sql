
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS PhoneTBL;
CREATE TABLE IF NOT EXISTS PhoneTBL (
  phoneID int(10) NOT NULL AUTO_INCREMENT,
  phoneType varchar(10) NOT NULL default 'work',
  phoneNum int(20) NOT NULL,
  PRIMARY KEY  (phoneID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS ClientTBL;
CREATE TABLE IF NOT EXISTS ClientTBL (
  clientID int(10) NOT NULL AUTO_INCREMENT,
  clientCompanyName varchar(50) NOT NULL,
  fName varchar(10) NOT NULL,
  lName varchar(10) NOT NULL,
  dob date NOT NULL,
  gender enum('M', 'F') NOT NULL,
  street varchar(50) NOT NULL,
  town varchar(10) NOT NULL,
  postcode varchar(8) NOT NULL,
  country varchar(10) NOT NULL default 'UK',
  email varchar(50) NOT NULL,
  phoneID int(10),
  PRIMARY KEY  (clientID),
  FOREIGN KEY  (phoneID) REFERENCES PhoneTBL (phoneID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS CampaignTBL;
CREATE TABLE IF NOT EXISTS CampaignTBL (
  campaignID int(20) NOT NULL AUTO_INCREMENT,
  campaignName varchar(50) NOT NULL,
  startDate date NOT NULL,
  endData date NOT NULL,
  campaignCost int(10) unsigned NOT NULL default 0,
  clientID int(10),
  KEY clientID (clientID),
  PRIMARY KEY  (campaignID),
  FOREIGN KEY  (clientID) REFERENCES ClientTBL (clientID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS JobTBL;
CREATE TABLE IF NOT EXISTS JobTBL (
  jobID int(10) NOT NULL AUTO_INCREMENT,
  jobTitle varchar(20) NOT NULL,
  hourlyRate int(10) NOT NULL default 0,
  PRIMARY KEY  (jobID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS EmployeeTBL;
CREATE TABLE IF NOT EXISTS EmployeeTBL (
  employeeID int(10) NOT NULL AUTO_INCREMENT,
  fName varchar(10) NOT NULL,
  lName varchar(10) NOT NULL,
  dob date NOT NULL,
  gender enum('M', 'F') NOT NULL,
  street varchar(50) NOT NULL,
  town varchar(10) NOT NULL,
  postcode varchar(8) NOT NULL,
  country varchar(10) NOT NULL default 'UK',
  email varchar(50) NOT NULL,
  phoneID int(10) NOT NULL,
  jobID int(10) NOT NULL,
  supervisorID int(10) default NULL,
  managesCampaign int(20) default NULL,
  PRIMARY KEY  (employeeID),
  FOREIGN KEY  (phoneID) REFERENCES PhoneTBL (phoneID),
  FOREIGN KEY  (jobID) REFERENCES JobTBL (jobID),
  FOREIGN KEY  (supervisorID) REFERENCES EmployeeTBL (employeeID),
  FOREIGN KEY  (managesCampaign) REFERENCES CampaignTBL (campaignID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS CampaignEmployeeTBL;
CREATE TABLE IF NOT EXISTS CampaignEmployeeTBL (
  campaignID int(20) NOT NULL,
  employeeID int(20) NOT NULL,
  hours int(10) NOT NULL,
  PRIMARY KEY  (campaignID,employeeID),
  FOREIGN KEY  (campaignID) REFERENCES CampaignTBL (campaignID) ON DELETE CASCADE,
  FOREIGN KEY  (employeeID) REFERENCES EmployeeTBL (employeeID) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS InvoiceTBL;
CREATE TABLE IF NOT EXISTS InvoiceTBL (
  invoiceID int(10) NOT NULL AUTO_INCREMENT,
  generatedDate date NOT NULL,
  dueDate date NOT NULL,
  paidDate date NOT NULL,
  campaignID int(20) NOT NULL,
  issuedByEmployee int(20) NOT NULL,
  PRIMARY KEY  (invoiceID),
  FOREIGN KEY  (campaignID) REFERENCES CampaignTBL (campaignID) ON DELETE CASCADE,
  FOREIGN KEY  (issuedByEmployee) REFERENCES EmployeeTBL (employeeID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS AdvertTBL;
CREATE TABLE IF NOT EXISTS AdvertTBL (
  adType varchar(10) NOT NULL,
  typeID int(2) NOT NULL,
  PRIMARY KEY  (adType)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS SationTBL;
CREATE TABLE IF NOT EXISTS SationTBL (
  stationID int(10) NOT NULL AUTO_INCREMENT,
  stationName varchar(20) NOT NULL,
  PRIMARY KEY  (stationID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS TVRadioTBL;
CREATE TABLE IF NOT EXISTS TVRadioTBL (
  adID int(11) NOT NULL AUTO_INCREMENT,
  adType varchar(10) NOT NULL,
  releaseDate date NOT NULL,
  adCost int(10) NOT NULL default 0,
  adLength enum('10s', '30s', '60'),
  timeslot enum('prime', 'day', 'night'),
  numOfBroadcast int(2) NOT NULL default 0,
  stationID int(2) NOT NULL,
  campaignID int(20) NOT NULL,
  PRIMARY KEY  (adID),
  FOREIGN KEY  (adType) REFERENCES AdvertTBL (adType),
  FOREIGN KEY  (stationID) REFERENCES SationTBL (stationID),
  FOREIGN KEY  (campaignID) REFERENCES CampaignTBL (campaignID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS MagazineTBL;
CREATE TABLE IF NOT EXISTS MagazineTBL (
  magzineID int(10) NOT NULL AUTO_INCREMENT,
  magazineName varchar(30) NOT NULL,
  PRIMARY KEY  (magzineID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS MagazineAdTBL;
CREATE TABLE IF NOT EXISTS MagazineAdTBL (
  adID int(11) NOT NULL AUTO_INCREMENT,
  adType varchar(10) NOT NULL,
  releaseDate date NOT NULL,
  adCost int(10) NOT NULL default 0,
  sizePercentage enum('30', '50','100'),
  position enum('inside front', 'inside back', 'other'),
  numberOfIssues int(2) NOT NULL default 0,
  magzineID int (10) NOT NULL,
  campaignID int(20) NOT NULL,
  PRIMARY KEY  (adID),
  FOREIGN KEY  (adType) REFERENCES AdvertTBL (adType),
  FOREIGN KEY  (magzineID) REFERENCES MagazineTBL (magzineID),
  FOREIGN KEY  (campaignID) REFERENCES CampaignTBL (campaignID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS WebCompanyTBL;
CREATE TABLE IF NOT EXISTS WebCompanyTBL (
  webCompanyID int(10) NOT NULL AUTO_INCREMENT,
  webCompanyName varchar(50) NOT NULL,
  PRIMARY KEY  (webCompanyID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS WebAdTBL;
CREATE TABLE IF NOT EXISTS WebAdTBL (
  adID int(11) NOT NULL AUTO_INCREMENT,
  adType varchar(10) NOT NULL,
  campaignID int(20) NOT NULL,
  releaseDate date NOT NULL,
  adCost int(10) NOT NULL CHECK (adCost>0),
  webCompanyID int(10) NOT NULL,
  demographic enum('children', 'teenager', 'adult', 'elderly'),
  region enum('Europe', 'UK', 'worldwide'),
  numOfImpression int(10) NOT NULL default 0,
  PRIMARY KEY  (adID),
  FOREIGN KEY  (adType) REFERENCES AdvertTBL (adType),
  FOREIGN KEY  (webCompanyID) REFERENCES WebCompanyTBL (webCompanyID),
  FOREIGN KEY  (campaignID) REFERENCES CampaignTBL (campaignID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
