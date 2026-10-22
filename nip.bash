#!/usr/bin/env bash

__nip_root="$(dirname $(realpath $0))"

. "$__nip_root/lib/module.bash"

module::use nip/main.bash

nip::main "$@"
