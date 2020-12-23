#Elevate to administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

$sourceDirectoryx64 = "C:\Program Files\Steinberg\VSTPlugins\Powered Plugins"
$destinationDirectoryx64 = "C:\Program Files\Steinberg\VSTPlugins-Disabled\Powered Plugins"

$sourceDirectoryx86 = "C:\Program Files (x86)\Steinberg\VSTPlugins\Powered Plugins"
$destinationDirectoryx86 = "C:\Program Files (x86)\Steinberg\VSTPlugins-Disabled\Powered Plugins"

#Make sure we can find the exclude file
$fileExcludeListName = "PluginsToKeep.txt"
$fileExcludeListPath = Join-Path $PSScriptRoot $fileExcludeListName
$fileExcludeList = Get-Content $fileExcludeListPath

function MoveFilesExceptRecursively ($sourceDirectory, $destinationDirectory, $fileExcludeList) {
    #Create destinationDirectory if not exists
    if (-not (Test-Path -Path $destinationDirectory)) {
        New-Item -Path $destinationDirectory -ItemType Directory | Out-Null
    }
    #endregion

    #region move files (does not support recursive folders)
    # Get-ChildItem $sourceDirectory -File | 
    # Where-Object { $_.Name -notin $fileExcludeList } | 
	# To debug do a foreach on the list and output the filename
    #ForEach-Object {Write-Host $_.FullName}
    # Move file and force (overwrite if already exist) 
    # Move-Item -Destination $destinationDirectory -Force
    #engregion

    #region move files (does support recursive folders)
	#Move file and force (overwrite if already exist) 
    Get-ChildItem $sourceDirectory -Recurse -Exclude $fileExcludeList | 
    Move-Item -Destination { Join-Path $destinationDirectory $_.FullName.Substring($sourceDirectory.length) } -Force
    #endregion
}

Write-Host "Cleaning up $sourceDirectoryx64"
MoveFilesExceptRecursively $sourceDirectoryx64 $destinationDirectoryx64 $fileExcludeList

Write-Host "Cleaning up $sourceDirectoryx86"
MoveFilesExceptRecursively $sourceDirectoryx86 $destinationDirectoryx86 $fileExcludeList
