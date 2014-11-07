#!/bin/bash

### REQUIREMENTS
#sudo apt-get install python-virtualenv

# Make the ssh keys for the anonymous user
if [ ! -f anonymous_user/.ssh/auto_df ]; then
    mkdir -p anonymous_user/.ssh
    ssh-keygen -f anonymous_user/.ssh/auto_df
    printf "command=\"tmux attach || tmux -f `pwd`/tmux.conf new-session `pwd`/df_linux/df\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding " > authorized_keys.txt
    cat anonymous_user/.ssh/auto_df.pub >> authorized_keys.txt
    cat authorized_keys >> ~/.ssh/authorized_keys
fi

# Grab GateOne, if it is not currently here.
if [ ! -d gateone ]; then
    git clone http://github.com/liftoff/gateone
    mkdir gateone/users
    ln -s ../../anonymous_user gateone/users/ANONYMOUS
fi

# Set up the virtual environment
if [ -d venv ]; then
    source venv/bin/activate
else
    virtualenv -p $(which python2.7) venv
    source venv/bin/activate
    pip install tornado futures html5lib
fi

# Grab dwarf fortress
if [ ! -d df_linux ]; then
    wget http://www.bay12games.com/dwarves/df_40_15_linux.tar.bz2
    tar -xjf df_*_linux.tar.bz2
fi

python gateone/run_gateone.py --port=8080