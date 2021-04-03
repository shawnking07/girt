#!/bin/bash

temp=$(mktemp -d)
temp_output=$(mktemp)
correct_output=$(mktemp)

({
cd "$temp" || exit 0
touch a b c d e f g h
girt-add a b c d e f
girt-commit -m 'first commit'
girt-rm e
girt-add g
girt-status
} > "$temp_output" 2>&1
)


cat > "$correct_output" << EOM
girt-add: error: girt repository directory .girt not found
girt-commit: error: girt repository directory .girt not found
girt-rm: error: girt repository directory .girt not found
girt-add: error: girt repository directory .girt not found
girt-status: error: girt repository directory .girt not found
EOM

# if diff "$temp_output" "$correct_output" ; then
#     echo "PASS" 
# else
#     echo "FAIL" 1>&2
#     exit 1
# fi

cat "$temp_output"
