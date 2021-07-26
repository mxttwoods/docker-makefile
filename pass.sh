#!/bin/bash

echo Enter a new password:
read varname
echo "Your new password is: $varname"
sed -i -e "s/placeholder/$varname/g" makefile