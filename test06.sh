#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

({
cd "$temp" || exit 0
girt-init
seq 1 7 >7.txt
girt-add 7.txt
girt-commit -m commit-1
girt-branch b1
girt-checkout b1
perl -pi -e '4' 7.txt
cat 7.txt
girt-commit -a -m commit-2
girt-checkout master
cat 7.txt
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
Switched to branch 'b1'
1
2
3
4
5
6
7
nothing to commit
Switched to branch 'master'
1
2
3
4
5
6
7
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi

# cat "$temp_output"
