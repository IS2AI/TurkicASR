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
eval_suffix=
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
    rm -r data
fi

train_dir=data/train_${eval_suffix}
dev_dir=data/dev_${eval_suffix}
test_dir=data/test_${eval_suffix}

mkdir -p data
mkdir -p $train_dir
mkdir -p $dev_dir
mkdir -p $test_dir

# Transcriptions preparation
for lang in "az" "ba" "cv" "kk" "ky" "sah" "tr" "tt" "ug" "uz" "ksc" "tsc" "usc"; do
    lang_path=${!lang}
    string="$(basename -- $lang_path)"
    suffix=".tar.gz"
    if [ -f $lang_path ] || [ -d datasets/${string/%$suffix} ]; then
        ### for ksc, tsc, and usc
        if [ ! -d datasets/${string/%$suffix} ] && [ ! -d datasets/$lang ]; then
            if [ $lang == 'ksc' ] || [ $lang == 'usc' ] || [ $lang == 'tsc' ]; then
                log unpacking $lang_path
                tar -xf $lang_path -C datasets/
                lang_path=$string
            else
                log unpacking $lang_path
                tar -xf $lang_path -C datasets/ --strip-components=1
            fi
        fi
        log Processing 
        mkdir -p data/train_lid_"${lang}"
        mkdir -p data/dev_lid_"${lang}"
        mkdir -p data/test_lid_"${lang}"
        local/prep_data.py -l $lang -p ${string/%$suffix}
    else
    
       log $lang_path does not exist
    fi
done

log "Combining all languages"
local/combine_all.py --suffix $eval_suffix

log "Successfully finished. [elapsed=${SECONDS}s]"
