#! /bin/bash

sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1
else
    # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
fi

# Potential tags:
# - devel, x.y.z-devel x.y-devel
#   current `trunk` in the R repo
# - alpha, x.y.z-alpha, x.y-alpha
#   current alpha
# - beta, x.y.z-beta, x.y-beta
#   current beta
# - rc, x.y.z-rc, x.y-rc
#   current rc
# - next
#   the next version of R. This can be patched, alpha, beta, rc or prerelease
# - patched, x.y.z-patched, x.y-patched
#   current patched branch
# - release, latest
#   always the latest release
# - x.y.z
# - x.y

# This is how we assign tags for the various versions:
#
# ## devel
# - devel
# - x.y.z-devel
# - x.y.z
# - x.y-devel
# - x.y
#
# ## next
# - next
# - patched (if it is patched)
# - x.y.z-patched (if it is)
# - x.y-patched (if it is)
# - alpha (if it is)
# - x.y.z-alpha (if it is)
# - x.y-alpha (if it is)
# - beta (if it is)
# - x.y.z-beta (if it is)
# - x.y-beta (if it is)
# - rc (if it is)
# - x.y.z-rc (if it is)
# - x.y-rc (if it is)
# - x.y.z
# - x.y
#
# ## x.y.z
# - x.y.z
# - x.y
# - release (if it is)
# - latest (if it is)

function prefix_tags() {
    local tags=$1
    tags1=$(echo $tags | tr ' ' '\n' | sed -e 's|^|rhub/r-minimal:|g' | tr '\n' ',')
    tags2=$(echo $tags | tr ' ' '\n' | sed -e 's|^|ghcr.io/r-hub/r-minimal/r-minimal:|g' | tr '\n' ',')
    if [[ -n "$tags1" && -n "$tags2" ]]; then
        echo "$tags1,$tags2"
    elif [[ -n "$tags1" ]]; then
        echo "$tags1"
    else
        echo "$tags2"
    fi | sed 's/,,/,/g' | sed 's/,$//'
}

function get_r_version_number() {
    R --slave -e 'cat(format(getRversion()))'
}

function get_r_version_string() {
    R --slave -e 'cat(R.version$version.string)'
}

function get_r_release_version() {
    release=$(wget -q -O- https://api.r-hub.io/rversions/r-release)
    echo $release |
        sed 's/^.*"version"\s*:\s*"//' |
        sed 's/".*$//'
}

function calculate() {
    r_version=${1}
    if [[ -z "$r_version" ]]; then
        >&2 echo "Version is not specified"
        exit 1;
    fi
    r_version_number=$(get_r_version_number)
    r_minor=$(echo ${r_version_number} | sed 's/[.][0-9][0-9]*$//')
    tags=""
    echo "R version number: ${r_version}"
    vstr=$(get_r_version_string)
    echo "R version string: $vstr"
    if [[ "${r_version}" = "devel" ]]; then
        tags="devel ${r_version_number}-devel ${r_version_number} ${r_minor} ${r_minor}-devel"

    elif [[ "${r_version}" = "next" ]]; then
        tags="next ${r_version_number} ${r_minor}"
        if echo $vstr | grep -q '[Pp]atched'; then
            tags="$tags patched ${r_version_number}-patched ${r_minor}-patched"
        elif echo $vstr | grep -q '[Aa]lpha'; then
            tags="$tags alpha ${r_version_number}-alpha ${r_minor}-alpha"
        elif echo $vstr | grep -q '[Bb]eta'; then
            tags="$tags beta ${r_version_number}-beta ${r_minor}-beta"
        elif echo $vstr | grep -q '[Rr][Cc]'; then
            tags="$tags rc ${r_version_number}-rc ${r_minor}-rc"            
        fi
    else
        tags="${r_version_number} ${r_minor}"
        relver=$(get_r_release_version)
        if [[ "$relver" == "$r_version_number" ]]; then
            tags="$tags release latest"
        fi
    fi
    echo "Tags to add: $tags"
    ftags="`prefix_tags "$tags"`"
    echo "::set-output name=tags::${ftags}"
}

function main() {
    calculate $1
}

if [ "$sourced" = "0" ]; then
    main $1
fi
