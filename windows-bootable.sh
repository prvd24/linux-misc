# https://nixaid.com/bootable-usb-windows-linux/

# https://www.microsoft.com/software-download/windows11
# sha256sum Win11_English_x64v1.iso

wipefs -a /dev/sda

parted /dev/sda
    mklabel gpt                                                      
    mkpart BOOT fat32 0% 1GiB
    mkpart INSTALL ntfs 1GiB 10GiB
    quit

# parted /dev/sda unit B print
      # Number  Start        End           Size          File system  Name     Flags
      # 1      1048576B     1073741823B   1072693248B                BOOT     msftdata
      # 2      1073741824B  62742593535B  61668851712B               INSTALL  msftdata

mkdir /mnt/iso ; mount Win11_English_x64v1.iso /mnt/iso/

mkfs.vfat -n BOOT /dev/sda1 ; mkdir /mnt/vfat ; mount /dev/sda1 /mnt/vfat/
rsync -r --progress --exclude sources --delete-before /mnt/iso/ /mnt/vfat/
mkdir /mnt/vfat/sources ; cp /mnt/iso/sources/boot.wim /mnt/vfat/sources/

mkfs.ntfs --quick -L INSTALL /dev/sda2 ; mkdir /mnt/ntfs ; mount /dev/sda2 /mnt/ntfs
rsync -r --progress --delete-before /mnt/iso/ /mnt/ntfs/

umount /mnt/ntfs ; umount /mnt/vfat ; umount /mnt/iso ; sync ; udisksctl power-off -b /dev/sda
