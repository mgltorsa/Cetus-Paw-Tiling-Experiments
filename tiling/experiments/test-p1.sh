#!/bin/bash

echo "running p1, jacobi_M: $JACOBI_M"
for i in {1..3}
do
 echo "running p1, iter=$i, nonTiled"
 srun sleep 20
 echo "running p1, iter=$i, singe-tiled"
 srun sleep 20
 echo "finished p1, iter=$i"
done
echo "finished all p1"
