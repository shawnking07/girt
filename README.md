# COMP(2041|9044) Assignment 1: girt

## Introduction

Your task in this assignment is to implement Girt, a subset of the version control system Git.

Git is a very complex program which has many individual commands. You will implement only a few of the most important commands. You will also be given a number of simplifying assumptions, which make your task easier.

Girt is a contraction of g-git eestricted subset You must implement Girt in Shell.

Interestingly, early versions of Git made heavy use of Shell and Perl.

## Girt Commands

### Subset 0
Subset 0 commands must be implemented in POSIX-compatible Shell. See the Permitted Languages section for more information.

#### girt-init
The girt-init command creates an empty Girt repository.

girt-init should create a directory named .girt, which it will use to store the repository. It should produce an error message if this directory already exists.

You should match this, and other error messages exactly. For example:

```sh
ls -d .girt
ls: cannot access .girt: No such file or directory
girt-init
Initialized empty girt repository in .girt
ls -d .girt
.girt
girt-init
girt-init: error: .girt already exists
girt-init may create initial files or directories inside .girt.
```

You do not have to use a particular representation to store the repository.

You do not have to create the same files or directories inside .girt as the reference implementation. You can create whatever files or directories inside .girt you wish.

Do not store information outside .girt

#### girt-add *filenames*...
The girt-add command adds the contents of one or more files to the index.

Files are added to the repository in a two step process. The first step is adding them to the index.

You will need to store files in the index somehow in the .girt sub-directory. For example, you might choose store them in a sub-directory of .girt.

Only ordinary files in the current directory can be added. You can assume filenames start with an alphanumeric character ([a-zA-Z0-9]) and will only contain alpha-numeric characters, plus '.', '-' and '_' characters.

The girt-add command, and other Girt commands, will not be given pathnames with slashes.

#### girt-commit -m message
The girt-commit command saves a copy of all files in the index to the repository.

A message describing the commit must be included as part of the commit command.

Girt commits are numbered sequentially: they are not hashes, like Git. You must match the numbering scheme.

You can assume the commit message is ASCII, does not contain new-line characters, and does not start with a '-' character.

#### girt-log
The girt-log command prints a line for every commit made to the repository: each line should contain the commit number, and the commit message.

girt-show [commit]:filename
The girt-show should print the contents of the specified filename as of the specified commit. If commit is omitted, the contents of the file in the index should be printed.

You can assume the commit if specified will be a non-negative integer.

For example:

```sh
./girt-init
Initialized empty girt repository in .girt
echo line 1 > a
echo hello world >b
./girt-add a b
./girt-commit -m 'first commit'
Committed as commit 0
echo  line 2 >>a
./girt-add a
./girt-commit -m 'second commit'
Committed as commit 1
./girt-log
1 second commit
0 first commit
echo line 3 >>a
./girt-add a
echo line 4 >>a
./girt-show 0:a
line 1
./girt-show 1:a
line 1
line 2
./girt-show :a
line 1
line 2
line 3
cat a
line 1
line 2
line 3
line 4
./girt-show 0:b
hello world
./girt-show 1:b
hello world
```

### Subset 1
Subset 1 is more difficult. You will need spend some time understanding the semantics (meaning) of these operations, by running the reference implementation, or researching the equivalent Git operations.

Note the assessment scheme recognises this difficulty.

Subset 1 commands must be implemented in POSIX-compatible Shell. See the Permitted Languages section for more information.

#### girt-commit [-a] -m message
girt-commit can have a -a option, which causes all files already in the index to have their contents from the current directory added to the index before the commit.

#### girt-rm [--force] [--cached] filenames...
girt-rm removes a file from the index, or from the current directory and the index.

If the --cached option is specified, the file is removed only from the index, and not from the current directory.

girt-rm, like git rm, should stop the user accidentally losing work, and should give an error message instead if the removal would cause the user to lose work. You will need to experiment with the reference implementation to discover these error messages. Researching git rm's behaviour may also help.

The --force option overrides this, and will carry out the removal even if the user will lose work.

#### girt-status
girt-status shows the status of files in the current directory, the index, and the repository. ./NAME-execute(""" ././NAME-init touch a b c d e f g h ././NAME-add a b c d e f ././NAME-commit -m 'first commit' echo hello >a echo hello >b echo hello >c ././NAME-add a b echo world >a rm d ././NAME-rm e ././NAME-add g ././NAME-status """.replace('NAME', name), use_tmp_directory=True)

### Subset 2
Subset 2 is extremely difficult. You will need spend considerable time understanding the semantics of these operations, by running the reference implementation, and/or researching the equivalent Git operations.

Note the assessment scheme recognises this difficulty.

Subset 2 commands must be implemented in POSIX-compatible Shell. See the Permitted Languages section for more information.

#### girt-branch [-d] [branch-name]
girt-branch either creates a branch, deletes a branch, or lists current branch names.

#### girt-checkout branch-name
girt-checkout switches branches.

Note that, unlike Git, you can not specify a commit or a file: you can only specify a branch.

#### girt-merge branch-name|commit -m message
girt-merge adds the changes that have been made to the specified branch or commit to the index, and commits them.

```sh
./girt-init
Initialized empty girt repository in .girt
seq 1 7 >7.txt
./girt-add 7.txt
./girt-commit -m commit-1
Committed as commit 0
./girt-branch b1
./girt-checkout b1
Switched to branch 'b1'
perl -pi -e 's/2/42/' 7.txt
cat 7.txt
1
42
3
4
5
6
7
./girt-commit -a -m commit-2
Committed as commit 1
./girt-checkout master
Switched to branch 'master'
cat 7.txt
1
2
3
4
5
6
7
./girt-merge b1 -m merge-message
Fast-forward: no commit created
cat 7.txt
1
42
3
4
5
6
7
If a file has been changed in both branches girt-merge produces an error message.
```

Note: if a file has been changed in both branches git examines which lines have been changed and combines the changes if possible. Girt doe not do this, for example:

```sh
./girt-init
Initialized empty girt repository in .girt
seq 1 7 >7.txt
./girt-add 7.txt
./girt-commit -m commit-1
Committed as commit 0
./girt-branch b1
./girt-checkout b1
Switched to branch 'b1'
perl -pi -e 's/2/42/' 7.txt
cat 7.txt
1
42
3
4
5
6
7
./girt-commit -a -m commit-2
Committed as commit 1
./girt-checkout master
Switched to branch 'master'
cat 7.txt
1
2
3
4
5
6
7
perl -pi -e 's/5/24/' 7.txt
cat 7.txt
1
2
3
4
24
6
7
./girt-commit -a -m commit-3
Committed as commit 2
./girt-merge b1 -m merge-message
girt-merge: error: can not merge
cat 7.txt
1
2
3
4
24
6
7
```
