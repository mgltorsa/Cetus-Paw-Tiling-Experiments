#!/bin/bash
vpkg_require papi
echo "$PATH"
sysctl kernel.perf_event_paranoid
./cache_misses
#sleep 30
