#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail
lang=turkic 
train_set=train_${lang} 
valid_set=dev_${lang}
test_sets="test_az_lid test_ba_lid test_cv_lid test_kk_lid test_ky_lid test_sah_lid test_tr_lid test_tt_lid test_ug_lid test_uz_lid"

asr_config=conf/train_asr.yaml
inference_config=conf/decode_asr.yaml
lm_config=conf/train_lm.yaml
use_lm=true
use_wordlm=false
nlsyms_txt=conf/nonlyng.txt

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

if [ ! -d datasets ]
then
    mkdir datasets
fi
# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh                                               \
    --lang "${lang}"                                   \
    --nlsyms_txt "${nlsyms_txt}"                       \
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
    --local_data_opts "--eval_suffix ${lang}" \
    --lm_train_text "data/${train_set}/text" "$@"
