#!/usr/bin/singularity exec -B /gpfs -B /direct -B /afs -B /sphenix /var/lib/jenkins/images/rhic_sl6-1.1.img tcsh -f

if (-e  cppcheck.xml) then
	rsync -avl --remove-source-files cppcheck.xml cppcheck.xml.backup
endif

source /opt/sphenix/core/bin/sphenix_setup.csh -n; 
which cppcheck; 

# cppcheck --enable=all --inconclusive --xml --xml-version=2 -j16 ./coresoftware >& cppcheck.xml 
# cppcheck -q --enable=warning --enable=style --enable=performance --platform=unix64 --inconclusive --xml --xml-version=2 -j16 -I $ROOTSYS/include/ ./coresoftware >& cppcheck.xml
# cppcheck -q --enable=warning --enable=style --enable=performance --platform=unix64 --inconclusive --xml --xml-version=2 -j16 --std=c++11 ./coresoftware > & cppcheck.xml
cppcheck -q --enable=warning --enable=style --enable=performance --platform=unix64 --inconclusive --xml --xml-version=2 -j 16 --std=c++11 ./coresoftware > & cppcheck.xml