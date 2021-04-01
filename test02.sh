#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

({
cd "$temp" || exit 0
girt-init
echo aaa > a.txt
echo bbb > b.txt
echo ccc > c.txt
girt-add a.txt b.txt
girt-commit -m 'commit-0'
echo bbbbb > b.txt
girt-show 
girt-show :a.txt
girt-show 0:a.txt
girt-show 0:b.txt
girt-show 0:c.txt
girt-show 1:c.txt
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
usage: $(which girt-show) <commit>:<filename>
aaa
aaa
bbb
$(which girt-show): error: 'c.txt' not found in commit 0
$(which girt-show): error: unknown commit '1'
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi

# cat "$temp_output"
