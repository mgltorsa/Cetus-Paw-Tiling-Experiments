#!/bin/bash

cd papi/
echo "Running experiments in $PWD"
./compile.sh
./run-local.sh >> ../results.csv &
wait

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh
./run-local.sh >> ../results.csv &
wait

echo "Finished experiments"