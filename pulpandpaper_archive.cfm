<cftry>

<cfoutput>

<title>PDF Archive | Pulp and Paper</title>

<cfquery name="getOlderFiles" datasource="Corporate">
    SELECT * FROM (
        SELECT FileURL,
               UserFileName,
               UploadDate,
               ROW_NUMBER() OVER (ORDER BY UploadDate DESC) AS rn
        FROM PulpPaper_Docs ) t WHERE rn > 10
</cfquery>


    <h2>Pulp and Paper PDF Archive</h2>
    <table>
        <thead>
            <tr>
                <th>File</th>
                <th>Uploaded</th>
            </tr>
        </thead>
        <tbody>
            <cfif getOlderFiles.recordcount>
                <cfloop query="getOlderFiles">
                <tr>
                    <td><a href="#getOlderFiles.FileURL#" target="_blank" download>#getOlderFiles.UserFileName#</a></td>
                    <td>#DateFormat(getOlderFiles.UploadDate,'mm-dd-yyyy')#</td>
                </tr>
                </cfloop>
            </cfif>
        </tbody>
    </table>

</cfoutput>

<cfcatch>
    <cfmail to="tfafard@randwhitney.com" from="webservices@randwhitney.com" subject="Pulp Paper Archive Error" type="html">
        <cfdump var="#cfcatch#">
    </cfmail>
</cfcatch>
</cftry>




