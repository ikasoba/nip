function cli::main::help() {
  printf 'NIP: Nix project manager\n\n'
  printf 'Commands:\n'
  printf '  add [-f <inputs-file>] <ref>\n'
  printf '    Add derivation reference to inputs file\n'
  printf 'Options:\n'
  printf '  -h|--help\n'
  printf '    Show help\n'
}

function cli::main() {
  local args=("$@")
  local arg
  local i

  for (( i=0; i < "${#args[@]}"; i++ )); do
    arg="${args["$i"]}"
    case "$arg" in
      "-h"|"--help")
        cli::main::help
        return 0
        ;;

      "add")
        (( i++ ))
        module::use cli/commands/add.bash

        cli::commands::add "${args[@]:$i}"
        return "$?"
        ;;

      *)
        printf 'Invalid argument: %s\n\n' "$arg"
        cli::main::help
        return 1        
        ;;
    esac
  done

  printf 'Argument required\n\n'
  cli::main::help
  return 1        
}
