-- Procedure to update email addresses
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
		IF NOT EXISTS 
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