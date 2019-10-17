#!/bin/bash

# Prevent running ldconfig when cross-compiling
if [[ "${BUILD}" != "${HOST}" ]]; then
  echo "#!/usr/bin/env bash" > ldconfig
  chmod +x ldconfig
  export PATH=${PWD}:$PATH
fi


export CPPFLAGS="${CPPFLAGS} -DSQLITE_ENABLE_COLUMN_METADATA=1 \
                             -DSQLITE_ENABLE_UNLOCK_NOTIFY \
                             -DSQLITE_ENABLE_DBSTAT_VTAB=1 \
                             -DSQLITE_ENABLE_FTS3_TOKENIZER=1 \
                             -DSQLITE_SECURE_DELETE \
                             -DSQLITE_MAX_VARIABLE_NUMBER=250000 \
                             -DSQLITE_MAX_EXPR_DEPTH=10000"

./configure --prefix=${PREFIX}   \
            --build=${BUILD}     \
            --host=${HOST}       \
            --enable-threadsafe  \
            --enable-shared=yes  \
            --enable-readline    \
            --enable-editline    \
            --disable-readline   \
            CFLAGS="${CFLAGS} -I${PREFIX}/include" \
            LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

rm -rf  ${PREFIX}/share
