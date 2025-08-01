# TurkicASR

This repository provides the recipe for the paper [Multilingual Speech Recognition for Turkic Languages](https://www.mdpi.com/2078-2489/14/2/74).

## Pre-trained models

You can download the best performing models below. 

|model|
|---|
|[turkic_languages_model.zip](https://drive.google.com/file/d/1GtK-OrH3ZRYz2Zc8vf-xndp7R9dic4rV/view?usp=sharing)|
|[all_languages_model.zip](https://drive.google.com/file/d/15Dc4Uwzqqrw3jkE5-zrgVAyNddGS7onw/view?usp=sharing)|

### Inference

To convert your audio file to text, please make sure it follows a wav format with sample rate of 16k. Unzip the pre-trained model in the current directory, and install the necessary packages by running ```pip install -r requirements.txt```. To perform the evaluation please run:
```
python recognize.py -f <path_to_your_wav>
```

## Datasets

There are multiple datasets involved, including [KSC](https://huggingface.co/datasets/issai/Kazakh_Speech_Corpus_2), [TSC](https://huggingface.co/datasets/issai/Turkish_Speech_Corpus), [USC](https://huggingface.co/datasets/issai/Uzbek_Speech_Corpus), and [Common Voice](https://commonvoice.mozilla.org/en/datasets) version 10.0 for the following languages: Azerbaijani, Bashkir, Chuvash, Kazakh, Kyrgyz, Sakha, Turkish, Tatar, Uzbek, and Uyghur. To train the ASR model, please download all of them and specify the paths in `conf/lang.conf`.


## Training

Our code builds upon [ESPnet](https://github.com/espnet/espnet), and requires prior installation of the framework for DNN training. Please follow the [installation guide](https://espnet.github.io/espnet/installation.html) and put the TurkicASR folder inside `espnet/egs2/` directory. Run the traning scripts with `./run.sh`

## Citation
```
@Article{info14020074,
AUTHOR = {Mussakhojayeva, Saida and Dauletbek, Kaisar and Yeshpanov, Rustem and Varol, Huseyin Atakan},
TITLE = {Multilingual Speech Recognition for Turkic Languages},
JOURNAL = {Information},
VOLUME = {14},
YEAR = {2023},
NUMBER = {2},
ARTICLE-NUMBER = {74},
URL = {https://www.mdpi.com/2078-2489/14/2/74},
ISSN = {2078-2489}
}
```
