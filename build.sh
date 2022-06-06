#!/bin/sh
# SPDX-License-Identifier: MIT

set -e

cd "$(dirname "$0")"

PYTHON_VER=3.9.6
PYTHON_PKG=python-$PYTHON_VER-macos11.pkg
PYTHON_URI="https://www.python.org/ftp/python/$PYTHON_VER/$PYTHON_PKG"

ARTWORK="$PWD/artwork"
SRC="$PWD/src"
DL="$PWD/dl"
PACKAGE="$PWD/package"
RELEASES="$PWD/releases"
RELEASES_DEV="$PWD/releases-dev"

rm -rf "$PACKAGE"

mkdir -p "$DL" "$PACKAGE" "$RELEASES" "$RELEASES_DEV"
mkdir -p "$PACKAGE/bin"

echo "Determining version..."

VER=$(git describe --always --dirty --tags)

echo "Version: $VER"

if [ -z "$VER" ]; then
    if [ -e version.tag ]; then
        VER="$(cat version.tag)"
    else
        echo "Could not determine version!"
        exit 1
    fi
fi

echo "Downloading installer components..."

cd "$DL"

wget -Nc "$PYTHON_URI"

echo "Copying files..."

cp -r "$SRC"/* "$PACKAGE/"
cp "$ARTWORK/logos/icns/AsahiLinux_logomark.icns" "$PACKAGE/logo.icns"
mkdir -p "$PACKAGE/boot"

echo "Extracting Python framework..."

mkdir -p "$PACKAGE/Frameworks/Python.framework"

7z x -so "$DL/$PYTHON_PKG" Python_Framework.pkg/Payload | zcat | cpio -i "$PACKAGE/Frameworks/Python.framework"

echo "Copying certificates..."

certs="$(python3 -c 'import certifi; print(certifi.where())')"

mkdir -p "$PACKAGE/Frameworks/Python.framework/Versions/Current/etc/openssl"

cp "$certs" "$PACKAGE/Frameworks/Python.framework/Versions/Current/etc/openssl/cert.pem"

echo "Packaging installer..."

cd "$PACKAGE"

echo "$VER" > version.tag

if [ "$1" == "prod" ]; then
    PKGFILE="$RELEASES/installer-$VER.tar.gz"
    LATEST="$RELEASES/latest"
elif [ "$1" == "dev" ]; then
    PKGFILE="$RELEASES_DEV/installer-$VER.tar.gz"
    LATEST="$RELEASES_DEV/latest"
else
    PKGFILE="../installer.tar.gz"
    LATEST="../latest"
fi

tar czf "$PKGFILE" .
echo "$VER" > "$LATEST"

echo
echo "Built package: $(basename "$PKGFILE")"
