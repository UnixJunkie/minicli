#!/bin/bash

TEST=_build/default/test.exe

$TEST

$TEST -i

$TEST -i input.txt

$TEST -i input.txt -o output.txt

$TEST -i input.txt -o output.txt -n /dev/null

$TEST -i input.txt -o output.txt -n 123

$TEST -i input.txt -o output.txt -n 123 -x /dev/null

$TEST -i input.txt -o output.txt -n 123 -x 0.123

$TEST -i input.txt -o output.txt -n 123 -x 0.123 -v

$TEST -i input.txt -o output.txt -n 123 -x 0.123 -v -i input.bin

$TEST --toto titi -i input.txt -o output.txt -n 123 -x 0.123 -v -y 42
