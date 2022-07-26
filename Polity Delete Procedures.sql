-- Procedure to delete a link to a certain page
-- Parameters: 
--		User ID
--		Page URL ID
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE DeletePageURL
(
	@UserID INT,
	@PageURLID INT
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID

	IF @UserType > 0
	AND EXISTS (SELECT * FROM PageURLS WHERE PAGEURLID = @PageURLID)
	BEGIN
		DELETE FROM PageURLS
		WHERE PAGEURLID = @PageURLID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO


-- Procedure to delete a policy card learn more
-- Parameters: 
--		User ID
--		Policy Card ID
--		Learn more
-- Return: 1 if successful or 0 if it was not successful
CREATE PROCEDURE DeletePolicyCard
(
	@UserID INT,
	@PCID INT
)
AS
	DECLARE @ReturnCode INT, @UserType INT
	SET @ReturnCode = 0
	EXECUTE @UserType = UserChecker @UserID
	
	IF @UserType > 0
	AND EXISTS(SELECT * FROM PolicyCard WHERE POLICYCARDID = @PCID)
	BEGIN
		DELETE FROM PolicyCard
		WHERE POLICYCARDID = @PCID
		SET @ReturnCode = 1
	END

	RETURN @ReturnCode
GO

-- Procedure to update a key platform
-- Parameters: 
--		User ID
--		Platform ID
--		Title
--		Description
-- Returns 1 id successful or 0 if not
CREATE PROCEDURE DeletePlatform
(
	@UserID INT,
	@PlatformID INT
)
AS
	DECLARE @ReturnID INT
	SET @ReturnID = 0
	
	IF EXISTS(SELECT * FROM KeyPlatforms WHERE PLATFORMID = @PlatformID)
	BEGIN
		DELETE FROM KeyPlatforms
		WHERE PLATFORMID = @PlatformID
		SET @ReturnID = 1
	END

	RETURN @ReturnID
GO