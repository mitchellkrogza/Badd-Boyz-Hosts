#!/bin/bash

export CFLAGS=$(echo ${CFLAGS} | sed 's|-O2|-O3|g')
export CPPFLAGS=$(echo ${CPPFLAGS} | sed 's|-O2|-O3|g')

MACH=$(${CC} -dumpmachine)
if [[ ${MACH} =~ x86_64.* ]] || [[ ${MACH} =~ i?86.* ]]; then
  export CFLAGS="${CFLAGS} -DUNALIGNED_OK"
fi

./configure --prefix=${PREFIX}  \
            --shared

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# Remove man files.
rm -rf $PREFIX/share

# Copy license file to the source directory so conda-build can find it.
cp $RECIPE_DIR/license.txt $SRC_DIR/license.txt
