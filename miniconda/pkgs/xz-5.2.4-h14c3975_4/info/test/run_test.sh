

set -ex



xz --help
unxz --help
echo greetings > hello.txt
xz -z hello.txt
xz -d hello.txt.xz
cat hello.txt | grep greetings
lzma --help
exit 0
