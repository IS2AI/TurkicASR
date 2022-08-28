#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}

az=
ba=
cv=
kk=
ky=
sah=
tr=
tt=
ug=
uz=
ksc=
tsc=
usc=

. ./conf/lang.conf

log "$0 $*"

. ./utils/parse_options.sh

. ./path.sh
. ./cmd.sh


if [ $# -gt 1 ]; then
  log "${help_message}"
  exit 2
fi

log "Data Preparation"

if [ -d data ]; then
    rm -r data/*
fi
train_dir=data/train
dev_dir=data/dev
test_dir=data/test

mkdir -p $train_dir
mkdir -p $dev_dir
mkdir -p $test_dir


# Transcriptions preparation
for lang in "az" "ba" "cv" "kk" "ky" "sah" "tt" "tr" "uz" "ug" "ksc" "tsc" "usc"; do
    lang_path=${!lang}
    if [ -f $lang_path ]; then
        string="$(basename -- $lang_path)"
        suffix=".tar.gz"
        ### for ksc, tsc, and usc
        if [ $lang == 'ksc' ] || [ $lang == 'usc' ] || [ $lang == 'tsc' ]; then
            if [ ! -d datasets/${string/%$suffix} ] ; then
                log unpacking $lang_path
                tar -xf $lang_path -C datasets/
            fi
            lang_path=$string
        else
            if [ ! -d datasets/$lang ]
            then
                log unpacking $lang_path
                tar -xf $lang_path -C datasets/ --strip-components=1
            fi 
        fi
        log Processing $lang_path 
        mkdir -p "${train_dir}_${lang}"
        mkdir -p "${dev_dir}_${lang}"
        mkdir -p "${test_dir}_${lang}"
        local/prep_data.py -l $lang -p $lang_path
    else
       log $lang_path does not exist
    fi
done

log "Combining all languages"
local/combine_all.py

log "Successfully finished. [elapsed=${SECONDS}s]"
