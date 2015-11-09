SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:  A Raghu
-- Create date: 30/07/2015
-- Description: <Description,,>
-- =============================================


CREATE PROCEDURE [dbo].[sp_TransferMessageThreadAdmin]
 @UserID Int,
 @Occupantids Varchar(500),
 @ThreadID Varchar(50)
AS
BEGIN
 SET NOCOUNT ON;

 Declare @ClinicID Int
 Declare @ThreadAdminUserID Int

 SELECT @ClinicID=ClinicID FROM  USERS WHERE UserID=@UserID

   SELECT TOP 1  @ThreadAdminUserID= U.USERID
   FROM QuickBloxUsers QBU WITH(NOLOCK)
    INNER JOIN USERS U ON QBU.UserID=U.UserID
   WHERE U.ClinicID=@ClinicID
     AND QBU.QuickBloxUserID IN(SELECT Value FROM DBO.Split(@Occupantids,','))
     AND U.UserID<>@UserID

  --If there is clinic users then we can get non clinic by user user
  IF(LEN(@ThreadAdminUserID)<=0)
    BEGIN
     
     SELECT TOP 1  @ThreadAdminUserID= USERID
   FROM QuickBloxUsers  WITH(NOLOCK) 
    WHERE  QuickBloxUserID IN(SELECT Value FROM DBO.Split(@Occupantids,','))
     AND UserID<>@UserID


    END
      
  
  UPDATE MessageThreads 
   SET ThreadAdminUserID=@ThreadAdminUserID,
    UpdatedDate=GETUTCDATE()
  WHERE ThreadID=@ThreadID


END

GO
