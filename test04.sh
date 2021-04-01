#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

({
cd "$temp" || exit 0
girt-init
touch a b c d e f g h
girt-add a b c d e f
girt-commit -m 'first commit'
echo hello >a
echo hello >b
echo hello >c
girt-add a b
echo world >a
rm d
girt-rm e
girt-commit -a -m 'second commit'
girt-status
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
Committed as commit 1
a - same as repo
b - same as repo
c - same as repo
f - same as repo
g - untracked
h - untracked
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi
