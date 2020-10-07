#!/bin/bash

# load functions
. ./function_input.sh

# load the parameters
. parameters.sh

######################################################################
# Main script starts here
######################################################################

# Lattice names

lat_name="${lat_name}${stream_cfg}"
lat_path="${DIRLAT}/${lat_name}"
reload_cmd="reload_serial ${lat_path}.hisq"

u1_lat_name="${lat_name_U1}${stream_cfg}"
u1_lat_path="${DIRLAT_U1}/${u1_lat_name}"
u1_reload_cmd="reload_u1_serial ${u1_lat_path}.hisq"

# Header

#cat <<EOF
#prompt ${prompt}
#nx ${ns}
#ny ${ns}
#nz ${ns}
#nt ${nt}
#iseed ${seed}
#job_id ${slurmjobid}
#EOF

#node_geometry ${node_geom}
#ionode_geometry ${io_geom}


# Loop over sources for loose solves

for ((t0=0; t0<${t0last}; t0+=${t0sep})); do
    build_for_source_time ${t0} ${ks_error_loose} "loose" "newrand"
    reload_cmd="continue"
done

# Do one fine solve at a selected time. Use same random source as loose solve

# Fine source precesses according to the cfg number

max_cg=${iter_fine}
cfgno=${stream_cfg}
##t0fine=$[0+(${cfgno}*${iter_fine})%${t0last}]
##t0fine=$[0+(${cfgno}*$RANDOM)%${t0last}]
t0fine=$[($RANDOM)%${t0last}]

##echo "DEBUG iter_fine = "  ${iter_fine}
#echo "DEBUG t0last = "  ${t0last}
##echo "DEBUG cfgno = "  ${cfgno}
##echo "DEBUG t0fine = "  ${t0fine}
##exit 0 

build_for_source_time ${t0fine} ${ks_error_fine} "fine" "oldrand"
