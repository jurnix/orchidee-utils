######################
### OBELIX      LSCE ##
#######################
#PBS -N alkalinity 
#PBS -m a
#PBS -q medium
#PBS -o out_test.o
#PBS -e out_test.e
#####PBS -S /bin/ksh
#PBS -v BATCH_NUM_PROC_TOT=8
#PBS -l nodes=1:ppn=8


##. /usr/share/Modules/init/ksh
module load netcdf/4p

cd /TO/RUNDIR/PATH 

mpirun ./orchidee_debug
