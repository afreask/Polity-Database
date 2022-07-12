-- Procedure to add email addresses
-- Checks whether the email exists or not
-- Inserts the email if it exists and not null or whitespace blank
-- Parameters: email address
-- Returns the id of the email address
CREATE PROCEDURE AddEmail(@Email VARCHAR(400) = NULL, @UserID INT)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	
	IF @Email IS NOT NULL AND LEN(LTRIM(@Email)) > 0
	IF @UserType > 0
	BEGIN
		IF NOT EXISTS 
		(
			SELECT * FROM Email WHERE EMAILADDRESS = @Email
		)
			BEGIN
				INSERT INTO Email
					VALUES (@Email);
				SET @ReturnID = SCOPE_IDENTITY();
			END
	END
	RETURN @ReturnID
GO

-- Add email testing
EXECUTE AddEmail NULL, 1
EXECUTE AddEmail '', 1
EXECUTE AddEmail 'test3@gmail.com', 2
EXECUTE AddEmail 'test2@gmail.com', 1
-- Check for the return value
DECLARE @ReturnID INT
EXECUTE @ReturnID = AddEmail ''
SELECT @ReturnID
SELECT * FROM Email
GO
DECLARE @ReturnID INT
EXECUTE @ReturnID = AddEmail 'testcall3@gmail.com', 1
SELECT @ReturnID
SELECT * FROM Email
GO

-- Procedure to register an email to a person
-- Checks whether the email, and person exists or not
-- Registers the email to a person if they exist
-- Parameters: email ID, person ID, user ID
-- Returns: 1 if successful and 0 if not
CREATE PROCEDURE AddPersonEmail(@EmailID INT, @ID INT,  @UserID INT, @EmailType INT)
AS
	DECLARE @ReturnID INT, @UserType INT, @CurrID INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	EXECUTE @CurrID = PersonChecker @ID
	
	
	IF EXISTS (SELECT * FROM Email WHERE EMAILID = @EmailID)
	AND @CurrID > 0
	AND @UserType > 0
	AND NOT EXISTS (SELECT * FROM PersonEmail WHERE PERSONID = @ID AND EMAILID = @EmailID)
	BEGIN
		INSERT INTO PersonEmail
			VALUES (@ID, @EmailID, @EmailType)
		SET @ReturnID = 1
	END
	RETURN @ReturnID
GO

-- Add email testing
-- Check for the return value
DECLARE @ReturnID INT
EXECUTE @ReturnID = AddPersonEmail 2, 1, 1, 0
SELECT @ReturnID
SELECT * FROM PersonEmail
GO

-- Procedure to add a person
-- Parameters: first name, last name, birthday and gender
-- Return: ID of the newly person
-- Note: Assumes that the person being added is a new person 
-- due to the fact that many people share the same name.
CREATE PROCEDURE AddPerson(	
	@FirstName VARCHAR(250), 
	@LastName VARCHAR(250),
	@Birthday DATE = NULL,
	@Gender SMALLINT
)
AS
	DECLARE @ReturnID INT = 0, @BD DATE = NULL, @G SMALLINT = 0
	IF @FirstName IS NOT NULL AND LEN(LTRIM(@FirstName)) > 0
	AND @LastName IS NOT NULL AND LEN(LTRIM(@LastName)) > 0
	BEGIN
		IF @Birthday IS NOT NULL AND LEN(LTRIM(@Birthday)) > 0
		BEGIN
			SET @BD = @Birthday
		END
		IF @Gender > 0
		BEGIN
			SET @G = @Gender
		END 

		INSERT INTO Person
			VALUES (@FirstName, @LastName, @BD, @G)

		SET @ReturnID = SCOPE_IDENTITY();
	END 
	RETURN @ReturnID
GO

--Tests AddPerson
DECLARE @TestID INT
EXECUTE @TestID = AddPerson 'Jenny', 'Doe', '1992-08-24', 1;
SELECT @TestID
SELECT * FROM Person
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPerson 'Jacky', 'Doe', NULL , 0;
SELECT @TestID
SELECT * FROM Person
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPerson null, 'Doe', NULL , 0;
SELECT @TestID
SELECT * FROM Person
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPerson ' ', 'Doe', NULL , 0;
SELECT @TestID
SELECT * FROM Person
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPerson 'Regie', '', NULL , 0;
SELECT @TestID
SELECT * FROM Person
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPerson 'Regie', null, NULL , 0;
SELECT @TestID
SELECT * FROM Person
GO

-- Procedure to create a new candidate
-- Parameters: person's id and bio
-- Return: ID of the new candidate
-- Note: Assumes that the candidate being added is new 
-- due to the fact that many people share the same name.
CREATE PROCEDURE CreateCandidate(@UserID INT, @PID INT, @Bio TEXT = NULL)
AS 
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0
	EXECUTE @UserType = UserChecker @UserID

	IF @PID > 0
	AND @UserType > 0
	BEGIN
		INSERT INTO Candidate
			VALUES(@PID,@Bio)
		SET @ReturnID = SCOPE_IDENTITY()
	END
	RETURN @ReturnID
GO

--Test CreateCandidate
DECLARE @TestID INT
EXECUTE @TestID = CreateCandidate 1, 1, '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
';
SELECT @TestID
SELECT * FROM Candidate
GO
DECLARE @TestID INT
EXECUTE @TestID = CreateCandidate 1, 1, 'fauifgoakn
';
SELECT @TestID
GO
SELECT * FROM Candidate
GO


-- Procedure to add a page
-- Parameters: user id, bio, first name and last name
-- Return: ID of the new page or 0 if it was not successful
-- Note: Assumes that the person being added is a new person 
-- due to the fact that many people share the same name.
CREATE PROCEDURE AddPage
(
	@UserID INT, 
	@Bio TEXT, 
	@FirstName VARCHAR(250) = NULL, 
	@LastName VARCHAR(250) = NULL
)
AS
	DECLARE @ReturnID INT, @PID INT, @CID INT
	SET @ReturnID = 0
	
	IF @FirstName IS NOT NULL AND LEN(LTRIM(@FirstName)) > 0
	AND @LastName IS NOT NULL AND LEN(LTRIM(@LastName)) > 0
	AND EXISTS (SELECT * FROM Users WHERE USERID = @UserID)
	BEGIN
		EXECUTE @PID = AddPerson @Firstname, @LastName, NULL, 0
		IF @PID > 0
			BEGIN
				EXECUTE @CID = CreateCandidate @UserID, @PID, @Bio
				INSERT INTO Pages
					VALUES (@UserID, @CID)
				SET @ReturnID = SCOPE_IDENTITY() 
		END
	END

	RETURN @ReturnID
GO

-- Tests for add page
DECLARE @TestID INT
EXECUTE @TestID = AddPage 1, 'test add page', 'Jason', 'Doe';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPage 2, 'test add page', 'Jason', 'Doe';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPage 1, 'test add page', Null, 'Doe';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPage 2, 'test add page', 'Jason', Null;
SELECT @TestID
GO


-- Procedure to add a key platform
-- Parameters: 
-- Return: ID of the new platform or 0 if it was not successful
CREATE PROCEDURE AddPlatform
(
	@UserID INT,
	@CandidateID INT,
	@Title VARCHAR(100), 
	@Description TEXT
)
AS
	DECLARE @ReturnID INT
	SET @ReturnID = 0
	
	IF @Title IS NOT NULL AND LEN(LTRIM(@Title)) > 0
	AND EXISTS(SELECT * FROM Candidate WHERE CANDIDATEID = @CandidateID)
	BEGIN
		INSERT INTO KeyPlatforms
			VALUES (@CandidateID, @Title, @Description)
		SET @ReturnID = SCOPE_IDENTITY()
	END

	RETURN @ReturnID
GO

-- Test for the AddPlatform Procedure
DECLARE @TestID INT
DECLARE @CID INT = (select top 1 CANDIDATEID from candidate)
EXECUTE @TestID = AddPlatform 2, @CID, 'test add platform', 'test description';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPlatform 1, 1, NULL, 'test description';
SELECT @TestID
SELECT * FROM KeyPlatforms
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPlatform 1, 1, 'test add platform', NULL;
SELECT @TestID
GO
SELECT * FROM Candidate


-- Procedure to add a policy
-- Parameters: 
-- Return: ID of the new policy or 0 if it was not successful
CREATE PROCEDURE AddPolicy
(
	@UserID INT, 
	@PolicyName VARCHAR(30)
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @PolicyName IS NOT NULL AND LEN(LTRIM(@PolicyName)) > 0
	AND @UserType = 2
	AND NOT EXISTS(SELECT * FROM Policies WHERE POLICYNAME = @PolicyName)
	BEGIN
		INSERT INTO Policies
			VALUES (@PolicyName)
		SET @ReturnID = SCOPE_IDENTITY()
	END

	RETURN @ReturnID
GO

select * from Policies
-- Test for the AddPolicy procedure
DECLARE @TestID INT
EXECUTE @TestID = AddPolicy 1, 'Economic';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicy 1, '    ';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicy 1, NULL;
SELECT @TestID
GO

-- Procedure to add a policy card
-- Parameters: 
--		User ID
--		Candidate ID
--		Policy ID
--		Card Title
--		Details
--		Learn More
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE AddPolicyCard
(
	@UserID INT,
	@CandidateID INT,
	@PolicyID INT,
	@Title VARCHAR(50),
	@Details VARCHAR(75),
	@LearnMore VARCHAR(500)
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @UserType > 0
	AND @Title IS NOT NULL AND LEN(LTRIM(@Title)) > 0
	AND @Details IS NOT NULL AND LEN(LTRIM(@Details)) > 0
	AND @LearnMore IS NOT NULL AND LEN(LTRIM(@LearnMore)) > 0
	AND EXISTS(SELECT * FROM Candidate WHERE CANDIDATEID = @CandidateID)
	AND EXISTS(SELECT * FROM Policies WHERE POLICYID = @PolicyID)
	BEGIN
		INSERT INTO PolicyCard
			VALUES (@CandidateID, @PolicyID, @Title, @Details, @LearnMore)
		IF @@ERROR = 0
			SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

select * from PolicyCard
--Test for AddPolicyCard
DECLARE @TestID INT
DECLARE @CandidateID INT = (SELECT TOP 1 CANDIDATEID FROM Candidate)
DECLARE @PolicyID INT = (SELECT TOP 1 POLICYID FROM Policies)
DECLARE @UserID INT = (SELECT TOP 1 USERID FROM Users)
EXECUTE @TestID = AddPolicyCard @UserID, @CandidateID, @PolicyID, 'Reduce Property Taxes', 'test details', 'test learn more'
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 2, 1, 1, 'Reduce Property Taxes', 'test details', 'test learn more'
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 2, 1, 2, 'Train To Airport', 'test details';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 1, 1, 1, '    ', 'test details';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 1,1, 1, NULL, 'test details';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 1, 1, 1, 'Reduce Property Taxes', '   ';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddPolicyCard 1, 1, 1, 'Reduce Property Taxes', NULL;
SELECT @TestID
GO


-- Procedure to add a URL
-- Requirements: Super user
-- Parameters: User ID and URL name
-- Return: ID of the new url or 0 if it was not successful
CREATE PROCEDURE AddURL
(
	@UserID INT,
	@URLNAME VARCHAR(250)
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @URLNAME IS NOT NULL AND LEN(LTRIM(@URLNAME)) > 0
	AND NOT EXISTS (SELECT * FROM URLS WHERE URLNAME = @URLNAME)
	AND @UserType = 2
	BEGIN
		INSERT INTO URLS
			VALUES (@URLNAME)
		SET @ReturnID = SCOPE_IDENTITY()
	END

	RETURN @ReturnID
GO

-- Test for AddURL
DECLARE @TestID INT
EXECUTE @TestID = AddURL 1, 'Youtube';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddURL 1, 'Youtube';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddURL 2, 'Youtube';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddURL 1, ' ';
SELECT @TestID
GO
DECLARE @TestID INT
EXECUTE @TestID = AddURL 1, NULL;
SELECT @TestID
GO



-- Procedure to key a link to a certain page
-- Parameters: 
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE AddPageURL
(
	@UserID INT,
	@PageID INT,
	@URLID INT,
	@Link VARCHAR(2050)
)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 0

	IF EXISTS (SELECT * FROM Pages WHERE USERID = @UserID AND PAGEID = @PageID)
	AND EXISTS (SELECT * FROM URLS WHERE URLID = @URLID)
	AND @Link IS NOT NULL AND LEN(LTRIM(@Link)) > 0 
	BEGIN
		INSERT INTO PageURLS
			VALUES (@URLID, @PageID, @Link)
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

Select * from PageURLS
select * from URLS ORDER BY URLID ASC
-- Test AddPageUrl procedure
DECLARE @TestID INT, @PageID INT, @URLID INT
SET @URLID = (SELECT TOP 1 URLID FROM URLS)
SET @PageID = (SELECT TOP 1 PAGEID FROM Pages)
EXECUTE @TestID = AddPageURL 2, @PageID , @URLID, 'https://marvelapp.com/prototype/de22bb8/screen/86485467';
SELECT @TestID
GO
DECLARE @TestID INT, @PageID INT, @URLID INT
SET @PageID = (SELECT TOP 1 PAGEID FROM Pages)
EXECUTE @TestID = AddPageURL 2, @PageID , 5, 'https://www.youtube.com/watch?v=mPZkdNFkNps';
SELECT @TestID
GO


