#requires -Version 5.1
<# Created by Dewald Pretorius. #>
[CmdletBinding(SupportsShouldProcess=$true)]
param([ValidateSet('Diagnose','ResetClientCache','FlushDns')][string]$Action='Diagnose',[string]$OutputPath=(Join-Path ([Environment]::GetFolderPath('Desktop')) 'Windows_App_Connection_Repair'))
$ErrorActionPreference='Stop';$cachePath="$env:LOCALAPPDATA\Packages\MicrosoftCorporationII.Windows365_8wekyb3d8bbwe\LocalCache"
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null;$stamp=Get-Date -Format yyyyMMdd_HHmmss;$log=Join-Path $OutputPath "Repair_$stamp.log";function Log($m){$l='{0:u} {1}'-f(Get-Date),$m;Write-Host $l;Add-Content $log $l}
[ordered]@{Action=$Action;Processes=@(Get-Process Windows365,msrdc -ErrorAction SilentlyContinue|Select-Object Name,Id);CacheExists=(Test-Path $cachePath);Cloud443=(Test-NetConnection 'rdweb.wvd.microsoft.com' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue);Identity443=(Test-NetConnection 'login.microsoftonline.com' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue)}|ConvertTo-Json -Depth 5|Set-Content (Join-Path $OutputPath "PreRepair_$stamp.json")
if($Action -eq 'Diagnose'){Log '[COMPLETE] Snapshot saved.';exit 0}
try{if($Action -eq 'ResetClientCache' -and $PSCmdlet.ShouldProcess($cachePath,'Back up and reset Windows App cache')){if(Get-Process Windows365,msrdc -ErrorAction SilentlyContinue){throw 'Close Windows App and Remote Desktop clients before resetting the cache.'};if(Test-Path $cachePath){$backup="$cachePath.backup-$stamp";Move-Item $cachePath $backup -Force;New-Item -ItemType Directory $cachePath -Force|Out-Null;Log "[BACKUP] $backup"}}
elseif($Action -eq 'FlushDns' -and $PSCmdlet.ShouldProcess('Windows DNS client cache','Clear')){Clear-DnsClientCache}}catch{Log "[FAILED] $($_.Exception.Message)";exit 5};Log '[COMPLETE] Repair completed.';exit 0
