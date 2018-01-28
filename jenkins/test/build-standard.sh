#!tcsh -f

if (-e  cppcheck.xml) then
	rsync -avl --remove-source-files cppcheck.xml cppcheck.xml.backup
endif

source /opt/sphenix/core/bin/sphenix_setup.csh -n; 
which cppcheck; 


#-------------
# sPHENIX
#-------------
#
# daily build
#
# 24 13 * * * source /opt/sphenix/core/bin/sphenix_setup.csh &&  set path = ($HOME/sPHENIX/ccache/bin $path) && setenv CCACHE_DIR /home/phnxbld/.sphenixccache && cp $HOME/krb5.keytab.phnxbld /tmp && kinit -k -t /tmp/krb5.keytab.phnxbld phnxbld && rm /tmp/krb5.keytab.phnxbld && /usr/bin/aklog &&  rm -rf /home/phnxbld/sPHENIX/new && rm -rf /home/phnxbld/sPHENIX/newbuild && mkdir -p /home/phnxbld/sPHENIX/newbuild && cd /home/phnxbld/sPHENIX/newbuild && git clone https://github.com/sPHENIX-Collaboration/utilities ./  >& $HOME/sphenixbld.log &&  cd utils/rebuild && ./build.pl --phenixinstall --notify  --tinderbox 
#
# insure build
#
# 23 20 * * *  setenv G4_MAIN /opt/sphenix/core/geant4.10.02.p01 && source /opt/sphenix/core/bin/sphenix_setup.csh new+insure  && cp $HOME/krb5.keytab.phnxbld /tmp && kinit -k -t /tmp/krb5.keytab.phnxbld phnxbld && rm /tmp/krb5.keytab.phnxbld && /usr/bin/aklog && rm -rf /home/phnxbld/sPHENIX/new+insure && rm -rf /home/phnxbld/sPHENIX/insutils && mkdir /home/phnxbld/sPHENIX/insutils && cd /home/phnxbld/sPHENIX/insutils &&  git clone https://github.com/sPHENIX-Collaboration/utilities ./  >& $HOME/sphenixinsurebld.log && cd utils/rebuild &&  ./build.pl --phenixinstall --tinderbox --insure --notify
#
# play build
#
# 35 17 * * * source /opt/sphenix/core/bin/sphenix_setup.csh play && set path = ($HOME/sPHENIX/ccache/bin $path) && setenv CCACHE_DIR /home/phnxbld/.sphenixccache && cp $HOME/krb5.keytab.phnxbld /tmp && kinit -k -t /tmp/krb5.keytab.phnxbld phnxbld && rm /tmp/krb5.keytab.phnxbld && /usr/bin/aklog &&  rm -rf /home/phnxbld/sPHENIX/play && rm -rf /home/phnxbld/sPHENIX/playbuild && mkdir -p /home/phnxbld/sPHENIX/playbuild && cd /home/phnxbld/sPHENIX/playbuild && git clone https://github.com/sPHENIX-Collaboration/utilities ./  >& $HOME/sphenixbld.log &&  cd utils/rebuild && ./build.pl --phenixinstall   --tinderbox  --notify --version='play'
#
#52 21 * * * setenv ROOTSYS /opt/sphenix/core/root-6.06.02 && source /opt/sphenix/core/bin/sphenix_setup.csh play+insure && cp $HOME/krb5.keytab.phnxbld /tmp && kinit -k -t /tmp/krb5.keytab.phnxbld phnxbld && rm /tmp/krb5.keytab.phnxbld && /usr/bin/aklog &&  rm -rf /home/phnxbld/sPHENIX/play+insure && rm -rf /home/phnxbld/sPHENIX/playinsbuild && mkdir -p /home/phnxbld/sPHENIX/playinsbuild && cd /home/phnxbld/sPHENIX/playinsbuild && git clone https://github.com/sPHENIX-Collaboration/utilities ./  >& $HOME/sphenixbld.log &&  cd utils/rebuild && ./build.pl --phenixinstall  --tinderbox   --version='play'  --insure --root6
#
mkdir work

echo ./build.pl --source=$WORKSPACE --workdir=`pwd`./work
./build.pl --source=$WORKSPACE --workdir=`pwd`./work
