#!/bin/sh
# Mknx the EXTRA service/client binaries from the one inetutils build (nanos-port's `binary` field
# only mknx's inetd). telnetd (H3) + the telnet/ifconfig/traceroute clients (FAZA I). Resilient:
# a single binary that fails to mknx does NOT abort the others.
mknx_if() {   # $1 = built ELF path, $2 = output .nxe name
  if [ -f "$1" ]; then
    if "${NX_HOST:-i686-nanos}-mknx" "$1" "$PORT/$2" --need libc.ndl; then
      echo "== produced $PORT/$2 =="
    else
      echo "!! mknx failed for $2 (skipped)"
    fi
  fi
}
mknx_if "$STAGE/telnetd/telnetd"       telnetd.nxe
mknx_if "$STAGE/telnet/telnet"         telnet.nxe
mknx_if "$STAGE/ifconfig/ifconfig"     ifconfig.nxe
mknx_if "$STAGE/src/traceroute"        traceroute.nxe
