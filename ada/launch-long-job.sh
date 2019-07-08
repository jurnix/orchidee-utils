#@ job_name = reference
#@ output = $(job_name).$(jobid)
#@ error = $(output)
#@ total_tasks = 32
#@ wall_clock_limit = 30:55:00
####@ as_limit = 7gb
#@ job_type = mpich
#@ environment = NB_TASKS=$(total_tasks) ; $DISPLAY
#@ queue

#
# Script to make long runs with orchidee and xios
# Place script into a main orchidee folder
# with all the required input files
#
# This scripts will keep at the end of the year all the outputs


set -eux

#module unload intel
#module load intel/2018.2

ulimit -s unlimited


function setrundefkey () { # modify an orchidee run.Def key value
  local KEY=$1 # key to modify
  local VAL=$2 # value to set
  local FIL=$3 # file to modify
  sed -i "s~$KEY=.*~$KEY=$VAL~" $FIL 
}

function searchandreplace() { # search and replace a value in a variable string
  local STR=$1 # string to apply
  local KEY=$2 # key to search
  local VAL=$3 # value to replace with
  local retval="${STR/$KEY/$VAL}"  
  echo "$retval"
}

# manually set up
STARTYEAR=1901
ENDYEAR=2000
FORCINGFILE_PATTERN="\/workgpfs\/rech\/psl\/rpsl035\/IGCM\/BC\/OOL\/OL2\/CRU-NCEP\/v8\/twodeg\/cruncep_twodeg_YEAR.nc" # replace YEAR tag by its loop year, escape special characters


for ITEYEAR in $(seq $STARTYEAR $ENDYEAR);
do
    echo "year:", $ITEYEAR
    ONEYEAR=1
    PREVYEAR=$(($ITEYEAR - $ONEYEAR))
    OUTFOLDER=output_$ITEYEAR
    OUTFOLDER_PREV=output_$PREVYEAR

    # Place here all required keys to modify at the beggining of the year
    # prepare the run.def
    if [ "$ITEYEAR" -eq "$STARTYEAR" ]; then # is first year?
       echo "FIRST YEAR DETECTED"
       setrundefkey RESTART_FILEIN NONE run.def
       setrundefkey SECHIBA_restart_in NONE run.def
       setrundefkey STOMATE_RESTART_FILEIN NONE run.def
    else
       echo "normal year detected"
       setrundefkey RESTART_FILEIN ${OUTFOLDER_PREV}\/driver_restart.nc run.def
       setrundefkey SECHIBA_restart_in ${OUTFOLDER_PREV}\/sechiba_restart.nc run.def
       setrundefkey STOMATE_RESTART_FILEIN ${OUTFOLDER_PREV}\/stomate_restart.nc run.def
    fi

    FORCING=$(searchandreplace $FORCINGFILE_PATTERN YEAR $ITEYEAR) 
    setrundefkey FORCING_FILE $FORCING run.def

    # launch simulation
    # only for DEV - 
    #sh stubs.sh # simulate output files    
    time mpirun ./orchidee_prod

    # Archive input/output files
    mkdir $OUTFOLDER

    cp run.def $OUTFOLDER/
    cp *.xml $OUTFOLDER/

    mv driver_restart.nc $OUTFOLDER/
    mv sechiba_restart.nc $OUTFOLDER/
    mv stomate_restart.nc $OUTFOLDER/

    mv sechiba_history.nc $OUTFOLDER/
    mv stomate_history.nc $OUTFOLDER/

    mv out_orchidee_* $OUTFOLDER/
    mv used_run.def $OUTFOLDER/
    mv Load_balance_orchidee.dat $OUTFOLDER/
done

#time mpirun ./orchidee_prod
