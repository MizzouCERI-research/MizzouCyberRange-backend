#!/bin/bash
omni -a illinois-ig createslice rspecTest
# we will activate this command once a user is doing this step
omni addslicemember rspecTest kvhg2 MEMBER
omni -a illinois-ig createsliver rspecTest /data/CyberRange_all_node_Rspec_ver2.xml
