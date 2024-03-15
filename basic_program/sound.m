[y,Fs] = audioread('Fur_Elise.flac');

player = audioplayer(y,Fs);
play(player);