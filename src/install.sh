#!/bin/sh
# SPDX-License-Identifier: MIT

set -e

cd "$(dirname "$0")"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export DYLD_LIBRARY_PATH=$PWD/Frameworks/Python.framework/Versions/Current/lib
export DYLD_FRAMEWORK_PATH=$PWD/Frameworks
python=Frameworks/Python.framework/Versions/3.9/bin/python3.9
export SSL_CERT_FILE=$PWD/Frameworks/Python.framework/Versions/Current/etc/openssl/cert.pem
# Bootstrap does part of this, but install.sh can be run standalone
# so do it again for good measure.
export PATH="$PWD/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

if ! arch -arch64 ls >/dev/null 2>/dev/null; then
    echo
    echo "Looks like this is an Intel Mac!"
    echo "Sorry, Asahi Linux only supports Apple Silicon machines."
    echo "May we interest you in https://t2linux.org/ instead?"
fi

exec </dev/tty >/dev/tty 2>/dev/tty
exec $python main.py "$@"
