#!/bin/bash

set -x

diff ref.txt <(./test.sh 2>&1)
