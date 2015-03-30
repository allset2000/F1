SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =============================================
Author: Mike Cardwell
Create date: 3/30/2015
Description: We are rolling our new functionality with Athena and every Athena client is going to need Job Delivery Rules configured and setup
at the DB Level. This stored proc allows integrations to to just run the stored proc. It is smart enough to validate data and not allow someone
to enter duplicate values
 ============================================= */

CREATE Procedure [dbo].[sp_RM3960_ins_upd_Athena_Orders_row]

@clinicCode varchar(5),
@JobType varchar(60)
 
as 
BEGIN

Declare @clinicID INT
Set @clinicID =(Select clinicId from EntradaHostedClient.dbo.clinics where ClinicCode = @clinicCode)
If @clinicID is null
BEGIN
         PRINT'Clinic Id not Found'
         return-1
END
 
If NOT EXISTS(Select jobTypeId from entradahostedClient.dbo.Jobtypes where clinicID=@clinicID and name = @JobType)
BEGIN
         PRINT'Clinic Does not have this job type setup'
         RETURN-1
END
 
DECLARE @message VARCHAR(1000)
DECLARE @fielData VARCHAR(1000)
DECLARE @ruleName VARCHAR(40)
 
SET @ruleName ='OrderInterpretation'
Set @message = 
'MSH|^~\&|ENTRADA|||##athenaclinic##|##Now##||ORU^R02|##Id##|P|2.3|##JobNumber##|##ClientJobNbr##|||||||
PID|||##PatMRN##||##PatLastName##^##PatFirstName##^##PatMI##|##PatDOB##|||||||||||||||||||||||||
##BEGIN_REPEAT##OBR||##encnbr##|##orderid##|##Sections##|||||||||||||||||
OBX|1|TX|||##TemplateDocument##||||||R|||##Now##||##END_REPEAT##'
 
Set @fielData = 
'<renaming_rule>
  <settings>
    <MultiDocument>1</MultiDocument>
    <Encoding>ascii</Encoding>
    <EncodingServer>utf8</EncodingServer>
  </settings>
  <rules>
    <rule name="JobNumber" type="field">
      <field>JobNumber</field>
    </rule>
    <rule name="ClientJobNbr" type="field">
      <field>ClientJobNumber</field>
    </rule>
    <rule name="PatMRN" type="field">
      <field>MRN</field>
    </rule>
    <rule name="PatLastName" type="field">
      <field>LastName</field>
    </rule>
    <rule name="PatFirstName" type="field">
      <field>FirstName</field>
    </rule>
    <rule name="PatMI" type="field">
      <field>MI</field>
    </rule>
    <rule name="providerid" type="field">
      <field>EHRProviderID</field>
    </rule>
    <rule name="locationid" type="field">
      <field>Custom4</field>
    </rule>
    <rule name="locationname" type="field">
      <field>Custom3</field>
    </rule>
    <rule name="providerlast" type="field">
      <field>DictatorLastName</field>
    </rule> 
    <rule name="PatDOB" type="field">
      <field>DOB</field>
      <function>formatDate</function>
      <format>Ymd</format>
    </rule>
    <rule name="encnbr" type="field" allowblanks="false" message="202|Missing Encounter Number from Custom 3 Job Must be returned as a letter.">
      <field>Custom3</field>
    </rule>
         <rule name="orderid" type="field" allowblanks="false" message="202|Missing Order ID Number from Custom 2 Job Must be returned as a letter.">
      <field>Custom2</field>
    </rule>
    <rule name="athenaclinic" type="field" allowblanks="false" required="true" message="107|Missing Athena Clinic ID">
      <field>EHRClinicID</field>
    </rule>
    <rule name="ApptDate" type="field">
      <field>AppointmentDate</field>
      <function>formatDate</function>
      <format>Ymd</format>
    </rule>
    <rule name="ApptTime" type="field">
      <field>AppointmentTime</field>
      <function>formatDate</function>
      <format>HHmm</format>
    </rule>
    <rule name="Sections" type="list" required="true" message="201|Bad or Missing Tag">
      <field/>
    </rule>
  </rules>
</renaming_rule>
'
UPDATE entrada.dbo.JobDeliveryRules set JobType=@JobType, Method = 200, RuleName=@ruleName where clinicID=@clinicID and jobtype = @jobtype
if @@ROWCOUNT= 0
         BEGIN
                 INSERT INTO entrada.dbo.JobDeliveryRules(ClinicID, JobType, Method, RuleName)values (@clinicID, @JobType, 200, @ruleName)
                 PRINT'Inserted Job Delivery Rule'
         END
ELSE 
BEGIN
         PRINT'Updated Job Delivery Rule'
END
 
UPDATE entrada.dbo.ROW_HL7Rules Set Message= @message, FieldData=@fielData WHERE ClinicID=@clinicID and @JobType=@JobType
IF @@ROWCOUNT= 0
BEGIN
         INSERT INTO Entrada.dbo.ROW_HL7Rules(ClinicID,Message, FieldData, RuleName)values (@clinicID, @message, @fielData, @ruleName)
         PRINT'Inserted Row_HL7 Rules'
END
ELSE
BEGIN
         PRINT'Updated Job Delivery Rule'
END
 
 
 
 
END
GO
