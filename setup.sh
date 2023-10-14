#!/bin/bash

dir=$(dirname $( readlink -f $0 ))

if [ -d $dir/nvim ]; 
then
    echo nvim alredy exists
else
    ln -s "$dir/nvim" ~/.config/nvim
fi
