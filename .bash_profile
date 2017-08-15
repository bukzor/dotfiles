# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
# environment variables go here!
export PYTHONSTARTUP=~/.pythonrc.py

# include .bashrc if it exists
if [ -f ~/.profile ]; then
    . ~/.profile
fi

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
