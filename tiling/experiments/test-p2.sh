#!/bin/bash

echo "running p2, MATRIX_M=$MATRIX_MULT_M"
for i in {1..3}
do
 echo "running p2, iter=$i, nonTiled"
 srun sleep 20
 echo "running p2, iter=$i, singe-tiled"
 srun sleep 20
 echo "finished p2, iter=$i"
done
echo "finished all p2"

