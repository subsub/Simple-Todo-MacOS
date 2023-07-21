#!/bin/bash

shasum -a 256 $1 > ${1}.checksum
nvim ${1}.checksum
