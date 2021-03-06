#!/bin/bash

#
# CIS Debian 7 Hardening
#

#
# 3.2 Set Permissions on bootloader config (Scored)
#

set -e # One error, it's over
set -u # One variable unset, it's over

# Assertion : Grub Based.

FILE='/boot/grub/grub.cfg'
PERMISSIONS='400'

# This function will be called if the script status is on enabled / audit mode
audit () {
    has_file_correct_permissions $FILE $PERMISSIONS
    if [ $FNRET = 0 ]; then
        ok "$FILE has correct permissions"
    else
        crit "$FILE has not $PERMISSIONS permissions set"
    fi 
}

# This function will be called if the script status is on enabled mode
apply () {
    has_file_correct_permissions $FILE $PERMISSIONS
    if [ $FNRET = 0 ]; then
        ok "$FILE has correct permissions"
    else
        info "fixing $FILE permissions to $PERMISSIONS"
        chmod 0$PERMISSIONS $FILE
    fi
}

# This function will check config parameters required
check_config() {
    is_pkg_installed "grub-pc"
    if [ $FNRET != 0 ]; then
        warn "grub-pc is not installed, not handling configuration"
        exit 128
    fi
    if [ $FNRET != 0 ]; then
        crit "$FILE does not exist"
        exit 128
    fi
}

# Source Root Dir Parameter
if [ ! -r /etc/default/cis-hardening ]; then
    echo "There is no /etc/default/cis-hardening file, cannot source CIS_ROOT_DIR variable, aborting"
    exit 128
else
    . /etc/default/cis-hardening
    if [ -z $CIS_ROOT_DIR ]; then
        echo "No CIS_ROOT_DIR variable, aborting"
        exit 128
    fi
fi 

# Main function, will call the proper functions given the configuration (audit, enabled, disabled)
[ -r $CIS_ROOT_DIR/lib/main.sh ] && . $CIS_ROOT_DIR/lib/main.sh
