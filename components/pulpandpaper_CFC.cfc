<cfcomponent>

    <cffunction name="getLinerboardPriceHist" access="remote" output="yes">
        <cfargument name="range" required="no">

        <cftry>

            <cfset result = 'pass'>
            <cfset error = ''>
            <cfset rPeriodsArr = []>
            <cfset rPricesArr = []>

            <cfquery name="getData" datasource="cfweb">
                SELECT
                    Period,
                    Price
                FROM Linerboard_Price
            </cfquery>

            <cfif getData.recordcount>
                <cfset rPeriodsArr = '['>
                <cfset rPricesArr = '['>
                <cfloop query="getData">

                    <!--- Convert period to human-readable format --->
                    <cfset getData.Period = monthAsString(LSParseNumber(Right(getData.Period,2))) & " " & Left(getData.Period,4)>

                    <cfif getData.currentrow neq getData.recordcount>
                        <cfset rPeriodsArr &= '"#getData.Period#",'>
                        <cfset rPricesArr &= '#getData.Price#,'>
                    <cfelse>
                        <cfset rPeriodsArr &= '"#getData.Period#"]'>
                        <cfset rPricesArr &= '#getData.Price#]'>
                    </cfif>
                </cfloop>
            <cfelse>
                <cfset result = 'fail'>
                <cfset error = 'No data...'>
            </cfif>


        <cfcatch>
            <cfset result = 'fail'>
            <cfset error = '#cfcatch.Message#..#cfcatch.Detail#'>
            <cfset rPeriodsArr = []>
            <cfset rPricesArr = []>
            <cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="PulpAndPaper GetLinerboardPriceHist failed.." type="html">
                <cfdump var="#cfcatch#">
            </cfmail>
        </cfcatch>
        </cftry>


        <cfset returnedJSON = '{"result":"#result#","error":"#error#","periods":#rPeriodsArr#,"prices":#rPricesArr#}'>
        <cfoutput>#returnedJSON#</cfoutput>

    </cffunction>


</cfcomponent>
