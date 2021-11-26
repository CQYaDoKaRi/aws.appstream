# for AppStream 2.0 Elastic fleet
#---------------------------------------------------------------------------
$dir = Split-Path $MyInvocation.MyCommand.Path
$vhdxs = Get-ChildItem $dir -File -Filter app*.vhdx

# mount
foreach($vhdx in $vhdxs) {
    $image = "$dir\$vhdx"
    $mount = "$dir\" + [System.IO.Path]::GetFileNameWithoutExtension($vhdx)

    If (!(test-path $mount)) {
        New-Item $mount -itemType Directory

        $disk = Mount-DiskImage -ImagePath $image -StorageType VHDX -NoDriveLetter
        $disk | Get-Disk | Get-Partition | where { ($_ | Get-Volume) -ne $Null } | Add-PartitionAccessPath -AccessPath $mount
    }
}