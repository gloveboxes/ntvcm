
COMMIT=$(git log -1 HEAD --format=%h 2> /dev/null)
BUILD=$(printf "%04d" "$(git rev-list --count HEAD 2> /dev/null)" )
#echo $COMMIT $BUILD

# macOS: no static crt0.o and clang deprecates -Ofast in favor of -O3
OPT=-Ofast
STATIC=-static
if [[ "$(uname)" == "Darwin" ]]; then
  OPT=-O3
  STATIC=
fi

if [[ -z ${COMMIT} ]]; then
  # with RSS
  #g++ -ggdb -Og -fno-builtin -D NTVCM_RSS_SUPPORT -D DEBUG -I . ntvcm.cxx x80.cxx -lssl -lcrypto -o ntvcm  -static
  # without RSS
  g++ -ggdb $OPT -fno-builtin -D DEBUG -I . ntvcm.cxx x80.cxx -o ntvcm $STATIC
else
  # with RSS
  #g++ -ggdb -Og -fno-builtin -D NTVCM_RSS_SUPPORT -D COMMIT_ID="\" [Commit Id:$COMMIT]\"" -D DEBUG -I . ntvcm.cxx x80.cxx -lssl -lcrypto -o ntvcm  -static
  # without RSS
  g++ -ggdb $OPT -fno-builtin -D BUILD="\".$BUILD\"" -D COMMIT_ID="\" [Commit Id:$COMMIT]\"" -D DEBUG -I . ntvcm.cxx x80.cxx -o ntvcm $STATIC
fi
