#!/usr/bin/env bash

CFLAGS="-I${PREFIX} -L${PREFIX} ${CFLAGS}" \
  ${PYTHON} setup.py install
