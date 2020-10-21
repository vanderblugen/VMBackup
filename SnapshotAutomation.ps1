# This is run every 12 hours snapshot of hyper-v vm

# Removes old snapshots according to NumberOfBackupsToKeep and 
# Backups up the HyperVName and puts them into FolderName
# It also writes to the EventViewer

$NumberOfDaysOld = 14
$HyperVName = "HyperVName"
$Application = "12 Hour $HyperVName HyperV Snapshot"
$Message = "Removed snapshots of $HyperVName older than $NumberOfDaysOld and Created a New Snapshot"

New-EventLog -LogName Application -Source $Application
# After running one time, this line may produce an error, this is normal

Remove-VMSnapshot (Get-VMSnapshot -VMName $HyperVName | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-$NumberOfDaysOld)})
Checkpoint-VM -Name $HyperVName -SnapshotName "$HyperVName - $(Get-Date -Format "yyyyMMdd HHmm")"
Write-EventLog -LogName "Application" -Source $Application -EventID 3001 -EntryType Information -Message $Message
