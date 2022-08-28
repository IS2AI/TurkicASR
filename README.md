# TurkicASR

This repository provides the recipe for the paper [Multilingual ASR for Turkic Languages](link-to-be-after-acceptance).

## Pre-trained models

You can download the best performing model [here](link-to-be).

### Inference

To convert your audio file to text, please make sure it follows a wav format with sample rate of 16k. Unzip the pre-trained model in the current directory, and install the necessary packages by running ```pip install -r requirements.txt```. To perform the evaluation please run:
```
python recognize.py -f <path_to_your_wav>
```

## Datasets

There are multiple datasets involved, including [KSC1](https://docs.google.com/forms/d/e/1FAIpQLSf_usCjxTvbH_2xhA6slH9FAfjrYVd4OHnr-CUcVVW3TEAscg/viewform), [TSC](path!!!), [USC](https://docs.google.com/forms/d/e/1FAIpQLSeWhxsVe0WlGSQ459sq6--pAqYyEWTI2K6X8UrF357GUvnDQA/viewform), and [Commonvoice](https://commonvoice.mozilla.org/en/datasets) for the following languages: Azerbaijani, Bashkir, Chuvash, Kazakh, Kyrgyz, Sakha, Turkish, Tatar, Uzbek, and Uyghur. To train the ASR model, please download all of them and specify the paths in `conf/lang.conf`.


## Training

Our code builds upon [ESPnet](https://github.com/espnet/espnet), and requires prior installation of the framework for DNN training. Please follow the [installation guide](https://espnet.github.io/espnet/installation.html) and put the TurkicASR folder inside `espnet/egs2/` directory. Run the traning scripts with `./run.sh`

## Citation
```
@inproceedings{arxiv,
  author={Kaisar Dauletbek, Saida Mussakhojayeva, Rustem Yeshpanov, and Huseyin Atakan Varol},
  title={{Multilingual ASR for Turkic Languages}},
  year=2022,
  booktitle={arxiv},
}
```