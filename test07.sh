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
girt-add g
girt-status
girt-branch b1
girt-checkout bb1
girt-checkout b1
girt-status
echo hi > h
girt-commit -a -m 'second commit'
girt-log
girt-checkout master
girt-log
girt-status
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
a - file changed, different changes staged for commit
b - file changed, changes staged for commit
c - file changed, changes not staged for commit
d - file deleted
e - deleted
f - same as repo
g - added to index
h - untracked
$PWD/girt-checkout: error: unknown branch 'bb1'
Switched to branch 'b1'
a - file changed, different changes staged for commit
b - file changed, changes staged for commit
c - file changed, changes not staged for commit
d - file deleted
e - deleted
f - same as repo
g - added to index
h - untracked
Committed as commit 1
1 second commit
0 first commit
Switched to branch 'master'
0 first commit
a - same as repo
b - same as repo
c - same as repo
d - same as repo
e - same as repo
f - same as repo
h - untracked
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi

# cat "$temp_output"
