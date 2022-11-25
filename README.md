# TurkicASR

This repository provides the recipe for the paper [Multilingual ASR for Turkic Languages](link-to-be-after-acceptance).

## Pre-trained models

You can download the best performing model [here](https://github.com/IS2AI/TurkicASR/blob/main/asr_train_asr_conformer_large_raw_cv_turkic_char_sp_valid.acc.ave.zip).

### Inference

To convert your audio file to text, please make sure it follows a wav format with sample rate of 16k. Unzip the pre-trained model in the current directory, and install the necessary packages by running ```pip install -r requirements.txt```. To perform the evaluation please run:
```
python recognize.py -f <path_to_your_wav>
```

## Datasets

There are multiple datasets involved, including [KSC](https://docs.google.com/forms/d/e/1FAIpQLSf_usCjxTvbH_2xhA6slH9FAfjrYVd4OHnr-CUcVVW3TEAscg/viewform), [TSC](https://forms.gle/xjsnC3uVmzRYuWBA8), [USC](https://docs.google.com/forms/d/e/1FAIpQLSeWhxsVe0WlGSQ459sq6--pAqYyEWTI2K6X8UrF357GUvnDQA/viewform), and [Common Voice](https://commonvoice.mozilla.org/en/datasets) for the following languages: Azerbaijani, Bashkir, Chuvash, Kazakh, Kyrgyz, Sakha, Turkish, Tatar, Uzbek, and Uyghur. To train the ASR model, please download all of them and specify the paths in `conf/lang.conf`.


## Training

Our code builds upon [ESPnet](https://github.com/espnet/espnet), and requires prior installation of the framework for DNN training. Please follow the [installation guide](https://espnet.github.io/espnet/installation.html) and put the TurkicASR folder inside `espnet/egs2/` directory. Run the traning scripts with `./run.sh`

## Citation
```
@inproceedings{inproceedings,
  author={Saida Mussakhojayeva, Kaisar Dauletbek, Rustem Yeshpanov, and Huseyin Atakan Varol},
  title={{Multilingual ASR for Turkic Languages}},
  year=2022,
}
```
