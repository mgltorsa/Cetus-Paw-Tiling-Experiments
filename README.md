# Experimental information


### Slurn notes
- --ntasks: 1 by default. Allows us to decide the amount of parallel
  tasks to execute by node. Example:
  ```
    #!/bin/bash
    #SBATCH --ntasks=1
    srun sleep 10 & 
    srun sleep 12 &
    wait
  ```
  Last script will last 22 secs because every command inside is being ran in row.
  So, next task need to wait the first task to start its execution. However, by 
  you can execute parallel task by changing the --ntasks parameter. For example:
  ```
  #!/bin/bash
  #SBATCH --ntasks=2
  srun --ntasks=1 sleep 10 & 
  srun --ntasks=1 sleep 12 &
  wait
  ```
  The script will last only 12 minutes because it will execute every command as a parallel task.

### Useful commands
For seeing the historical of jobs in your workgroup:

```
 sacct

 # For formatting
 sacct --format=JobID,Start,End,Elapsed,NCPUS

 # Filtering for by an specific job id
 sacct -j 2057510 --format=JobID,Start,End,Elapsed,NCPUS
```
