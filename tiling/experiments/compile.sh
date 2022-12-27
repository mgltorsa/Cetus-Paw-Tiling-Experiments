#!/bin/bash
for j in {1..10}
do

    cd tileSize
    ./compile.sh
    cd ..
    
    cd speed-up
    ./compile.sh
    cd ..

    if [[ -n "$PAPI" ]]; then
        cd papi
        ./compile.sh
        cd ..
    fi
    
done

