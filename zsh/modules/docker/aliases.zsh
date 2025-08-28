# Removes all containers with a given name
alias docker-rm-name='docker ps -a --filter "name=$1" -q | xargs docker rm -f'
