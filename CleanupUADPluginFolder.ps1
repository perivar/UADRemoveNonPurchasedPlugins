
$sourceDirectoryx64 = "C:\Program Files\Steinberg\VSTPlugins\Powered Plugins"
$destinationDirectoryx64 = "C:\Program Files\Steinberg\VSTPlugins-Disabled\Powered Plugins"

$sourceDirectoryx86 = "C:\Program Files (x86)\Steinberg\VSTPlugins\Powered Plugins"
$destinationDirectoryx86 = "C:\Program Files (x86)\Steinberg\VSTPlugins-Disabled\Powered Plugins"

$fileExcludeList = Get-Content "PluginsToKeep.txt"

function MoveFilesExceptRecursively ($sourceDirectory, $destinationDirectory, $fileExcludeList) {
    #Create destinationDirectory if not exists
    if (-not (Test-Path -Path $destinationDirectory)) {
        New-Item -Path $destinationDirectory -ItemType Directory | Out-Null
    }
    #endregion

    #region move files (does not support recursive folders)
    # Get-ChildItem $sourceDirectory -File | 
    # Where-Object { $_.Name -notin $fileExcludeList } | 
    # Move-Item -Destination $destinationDirectory -Force
    #engregion

    #region move files (does support recursive folders)
    Get-ChildItem $sourceDirectory -Recurse -Exclude $fileExcludeList | 
    Move-Item -Destination { Join-Path $destinationDirectory $_.FullName.Substring($sourceDirectory.length) }
    #engregion
}

Write-Host "Cleaning up $sourceDirectoryx64"
MoveFilesExceptRecursively $sourceDirectoryx64 $destinationDirectoryx64 $fileExcludeList

Write-Host "Cleaning up $sourceDirectoryx86"
MoveFilesExceptRecursively $sourceDirectoryx86 $destinationDirectoryx86 $fileExcludeList
