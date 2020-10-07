#
#  Functions used to build the input file
#

######################################################################
function build_sources() {

myt0=$1
saverand=$2

# Arrange to ignore the new source if we are asked to use the old one
# This way the fine solve can use the same source as the loose solve

if [ ${saverand} = "oldrand" ]
then
   rnd_save_cmd="forget_source"
else
##   rnd_save_cmd="save_partfile_scidac_ks_source ${rnd_path}"
   rnd_save_cmd="save_serial_scidac_ks_source ${rnd_path}"
##   rnd_save_cmd="save_serial_ks_source ${rnd_path}"
fi

cat <<EOF

######################################################################
# source time ${myt0}
######################################################################

# Gauge field description

${reload_cmd}
u0 1
no_gauge_fix
forget
${u1_reload_cmd}
forget_u1
staple_weight 0.1
ape_iter 5
coordinate_origin 0 0 0 0
time_bc antiperiodic

max_number_of_eigenpairs 0

# Chiral condensate and related measurements

number_of_pbp_masses 0

# Description of base sources

number_of_base_sources 2

# base source 0
random_color_wall
field_type KS
subset full
t0 ${myt0}
ncolor 3
momentum 0 0 0
source_label w
${rnd_save_cmd}

# base source 1
vector_field
field_type KS
subset full
origin 0 0 0 ${myt0}
load_source ${rnd_path}
ncolor 3
momentum 0 0 0
source_label w
forget_source

# Description of modified sources

number_of_modified_sources 4

# source 2

source 1
fat_covariant_gaussian
stride 2
r0 ${r0}
source_iters ${source_iters}
op_label s
forget_source

# source 3

source 1
spin_taste
spin_taste rhox
op_label x
forget_source

# source 4

source 1
spin_taste
spin_taste rhoy
op_label y
forget_source

# source 5

source 1
spin_taste
spin_taste rhoz
op_label z
forget_source

EOF
}
##  end of build sources


######################################################################

function build_dummy_prop () {

nprop=$1
source=$2
charge=$3

cat <<EOF

# Dummy propagator

# Parameters for set 0

max_cg_iterations 10
max_cg_restarts 1
check sourceonly
momentum_twist 0 0 0
precision 2
charge ${charge}

source ${source}

number_of_propagators 1

# propagator ${nprop}

mass 0.0
naik_term_epsilon 0.0
error_for_propagator 0.0
rel_error_for_propagator 0.0
fresh_ksprop
forget_ksprop

EOF
}

######################################################################

function build_prop () {

nprop=$1
source=$2
mass=$3
err=$4
charge=$5

cat <<EOF

# Parameters for set ${nprop}

max_cg_iterations ${max_cg}
max_cg_restarts ${max_restarts}
check yes
momentum_twist 0 0 0
precision ${ks_prec}
charge ${charge} 

source ${source}

number_of_propagators 1

# propagator ${nprop}

mass ${mass}
naik_term_epsilon 0
error_for_propagator ${err}
rel_error_for_propagator 0.0
fresh_ksprop
forget_ksprop

EOF
}

######################################################################

function build_real_props(){

nprev=$1
mass=$2
err=$3
charge=$4

build_prop $[${nprev}+0] 1 ${mass} ${err} ${charge}
build_prop $[${nprev}+1] 2 ${mass} ${err} ${charge}
build_prop $[${nprev}+2] 3 ${mass} ${err} ${charge}
build_prop $[${nprev}+3] 4 ${mass} ${err} ${charge}
build_prop $[${nprev}+4] 5 ${mass} ${err} ${charge}

}

######################################################################
# Creates 7 quarks
#
######################################################################

function build_quarks(){

nprevqk=$1
nprevprop=$2

cat <<EOF

# quark $[${nprevqk}+0], point to point

propagator $[${nprevprop}+1]
identity
op_label d
forget_ksprop


# quark $[${nprevqk}+1], point to smear

propagator $[${nprevprop}+1]
fat_covariant_gaussian
stride 2
r0 ${r0}
source_iters ${source_iters}
op_label s
forget_ksprop


# quark $[${nprevqk}+2], smear to point

propagator $[${nprevprop}+2]
identity
op_label d
forget_ksprop


# quark $[${nprevqk}+3], smear to smear

propagator $[${nprevprop}+2]
fat_covariant_gaussian
stride 2
r0 ${r0}
source_iters ${source_iters}
op_label s
forget_ksprop


# quark $[${nprevqk}+4], GX-GX to point

propagator $[${nprevprop}+3]
identity
op_label d
forget_ksprop


# quark $[${nprevqk}+5], GY-GY to point

propagator $[${nprevprop}+4]
identity
op_label d
forget_ksprop


# quark $[${nprevqk}+6], GZ-GZ to point

propagator $[${nprevprop}+5]
identity
op_label d
forget_ksprop

EOF
}

######################################################################
function build_mesons(){

m=$1
n=$2
tag=$3
myt0=$4
errtag=$5

corrfile=${corrfilepath}/corr_${errtag}_${run}${stream_cfg}

cat <<EOF

pair $[$m + 0] $[$n + 0]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 1] $[$n + 1]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 2] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 3] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 0] $[$n + 1]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 0] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                                
                                              
pair $[$m + 0] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E
                                                                            

pair $[$m + 1] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E

pair $[$m + 1] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E


pair $[$m + 2] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator pion  p000  1 / 1 pion5  0 0 0 E E E


pair $[$m + 4] $[$n + 0]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhox p000  1 / 1 rhox  0 0 0 E E E


pair $[$m + 4] $[$n + 1]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhox p000  1 / 1 rhox  0 0 0 E E E


pair $[$m + 4] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhox p000  1 / 1 rhox  0 0 0 E E E


pair $[$m + 4] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhox p000  1 / 1 rhox  0 0 0 E E E


pair $[$m + 5] $[$n + 0]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoy p000  1 / 1 rhoy  0 0 0 E E E


pair $[$m + 5] $[$n + 1]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoy p000  1 / 1 rhoy  0 0 0 E E E


pair $[$m + 5] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoy p000  1 / 1 rhoy  0 0 0 E E E


pair $[$m + 5] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoy p000  1 / 1 rhoy  0 0 0 E E E


pair $[$m + 6] $[$n + 0]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoz p000  1 / 1 rhoz  0 0 0 E E E


pair $[$m + 6] $[$n + 1]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoz p000  1 / 1 rhoz  0 0 0 E E E


pair $[$m + 6] $[$n + 2]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoz p000  1 / 1 rhoz  0 0 0 E E E


pair $[$m + 6] $[$n + 3]
spectrum_request meson
save_corr_fnal ${corrfile}
r_offset 0 0 0 ${myt0}
number_of_correlators 1
correlator rhoz p000  1 / 1 rhoz  0 0 0 E E E

EOF
}

######################################################################
#   Top level function for creating the input file
#
######################################################################

function build_for_source_time(){

myt0=$1
err=$2
errtag=$3
saverand=$4

rnd_name="rnd${run}${stream_cfg}.t${myt0}"
rnd_path="${SCRATCH}/${rnd_name}"

build_sources ${myt0} ${saverand}

cat <<EOF
# Description of propagators
number_of_sets $[1+3*5]
EOF

build_dummy_prop 0 0 ${charge_dummy}
build_real_props 1 ${m_up} ${err}  ${charge_up}
build_real_props 6 ${m_down} ${err} ${charge_down}
build_real_props 11 ${m_strange} ${err} ${charge_strange}

cat <<EOF
# Description of quarks
number_of_quarks $[7*3]
EOF

build_quarks 0 0
build_quarks 7 5
build_quarks 14 10

cat <<EOF
# Description of mesons
number_of_mesons $[22*6]
EOF
                                              
build_mesons  0  0 UU ${myt0} ${errtag}
build_mesons  7  7 DD ${myt0} ${errtag}
build_mesons 14 14 LL ${myt0} ${errtag}
build_mesons  0  7 UD ${myt0} ${errtag}
build_mesons  0 14 UL ${myt0} ${errtag}
build_mesons  7 14 DL ${myt0} ${errtag}

cat <<EOF
# Description of baryons
number_of_baryons 0
EOF
}
