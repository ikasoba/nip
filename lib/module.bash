declare -A __loaded_modules

function module::resolve() {
  realpath "$__nip_root/$1"
}

function module::use() {
  if [[ -z "${__loaded_modules["$1"]}" ]]; then
    __loaded_modules["$1"]="1"
    . "$__nip_root/$1"
  fi
}
