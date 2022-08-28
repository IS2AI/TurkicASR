from espnet2.bin.asr_inference import Speech2Text
import argparse
import numpy as np
import wave, time, os

def get_args():
    parser = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--wav_path", help="path to wav audio", required=True)
    print(' '.join(sys.argv))
    args = parser.parse_args()
    return 

def recognize(wavfile):
    timer = time.perf_counter()
    with wave.open(wavfile, 'rb') as wavfile:
        ch=wavfile.getnchannels()
        bits=wavfile.getsampwidth()
        rate=wavfile.getframerate()
        nframes=wavfile.getnframes()
        buf = wavfile.readframes(-1)
        data=np.frombuffer(buf, dtype='int16')
    speech = data.astype(np.float16)/32767.0 #32767 is the upper limit of 16-bit binary numbers and is used for the normalization of int to float.

    results = speech2text(speech)
    print('time passed:', time.perf_counter()-timer)
    print("RECOGNIZED", results[0][0])
    return results[0][0]


if __name__ == "__main__":
    args = get_args()
    wav_file = args.wav_path
    if os.path.exists(wav_file): 
        asr_model_path="exp/asr_train_ksc2_raw_ksc2_char_sp"
        lm_model_path="exp/lm_train_lm_ksc2_char"

        train_config=asr_model_path + "/config.yaml"
        model_file=asr_model_path + "/valid.acc.ave.pth"

        lm_config = lm_model_path + "/config.yaml"
        lm_file = lm_model_path + "/valid.loss.ave.pth"

        speech2text = Speech2Text(
            asr_train_config=train_config,
            asr_model_file=model_file,
            lm_train_config=lm_config,
            lm_file=lm_file,
            token_type=None,
            bpemodel=None,
            maxlenratio=0.0,
            minlenratio=0.0,
            beam_size=10,
            ctc_weight=0.5,
            lm_weight=0.3,
            penalty=0.0,
            nbest=1,
            device = "cpu"
        )
        recognize(wav_file)
