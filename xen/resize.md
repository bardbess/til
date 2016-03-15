# XEN

Resizing a non-partitioned xen image. (make sure its shutdown first `xm shutdown vmname`)
This example increases the vm size by 50G.
```bash
  dd if=/dev/zero bs=1024 count=50 >> vmname.img
  resize2fs -f vmname.img
  fsck vmname.img
```
