#!/bin/bash
#########################################################################
#
# make-icon-osx.sh
# Copyright (C) 2015 Frank Erens <frank@synthi.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#########################################################################

log() {
    echo "$*" >&2
}

die() {
    log "$*"
    exit 1
}

which -s convert || die "This script requires imagemagick to run"

if [[ ! -f "$1" || ! "$1" == *.png ]]; then
    die "Usage: $0 <icon.png>"
fi

base=$(basename "$1" .png)
icon="$1"

log "Creating ico file..."
convert "$1" -resize '256x256' ${base}.ico

log "Done!"
