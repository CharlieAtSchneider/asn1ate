#!/bin/env sh

# For every *.asn file, run it through test.py and pipe
# the result back to Python.
# This checks two things:
# 1) All steps of parsing and codegen run without exceptions
# 2) The end result is valid Python
# Note that it does not say anything about correctness or
# completeness of the generated code.

set -e

PYTHONPATH="$(pwd)"
export PYTHONPATH
if command -v uv >/dev/null 2>&1
then
    # Automatically uses .venv and install dependencies
    RUNPY='uv run'
else
    RUNPY='python'
fi

for f in testdata/*.asn;
do
    echo "Checking $f";
    rm -rf _testdir/
    mkdir _testdir/
    $RUNPY src/asn1ate/test.py --outdir=_testdir --gen "$f"
    # Run python over _testdir/*.py
    for m in _testdir/*.py;
    do
        $RUNPY "$m"
    done
done
