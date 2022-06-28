CREATE TABLE Person
(
	ID INT IDENTITY(1,1),
	FIRSTNAME VARCHAR(250) NOT NULL,
	LASTNAME VARCHAR(250) NOT NULL,
	DATEOFBIRTH DATE NULL,
	GENDER SMALLINT NOT NULL DEFAULT 0,
	CONSTRAINT PK_ID PRIMARY KEY(ID)
)

CREATE TABLE Email
(
	EMAILID INT IDENTITY(1,1) PRIMARY KEY,
	EMAILADDRESS VARCHAR(400) UNIQUE
)

CREATE TABLE PersonEmail
(
	PERSONID INT NOT NULL,
	EmailID INT NOT NULL,
	EMAILTYPE SMALLINT NOT NULL DEFAULT 1,
	CONSTRAINT FK_PERSONID_EMAIL FOREIGN KEY (PERSONID)
		REFERENCES Person (ID),
	CONSTRAINT FK_EMAILID_EMAIL FOREIGN KEY (EmailID)
		REFERENCES Email (EmailID),
	CONSTRAINT PK_PersonEmail PRIMARY KEY (PersonID, EmailID)
);

-- USERTYPE:
--	1: Regular
--	2: Super User
CREATE TABLE Users
(
	USERID INT IDENTITY(1,1),
	PersonID INT NOT NULL,
	PASSWORD VARCHAR(20) NOT NULL,
	USERTYPE INT NOT NULL DEFAULT 1,
	CONSTRAINT FK_PersonID_USERS FOREIGN KEY (PersonID)
		REFERENCES Person (ID),
	CONSTRAINT PK_UserID PRIMARY KEY (USERID)
);

CREATE TABLE Candidate
(
	CANDIDATEID INT IDENTITY(1,1),
	PERSONID INT NOT NULL UNIQUE,
	BIO TEXT NULL,
	--LEADERSHIPSTYLE VARCHAR(250),
	--HIGHLIGHTS TEXT,
	--ELE
	CONSTRAINT PK_CANDIDATEID PRIMARY KEY (CANDIDATEID),
	CONSTRAINT FK_PERSONID_CANDIDATE FOREIGN KEY (PERSONID)
		REFERENCES Person (ID)
);

CREATE TABLE Pages
(
	PAGEID INT IDENTITY(1,1),
	USERID INT NOT NULL,
	CANDIDATEID INT NOT NULL,
	CONSTRAINT PK_PAGEID PRIMARY KEY (PAGEID),
	CONSTRAINT FK_USERID_PAGES FOREIGN KEY (USERID)
		REFERENCES Users (USERID),
	CONSTRAINT FK_CANDIDATEID_PAGES FOREIGN KEY (CANDIDATEID)
		REFERENCES Candidate (CANDIDATEID)
);


CREATE TABLE URLS
(
	URLID INT IDENTITY(1,1),
	URLNAME VARCHAR(250) UNIQUE NOT NULL,
	CONSTRAINT PK_URL PRIMARY KEY (URLID) 
);

CREATE TABLE PageURLS
(
	URLID INT NOT NULL,
	PAGEID INT NOT NULL,
	LINK TEXT NOT NULL,
	CONSTRAINT FK_PAGEID_PageURLS FOREIGN KEY (PageID)
		REFERENCES Pages (PAGEID),
	CONSTRAINT FK_URLID_PageURLS FOREIGN KEY (URLID)
		REFERENCES URLS (URLID),
	CONSTRAINT PK_PAGEURLS PRIMARY KEY (URLID, PageID)
)

-- Table of policies 
-- Policy ID:
-- 1: Economic
-- 2: Social
-- 3: Environment
-- 4: Leadership
CREATE TABLE Policies
(
	POLICYID INT IDENTITY(1,1),
	POLICYNAME VARCHAR(30) UNIQUE NOT NULL,
	CONSTRAINT PK_POLICY PRIMARY KEY (PolicyID)
)

CREATE TABLE PolicyCard
(
	POLICYCARDID INT IDENTITY(1,1),
	CANDIDATEID INT NOT NULL,
	POLICYID INT NOT NULL,
	TITLE VARCHAR(50) NOT NULL,
	DETAILS VARCHAR(75) NOT NULL,
	LEARNMORE VARCHAR(500) NOT NULL,
	CONSTRAINT FK_PAGEID_PolicyCard FOREIGN KEY (CANDIDATEID)
		REFERENCES Candidate (CANDIDATEID),
	CONSTRAINT FK_POLICYID_PolicyCard FOREIGN KEY (POLICYID)
		REFERENCES Policies (POLICYID),
	CONSTRAINT PK_POLICYCARD PRIMARY KEY (POLICYCARDID)
)

CREATE TABLE KeyPlatforms
(
	PLATFORMID INT IDENTITY(1,1),
	CANDIDATEID INT NOT NULL,
	TITLE VARCHAR(100) NOT NULL,
	DESCRIPTION TEXT NOT NULL,
	CONSTRAINT PK_PLATFORMID PRIMARY KEY (PLATFORMID),
	CONSTRAINT FK_CANDIDATEID_KEYPLATFORMS FOREIGN KEY (CANDIDATEID)
		REFERENCES Candidate (CANDIDATEID)
)

CREATE TABLE Region
(
	REGIONID INT IDENTITY(1,1),
	REGIONNAME VARCHAR(100) NOT NULL,
	CONSTRAINT PK_REGION PRIMARY KEY (REGIONID)
)

CREATE TABLE Country
(
	COUNTRYID INT IDENTITY(1,1),
	COUNTRYNAME VARCHAR(80) NOT NULL,
	CONSTRAINT PK_COUNTRY PRIMARY KEY (COUNTRYID)
)

CREATE TABLE Addresses
(
	ADDRESSID INT IDENTITY(1,1),
	STREET VARCHAR(100) NOT NULL,
	CITY VARCHAR(100) NOT NULL,
	POSTALCODE VARCHAR(20) NOT NULL
	CONSTRAINT PK_ADDRESS PRIMARY KEY (ADDRESSID)
)

CREATE TABLE RegionAddress
(
	ADDRESSID INT NOT NULL,
	REGIONID INT NOT NULL,
	CONSTRAINT FK_ADDRESSID_REGIONADDRESS FOREIGN KEY (ADDRESSID)
		REFERENCES Addresses (ADDRESSID),
	CONSTRAINT FK_REGIONID_REGIONADDRESS FOREIGN KEY (REGIONID)
		REFERENCES Region (REGIONID),
	CONSTRAINT PK_REGIONADDRESS PRIMARY KEY (ADDRESSID, REGIONID)
)

CREATE TABLE RegionCountry
(
	COUNTRYID INT NOT NULL,
	REGIONID INT NOT NULL,
	CONSTRAINT FK_COUNTRYID_REGIONCOUNTRY FOREIGN KEY (COUNTRYID)
		REFERENCES Country (COUNTRYID),
	CONSTRAINT FK_REGIONID_REGIONCOUNTRY FOREIGN KEY (REGIONID)
		REFERENCES Region (REGIONID),
	CONSTRAINT PK_REGIONCOUNTRY PRIMARY KEY (COUNTRYID, REGIONID)
)


--CREATE TABLE Organization
--(
--	ORGID INT IDENTITY(1,1),
--	ORGNAME VARCHAR(250) NOT NULL,
--	ORGTYPE SMALLINT NOT NULL DEFAULT 1,
--	DESCRIPTION TEXT,
--	CONSTRAINT PK_ORGID PRIMARY KEY(ORGID)
--)
--GO


CREATE TABLE Style
(
	STYLEID INT IDENTITY(1,1),
	STYLENAME VARCHAR(50) NOT NULL,
	CONSTRAINT PK_STYLEID PRIMARY KEY(STYLEID)
)