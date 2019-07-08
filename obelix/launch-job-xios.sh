#######################
### OBELIX      LSCE ##
#######################
#PBS -N micttrunk_test 
#PBS -m a
#PBS -q medium
#PBS -o out_test.o
#PBS -e out_test.e
#####PBS -S /bin/ksh
#PBS -v BATCH_NUM_PROC_TOT=4
#PBS -l nodes=1:ppn=4


##. /usr/share/Modules/init/ksh
module load netcdf/4p

cd /TO/RUNDIR/PATH

mpirun -n 3 ./orchidee.e ; -n 1 ./xios_server.exe
