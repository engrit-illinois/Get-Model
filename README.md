# Summary
This script reports the Manufacturer (Make), Model, and TotalPhysicalMemory size of a list of remote computers.
It optionally outputs a log and a CSV file of the data.  

# Usage
- Download `Get-Model.psm1`
- Import it as a module: `Import-Module "c:\path\to\script\Get-Model.psm1"`
- Run it using the examples and parameter documentation below.

# Examples
- `Get-DiskSpace "espl-114-01"`
- `Get-DiskSpace "espl-114-01","espl-114-02","tb-207-01"`
- `Get-DiskSpace "espl-114-*"`
- `Get-DiskSpace "espl-114-*","tb-207-01","tb-306-*"`

# Example output:
```powershell
C:\> Import-Module .\Get-Model.psm1
C:\> Get-Model "tb-306-0*" -Log -Csv

[2020-09-20_14-35-51] Name,Error,Make,Model,Memory
[2020-09-20_14-35-51] TB-306-01,,Dell Inc.,Precision T1700,8134MB
[2020-09-20_14-35-51] TB-306-02,,Dell Inc.,Precision T1700,8134MB
[2020-09-20_14-35-51] TB-306-03,,Dell Inc.,Precision T1700,8134MB
[2020-09-20_14-35-51] TB-306-04,,Dell Inc.,Precision T1700,8100MB
[2020-09-20_14-35-51] TB-306-05,,Dell Inc.,Precision T1700,8100MB
[2020-09-20_14-36-12] TB-306-06,True,,,
[2020-09-20_14-36-13] TB-306-07,,Dell Inc.,Precision T1700,8134MB
[2020-09-20_14-36-13] TB-306-08,,Dell Inc.,Precision T1700,8134MB
[2020-09-20_14-36-13] TB-306-09,,Dell Inc.,Precision T1700,8134MB

Name      Error Make      Model                   Memory
----      ----- ----      -----                   ------
TB-306-01       Dell Inc. Precision T1700         8134MB
TB-306-02       Dell Inc. Precision T1700         8134MB
TB-306-03       Dell Inc. Precision T1700         8134MB
TB-306-04       Dell Inc. Precision T1700         8100MB
TB-306-05       Dell Inc. Precision T1700         8100MB
TB-306-06 True
TB-306-07       Dell Inc. Precision T1700         8134MB
TB-306-08       Dell Inc. Precision T1700         8134MB
TB-306-09       Dell Inc. Precision T1700         8134MB

[2020-09-20_14-37-51] -Csv was specified. Outputting gathered data to "c:\engrit\logs\Get-Model_2020-09-20_14-35-51.csv"...
[2020-09-20_14-37-51] Done.

[2020-09-20_14-37-51] EOF

C:\>
```

# Parameters

### -ComputerName [string[]]
Required string array.  
The list of computer names and/or computer name query strings to poll.  
Use an asterisk (`*`) as a wildcard.  
The parameter name may be omitted if the value is given as the first or only parameter.   

### -OUDN [string]
Optional string.  
The distinguished name of the OU to limit the computername search to.  
Default is `"OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu"`.  

### -Log
Optional switch.  
Whether or not to log output to a log file.  
Log filename will be `Get-DiskSpace_yyyy-MM-dd_HH-mm-ss.log`.  
Log will be created in the directory specified by the `-LogDir` parameter.  

### -Csv
Optional switch.  
Whether or not to log retrieved data to a CSV file.  
CSV filename will be `Get-DiskSpace_yyyy-MM-dd_HH-mm-ss.csv`.  
CSV will be created in the directory specified by the `-LogDir` parameter.  

### -LogDir [string]
Optional string.  
The directory in which to create log and/or CSV files, if any are created.  
Default is `"c:\engrit\logs"`.  

# Notes
- Machines for which data could not be retrieved will have an `Error` value of `TRUE` and will have null data otherwise.
- Machines for which data was retrieved will have a null `Error` value.
- By mseng3
