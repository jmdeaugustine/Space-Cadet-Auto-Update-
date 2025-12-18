#!/bin/bash
# auto-upgrade.sh
# Copyright (c) 2025 Kurt Mangle
# Licensed under the MIT License


set -e

# ========= ANSI colors =========
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

RED="\033[31m"
GRN="\033[32m"
YEL="\033[33m"
BLU="\033[34m"
MAG="\033[35m"
CYN="\033[36m"
WHT="\033[37m"

# ========= helpers =========
say() { echo -e "$1"; }
pause() { sleep "${1:-1}"; }

# ========= ASCII-safe progress bar (no Unicode blocks) =========
loading_bar() {
  local label="${1:-Working}"
  local secs="${2:-2}"
  local width=28
  local end=$((SECONDS + secs))
  local i=0

  while [ $SECONDS -lt $end ]; do
    i=$(( (i+1) % (width+1) ))
    local filled="$(printf '%*s' "$i" '' | tr ' ' '#')"
    local empty="$(printf '%*s' "$((width-i))" '' | tr ' ' '-')"
    printf "\r${CYN}${BOLD}%s${RST} ${GRN}[%s%s]${RST} ${YEL}.${RST}" "$label" "$filled" "$empty"
    sleep 0.08
  done
  printf "\r${CYN}${BOLD}%s${RST} ${GRN}[%s]${RST}\n" "$label" "$(printf '%*s' "$width" '' | tr ' ' '#')"
}

# ========= Rocket-as-loading-bar (draws line-by-line) =========
draw_rocket_loading() {
  local label="${1:-Preparing launch}"
  local secs="${2:-2}"

  # ASCII-only rocket (safe everywhere)
  local -a ROCKET=(
"                 ^"
"                /^\\"
"               /___\\"
"               |=   =|"
"               |  O  |"
"               |     |"
"               |     |"
"               |     |"
"              /|##!##|\\"
"             / |##!##| \\"
"            /  |##!##|  \\"
"           |   |##!##|   |"
"               |##!##|"
"               |##!##|"
"              /_|##!##|_\\"
"                  |"
"                 / \\"
"                /___\\"
  )

  clear
  say "${CYN}${BOLD}${label}${RST}"
  echo

  local total=${#ROCKET[@]}
  local delay_ms=$(( (secs * 1000) / (total > 0 ? total : 1) ))
  [ $delay_ms -lt 25 ] && delay_ms=25
  local delay
  delay=$(awk "BEGIN{printf \"%.3f\", $delay_ms/1000}")

  # Draw rocket line-by-line with a subtle color gradient
  local n=0
  for line in "${ROCKET[@]}"; do
    n=$((n+1))
    if (( n <= 3 )); then
      echo -e "${WHT}${BOLD}${line}${RST}"
    elif (( n <= 10 )); then
      echo -e "${CYN}${line}${RST}"
    else
      echo -e "${WHT}${line}${RST}"
    fi
    sleep "$delay"
  done

  # Flicker flames briefly
  for i in {1..6}; do
    printf "\r${RED}${BOLD}                *   *${RST}     "
    sleep 0.07
    printf "\r${YEL}${BOLD}               * * * *${RST}    "
    sleep 0.07
    printf "\r${MAG}${BOLD}                *   *${RST}     "
    sleep 0.07
  done
  echo
}

# ========= ASCII scenes =========
rocket_frame() {
  local flame="$1"
  cat <<EOF
${WHT}                 ^
                /^\\
               /___\\
               |=   =|
               |  O  |
               |     |
               |     |
               |     |
              /|##!##|\\
             / |##!##| \\
            /  |##!##|  \\
           |   |##!##|   |
               |##!##|
               |##!##|
              /_|##!##|_\\
                  |
                 / \\
${RST}${flame}${RST}
EOF
}

liftoff() {
  local lines
  lines=$(tput lines 2>/dev/null || echo 30)
  local height=$((lines - 18))
  [ $height -lt 3 ] && height=3

  for ((o=height; o>=0; o--)); do
    clear
    for ((i=0; i<o; i++)); do echo; done

    local r=$((RANDOM % 3))
    local flame
    case "$r" in
      0) flame="${RED}${BOLD}                *   *\n               * * * *\n                *   *${RST}" ;;
      1) flame="${YEL}${BOLD}               *     *\n                *   *\n               *     *${RST}" ;;
      2) flame="${MAG}${BOLD}                * * *\n               *   *\n                * * *${RST}" ;;
    esac

    rocket_frame "$flame"
    sleep 0.05
  done
}

moon_scan() {
  clear
  cat <<'EOF'
               _..._
            .-'_..._''.
          .' .'      '.\
         /  /   .--.   \
        |  |   /    \   |
        |  |  |  .-. |  |
        |  |  | (   )|  |
        |  |  |  `-' |  |
         \  \  \    /  /
          '. '.`--' .'
            '-....-'
EOF

  for i in {1..6}; do
    printf "\r${CYN}${BOLD}Scanning orbit for upgrade candidates${RST}"
    printf "%*s" $((i % 4)) ""
    sleep 0.25
    printf "\r\033[2K"
  done
  echo -e "${CYN}${BOLD}Scan lock achieved.${RST}"
}

station_console() {
  clear
  cat <<'EOF'
        .--------------------------------.
        |     ORBITAL UPDATE STATION     |
        |   "Patch early. Patch often."  |
        '--------------------------------'
                    ||
   .----------------||----------------.
  /   [==]    [==]  ||  [==]    [==]   \
 |    ____    ____  ||  ____    ____    |
 |   |____|  |____| || |____|  |____|   |
 |        ________  ||  ________        |
 |       |  CORE  | || |  CORE  |       |
  \______|_________|_||_|_________|_____/
                    ||
                 ___/  \___
EOF
  loading_bar "Aligning docking clamps" 2
}

# =========================================================
# Flow preserved — dialogue/visuals upgraded
# =========================================================

say "${CYN}${BOLD}Good morning, Cadet.${RST}"
sleep 1
say "${DIM}Ship logs indicate you did not sleep well.${RST} ${MAG}The autopilot kept watch.${RST}"
sleep 1

say "${YEL}${BOLD}Close your eyes and begin the launch countdown:${RST}"
for i in {5..1}; do
  echo -e "${WHT}${BOLD}$i...${RST}"
  sleep .5
done

sleep .5

# Update package lists
liftoff
say "${CYN}${BOLD}Space Commander:${RST} Updating package lists. Try not to panic."
sleep 1
say "${DIM}Hold your horses. Preferably the ones not floating out the airlock.${RST}"
sleep 1

# Rocket drawing = loading bar (ASCII-safe)
draw_rocket_loading "Linking to package beacons..." 2
sudo apt update

# List upgradable packages
moon_scan
say "${CYN}${BOLD}Space Commander:${RST} Here's a list of upgradable packages, Cadet."
sleep 2
sudo apt list --upgradable || true

# Perform a full upgrade and automatically answer 'yes' to prompts
station_console
say "${MAG}${BOLD}Initializing full upgrade.${RST} ${DIM}Automatic confirmations enabled.${RST}"
sleep 2
loading_bar "Pressurizing upgrade chamber" 2
sudo apt full-upgrade -y

# Remove unnecessary packages
say "${GRN}${BOLD}Jettisoning unnecessary cargo${RST} ${DIM}so you don’t carry extra mass into orbit.${RST}"
sleep 2
loading_bar "Calculating discard trajectory" 2
sudo apt autoremove -y

# Update Flatpak packages
say "${BLU}${BOLD}Final pass:${RST} Updating Flatpak supply crates."
sleep 2
loading_bar "Repacking Flatpak containers" 2
flatpak update -y

say "${GRN}${BOLD}All finished.${RST}"
sleep 2
say "${CYN}${BOLD}Mission report:${RST} You are now fully patched and mission-capable."
sleep 2
for i in {5..1}; do
  echo -e "${DIM}${WHT}$i...${RST}"
  sleep .5
done

echo -e "${YEL}${BOLD}      .-.\n     (o o)\n     | O \\\n      \\   \\\n       \`~~~'\n${RST}"
sleep .5
echo -e "${CYN}${BOLD}Commander out.${RST} ${DIM}Try not to go another 4 months, Cadet.${RST}"
sleep 2
