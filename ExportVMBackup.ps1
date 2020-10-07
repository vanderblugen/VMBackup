# This script creates a backup of HyperV VM and exports it to a specified folder
# The number of backups is limited
# It also writes to the EventViewer

$NumberOfBackupsToKeep = 8                  # number of backups to keep
$VMName = "VMName"                          # name of the virtual machine
$FolderName = "E:\WhereverYouWant"          # where the exported/backup VM goes

New-EventLog –LogName Application –Source “Weekly $VMName HyperV Backup“
# After running this script one time, this line may produce an error, this is normal

While((Get-ChildItem -Path $FolderName | Measure-Object).Count -ge $NumberOfBackupsToKeep)
# runs a loop as long as the number of folders in $FolderName is greater than or equal to $NumberOfBackupsToKeep
{

    $Item = Get-ChildItem -Path $FolderName | Sort CreationTime | select -First 1
    # counts entries in the folder and outputs the oldest name by creation date
    
    Write-EventLog -LogName "Application" -Source "Weekly $VMName HyperV Backup" -EventID 3001 -EntryType Information -Message "Removing HyperV Exported Backup for $VMName at Folder $($Item.FullName)"
    # creates an entry in Event Viewer stating that the Exported VM folder was removed
    
    rmdir $($Item.FullName) -r
    # removes the oldest folder
}

Export-VM $VMName -Path "$FolderName\$VMName $(Get-Date -Format "yyyyMMdd hhmm")"
# export the VM to the specified folder

Write-EventLog -LogName "Application" -Source "Weekly $VMName HyperV Backup" -EventID 3001 -EntryType Information -Message "Exported HyperV $VMName to $FolderName\$VMName $(Get-Date -Format "yyyyMMdd hhmm")"
# creates an entry in Event Viewer stating that the VM was backed up to a specified folder
