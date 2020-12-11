<cftry>

    <cfset fileSuffix = FORM.type>

    <cfif fileSuffix eq 'xlsx' OR fileSuffix eq 'xls'>
        <cfset FolderPath = '../files/excel/'>
    <cfelseif fileSuffix eq 'pdf'>
        <cfset FolderPath = '../files/pdf/'>
    </cfif>

    <cfset userFileName = (Len(FORM.ORIGFILENAME) gt 27) ? (Left(FORM.ORIGFILENAME,12) & '...' & Right(FORM.ORIGFILENAME,12)) : FORM.ORIGFILENAME>

    <cftry>
        <cfif DirectoryExists(expandpath(FolderPath)) is false>
            <cfdirectory action="create" directory="#expandpath(FolderPath)#">
        </cfif>
        <cfcatch></cfcatch>
    </cftry>

    <cftry>

        <cffile action="upload" filefield="TheFile" destination="#expandpath(FolderPath)#" nameconflict="OVERWRITE" result="uploadResult">

        <cfcatch>
            <cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="Upload Error" type="HTML">
                <cfdump var="#cfcatch#">
            </cfmail>
        </cfcatch>
    </cftry>


    <cfset filepath = '#uploadResult.SERVERDIRECTORY#\#ReReplaceNoCase(uploadResult.SERVERFILE, "[^0-9A-Za-z.]", "_", "all")#'>

    <cfif fileSuffix eq 'xlsx' OR fileSuffix eq 'xls'>
        <cfset fileurl = 'https://tomfafard.com/coldfusion/pulpandpaper/files/excel/#ReReplaceNoCase(uploadResult.SERVERFILE, "[^0-9A-Za-z.]", "_", "all")#'>
    <cfelseif fileSuffix eq 'pdf'>
        <cfset fileurl = 'https://tomfafard.com/coldfusion/pulpandpaper/files/pdf/#ReReplaceNoCase(uploadResult.SERVERFILE, "[^0-9A-Za-z.]", "_", "all")#'>
    </cfif>

    <cfif fileSuffix eq 'pdf'>
        <cfset thumburl = 'https://tomfafard.com/coldfusion/pulpandpaper/files/thumbnail/#ReReplaceNoCase(uploadResult.SERVERFILENAME, "[^0-9A-Za-z.]", "_", "all")#_page_1.jpg'>
        <cfset thumbFolder = '../files/thumbnail/'>
        <cftry>
            <cfpdf action = 'thumbnail' source='#filepath#' pages='1'
                    destination = '#thumbFolder#'
                    format = 'jpeg'
                    overwrite = 'yes'
                    resolution= 'high'
                    scale = '100' >
        <cfcatch>
            <cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="Thumbnail Error" type="HTML">
                <cfdump var="#cfcatch#">
            </cfmail>
        </cfcatch>
        </cftry>
    </cfif>

    <cfquery name="deleteDupe" datasource="cfweb">
        DELETE FROM PulpPaper_Docs
        WHERE FilePath = '#filepath#'
    </cfquery>

    <cfquery name="addFileRecord" datasource="cfweb">
        INSERT INTO PulpPaper_Docs
        (FilePath,
        FileURL,
        <cfif fileSuffix eq 'pdf'>
        ThumbURL,
        </cfif>
        NewFileName,
        UserFileName,
        UploadDate,
        UploadUser)
        VALUES
        ('#filepath#',
        '#fileurl#',
        <cfif fileSuffix eq 'pdf'>
        '#thumburl#',
        </cfif>
        '#ReReplaceNoCase(uploadResult.SERVERFILENAME, "[^0-9A-Za-z.]", "_", "all")#',
        '#ReReplaceNoCase(userFileName, "[^0-9A-Za-z. ]", "_", "all")#',
        getDate(),
        'Guest')
    </cfquery>


    <cfoutput>Upload successful.</cfoutput>
    <cfcatch>
        <cfoutput>Upload error....</cfoutput>
        <cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="Upload Error" type="HTML">
            <cfdump var="#cfcatch#">
        </cfmail>
    </cfcatch>
</cftry>
