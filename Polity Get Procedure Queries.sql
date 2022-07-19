-- Procedure to validate a user that's logging in
-- Parameters: email address, password
-- Returns the id of the user or 0
CREATE PROCEDURE ValidateUser(@EMAIL VARCHAR(400) = NULL, @PASSWORD VARCHAR(20) = NULL)
AS 
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	SELECT UserID
		FROM Users
	JOIN Person
		ON ID = Users.PERSONID
	JOIN PersonEmail
		ON ID = PersonEmail.PERSONID
	JOIN Email
		ON Email.EmailID = PersonEmail.EmailID
	WHERE EMAILADDRESS = @EMAIL
	AND PASSWORD = @PASSWORD

	-- Another way to do this
	-- SELECT IIF (EXISTS(
	--	SELECT *
	--		FROM Users
	--	JOIN Person
	--		ON ID = Users.PERSONID
	--	JOIN PersonEmail
	--		ON ID = PersonEmail.PERSONID
	--	JOIN Email
	--		ON Email.EmailID = PersonEmail.EmailID
	--	WHERE EMAILADDRESS = @EMAIL
	--	AND PASSWORD = @PASSWORD), 0, 1)

	IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE 
		RAISERROR('ValidateUser - SELECT error: User Table.', 16, 1)

	RETURN @ReturnCode
GO

-- Test for ValidateUser
-- EXECUTE ValidateUser 'test@gmail.com', 'password'
GO

-- Procedure to check if a person exists
-- Parameters: ID
-- Returns the ID or 0
CREATE PROCEDURE PersonChecker(@ID INT)
AS 
	DECLARE @ReturnCode INT = 0;

	IF EXISTS(SELECT TOP 1 ID FROM Person WHERE ID = @ID)
	BEGIN
		SET @ReturnCode = (SELECT TOP 1 ID FROM Person WHERE ID = @ID)
		SELECT @ReturnCode
	END 
	RETURN @ReturnCode
GO

-- Test for PersonChecker
-- EXECUTE PersonChecker 1
GO
-- EXECUTE PersonChecker 0
GO

-- Procedure to check if user exists
-- Parameters: User ID
-- Returns the user type or 0
CREATE PROCEDURE UserChecker(@UserID INT)
AS 
	DECLARE @ReturnCode INT = 0;

	IF EXISTS(SELECT TOP 1 USERID FROM USERS WHERE USERID = @UserID)
	BEGIN
		SET @ReturnCode = (SELECT USERTYPE FROM Users WHERE USERID = @UserID)
	END 

	RETURN @ReturnCode

-- Test for UserChecker
DECLARE @TestID INT
EXECUTE @TestID = UserChecker 1;
SELECT @TestID
GO

DECLARE @TestID INT
EXECUTE @TestID = UserChecker 2;
SELECT @TestID
GO

-- Procedure to check whether an email exists
-- Parameters: email address
-- Returns the email id
CREATE PROCEDURE EmailChecker(@EMAILADDRESS VARCHAR(400))
AS
	DECLARE @ReturnCode INT = 0;

	IF EXISTS(SELECT TOP 1 EmailID FROM Email WHERE EMAILADDRESS = @EMAILADDRESS)
	BEGIN
		SET @ReturnCode = 
		(
			SELECT EmailID
				FROM Email
			WHERE EMAILADDRESS = @EMAILADDRESS
		)
		SELECT @ReturnCode
	END 

	RETURN @ReturnCode
GO

-- Test email checker
--EXECUTE EmailChecker 'test@gmail.com'
GO

-- Procedure to get all candidates
-- Returns the page id, person id,
-- and candidate:	first name , 
--					last name, 
--					date of birth, 
--					gender, 
--					bio
CREATE PROCEDURE GetAllCandidates
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	SELECT 	PAGEID, ID, Candidate.CANDIDATEID, FIRSTNAME, LASTNAME, 
		CASE WHEN DATEOFBIRTH IS NULL 
		THEN CAST('0001-01-01' AS DATE)
	ELSE DATEOFBIRTH END,  GENDER, BIO
		FROM Pages
	JOIN Candidate
		ON Candidate.CANDIDATEID = Pages.CANDIDATEID
	JOIN PERSON
		ON PERSONID = ID

	IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE 
		RAISERROR('GetAllCandidates - SELECT error: User Table.', 16, 1)

	RETURN @ReturnCode
GO

-- Procedure to get user pages
-- Parameters: user id
-- Returns the page id, person id,
-- and candidate:	first name , 
--					last name, 
--					date of birth, 
--					gender, 
--					bio
CREATE PROCEDURE GetUserPages(@UserID INT)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	SELECT 	PAGEID, ID, Candidate.CANDIDATEID, FIRSTNAME, LASTNAME, 
		CASE WHEN DATEOFBIRTH IS NULL 
		THEN CAST('0001-01-01' AS DATE)
	ELSE DATEOFBIRTH END,  GENDER, BIO
		FROM Pages
	JOIN Candidate
		ON Candidate.CANDIDATEID = Pages.CANDIDATEID
	JOIN PERSON
		ON PERSONID = ID
	WHERE USERID = @UserID

	IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE 
		RAISERROR('GetUserPages - SELECT error: User Table.', 16, 1)

	RETURN @ReturnCode
GO

--EXECUTE GetUserPages 1;
GO 

-- Procedure to get user pages
-- Parameters: PageID
-- Returns the page id, person id,
-- and candidate:	first name , 
--					last name, 
--					date of birth, 
--					gender, 
--					bio
CREATE PROCEDURE GetPage(@PageID INT)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	SELECT 	PAGEID, ID, Candidate.CANDIDATEID, FIRSTNAME, LASTNAME, 
		CASE WHEN DATEOFBIRTH IS NULL
		THEN CAST('0001-01-01' AS DATE)
	ELSE DATEOFBIRTH END,  GENDER, BIO
		FROM Pages
	JOIN Candidate
		ON Candidate.CANDIDATEID = Pages.CANDIDATEID
	JOIN PERSON
		ON PERSONID = ID
	WHERE Pages.PAGEID = @PageID

	IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE 
		RAISERROR('GetPage - SELECT error: Page Table.', 16, 1)

	RETURN @ReturnCode
GO

-- EXECUTE GetPage 2;
GO 


-- Procedure to get a user's candidate via the page id
-- Parameters: page id
-- Returns the page id, person id,
-- and candidate:	first name , 
--					last name, 
--					date of birth, 
--					gender, 
--					bio
CREATE PROCEDURE GetCandidate(@PageID INT)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	SELECT ID, Candidate.CANDIDATEID, FIRSTNAME, LASTNAME, 
		CASE WHEN DATEOFBIRTH IS NULL 
		THEN CAST('0001-01-01' AS DATE)
	ELSE DATEOFBIRTH END,  GENDER, BIO
		FROM Pages
	JOIN Candidate
		ON Candidate.CANDIDATEID = Pages.CANDIDATEID
	JOIN PERSON
		ON PERSONID = ID
	WHERE PAGEID = @PageID

	IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE 
		RAISERROR('GetCandidate - SELECT error: Page Table.', 16, 1)

	RETURN @ReturnCode
GO

--EXECUTE GetCandidate 16;
GO 


-- Procedure to get user's information
-- Parameters: user id
-- Returns user's:	
--		person id,
--		first name , 
--		last name, 
--		date of birth, 
--		gender
CREATE PROCEDURE GetUserInformation(@UserID INT)
AS 
	DECLARE @ReturnID INT
	SET @ReturnID = 0

	SELECT ID, FIRSTNAME, LASTNAME, 
		CASE WHEN DATEOFBIRTH IS NULL 
			THEN '0000-00-00'
		ELSE DATEOFBIRTH END, 
		GENDER, USERTYPE 
		FROM Users
	JOIN Person
		ON ID = Users.PERSONID
	JOIN PersonEmail
		ON ID = PersonEmail.PERSONID
	JOIN Email
		ON Email.EmailID = PersonEmail.EmailID
	WHERE USERID = @UserID

	RETURN @ReturnID
GO

-- Test for the GetUserInformation procedure
EXECUTE GetUserInformation 1
EXECUTE GetUserInformation 2
GO


-- Procedure to get a page's url links
-- Parameters: Page's ID
-- Returns user's:	
--		URL ID,
--		URL NAME,
--		Link
CREATE PROCEDURE GetPageLinks(@PageID INT)
AS 
	IF EXISTS (SELECT * FROM Pages WHERE PAGEID = @PageID)
	BEGIN
		SELECT URLS.URLID, URLNAME, LINK
			FROM URLS
		JOIN PageURLS
			ON PageURLS.URLID = URLS.URLID
		WHERE PageURLS.PageID = @PageID
	END
GO

-- Test for GetPageLinks
EXECUTE GetPageLinks 2
GO

-- Procedure to get a candidate's policy card
-- Parameters: page id
-- Returns user's:	
--		Policy id,
--		Policy name, 
--		Title, 
--		Detail
--		Learn More
CREATE PROCEDURE GetCandidatePolicyCards(@CandidateID INT)
AS 

	IF EXISTS (SELECT * FROM Candidate WHERE CANDIDATEID = @CandidateID)
	BEGIN
		SELECT PolicyCard.POLICYCARDID, Policies.PolicyID, POLICYNAME, TITLE, DETAILS, LEARNMORE
			FROM Policies
		JOIN PolicyCard
			ON PolicyCard.POLICYID =  Policies.POLICYID
		WHERE PolicyCard.CANDIDATEID= @CandidateID
	END
GO

-- Test GetPagePolicyCards
EXECUTE GetCandidatePolicyCards 2
EXECUTE GetCandidatePolicyCards 1
GO
SELECT * FROM PolicyCard
GO

-- Procedure to get a candidate's key platforms
-- Parameters: CandidateID
-- Returns user's:	
--		Policy id,
--		Policy name, 
--		Title, 
--		Detail
CREATE PROCEDURE GetCandidateKeyPlatforms(@CandidateID INT)
AS 
	DECLARE @UserType INT

	IF EXISTS (SELECT * FROM Candidate WHERE CANDIDATEID = @CandidateID)
	BEGIN
		SELECT PLATFORMID, TITLE, DESCRIPTION
			FROM KeyPlatforms
		WHERE CANDIDATEID= @CandidateID
	END
GO

-- Test GetCandidateKeyPlatforms
EXECUTE GetCandidateKeyPlatforms 1
EXECUTE GetCandidateKeyPlatforms 2
SELECT * FROM KeyPlatforms
GO

-- Procedure to get the policies
-- Returns policies
CREATE PROCEDURE GetPolicies
AS 
	SELECT POLICYID, POLICYNAME
		FROM Policies
GO

-- Test GetPolicies
EXECUTE GetPolicies
GO

-- Procedure to get the policies
-- Returns policies
CREATE PROCEDURE GetURLs
AS 
	SELECT URLID, URLNAME
		FROM URLs
GO

-- Test GetPolicies
EXECUTE GetURLs
GO

-- Procedure to get a person's emails
-- Parameters: Person's ID
-- Returns a list of the person's email addresses
CREATE PROCEDURE GetPersonEmails
(
	@ID INT
)
AS 
	SELECT Email.EmailID, EMAILADDRESS, EMAILTYPE
		FROM PersonEmail
	JOIN Email
		ON PersonEmail.EmailID = Email.EmailID
	WHERE PERSONID = @ID
GO

-- Test for GetPersonEmails
EXECUTE GetPersonEmails 1