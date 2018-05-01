#!/bin/bash

set -e


# Shortcut for echo to stderr
function errecho() {
    (>&2 echo "$@")
}

# The basename of this script
entry=$(basename $0)

# Print and exit if the user called yum, dnf, or atomic
if [[ $entry == "yum" || $entry == "dnf" || $entry == "atomic" ]]; then
    errecho "This is a Red Hat CoreOS node; it is an image-based rpm-ostree
deployment containing the operating system and kubelet.
See the os command for more information."
    exit 2
fi


# Show usage via stderr and exit
function usage() {
    errecho "Please provide one of the following subcommands:
- status
- upgrade
- usroverlay
- override replace"
    exit 1
}

# End early if we have no input
if [[ $# == 0 ]]; then
	usage
fi


# Execute the input as a shell command and then exit with the
# exit code from the called command.
function execute_and_exit() {
    $@
    exit $?
}


# Forward subcommands to other commands
if [[ "$1" == "status" ]]; then
    rpm-ostree status
    # FIXME: probably a better way to check for which install type is used
    os_type="origin"
    if [[ -f "/etc/systemd/system/atomic-openshift-node.service" ]]; then
        os_type="atomic-openshift"
    fi
    execute_and_exit "systemctl status $os_type-node"
elif [[ "$1" == "upgrade" ]]; then
    # TODO: Detect if operator is in use
    execute_and_exit "rpm-ostree upgrade ${@:2}"
elif [[ "$1" == "usroverlay" ]]; then
    execute_and_exit "rpm-ostree usroverlay ${@:2}"
elif [[ "$1" == "override" && $2 == "replace" ]]; then
    execute_and_exit "rpm-ostree override replace ${@:3}"
fi

# If we get here the subcommand was not valid
echo "Unknown input: ${@:1}"
usage
