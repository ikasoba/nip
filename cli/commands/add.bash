function cli::commands::add() {
  local args=("$@")
  local arg
  local pkgbase
  local pkg
  local inputsfile="inputs.nix"
  local i
  local params=()

  for (( i=0; i < "${#args[@]}"; i++ )); do
    arg="${args["$i"]}"
    case "$arg" in
      "-f")
        (( i++ ))
        inputsfile="${args["$i"]}"
        ;;

      *)
        params["${#params[@]}"]="$arg"
        ;;
    esac
  done

  if ! [[ -f "$inputsfile" ]]; then
    echo "{}" > "$inputsfile"
  fi

  local tmpfile="$(mktemp ./$inputsfile.XXXXX.nix)"

  ARGS="$(jq -rn '$ARGS.positional' --args "${params[@]}")" \
  INPUTS_FILE="$(realpath "$inputsfile")" \
    nix eval --raw --impure -f "$(module::resolve cli/commands/add.nix)" > "$tmpfile"
  if [[ "$?" != 0 ]]; then
    rm "$tmpfile"
    return 1
  fi

  mv "$tmpfile" "$inputsfile"
}
