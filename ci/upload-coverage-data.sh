#!/usr/bin/env bash

set -e

pushd `pwd`
mkdir -p target/kcov
cd target/kcov
wget -c https://github.com/SimonKagstrom/kcov/archive/master.tar.gz
tar xzf master.tar.gz
cd kcov-master
mkdir -p build
cd build
cmake ..
make
make install DESTDIR=../../kcov-build
popd
for file in `find -wholename "./target/debug/genpass-*[^\.d]"`; do
    echo "processing $file"
    mkdir -p "target/coverage-data/$(basename $file)"
    ./target/kcov/kcov-build/usr/local/bin/kcov --exclude-pattern=/.cargo,/usr/lib --verify "target/coverage-data/$(basename $file)" "$file"
done
bash <(curl -s https://codecov.io/bash)
echo "Uploaded code coverage"
