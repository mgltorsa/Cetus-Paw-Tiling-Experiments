#!/bin/bash
vpkg_require papi
echo "GG $@"
sysctl kernel.perf_event_paranoid
./cache_misses
#sleep 30
