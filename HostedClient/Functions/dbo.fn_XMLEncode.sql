-- =============================================
-- Author	  :	<Author>
-- Create date: 03-Nov-2015
-- Description:	Replace special characters like &,<,>,",' with &amp,&lt,&gt,&quot,&apos.
-- =============================================
CREATE FUNCTION [dbo].[fn_XMLEncode]
(
	@nodeValue as varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	-- replace the value with '&amp' if string contains '&'
	set @nodeValue = replace (@nodeValue, '&', '&amp;')
	-- replace the value with '&lt' if string contains '<'
	set @nodeValue = replace (@nodeValue, '<', '&lt;')
	-- replace the value with '&gt' if string contains '>'
	set @nodeValue = replace (@nodeValue, '>', '&gt;')
	-- replace the value with '&quot' if string contains double quots like "
	set @nodeValue = replace (@nodeValue, '"', '&quot;')
	-- replace the value with '&apos' if string contains single quots lik '
	set @nodeValue = replace(@nodeValue, '''', '&apos;')

	return @nodeValue
END


