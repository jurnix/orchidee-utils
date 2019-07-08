#@ job_name = reference
#@ output = $(job_name).$(jobid)
#@ error = $(output)
#@ total_tasks = 32 
#@ wall_clock_limit = 0:55:00
####@ as_limit = 7gb
#@ job_type = mpich
#@ environment = NB_TASKS=$(total_tasks) ; $DISPLAY
#@ queue

set -x

module unload intel
module load intel/2018.2
module load totalview

ulimit -s unlimited

cd /TO/RUNDIR/PATH 

tv ./orchidee_debug
