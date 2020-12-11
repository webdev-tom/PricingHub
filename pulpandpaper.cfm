<cfset currentUser = 'Guest'>
<cfset dataAdmin = 'TFafard'>
<!---<cfset dataAdmin = 'DJensen'>--->
<script type="text/javascript">
<cfoutput>
    const #toScript(currentUser, "current_user")#;
    const #toScript(dataAdmin, "data_admin")#;
</cfoutput>
</script>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="description" content="Pulp and Paper UI">
<meta name="author" content="Tom Fafard">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Pulp and Paper</title>

<link href="/includes/plugins/bootstrap-4.5/css/bootstrap.min.css" rel="stylesheet">
<link href="https://code.highcharts.com/css/highcharts.css" rel="stylesheet">
<link href="/includes/plugins/webui-popover/dist/jquery.webui-popover.css" rel="stylesheet">
<link href="/includes/plugins/fontawesome/css/all.min.css" rel="stylesheet">
<link href="/includes/plugins/DataTables/datatables.min.css" rel="stylesheet">
<link href="/includes/plugins/DataTables/DataTables-1.10.21/css/dataTables.bootstrap4.css" rel="stylesheet">
<link href="/includes/plugins/DataTables/fixedColumns.dataTables.min.css" rel="stylesheet">
<link href="/includes/plugins/DataTables/Buttons-1.6.2/css/buttons.dataTables.min.css" rel="stylesheet">
<link href="/includes/plugins/DataTables/Buttons-1.6.2/css/buttons.bootstrap4.min.css" rel="stylesheet">
<style>

    body {
        background-image: url('/includes/images/projects/PulpAndPaper/paper-texture-bg.jpg');
        background-repeat: repeat;
    }

    table.dataTable {
        margin: 0 !important;
    }

    table.dataTable thead th,
    table.dataTable tfoot th {
        text-align: center;
    }
    table.dataTable thead th,
    table.dataTable thead td {
        padding: 10px 18px 10px 5px;
        border-right: 1px solid #dddddd;
    }
    table.dataTable tbody th,
    table.dataTable tbody td {
        padding: 10px 18px 10px 5px;
        border-right: 1px solid #dddddd;
    }

    table.DTFC_Cloned thead {
        background-image: url('/includes/images/projects/PulpAndPaper/paper-texture-bg.jpg') !important;
        background-position: top !important;
    }

    td form {
        margin: 0 !important;
    }

    rect.highcharts-background {
        fill: rgb(31, 31, 32) !important;
    }

    .success {
        color: #4cae4c !important;
    }

    .failure {
        color: #d43f3a !important;
    }

    .loading {
        color: #006CFF;
    }

    .page-container {
        width: 99%;
        margin: 0 auto;
    }

    .dynamic-h1 {
        font-size: 40px;
        padding: 25px 0 0 25px;
    }

    .windowpane {
        width: 100%;
        height: 100%;
        position: absolute;
        z-index: 0;
        background-color: #fff;
        transition: 300ms ease;
        opacity: 0;
    }

    .show{
        opacity: 1;
    }


    .divider {
        border-bottom: 1px solid #515F66;
    }

    .ui-container {
        margin: 30px 0;
    }

    .vertHdr {
        font-weight: bold;
    }

    .rowData {
        text-align: center;
    }

    .document {
        position: relative;
        flex-grow: 0;
        flex-shrink: 1;
        flex-basis:calc(100% - 1em);
        height: 300px;
        box-sizing: border-box;
        margin: 1em .5em;
        border-radius: 2px;
        background-repeat: no-repeat;
        background-size: cover;
        background-position: top;
        background-image: url("/includes/images/projects/PulpAndPaper/placeholder.jpg");
        transition: all 700ms ease-in-out;
        overflow: hidden;
        box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);
    }

    .document.archive {
        background-image: url("/includes/images/projects/PulpAndPaper/archive.jpg") !important;
    }

    .document-text {
        position: absolute;
        bottom: 0;
        left: 0;
        color: black;
        text-decoration: none;
        font-weight: bold;
        width: 100%;
        text-align: center;
        box-shadow: inset 0 0 2000px rgba(255, 255, 255, .5);
    }

    .uploadStatus {
        padding: 10px;
    }

    #page-title {
        color: #2F2E3F;
    }

    #doc-well {
        width: 100%;
        max-height: 400px;
        overflow: hidden;
        transition: max-height 750ms ease;
    }

    #well-grid {
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        flex-direction: row-reverse;
    }

    #well-grid::after {
        content: "";
        flex: auto;
    }

    #uploadFilesLink {
        float: right;
        font-size: 20px;
        background-color: #fff;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #CECECB;
    }

    #upload-excel {
        margin-top: 3px;
    }

    #current-excel-name {
        font-weight: bold;
        margin: 10px 0;
        text-indent: 15px;
    }

    #fileUploadExcel {
        margin-top: 10px;
    }

    #LB_price_table {
        width: 100%;
    }

    #priceTableStatus {
        color: #94948f;
        float: right;
        cursor: default;
        user-select: none;
        -moz-user-select: none;
        -webkit-user-select: none;
    }


    @media screen and (min-width: 40em) {
        #well-grid {
            display: flex;
            flex-wrap: wrap;
        }

        .dynamic-h1 {
            font-size: 50px;
        }

        .document {
            flex-basis: calc(50% -  1em);
        }
    }


    @media screen and (min-width: 60em) {

        .dynamic-h1 {
            font-size: 55px;
        }

        .document {
            flex-basis: calc(25% -  1em);
        }
    }

</style>
</head>
<body>
<cfoutput>

    <cfquery name="getPDFDocs" datasource="cfweb">
        SELECT FileURL, ThumbURL, UserFileName FROM PulpPaper_Docs WHERE ThumbURL is NOT NULL ORDER BY UploadDate DESC
    </cfquery>

    <!-- Because thumbnails are not created for excel files, we can filter them by querying WHERE ThumbURL is NULL -->
    <cfquery name="getExcelDocs" datasource="cfweb">
        SELECT TOP 1 FileURL, UserFileName FROM PulpPaper_Docs WHERE ThumbURL is NULL ORDER BY UploadDate DESC
    </cfquery>


    <div class="page-container">

        <h1 class="dynamic-h1" id="page-title">Pulp and Paper</h1>
        <div class="divider"></div>
        <!---<div class="windowpane"></div>--->

        <div id="doc-container" class="ui-container">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-11">
                        <div id="doc-well" class="card card-body bg-light">
                            <div id="well-upload">
                                <a href="##" id="uploadFilesLink"><i class="fas fa-upload"></i></a>
                                <div class="webui-popover-content">
                                    <h3>Upload PDF Documents</h3>
                                    <input type="file" id="fileUpload" accept=".pdf,application/pdf" onchange="tryUpload(this)">
                                    <div class="uploadStatus"></div>
                                </div>
                            </div>
                            <div id="well-grid">
                                <cfif getPDFDocs.recordcount>
                                    <cfloop query="getPDFDocs" endrow="20"> <!--- Show user 20 docs before archive --->
                                        <a href="#getPDFDocs.FileURL#" class="document" target="_blank" style="background-image: url('#ThumbURL#')">
                                            <span class="document-text">#getPDFDocs.UserFileName#</span>
                                        </a>
                                    </cfloop>
                                    <cfif getPDFDocs.recordcount gt 20>
                                        <a href="pulpandpaper_archive.cfm" class="document archive" target="_blank">
                                            <span class="document-text">Older Files</span>
                                        </a>
                                    </cfif>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1">
                        <button id="open-grid" class="btn btn-primary">Show all</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="divider"></div>


        <div id="chart-container" class="ui-container">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-11">
                        <div id="linerBoard_chart"></div>
                    </div>
                    <div class="col-md-1">
                        <a id="export-excel" class="btn btn-primary" href="#getExcelDocs.FileURL#" download>Export Excel</a>
                        <cfif 'Guest' eq dataAdmin>
                            <a id="upload-excel" class="btn btn-primary" href="##">Upload Excel</a>
                            <div class="webui-popover-content">
                                <h3>Update Excel Export</h3>
                                <div class="card card-body bg-light">
                                    <span>This upload controls the current downloadable excel file. Uploading a file here will replace the file current file, named below:</span>
                                    <li id="current-excel-name">#getExcelDocs.UserFileName#</li>
                                </div>
                                <input type="file" id="fileUploadExcel" accept=".xls,.xlsx,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" onchange="tryUpload(this)">
                                <div class="uploadStatus"></div>
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>
        </div>



        <div id="table-container" class="ui-container">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-11">
                        <cfif 'Guest' eq dataAdmin><em id="priceTableStatus">The cells below are editable. Press enter to save changes.</em></cfif>
                        <table id="LB_price_table" class="display">
                            <thead><tr><th></th></tr></thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="col-md-1">
                        <!---<button id="export-excel" class="btn btn-primary">Export Excel</button>--->
                    </div>
                </div>
            </div>
        </div>

    </div>

</cfoutput>
<script src="/includes/plugins/jquery_3.4.1/jquery-3.4.1.min.js" type="text/javascript"></script>
<script src="/includes/plugins/bootstrap-4.5/js/bootstrap.min.js" type="text/javascript"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/themes/high-contrast-dark.js"></script>
<script src="/includes/plugins/webui-popover/dist/jquery.webui-popover.min.js"></script>
<script src="/includes/plugins/fontawesome/js/all.min.js"></script>
<script src="/includes/plugins/DataTables/dataTables.min.js"></script>
<script src="/includes/plugins/DataTables/DataTables-1.10.21/js/dataTables.bootstrap4.js"></script>
<script src="/includes/plugins/DataTables/dataTables.fixedColumns.min.js"></script>
<script src="/includes/plugins/DataTables/Buttons-1.6.2/js/dataTables.buttons.min.js"></script>
<script src="/includes/plugins/DataTables/Buttons-1.6.2/js/buttons.bootstrap4.min.js"></script>
<script src="/includes/plugins/DataTables/Buttons-1.6.2/js/buttons.html5.min.js"></script>
<script src="/includes/plugins/jeditable/dist/jquery.jeditable.min.js"></script>

<script type="text/javascript">
    $(function(){

        $('#open-grid').on('click',function(){
            $('#doc-well').css("max-height","unset");
        });


        $('#uploadFilesLink').webuiPopover({
            animation: 'pop'
        });

        if(current_user == data_admin) {
            $('#upload-excel').webuiPopover({
                animation: 'pop',
                width: 400
            });
        }

        $.ajax({
            type: "get",
            url: "components/pulpandpaper_CFC.cfc?method=getLinerboardPriceHist",
            dataType: "text",
            data: {
            },
            cache: false,
            success: function( data ){
                var json = data.trim();
                var objRes = JSON.parse(json);

                if(objRes.result == 'pass'){

                    drawChart(objRes.periods, objRes.prices);
                    drawTable(objRes.periods,objRes.prices);


                } else {
                    alert(objRes.error);
                    return false;
                }

            }
        });



    });

    function drawChart(periods,prices) {

        // Period label formatting
        let locPeriodsArr = periods.slice(); // Use slice to avoid mutation of original periods array
        for(let i = 0; i < locPeriodsArr.length; i++) {
            let newPerFormat = locPeriodsArr[i].split(' ')[0].substr(0,3) + " '" + locPeriodsArr[i].split(' ')[1].substr(2,4);
            locPeriodsArr.splice(i, 1, newPerFormat);
        }

        let chart = Highcharts.chart('linerBoard_chart', {
            chart: {
                type: 'line'
            },

            title: {
                text: 'Linerboard Pricing'
            },

            xAxis: {
                categories: locPeriodsArr
            },

            yAxis: {
                title: {
                    text: null
                }
            },

            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },

            plotOptions: {
                series: {
                    events: {
                        legendItemClick: function(e) {
                            e.preventDefault();
                        }
                    }
                }
            },

            tooltip: {
                style: {
                    color: '#333333'
                }
            },

            series: [{
                showInLegend: true,
                name: 'Total',
                data: prices
            }],

            credits: {
                enabled: false
            },

            exporting: {
                enabled: false
            }

        });

        // $('#export-pdf').on('click', function(){
        //     chart.exportChartLocal({ type: 'application/pdf' });
        // });
    }


    function drawTable(periods,prices) {

        let $thisDT = $('#LB_price_table');


        // First, we need to append the period years to THead. At the same time, we
        // populate the periodMonths array to be used later.

        let periodMonths = [];
        let thisYr = 0;
        for(let i = 0; i < periods.length; i++){
            if(i < 12){
                periodMonths.push(periods[i].split(' ')[0]);
            }

            if(thisYr != periods[i].split(' ')[1]){
                // Append header labels
                let hdrToAppend = periods[i].split(' ')[1];
                $thisDT.children('thead').children('tr').append('<th>' + hdrToAppend + '</th>');
                thisYr = periods[i].split(' ')[1];
            }
        }


        // Next, we need to append the table body. With the way our dataset is sorted,
        // looping through and appending columns would be ideal. While possible,
        // I've found it to be much less of a headache to play by HTML's rules and append as
        // rows instead.
        //
        // To do this with our dataset, we'll need to grab every 12th data point ( To get
        // the price from Jan99, Jan00, Jan01, etc ). This is the thinking behind setting
        // delta to 12.
        //
        // maxLength is assigned the highest value from thisRowColCount ( usually the first row ),
        // which is a variable that keeps track of the total columns a row takes up. This is used
        // to ensure that every row has the same number of columns, as DataTables would break otherwise.

        let delta = 12;
        let maxLength = 0;
        let $tbody = $thisDT.children('tbody');
        for(let k = 0; k < 12; k++){
            let appendStr = '';
            let thisRowColCount = 0;

            // Append vertical header label
            appendStr += '<tr><td class="vertHdr">' + periodMonths[k] + '</td>';
            thisRowColCount++;

            for(let i = k; i < prices.length; i=i+delta){
                // Append month's data
                appendStr += '<td class="rowData">' + prices[i] + '</td>';
                thisRowColCount++;
            }

            if(thisRowColCount < maxLength) {
                let colsToAdd = maxLength - thisRowColCount;
                for(let j = 0; j < colsToAdd; j++){
                    appendStr += '<td class="rowData">' + '' + '</td>';
                }
            }

            appendStr += ('</tr>');
            $tbody.append(appendStr);

            if(k == 0) {
                maxLength = thisRowColCount;
            }

        }



        // Init data-table
        let table = $thisDT.DataTable({
            scrollX: true,
            autoWidth: false,
            paging: false,
            ordering: false,
            searching: false,
            info: false,
            fixedColumns: true,
            buttons: [
                {
                    extend: 'csv',
                }
            ]
        });


        if(current_user == data_admin) {

            // Apply JEdiTable handlers to DataTable
            table.$('td').editable( 'components/updateTable.cfm', {
                callback: function( result, settings, sValue) {
                    // Update value in the table
                    table.cell(this).data(sValue.value).draw();
                },
                submitdata: function ( value, settings ) {
                    return {
                        // row number, to identify period month
                        "row": table.cell(this).index().row,
                        // column number, for intercept function
                        "column": table.cell(this).index().column,
                        // year, to identify period year
                        "year": $(table.column(table.cell(this).index().column).header()).html()
                    };
                },
                intercept : function(json) {
                    let obj = JSON.parse(json);
                    let $tableStatus = $('#priceTableStatus');
                    if(obj.result == 'pass'){
                        $tableStatus.html('Changes saved successfully.');
                        $tableStatus.removeClass('failure').addClass('success');
                    } else {
                        $tableStatus.html('Error saving changes...See IT.');
                        $tableStatus.removeClass('success').addClass('failure');
                        console.log(obj.error);
                    }
                },
                height: "auto",
                width: "100%",
                tooltip: "",
                placeholder: ""
            } );
        }



        // $("#export-excel").on("click", function() {
        //     table.button( '.buttons-csv' ).trigger();
        // });
    }

    function tryUpload(fileUploader) {
        let uploader = fileUploader;

        for(let i = 0; i < uploader.files.length; i++){
            let file =  uploader.files[i];
            console.group("File " + i);
            console.log("name : " + file.name);
            console.log("size : " + file.size);
            console.log("type : " + file.type);
            console.log("date : " + file.lastModified);
            console.groupEnd();

            if((uploader.id == 'fileUpload' && file.type == 'application/pdf') || (uploader.id == 'fileUploadExcel' && (file.type == 'application/vnd.ms-excel' || file.type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))){
                uploadFile(file,file.name.split('.')[1],i,uploader.files.length);
                $('.uploadStatus').html('<span><i class="fas fa-circle-notch fa-spin loading"></i> Uploading...</span>');
            } else {
                uploader.value = '';
                alert('Error. Make sure you are only uploading the allowed file type.');
            }
        }
    }

    function uploadFile(file,type,fileNum,fileCount){
        var url = 'components/uploader.cfm';
        var xhr = new XMLHttpRequest();
        var fd = new FormData();
        fd.append('TheFile', file, (file.name.replace(/[`~!@#$%^&*()_|+\-=?;:'",<>\{\}\[\]\\\/]/gi, '_').replace(/\s/g, '_')));
        fd.append('OrigFileName',file.name);
        fd.append('Type', type);
        xhr.open('POST', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status == 200) {
                // Everything ok, file uploaded
                console.log(xhr.responseText); // handle response.
                console.log(fileNum);
                console.log(fileCount);
                if(fileNum+1 === fileCount) {
                    $('.uploadStatus').html('<span><i class="far fa-check-circle success"></i> Success.</span>');
                    setTimeout(function(){
                        location.reload(true);
                    },1500);
                }
            } else if(xhr.status != 200) {
                $('.uploadStatus').html('<span><i class="fas fa-times failure"></i> Upload error...See IT.</span>');
            }
        };
        xhr.send(fd);
    }
</script>
</body>
</html>
