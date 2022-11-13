#!/bin/bash

cd papi/
echo "Running experiments in $PWD"
./compile.sh
./run-local.sh >> ../results.csv
echo "Finish experiments in $PWD"

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh
./run-local.sh >> ../results.csv
echo "Finish experiments in $PWD"

echo "Finished experiments"