#!/usr/bin/env bash

out=$(bash run1.sh)

# we should check out == hello
if [ "${out}" == "hello" ];then
  echo "GOOD: test pass"
else
  echo "BAD: test fail"
  echo "expected hello, got ${out}"
  exit 1
fi