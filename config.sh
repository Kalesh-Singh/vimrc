#!/bin/bash

# Symlink the configuration to vim's default search file
VIM_CONF=$HOME/.vimrc
echo $VIM_CONF
if [ -L  "$VIM_CONF" ] || [ -f "$VIM_CONF" ]; then
    echo "Found file exists"
    rm $VIM_CONF
fi
ln -s $(pwd)/.vimrc $VIM_CONF

