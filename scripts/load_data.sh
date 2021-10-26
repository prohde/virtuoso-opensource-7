#!/bin/sh
# Loads the RDF files from /database/toLoad into Virtuoso using DEFAULT_GRAPH as the graph IRI.
# It uses NUM_WORKERS parallel instances of the RDF Loader.
# If the variable is not set, it is set to the number of CPU cores divided by 2.5 rounded up.

if [ -z "$NUM_WORKERS" ]; then
	NUM_CPU_CORES=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
	NUM_WORKERS=$(awk -v var1=$NUM_CPU_CORES -v var2=2.5 'BEGIN { printf "%3.0f\n",  ( var1 / var2 ) }')
fi

# set allowed directories to the default ones plus /database/toLoad
sh -c "cd /database; inifile +inifile virtuoso.ini +section Parameters +key DirsAllowed +value '., ../vad, /usr/share/proj, /database/toLoad'"

virtuoso-t +wait +no-checkpoint
isql 1111 dba dba exec="ld_dir_all('/database/toLoad', '*', '$DEFAULT_GRAPH')"

i=1
while [ "$i" -le "$NUM_WORKERS" ]; do
    isql 1111 dba dba exec="rdf_loader_run();" &
    i=$(( i + 1 ))
done
wait 

isql 1111 dba dba exec="checkpoint;"
kill $(ps aux | pgrep '[v]irtuoso-t')

