# Removes old backups according to $NumberOfBackupsToKeep and Exported the $VMName and puts it into $FolderName
# It also writes to the EventViewer

$NumberOfBackupsToKeep = 8
$VMName = "VMName"
$FolderName = "E:\WhereverYouWant"

New-EventLog –LogName Application –Source “Weekly $VMName HyperV Backup“
# After running one time, this line may produce an error, this is normal

While((Get-ChildItem -Path $FolderName | Measure-Object).Count -ge $NumberOfBackupsToKeep) 
{
    $Item = Get-ChildItem -Path $FolderName | Sort CreationTime | select -First 1
    Write-EventLog -LogName "Application" -Source "Weekly $VMName HyperV Backup" -EventID 3001 -EntryType Information -Message "Removing HyperV Exported Backup for $VMName at Folder $($Item.FullName)"
    rmdir $($Item.FullName) -r
}

Export-VM $VMName -Path "$FolderName\$VMName $(Get-Date -Format "yyyyMMdd hhmm")"
Write-EventLog -LogName "Application" -Source "Weekly $VMName HyperV Backup" -EventID 3001 -EntryType Information -Message "Exported HyperV $VMName to $FolderName\$VMName $(Get-Date -Format "yyyyMMdd hhmm")"
