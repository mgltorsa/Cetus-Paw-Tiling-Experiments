#!/bin/bash
#SBATCH --job-name=mm-tile-sizes-job
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail
#SBATCH --constraint='Gen1'
getconf -a | grep CACHE