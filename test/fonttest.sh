#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "zcat fonttest_inc_01.gz && sleep 2\r"
SNAP ${SNAP_NAME} ${SNAP_HASH}
