# 作業用
# - フォルダ内にある [app.*.vhdx] を vhdx ファイル名でフォルダ内に全マウント
#---------------------------------------------------------------------------
$dir = Split-Path $MyInvocation.MyCommand.Path
$vhdxs = Get-ChildItem $dir -File -Filter app*.vhdx

# アンマウント
foreach($vhdx in $vhdxs) {
    $image = "$dir\$vhdx"
    $mount = "$dir\" + [System.IO.Path]::GetFileNameWithoutExtension($vhdx)

    If ((test-path $mount)) {
        Dismount-DiskImage -ImagePath $image

        Remove-Item -Path $mount -Force
    }
}

# マウント
foreach($vhdx in $vhdxs) {
    $image = "$dir\$vhdx"
    $mount = "$dir\" + [System.IO.Path]::GetFileNameWithoutExtension($vhdx)

    If (!(test-path $mount)) {
        New-Item $mount -itemType Directory
    }

    $disk = Mount-DiskImage -ImagePath $image -StorageType VHDX -NoDriveLetter
    $disk | Get-Disk | Get-Partition | where { ($_ | Get-Volume) -ne $Null } | Add-PartitionAccessPath -AccessPath $mount
}