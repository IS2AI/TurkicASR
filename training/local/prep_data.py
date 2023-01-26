#!/usr/bin/env python

import sys, argparse, os, glob, csv, pdb
from tqdm import tqdm
from pathlib import Path
import regex, re
import wave
import contextlib

import pandas as pd

seed=4

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--lang', '-l', type=str, required=True)
    parser.add_argument('--path', '-p', type=str, required=True)
    print(' '.join(sys.argv))
    args = parser.parse_args()
    return args

def get_duration(file_path):
    duration = None
    if os.path.exists(file_path) and Path(file_path).stat().st_size > 0:
        with contextlib.closing(wave.open(file_path,'r')) as f:
            frames = f.getnframes()
            if frames>0:
                rate = f.getframerate()
                duration = frames / float(rate)
    return duration if duration else 0

def normalize_text(text, chuvash=False):
    text = text.strip()
    text  = re.sub("[\(\{\[].*?[\)\}\]]", "", text) #remove (text*) and same for [], {}
    text = re.sub('[-—–]', '-', text) # normalize hyphen
    text = text.lower()
    text = " ".join(regex.findall('\p{alpha}+', text)) # for v1
    if chuvash: 
        ### fix some errors in chuvash commonvoice data
        replace = {"ă":"ӑ", "ç":"ҫ", "ĕ":"ӗ", "ÿ":"ӳ", "ӱ":"ӳ"}
        for x, y in replace.items():
            text = text.replace(x, y)

    return text

def prep_cv(filelist, lang):
    path = 'datasets/'+lang
    is_ch = True if lang=='cv' else False
    all_tsv = pd.read_csv(path + '/validated.tsv', delimiter='\t', quoting=csv.QUOTE_NONE)
    file2text = dict(zip(all_tsv.path, all_tsv.sentence))
    files = {}
    if os.path.exists(filelist):
        with open(filelist, 'r', encoding='utf-8') as f:
            lists = f.read().splitlines()
            for file in lists:
                file = file+'.mp3'
                audio_path = path+'/clips/'+ file
                if os.path.exists(audio_path) and file in file2text:
                    text = normalize_text(file2text[file], is_ch)
                    files[file] = ("["+lang+"]", audio_path, text)
                else: print('err', audio_path)
    return files ## key rec_id value (wav, text)

def get_text(path):
    with open(path, 'r', encoding='utf-8') as f:
        return normalize_text(f.read().strip())
def read_meta(path):
    meta = pd.read_csv(path, sep=" ") 
    return list(meta['uttID'])

def prep_sc(path, eval_dir, lang):
    eval_dir = eval_dir.capitalize() if lang=='tsc' else eval_dir
    path = 'datasets/'+path.strip('.tar.gz') +'/' + eval_dir
    lid = '[tr]' if lang =='tsc' else '[uz]'
    files = {os.path.basename(x).replace('.wav', ''):(lid, x, get_text(x.replace('.wav','.txt'))) for x in glob.glob(path + '/*.wav')}
    return files

def prep_ksc(path, eval_dir):
    path = 'datasets/'+path.strip('.tar.gz')
    meta = pd.read_csv(path+'/Meta/'+eval_dir+'.csv', sep=" ")
    meta = list(meta['uttID'])
    files = {}
    for rec_id in meta:
        file_path = os.path.join(path, 'Audios', rec_id) + '.wav'
        text = get_text(os.path.join(path, 'Transcriptions', rec_id) + '.txt')
        files[rec_id] = ('[kk]', file_path, text)
    return files

def write_dir(files, eval_dir, formatting, lib, lang):
    path_root = os.path.join('data', eval_dir)
    os.makedirs(path_root, exist_ok=True) 
    ### files is a dict
    rec_ids = list(files.keys())
    rec_ids.sort(key=lambda x: str(x))
    
    with open(path_root + '/text', 'w', encoding="utf-8") as f1, \
    open(path_root + '/utt2spk', 'w', encoding="utf-8") as f2, \
    open(path_root + '/spk2utt', 'w', encoding="utf-8") as f3, \
    open(path_root + '/wav.scp', 'w', encoding="utf-8") as f4:    
        for rec_id in rec_ids:
            lid, audio_path, text = files[rec_id]
            rec_id = lang + '_' + rec_id
            f1.write(rec_id + ' ' + lid + ' ' + text + '\n')
            f2.write(rec_id + ' ' + rec_id + '\n')
            f3.write(rec_id + ' ' + rec_id + '\n')
            f4.write(rec_id + lib + audio_path + ' ' + formatting +  '\n')

def main():
    args = get_args()
    lang = args.lang
    path = args.path

    for x in ['train', 'dev', 'test']:
        eval_dir = x + '_lid_' + lang
        formatting = '-r 16000 -c 1 -b 16 -t wav - downsample |'
        lib = ' sox '
        if lang=='ksc':
            ### Kazakh Speech Corpus
            files = prep_ksc(path, x)
        elif lang=='usc' or lang=='tsc':
            ### Uzbek or Turkish Speech Corpus
            files = prep_sc(path, x, lang)
        else:
            ### Commonvoice
            filelist = "conf/filelists/"+eval_dir.replace('_lid', '') + ".txt"
            files = prep_cv(filelist, lang)
            formatting='-f wav -ar 16000 -ab 16 -ac 1 - |'
            lib = ' ffmpeg -i '
        write_dir(files, eval_dir, formatting, lib, lang)
    
if __name__ == "__main__":
    main()