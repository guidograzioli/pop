#!/bin/bash
declare -A pids

source /virtualenv/*/bin/activate

readonly MOL_DRIVER=${MOL_DRIVER:-'podman'}

list_scenarios() {
  find molecule/ -maxdepth 1  -type d | sed -e 's;molecule/;;g' | grep -e '^[^ ]'
}

# see https://www.die-welt.net/2024/04/running-ansible-molecule-tests-in-parallel/
mkdir -p .config/molecule
echo 'prerun: false' >> .config/molecule/config.yml

readonly LOG_DIR=${MOLECULE_LOG_DIR:-$(mktemp -d)}
echo "Log will be placed in ${LOG_DIR}."

PORT_BINDING=${PORT_BINDING:-8080}
for s in $(list_scenarios)
do
    if [ -e "./molecule/${s}/molecule.yml" ]; then
      logfile="${LOG_DIR}/${s}.log"
      export PORT_BINDING=$(expr "${PORT_BINDING}" + 1)
      molecule test --parallel -d "${MOL_DRIVER}" -s "${s}" -- -e wildfly_node_id=${s} "${@}" &> "${logfile}" &
      pids["${s}"]="${!}"
      echo "Scenario ${s} (PID:${pids[${s}]}, ${logfile} )"
    else
      echo "Directory ${s} is not a molecule scenario, skipping."
    fi
done

for i in ${pids[@]}
do
  wait "${i}"
  echo "PID(${i}) returned: $?"
done
