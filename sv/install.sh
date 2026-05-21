#!/bin/sh
cd "$(dirname "$0")" || exit 1

# Target user: explicit arg, else the user who invoked sudo.
SV_USER="${1:-$SUDO_USER}"

if test -z "$SV_USER"; then
  echo "usage: sudo sh install.sh <user>   (or run via sudo so SUDO_USER is set)" >&2
  exit 1
fi

if ! id "$SV_USER" >/dev/null 2>&1; then
  echo "error: user '$SV_USER' does not exist" >&2
  exit 1
fi

# Pick the active runit service dir.
for d in /var/service /run/runit/service /etc/service /etc/runit/runsvdir/current; do
  test -d "$d" && SVDIR="$d" && break
done
SVDIR="${SVDIR:-/var/service}"

mkdir -p /etc/sv/pipewire/log /var/log/pipewire
install -m 0755 pipewire/run     /etc/sv/pipewire/run
install -m 0755 pipewire/log/run /etc/sv/pipewire/log/run

printf 'SV_USER=%s\n' "$SV_USER" > /etc/sv/pipewire/conf

ln -sfn /etc/sv/pipewire "$SVDIR/pipewire"

echo "installed pipewire runit service for user '$SV_USER' into $SVDIR; runsv will pick it up shortly"
