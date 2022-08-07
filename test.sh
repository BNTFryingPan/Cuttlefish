#!/bin/bash

while getops u:a:f: flag
do
case "${flag}"
in
hl) runHl;
cpp) runCpp;
esac
done

toTestDir() {
   cd test
}

runCpp() {
   cp ./build/Main ./test/Cuttlefish.x86
   toTestDir;
   ./Cuttlefish.x86
}

runHl() {
   cp ./build/hashlink/build.hl ./test/Cuttlefish.hl
   toTestDir;
   hl ./Cuttlefish.hl
}
