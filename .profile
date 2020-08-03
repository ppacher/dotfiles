#
# Profile
#

# Enable vim keybindings for the terminal
bindkey -v

# Setup environment for SSH only connections
if [[ -n "$SSH_CONNECTION" ]]; then
    export GPG_TTY=$(tty)
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

#
# Load environment files from systemd environment.d(5).
#
function envup() {
  local envfile=$1
  if [[ -z "$envfile" ]]; then
    envfile=".env"
  fi

  set -o allexport -e
  source $envfile
  set +o allexport +e
}

function loadEnv() {
  for file in $(ls ${HOME}/.config/environment.d/*.conf) ; do
      envup $file
  done
}

loadEnv
