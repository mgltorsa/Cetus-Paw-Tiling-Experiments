#!/bin/bash

. ../../setup.sh

sbatch slurm-baseline-run.sh
ssbatch variations-run.sh
