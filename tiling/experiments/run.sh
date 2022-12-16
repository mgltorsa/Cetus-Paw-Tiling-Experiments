#!/bin/bash

cd papi/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ssbatch run.sh
done

echo "Finish experiments in $PWD"

cd ../speed-up/
echo "Running experiments in $PWD"
./compile.sh

for i in {1..5};
do
    ssbatch run.sh
done
echo "Finish experiments in $PWD"

echo "Finished experiments"
