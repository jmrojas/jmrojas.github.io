# Custom variables and other config
. ~/Systems/jmrojas.github.io/scripts/bash/bashrc-common
# End of custom config

export TEXINPUTS=$TEXINPUTS:/Volumes/leicester/texmf/tex/latex/local/

function mount_leicester() {

    echo "Creating leicester directories"
    sudo mkdir -p /Volumes/leicester/resources/CO3095
    sudo mkdir -p /Volumes/leicester/CO-Modules18-19
    sudo mkdir -p /Volumes/leicester/texmf
    sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/var/cscampus/teaching/resources/CO3095 /Volumes/leicester/resources/CO3095
    sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/MCS-Local/Data/ModuleForms/CO-Modules18-19/ /Volumes/leicester/CO-Modules18-19
    sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/MCS-Local/TeX/teTeX-local/texmf/ /Volumes/leicester/texmf
}
