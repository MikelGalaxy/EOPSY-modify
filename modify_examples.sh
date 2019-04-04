#!/bin/bash
# Author: Michal Boniakowski
echo "Test script"

echo ""
echo "Lower"
./modify.sh -l OPKE

echo ""
echo "Help test"
./modify.sh -h

echo ""
echo "Seed test"
./modify.sh -r 's/or/KOR/' order

echo "Recursion test"
./modify.sh -r -l TEST1