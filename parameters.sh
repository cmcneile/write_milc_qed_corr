#
#   parameters
#

run="latt_"
stream_cfg=CSTART
DIRLAT=../configs
lat_name="lat.sample.l8888_"

DIRLAT_U1=../mean_u1_g_-Feynman-QED_L_convert/configs_fix
lat_name_U1="U1_lat.sample.l8888_"

SCRATCH=./temp

node_geom=not_used
io_geom=not_used
seed=1000

corrfilepath=corr
slurmjobid="QCD_and_QED"

prompt=0
ns=8
nt=8

t0last=8
t0sep=1

r0=2.5
source_iters=20

charge=-0.1

max_cg=1000
max_restarts=5
ks_prec=2

iter_fine=20001

#  precisions
ks_error_loose=1e-5
ks_error_fine=1e-9

##err=1e-5

m_up=0.001524
m_down=0.003328
m_light=0.0673



