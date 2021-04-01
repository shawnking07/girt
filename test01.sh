#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

(
cd "$temp" || exit 0
. girt-init
echo aaa > a.txt
echo bbb > b.txt
echo ccc > c.txt
. girt-add a.txt b.txt
. girt-commit -m 'commit-0'
echo bbbbb > b.txt
. girt-log
) > "$temp_output"

cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
0 commit-0
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi
