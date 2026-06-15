# Fix: "Transport endpoint is not connected" on /proc files

## Trigger

Errors like:
```
cat: /proc/stat: Transport endpoint is not connected
cat: /proc/meminfo: Transport endpoint is not connected
```

Or symptoms:
- `top` shows `?` for %CPU and %MEM columns
- `ps` prints "Unable to get total memory"

## Cause

Crostini uses LXCFS to provide container-aware `/proc` files via FUSE mounts. The LXCFS daemon runs on the ChromeOS host VM, outside the container. When it crashes or disconnects, the FUSE mounts become stale.

## Fix (no VM restart required)

Unmount the stale LXCFS FUSE mounts to expose the real kernel `/proc`:

```bash
sudo umount -l /proc/cpuinfo /proc/diskstats /proc/loadavg /proc/meminfo /proc/slabinfo /proc/stat /proc/swaps /proc/uptime /sys/devices/system/cpu /var/lib/lxcfs
```

## Trade-off

After unmounting, `/proc/meminfo` etc. show the full host VM's resources instead of container limits. This is fine for most use cases. The LXCFS mounts will return on VM restart.

## Diagnosis commands

```bash
# Check if lxcfs mounts are present but broken
mount | grep lxcfs

# Confirm lxcfs service is not running inside container (expected)
systemctl status lxcfs
```
