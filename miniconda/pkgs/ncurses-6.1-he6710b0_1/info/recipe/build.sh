#!/bin/bash

set -x

# ncurses (gen-pkgconfig.in) adds -ltinfo to ncurses.pc if any of the following conditions is true:
# 1. No `*-Wl,-rpath,*` is found in EXTRA_LDFLAGS
# 2. Any `*--as-needed*` is found in EXTRA_LDFLAGS
# The build system takes care that any `-Wl,-rpath,` in LDFLAGS gets copied into EXTRA_LDFLAGS
# (and also that any -L${PREFIX}/lib gets translated to -Wl,-rpath,${PREFIX}/lib)
# the same is not true of -Wl,--as-needed (which is referenced only in gen-pkgconfig.in).
# One option to fix this is to pass our LDFLAGS as EXTRA_LDFLAGS however this ends up copying across
# all of our linker flags into the .pc file which means they are forced upon all pkg-config based
# consumers of ncurses and that is a very bad thing indeed. If we wanted to do that we would:
# export EXTRA_LDFLAGS=${LDFLAGS}
# export LDFLAGS=
# .. but instead it is better to strip off all '-Wl,-rpath,*' and '-L${PREFIX}' from LDFLAGS.
re='^(.*)(-Wl,-rpath,[^ ]*)(.*)$'
if [[ ${LDFLAGS} =~ $re ]]; then
  export LDFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
fi
re='^(.*)(-L[^ ]*)(.*)$'
if [[ ${LDFLAGS} =~ $re ]]; then
  export LDFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
fi

./configure \
  --prefix="${PREFIX}" \
  --build=${BUILD} \
  --host=${HOST} \
  --without-debug \
  --without-ada \
  --without-manpages \
  --with-shared \
  --disable-overwrite \
  --enable-symlinks \
  --enable-termcap \
  --with-pkg-config-libdir="${PREFIX}"/lib/pkgconfig \
  --enable-pc-files \
  --with-termlib \
  --enable-widec
make -j${CPU_COUNT} ${VERBOSE_AT}
make install

if [[ ${HOST} =~ .*linux.* ]]; then
  _SOEXT=.so
else
  _SOEXT=.dylib
fi

# Make symlinks from the wide to the non-wide libraries.
pushd "${PREFIX}"/lib
  for _LIB in ncurses ncurses++ form panel menu tinfo; do
    for WIDE_LIBFILE in $(ls lib${_LIB}w${_SOEXT}*); do
      NONWIDE_LIBFILE=${WIDE_LIBFILE/${_LIB}w/${_LIB}}
      ln -s ${WIDE_LIBFILE} ${NONWIDE_LIBFILE}
    done
    if [[ -f lib${_LIB}w.a ]]; then
      ln -s lib${_LIB}w.a lib${_LIB}.a
    fi
    pushd pkgconfig
      if [[ -f ${_LIB}w.pc ]]; then
        ln -s ${_LIB}w.pc ${_LIB}.pc
      fi
    popd
  done
  pushd pkgconfig
    for _PC in form formw menu menuw panel panelw ncurses ncursesw ncurses++ ncurses++w tinfo tinfow; do
      sed -i.bak 's:include/ncursesw$:include/ncurses:g' ${_PC}.pc
      [[ -f ${_PC}.pc.bak ]] && rm ${_PC}.pc.bak
    done
  popd
popd

# Provide headers in `$PREFIX/include` and
# symlink them in `$PREFIX/include/ncurses`
# and in `$PREFIX/include/ncursesw`.
HEADERS_DIR_W="${PREFIX}/include/ncursesw"
HEADERS_DIR="${PREFIX}/include/ncurses"
mkdir -p "${HEADERS_DIR}"
for HEADER in $(ls $HEADERS_DIR_W); do
  mv "${HEADERS_DIR_W}/${HEADER}" "${PREFIX}/include/${HEADER}"
  ln -s "${PREFIX}/include/${HEADER}" "${HEADERS_DIR_W}/${HEADER}"
  ln -s "${PREFIX}/include/${HEADER}" "${HEADERS_DIR}/${HEADER}"
done

# Ensure that the code at the top that strips -L and -Wl,-rpath from LDFLAGS did its job
# and we have ended up with a working ncursesw.pc file (i.e. one that contains -ltinfow)
if ! cat "${PREFIX}"/lib/pkgconfig/ncursesw.pc | grep "Libs:" | grep "\-ltinfow"; then
  echo "ERROR: ncurses gen-pkgconfig script has created a broken ncursesw.pc"
  echo "       It does not contain '-ltinfow' in the 'Libs:' line"
  exit 1
fi
