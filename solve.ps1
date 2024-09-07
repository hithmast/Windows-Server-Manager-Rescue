$AutoRecoverPath = "$env:windir\System32\wbem\AutoRecover\"

Write-Output "Getting AutoRecover MOFs to recompile."
$GetAutoRecoverMOFS = Get-ChildItem -Path $AutoRecoverPath | Where-Object { ($_.Extension -in ".mof", ".mfl") -and ($_.Name -notlike "*uninstall*") } | Sort-Object -Property Name

Write-Output "Checking syntax of MOFS in $AutoRecoverPath"
$c = 1
foreach ($file in $GetAutoRecoverMOFS) {
    $FileName = $file.Name
    $FilePath = $file.FullName
    Write-Output "Recompiling $FileName. $c of $($GetAutoRecoverMOFS.Count)."
    C:\Windows\System32\wbem\mofcomp.exe -check $FilePath
    $c++
}

Write-Output "Recompiling MOFS in $AutoRecoverPath"
$c = 1
foreach ($file in $GetAutoRecoverMOFS) {
    $FileName = $file.Name
    $FilePath = $file.FullName
    Write-Output "Recompiling $FileName. $c of $($GetAutoRecoverMOFS.Count)."
    C:\Windows\System32\wbem\mofcomp.exe -autorecover $FilePath
    $c++
}
