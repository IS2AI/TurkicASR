#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set=train
valid_set=dev
test_sets=dev

asr_config=conf/train_asr.yaml
inference_config=conf/decode_asr.yaml
lm_config=conf/train_lm.yaml
use_lm=true
use_wordlm=false


### COPY ESPNET SCRIPTS ###
if [ ! -f asr.sh ]
then
    ln -s ../../TEMPLATE/asr1/asr.sh .
fi
if [ ! -f path.sh ]
then
    ln -s ../../TEMPLATE/asr1/path.sh .
fi
if [ ! -d pyscripts ]
then
    ln -s ../../TEMPLATE/asr1/pyscripts .
fi
if [ ! -d scripts ]
then
    ln -s ../../TEMPLATE/asr1/scripts .
fi
if [ ! -d steps ]
then
    ln -s ../../../tools/kaldi/egs/wsj/s5/steps .
fi
if [ ! -d utils ]
then
    ln -s ../../../tools/kaldi/egs/wsj/s5/utils .
fi

if [ ! -d datasets ]
then
    mkdir datasets
fi
# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh                                               \
    --lang all                                         \
    --audio_format wav                                 \
    --feats_type raw                                   \
    --token_type char                                  \
    --use_lm ${use_lm}                                 \
    --lm_config "${lm_config}"                         \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --speed_perturb_factors "${speed_perturb_factors}" \
    --asr_speech_fold_length 512 \
    --asr_text_fold_length 150 \
    --lm_fold_length 150 \
    --lm_train_text "data/${train_set}/text" "$@"
