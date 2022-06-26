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

 function Get-Banner(){
    [cmdletbinding()]
    Param (
    [string]$Ascii
    )
    Process {
        (Write-Color "{cyan}",$Ascii);
    }
}
function Get-FileExistence(){
(Write-Color "{yellow}Checking If Output File Exists...");
Start-Sleep -s 1.5;
if(-not(Test-Path $fullpath)){
     (Write-Color "{white}[{green}+{white}]Creating Output File, Since it doesn't exist...");
    $customDirPath = '{0}\{1}' -f $currentloc,'Temp';
    $createTempDir = New-Item $customDirPath -ItemType Directory;
  if(Test-Path $customDirPath){
New-Item $fullpath -ItemType File;
  }
     }elseif (Test-Path $fullpath) {
     (Write-Color "{white}[{green}+{white}]Output File Exists in ", $fullpath);
     Start-Sleep -s 1.5;
     }
}
function Get-LiveProcesses(){
     [cmdletbinding()]
     Param (
     [string]$Ps,[string]$Path
     )
     Process {
$osLabel = (Get-WmiObject Win32_OperatingSystem).Caption;
$compname =  $(whoami.exe);
$architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
$version = (Get-WmiObject Win32_OperatingSystem).Version;
$buildnum = (Get-WmiObject Win32_OperatingSystem).BuildNumber;
while($true){
$GetProcesses = Get-Process | Select-Object -Property $Ps;
$SetContent = Set-Content $Path $GetProcesses;
$PsLength = (Get-Content $fullpath).Length;

Start-Sleep -s 1.5
Clear-Host;
Get-Banner -Ascii @"
██████╗ ███████╗██╗      ██╗     ██╗██╗   ██╗███████╗██████╗ ███████╗
██╔══██╗██╔════╝██║      ██║     ██║██║   ██║██╔════╝██╔══██╗██╔════╝
██████╔╝███████╗██║█████╗██║     ██║██║   ██║█████╗  ██████╔╝███████╗
██╔═══╝ ╚════██║██║╚════╝██║     ██║╚██╗ ██╔╝██╔══╝  ██╔═══╝ ╚════██║
██║     ███████║███████╗ ███████╗██║ ╚████╔╝ ███████╗██║     ███████║
╚═╝     ╚══════╝╚══════╝ ╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝     ╚═════
"@
(Write-Color "{white}[{green}+{white}]Made By FonderElite | Github: {green}https://github.com/FonderElite");
(Write-Color "{green}System-User: {white}", $compname);
(Write-Color "{green}Os: {white}", $osLabel);
(Write-Color "{green}Os-Architecture: {white}", $architecture);
(Write-Color "{green}Version: {white}", $version);
(Write-Color "{green}Build-Number: {white}", $buildnum);
(Write-Color "{green}Total Live Processes: {white}", $PsLength);

}
     }
}
Get-FileExistence;
Get-LiveProcesses -Ps Name -Path $fullpath; 
