# Force-remove every container whose name matches (aliases can't take $1; this can).
docker-rm-name() {
  [[ -z $1 ]] && { echo "usage: docker-rm-name <name>"; return 2; }
  local -a ids
  ids=(${(f)"$(docker ps -a --filter "name=$1" -q)"})
  (( ${#ids} )) || { echo "no containers matching '$1'"; return 0; }
  docker rm -f "${ids[@]}"
}
