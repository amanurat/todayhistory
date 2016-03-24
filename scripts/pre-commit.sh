#!/usr/bin/env bash
# this hook is in SCM so that it can be shared
# to install it, create a symbolic link in the projects .git/hooks folder
#
#       i.e. - from the .git/hooks directory, run
#               $ ln -s ../../git-hooks/pre-commit.sh pre-commit
#
# to skip the tests, run with the --no-verify argument
#       i.e. - $ 'git commit --no-verify'

# stash any unstaged changes
git stash -q --keep-index

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"`)
ABSOLUTE_PARENT_PATH="$(dirname "$ABSOLUTE_PATH")"

# run the tests with the gradle wrapper
sh $ABSOLUTE_PARENT_PATH/gradlew testMockedDebugUnitTest --daemon -PmaxParallelForks=10

# store the last exit code in a variable
RESULT=$?

# unstash the unstashed changes
git stash pop -q

# return the './gradlew test' exit code
exit $RESULT