SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_reporting_mirth_channels_uploader_check]

AS
BEGIN

create table #channel_hold (clinic varchar(15),name varchar(60), elapsedtime varchar(25)) 

insert into #channel_hold select clinic, name,
CASE WHEN isnull(cast(rec_interval AS varchar(15)),'') ='' THEN 'NO Interval Set' ELSE cast(uploader_elapsed as varchar(15))+' Minutes' END AS elapsed_time
from [CPRODATHENA01.ENTRADA-CPROD.LOCAL].athena_intrf.dbo.mirth_monitor WITH(NOLOCK)
where type = 'UPLOADER' and ((disabled = 0 and uploader_elapsed > rec_interval) or rec_interval is null)

Select * from #channel_hold

END
GO
