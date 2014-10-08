SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeContactRole] (
	@ContactRoleId  [int],
	@ContactId  [int],
	@RoleId  [int],
	@ClinicId  [int],
	@ClinicsFilter  [varchar]  (500),
	@DictatorsFilter  [varchar]  (500),
	@JobsFilter  [varchar]  (255),
	@RoleStatus  [char]  (1) 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[ContactRoles] WHERE ([ContactRoleId] = @ContactRoleId))
   BEGIN
			INSERT INTO [dbo].[ContactRoles] (
				[ContactRoleId], [ContactId], [RoleId], [ClinicId], [ClinicsFilter], [DictatorsFilter], [JobsFilter], [RoleStatus] 
			) VALUES (
				@ContactRoleId, @ContactId, @RoleId, @ClinicId, @ClinicsFilter, @DictatorsFilter, @JobsFilter, @RoleStatus 
			)
   END
ELSE 
   BEGIN
   
		IF EXISTS(SELECT * FROM [dbo].[ContactRoles] WHERE ([ContactRoleId] = @ContactRoleId AND [ContactId] = @ContactId))
			BEGIN
			UPDATE [dbo].[ContactRoles] 
			 SET
				 [RoleId] = @RoleId ,
				 [ClinicId] = @ClinicId ,
				 [ClinicsFilter] = @ClinicsFilter ,
				 [DictatorsFilter] = @DictatorsFilter,
				 [JobsFilter] = @JobsFilter ,
				 [RoleStatus] = @RoleStatus
			WHERE 
				([ContactRoleId] = @ContactRoleId) AND ([ContactId] = @ContactId)
			END
		ELSE 
		RAISERROR(N'ContactRoleId belongs to another contactId.', 11, 1)
	END
GO
