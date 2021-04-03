#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

({
cd "$temp" || exit 0
2041 girt-init
touch a b
2041 girt-add a
echo 12 > a
2041 girt-commit -m 'commit-0'
2041 girt-branch b1
2041 girt-checkout b1
2041 girt-add b
2041 girt-commit -m 'commit-1'
2041 girt-status
2041 girt-checkout master
2041 girt-status
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
Initialized empty girt repository in .girt
Committed as commit 0
Switched to branch 'b1'
Committed as commit 1
a - file changed, changes not staged for commit
b - same as repo
Switched to branch 'master'
a - file changed, changes not staged for commit
EOM

if diff "$temp_output" "$correct_output" ; then
    echo "PASS" 
else
    echo "FAIL" 1>&2
    exit 1
fi

# cat "$temp_output"
