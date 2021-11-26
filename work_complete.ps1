# 作業用
# - フォルダ内にある [app.*.vhdx] を全てアンマウントして [app.*.vhdx] を圧縮
#---------------------------------------------------------------------------
$dir = Split-Path $MyInvocation.MyCommand.Path
$vhdxs = Get-ChildItem $dir -File -Filter app*.vhdx

foreach($vhdx in $vhdxs) {
    $image = "$dir\$vhdx"
    $mount = "$dir\" + [System.IO.Path]::GetFileNameWithoutExtension($vhdx)

    # アンマウント
    If ((test-path $mount)) {
        Dismount-DiskImage -ImagePath $image

        Remove-Item -Path $mount -Force
    }

    # 圧縮
    $image_diskpart = "$image.disppart.txt"

    $diskpart = "select vdisk file='$image'"
    $diskpart = "$diskpart`nattach vdisk readonly"
    $diskpart = "$diskpart`ncompact vdisk"
    $diskpart = "$diskpart`ndetach vdisk"
    [System.IO.File]::WriteAllText($image_diskpart, $diskpart, [System.Text.UTF8Encoding]$false)

    diskpart /s "$image_diskpart"
    Remove-Item -Path $image_diskpart -Force
}