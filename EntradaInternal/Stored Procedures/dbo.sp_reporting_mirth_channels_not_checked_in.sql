SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_reporting_mirth_channels_not_checked_in]

AS
BEGIN

create table #channel_hold (clinic varchar(15),name varchar(60), elapsedtime varchar(25)) 

insert into #channel_hold select clinic,name,DATEDIFF(MINUTE,lastupdated,GETDATE()) from [CPRODATHENA01.ENTRADA-CPROD.LOCAL].athena_intrf.dbo.mirth_monitor WITH(NOLOCK)
where DATEDIFF(MINUTE,lastupdated,GETDATE()) > 10 and disabled = 0

Select * from #channel_hold

END
GO
