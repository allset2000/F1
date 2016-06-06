SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_reporting_mirth_ODP_monitor]

AS
BEGIN

create table #channel_hold (clinic varchar(15),name varchar(60), queuecount int) 

insert into #channel_hold select clinic,name,queuecount from [CPRODATHENA01.ENTRADA-CPROD.LOCAL].athena_intrf.dbo.mirth_monitor WITH(NOLOCK)
where  queuecount > 0 and disabled = 0 and TYPE='ODP'

Select * from #channel_hold

END
GO
