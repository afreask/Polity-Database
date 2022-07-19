Up-- Procedure to update email addresses
-- Checks whether the email exists or not
-- Updates the email if it exists and not null or whitespace blank
-- Parameters: 
--			Email address
--			Email ID
--			User ID
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdateEmail
(
	@Email VARCHAR(400) = NULL, 
	@EmailID INT,
	@UserID INT
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	
	IF @Email IS NOT NULL AND LEN(LTRIM(@Email)) > 0
	IF @UserType > 0
	BEGIN
		IF EXISTS 
		(
			SELECT * FROM Email WHERE EMAILADDRESS = @Email
		)
			BEGIN
				UPDATE Email 
					SET EMAILADDRESS = @Email
				WHERE EmailID = @EmailID
				SET @ReturnID = 1
			END
	END
	RETURN @ReturnID
GO


-- Procedure to update a person's information
-- Checks whether the person exists or not
-- Updates the person's information if it exists and not null or whitespace blank
-- Parameters: 
--			UserID : Only a user can do such
--			ID
--			First name
--			Last name
--			Birthday
--			Gender
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdatePerson
(
	@UserID INT,
	@ID INT,
	@FirstName VARCHAR(250), 
	@LastName VARCHAR(250),
	@Birthday DATE = NULL,
	@Gender SMALLINT
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	
	IF @FirstName IS NOT NULL AND LEN(LTRIM(@FirstName)) > 0
	AND @LastName IS NOT NULL AND LEN(LTRIM(@LastName)) > 0
	AND @UserType > 0
	BEGIN
		IF EXISTS 
		(
			SELECT * FROM Person WHERE ID = @ID
		)
			BEGIN
				UPDATE Person 
					SET FIRSTNAME= @FirstName,
						LASTNAME = @LastName,
						DATEOFBIRTH = @Birthday,
						GENDER = @Gender
				WHERE ID = @ID
				SET @ReturnID = 1
			END
	END
	RETURN @ReturnID
GO

-- Test UpdatePerson
--DECLARE @TestID INT
--EXECUTE @TestID = UpdatePerson 1, 13, 'Larry', 'Doberman', NULL, 0
--SELECT @TestID
--SELECT * FROM Person
--SELECT * FROM Users
GO


-- Procedure to update a person's first name
-- Checks whether the person exists or not
-- Updates the person's first name if it exists and not null or whitespace blank
-- Parameters: 
--			UserID : Only a user can do such
--			ID
--			First name
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdateFirstName
(
	@ID INT,
	@UserID INT,
	@FirstName VARCHAR(250)
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	
	IF @FirstName IS NOT NULL AND LEN(LTRIM(@FirstName)) > 0
	AND @UserType > 0
	BEGIN
		IF EXISTS 
		(
			SELECT * FROM Person WHERE ID = @ID
		)
			BEGIN
				UPDATE Person 
					SET FIRSTNAME= @FirstName
				WHERE ID = @ID
				SET @ReturnID = 1
			END
	END
	RETURN @ReturnID
GO

-- Procedure to update a person's last name
-- Checks whether the person exists or not
-- Updates the person's last name if it exists and not null or whitespace blank
-- Parameters: 
--			UserID : Only a user can do such
--			ID
--			Last name
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdateLastName
(
	@UserID INT,
	@ID INT,
	@LastName VARCHAR(250)
)
AS
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0 
	EXECUTE @UserType = UserChecker @UserID
	
	IF @LastName IS NOT NULL AND LEN(LTRIM(@LastName)) > 0
	AND @UserType > 0
	BEGIN
		IF EXISTS 
		(
			SELECT * FROM Person WHERE ID = @ID
		)
			BEGIN
				UPDATE Person 
					SET LASTNAME = @LastName
				WHERE ID = @ID
				SET @ReturnID = 1
			END
	END
	RETURN @ReturnID
GO


-- Procedure to update a candidate
-- Parameters: candidate's id and bio
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdateCandidate
(
	@UserID INT, 
	@CID INT, 
	@Bio TEXT = NULL
)
AS 
	DECLARE @ReturnID INT, @UserType INT
	SET @ReturnID = 0
	EXECUTE @UserType = UserChecker @UserID

	IF @CID > 0
	AND @UserType > 0
	AND LEN((SELECT REPLACE(CAST(@Bio AS VARCHAR(MAX)), ' ', ''))) > 0
	BEGIN
		UPDATE Candidate
			SET BIO = @Bio
		WHERE CANDIDATEID = @CID
		SET @ReturnID = 1
	END
	RETURN @ReturnID
GO

-- Test UpdateCandidate
DECLARE @TestID INT
EXECUTE @TestID = UpdateCandidate 1, 27, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
SELECT @TestID
SELECT * FROM Candidate
SELECT * FROM Users
GO

-- Procedure to update a key platform
-- Parameters: 
--		User ID
--		Platform ID
--		Title
--		Description
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdatePlatform
(
	@UserID INT,
	@PlatformID INT,
	@Title VARCHAR(100), 
	@Description TEXT
)
AS
	DECLARE @ReturnID INT
	SET @ReturnID = 0
	
	IF @Title IS NOT NULL AND LEN(LTRIM(@Title)) > 0
	AND LEN((SELECT REPLACE(CAST(@Description AS VARCHAR(MAX)), ' ', ''))) > 0
	AND EXISTS(SELECT * FROM KeyPlatforms WHERE PLATFORMID = @PlatformID)
	BEGIN
		UPDATE KeyPlatforms
			SET TITLE = @Title,
				DESCRIPTION = @Description
		WHERE PLATFORMID = @PlatformID
		SET @ReturnID = 1
	END

	RETURN @ReturnID
GO

-- Test UpdatePerson
DECLARE @TestID INT
EXECUTE @TestID = UpdatePlatform 1, 5, 'Test UpdatePlatform Title', 'Test UpdatePlatform Description'
SELECT @TestID
SELECT * FROM KeyPlatforms
SELECT * FROM Users
GO

-- Procedure to update a key platform
-- Parameters: 
--		User ID
--		Platform ID
--		Title
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdatePlatformTitle
(
	@UserID INT,
	@PlatformID INT,
	@Title VARCHAR(100)
)
AS
	DECLARE @ReturnID INT
	SET @ReturnID = 0
	
	IF @Title IS NOT NULL AND LEN(LTRIM(@Title)) > 0
	AND EXISTS(SELECT * FROM KeyPlatforms WHERE PLATFORMID = @PlatformID)
	BEGIN
		UPDATE KeyPlatforms
			SET TITLE = @Title
		WHERE PLATFORMID = @PlatformID
		SET @ReturnID = 1
	END

	RETURN @ReturnID
GO

-- Procedure to update a key platform
-- Parameters: 
--		User ID
--		Platform ID
--		Title
--		Description
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE UpdatePlatformDescription
(
	@UserID INT,
	@PlatformID INT,
	@Description TEXT
)
AS
	DECLARE @ReturnID INT
	SET @ReturnID = 0
	
	IF LEN((SELECT REPLACE(CAST(@Description AS VARCHAR(MAX)), ' ', ''))) > 0
	AND EXISTS(SELECT * FROM KeyPlatforms WHERE PLATFORMID = @PlatformID)
	BEGIN
		UPDATE KeyPlatforms
			SET DESCRIPTION = @Description
		WHERE PLATFORMID = @PlatformID
		SET @ReturnID = 1
	END

	RETURN @ReturnID
GO

-- Procedure to updates a policy card
-- Parameters: 
--		User ID
--		Policy Card ID
--		Card Title
--		Details
--		Learn more
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE UpdatePolicyCard
(
	@UserID INT,
	@PCID INT,
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
	AND EXISTS(SELECT * FROM PolicyCard WHERE POLICYCARDID = @PCID)
	BEGIN
		UPDATE PolicyCard
			SET TITLE = @Title,
				DETAILS = @Details,
				LEARNMORE = @LearnMore
		WHERE POLICYCARDID = @PCID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

-- Test for UpdatePolicyCard
DECLARE @TestID INT
EXECUTE @TestID = UpdatePolicyCard 1, 1, 'Reduce Property Taxes update', 'test update details', 'test update learn more'
SELECT @TestID
SELECT * FROM PolicyCard
GO

-- Procedure to updates a policy card
-- Parameters: 
--		User ID
--		Policy Card ID
--		Card Title
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE UpdatePolicyCardTitle
(
	@UserID INT,
	@PCID INT,
	@Title VARCHAR(50)
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @UserType > 0
	AND @Title IS NOT NULL AND LEN(LTRIM(@Title)) > 0
	AND EXISTS(SELECT * FROM PolicyCard WHERE POLICYCARDID = @PCID)
	BEGIN
		UPDATE PolicyCard
			SET TITLE = @Title
		WHERE POLICYCARDID = @PCID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

-- Procedure to updates a policy card
-- Parameters: 
--		User ID
--		Policy Card ID
--		Details
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE UpdatePolicyCardDetails
(
	@UserID INT,
	@PCID INT,
	@Details VARCHAR(75)
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @UserType > 0
	AND @Details IS NOT NULL AND LEN(LTRIM(@Details)) > 0
	AND EXISTS(SELECT * FROM PolicyCard WHERE POLICYCARDID = @PCID)
	BEGIN
		UPDATE PolicyCard
			SET DETAILS = @Details
		WHERE POLICYCARDID = @PCID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

-- Procedure to updates a policy card
-- Parameters: 
--		User ID
--		Policy Card ID
--		Learn more
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE UpdatePolicyCardLearnMore
(
	@UserID INT,
	@PCID INT,
	@LearnMore VARCHAR(500)
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @UserType > 0
	AND @LearnMore IS NOT NULL AND LEN(LTRIM(@LearnMore)) > 0
	AND EXISTS(SELECT * FROM PolicyCard WHERE POLICYCARDID = @PCID)
	BEGIN
		UPDATE PolicyCard
			SET LEARNMORE = @LearnMore
		WHERE POLICYCARDID = @PCID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

-- Procedure to update a link to a certain page
-- Parameters: 
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE UpdatePageURL
(
	@UserID INT,
	@PageID INT,
	@URLID INT,
	@Link VARCHAR(2050)
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID

	IF @UserType > 0
	AND EXISTS (SELECT * FROM Pages WHERE USERID = @UserID AND PAGEID = @PageID)
	AND EXISTS (SELECT * FROM URLS WHERE URLID = @URLID)
	AND @Link IS NOT NULL AND LEN(LTRIM(@Link)) > 0 
	BEGIN
		UPDATE PageURLS
			SET LINK = @Link
		WHERE PAGEID = @PageID
		AND URLID = @URLID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

SELECT * FROM PageURLS
SELECT * FROM Pages