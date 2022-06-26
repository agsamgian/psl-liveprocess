$currentloc = Get-Location;
$custompath = 'Temp\ps.dat';
$fullpath = "{0}\{1}" -f $currentloc,$custompath;

function Write-Color() {
     Param (
         [string] $text = $(Write-Error "You must specify some text"),
         [switch] $NoNewLine = $false
     )
 
     $startColor = $host.UI.RawUI.ForegroundColor;
 
     $text.Split( [char]"{", [char]"}" ) | ForEach-Object { $i = 0; } {
         if ($i % 2 -eq 0) {
             Write-Host $_ -NoNewline;
         } else {
             if ($_ -in [enum]::GetNames("ConsoleColor")) {
                 $host.UI.RawUI.ForegroundColor = ($_ -as [System.ConsoleColor]);
             }
         }
         $i++;
     }
 
     if (!$NoNewLine) {
         Write-Host;
     }
     $host.UI.RawUI.ForegroundColor = $startColor;
 }
function Get-FileExistence(){
(Write-Color "{yellow}Checking If Output File Exists...");
Start-Sleep -s 1.5;
if(-not(Test-Path $fullpath)){
     (Write-Color "{green}Creating Output File, Since it doesn't exist...");
    $customDirPath = '{0}\{1}' -f $currentloc,'Temp';
    $createTempDir = New-Item $customDirPath -ItemType Directory;
  if(Test-Path $customDirPath){
New-Item $fullpath -ItemType File;
  }
     }elseif (Test-Path $fullpath) {
     (Write-Color "{green}Output File Exists in ");
     Write-Host $fullpath;
     Start-Sleep -s 1.5;
     }
}
function Get-LiveProcesses(){
     [cmdletbinding()]
     Param (
     [string]$Ps,[string]$Path
     )
     Process {
while($true){
$GetProcesses = Get-Process | Select-Object -Property $ps;
$SetContent = Set-Content $Path $GetProcesses;
$PsLength = (Get-Content $fullpath).Length;
Start-Sleep -s 1.5
Clear-Host;
(Write-Color "{white}[{green}+{white}]Made By Gian Paris C. Agsam | Github: {green}https://github.com/agsamgian");
Write-Host("Total Live Processes:", $PsLength)


}
     }
}
Get-FileExistence;
Get-LiveProcesses -Ps Name -Path $fullpath; 
