#!/bin/bash

cd papi/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..10};
do
    ./run-local.sh >> ../results.csv
done

echo "Finish experiments in $PWD"

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..10};
do
    ./run-local.sh >> ../results.csv
done
echo "Finish experiments in $PWD"

echo "Finished experiments"
