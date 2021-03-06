# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/opt/review/bin" ] ; then
    PATH="/opt/review/bin:$PATH"
fi

if [ -d "/opt/jena/latest/bin" ] ; then
    PATH="/opt/jena/latest/bin":$PATH
fi

export JAVA_LIBS="$HOME/.java:$JAVA_LIBS";
export TEXMFHOME="$HOME/.texmf:$TEXMFHOME";
export BIBINPUTS="$HOME/.bib:$BIBINPUTS";
export BSTINPUTS="$HOME/.bst:$BSTINPUTS";
export JENAROOT="/opt/jena/latest/";

export JAVA_HOME=$HOME/opt/jdk
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$HOME/usr/bin:$PATH"

export GOROOT="$HOME/opt/go"
export PATH="$GOROOT/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
