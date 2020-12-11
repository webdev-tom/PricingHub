<cftry>
    <cfset result = 'pass'>
    <cfset error = ''>

    <!--- Create Period--->
    <cfset periodYear = FORM.year>
    <cfset periodMonth = lsNumberFormat(FORM.row+1,'00')>
    <cfset period = periodYear & periodMonth>

    <!--- Validate user submitted price --->
    <cfset sPriceVal = FORM.value>
    <cfif trim(sPriceVal) neq ''> <!--- We allow empty strings as a way to clear the cell, so exclude from validation --->
        <cfif !isNumeric(sPriceVal)>
            <cfset result = 'fail'>
            <cfset error = 'Submission must be numeric.'>
        </cfif>

        <cfif result neq 'fail'>
            <!---Check table for existing period --->
            <cfquery name="checkLBTable" datasource="cfweb">
                SELECT * FROM Linerboard_Price WHERE Period = '#period#'
            </cfquery>
            <cfif checkLBTable.recordcount>
                <!--- Period exists...Update table --->
                <cfquery name="updateLBTable" datasource="cfweb">
                    UPDATE Linerboard_Price
                    SET Price = #sPriceVal#
                    WHERE Period = '#period#'
                </cfquery>
            <cfelse>
                <!--- No period records...Insert to table --->
                <cfquery name="insertLBTable" datasource="cfweb">
                    INSERT INTO Linerboard_Price
                    (Period,Price) VALUES ('#period#',#sPriceVal#)
                </cfquery>
            </cfif>
        </cfif>

    <cfelse>
        <!--- User submitted empty string, delete from table if record exists --->
        <cfquery name="checkLBTable" datasource="cfweb">
            SELECT * FROM Linerboard_Price WHERE Period = '#period#'
        </cfquery>
        <cfif checkLBTable.recordcount>
            <cfquery name="deleteFromLBTable" datasource="cfweb">
                DELETE FROM Linerboard_Price WHERE Period = '#period#'
            </cfquery>
        </cfif>
    </cfif>


<cfcatch>
    <cfset result = 'fail'>
    <cfset error = 'Application error...See IT.'>
    <cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="PulpandPaper: Update data fail" type="html">
        LoggedInUser: #Session.LoggedInUser#
        <br><br>
        Form:
        <br>
        <cfdump var="#FORM#">
        <br><br>
        <cfdump var="#cfcatch#">
    </cfmail>
</cfcatch>
</cftry>

<cfset returnedJSON = '{"result":"#result#","error":"#error#","row":"#FORM.row#","column":"#FORM.column#"}'>
<cfoutput>#returnedJSON#</cfoutput>









