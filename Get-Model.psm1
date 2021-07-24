# Documentation home: https://github.com/engrit-illinois/Get-Model

function Get-Model {
	
	param(
		[Parameter(Mandatory=$true,Position=0)]
		[string[]]$ComputerName,
		
		[string]$OUDN = "OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu",
		
		[string]$CIMTimeoutSec = 30,
		
		[switch]$Log,
		
		[switch]$Csv,
		
		[string]$LogDir = "c:\engrit\logs"
	)
	
	$ts = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
	$LOGPATH = "$LogDir\Get-Model_$ts.log"
	$CSVPATH = $LOGPATH.Replace(".log",".csv")
	
	function log {
		param(
			[string]$Msg,
			[switch]$NoTS
		)
		
		$ts = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
		if(!$NoTS) {
			$msg = "[$ts] $msg"
		}
		
		Write-Host $Msg
		
		if($Log) {
			if(!(Test-Path -PathType Leaf -Path $LOGPATH)) {
				$shutup = New-Item -ItemType File -Force -Path $LOGPATH
			}
			$Msg | Out-File $LOGPATH -Append
		}
	}

	function Get-Comps {
		$comps = @()
		foreach($query in @($ComputerName)) {
			$thisQueryComps = (Get-ADComputer -Filter "name -like '$query'" -SearchBase $OUDN | Select Name).Name
			$comps += @($thisQueryComps)
		}
		$comps
	}
	
	function Get-Data($comps) {
		log "Name,Error,Make,Model,Memory"
		
		$data = @()
		foreach($comp in $comps) {
			$this = $null
			try {
				$this = Get-CIMInstance -ClassName "Win32_ComputerSystem" -ComputerName $comp -OperationTimeoutSec $CIMTimeoutSec -ErrorAction "SilentlyContinue"
				$this2 = Get-CIMInstance -ClassName "Win32_BIOS" -ComputerName $comp -OperationTimeoutSec $CIMTimeoutSec -ErrorAction "SilentlyContinue"
			}
			catch {
			}
			
			$error = $null
			if($this -and $this2) {
				$this | Add-Member -NotePropertyName "Make" -NotePropertyValue $this.Manufacturer
				$this | Add-Member -NotePropertyName "Memory" -NotePropertyValue "$([math]::round($this.TotalPhysicalMemory / 1MB))MB"
				$this | Add-Member -NotePropertyName "Serial" -NotePropertyValue $this2.SerialNumber
			}
			else {
				$error = $true
				$this = [PSCustomObject]@{
					"Name" = $comp
				}
			}
			$this | Add-Member -NotePropertyName "Error" -NotePropertyValue $error
			
			log "$($this.Name),$($this.Error),$($this.Make),$($this.Model),$($this.Memory),$($this.Serial)"
			
			$data += @($this)
		}
		$data
	}
	
	function Print-Data($data) {
		log ($data | Sort Name | Select Name,Error,Make,Model,Memory,Serial | Format-Table -AutoSize -Wrap | Out-String).Trim() -NoTS
	}
	
	function Output-Csv($data) {
		log "-Csv was specified. Outputting gathered data to `"$CSVPATH`"..."
		$data | Sort Name | Select Name,Error,Make,Model,Memory,Serial | Export-Csv -Path $CSVPATH -NoTypeInformation -Encoding Ascii
		log "Done."
		
	}
	
	log " " -NoTS
	
	$comps = Get-Comps
	$data = Get-Data $comps
	log " " -NoTS
	Print-Data $data
	log " " -NoTS
	if($Csv) {
		Output-Csv $data
	}
	log " " -NoTS
	log "EOF"
	log " " -NoTS
}