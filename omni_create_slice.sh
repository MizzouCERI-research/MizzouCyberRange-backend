#!/bin/bash
# $1 is user name, $2 is slice name
omni createslice $2
omni addslicemember $2 $1 MEMBER
