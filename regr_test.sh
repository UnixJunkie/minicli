#!/bin/bash

diff ref.txt <(./test.sh 2>&1)
