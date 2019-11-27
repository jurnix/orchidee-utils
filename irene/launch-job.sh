#!/bin/bash
#MSUB -r forchide # Request name
#MSUB -n 48 # Number of tasks to use
#MSUB -T 8000 # Elapsed time limit in seconds
#MSUB -o orchid_%I.o # Standard output. %I is the job id
#MSUB -e orchid_%I.e # Error output. %I is the job id
#MSUB -Q normal 
#MSUB -A gen6328
#MSUB -D
#MSUB -q skylake 
#MSUB -m work


set -x

# enable core dump file in case of error
ulimit -c unlimited

ccc_mprun ./orchidee_prod
