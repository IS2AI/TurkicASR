#!/usr/bin/env python
import os, glob, pdb

def get_dicts(lines):
    rec2text = {}
    for l in lines:
        l = l.split()
        rec_id = l[0]
        text = " ".join(l[1:])
        rec2text[rec_id] = text
    return rec2text

def write_dir(texts, wavs, eval_dir):
    rec_ids = list(texts.keys())
    rec_ids.sort()
    path_root = 'data/' + eval_dir
    with open(path_root + '/text', 'w', encoding="utf-8") as f1, \
        open(path_root + '/utt2spk', 'w', encoding="utf-8") as f2, \
        open(path_root + '/spk2utt', 'w', encoding="utf-8") as f3, \
        open(path_root + '/wav.scp', 'w', encoding="utf-8") as f4:   
            for rec_id in rec_ids:
                audio_info = wavs[rec_id]
                text = texts[rec_id]
                f1.write(rec_id + ' ' + text + '\n')
                f2.write(rec_id + ' ' + rec_id + '\n')
                f3.write(rec_id + ' ' + rec_id + '\n')
                f4.write(rec_id + ' ' + audio_info + '\n')

if __name__ == "__main__":
    for x in ['train', 'dev', 'test']:
        dirs = glob.glob('data/'+x+'_*')
        rec2text, rec2wav = {}, {}
        for lang in dirs:
            with open(lang + '/text', 'r', encoding='utf-8') as f1,\
            open(lang+'/wav.scp', encoding='utf-8') as f2:
                rec2text.update(get_dicts(f1.readlines()))
                rec2wav.update(get_dicts(f2.readlines()))
        write_dir(rec2text, rec2wav, x)
            
    