#!/bin/bash
read -p "say your name: " name
if ! [[ $name == "guillem" ]]; then 
	echo $name
fi
