SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_reporting_mirth_channels_with_errors]

AS
BEGIN

create table #channel_hold (clinic varchar(15),name varchar(60), errorcount int, queuecount int, lasterror datetime) 

insert into #channel_hold select clinic,name,errorcount,queuecount,lasterror from [CPRODATHENA01.ENTRADA-CPROD.LOCAL].athena_intrf.dbo.mirth_monitor WITH(NOLOCK)
where (errorcount > 0 or queuecount > 0) and disabled = 0 and TYPE='MIRTH'

Select * from #channel_hold

END
GO
