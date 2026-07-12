#!/bin/sh
# post_configure.sh — x86_64 only: route picolibc's stdio/errno/ctype DATA exports through
# libc.ndl IAT slots. x86_64 code references stdin/stdout/stderr/environ/_ctype_b RIP-relative
# (R_X86_64_PC32 to an undefined data symbol), which mknx can't auto-import — the link would
# fail "undefined function 'stdout'". The nx-dllimport.h shim (shipped into the sysroot include
# by `make ping`) redefines each to an __imp_<name> slot deref that mknx imports. Appended at the
# BOTTOM of the generated config.h, which every TU includes first, so the macros are live before
# any stdio reference. i686 uses absolute relocs and needs none of this (NX_HOST != x86_64-nanos).
set -e
[ "${NX_HOST:-i686-nanos}" = "x86_64-nanos" ] || exit 0
printf '\n#include <nx-dllimport.h>\n' >> "$STAGE/config.h"
echo "  [post_configure] appended nx-dllimport.h to config.h (x86_64 data-import shim)"
