# ZFS

## Scrub

Run Scrub on all zfs pool

```bash
# Run scrub on all pool
sh scrub_zfs.sh
```

## S.M.A.R.T

Run SMART Self-test on drive used by zfs

```bash
# Run short test on all drive used by zfs pool
sh smart_zfs.sh short
# Run long test on all drive used by zfs pool
sh smart_zfs.sh long
# Run short test on all drive from a specific pool
sh smart_zfs.sh short backup_tank
```
