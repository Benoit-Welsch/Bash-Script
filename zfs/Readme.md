# ZFS

## Scrub

Run Scrub on all zfs pool

```bash
# Add execution permission
chmod +x scrub_zfs.sh

# Run scrub on all pool
./scrub_zfs.sh
```

## S.M.A.R.T

Run SMART Self-test on all drive used by zfs

```bash
# Add execution permission
chmod +x smart_zfs.sh

# Run short test
./smart_zfs.sh short
# OR
# Run long test
./smart_zfs.sh long
```