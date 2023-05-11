clear;
close all;

f_ech = 44100;

% Données
song.path = '../Samples/Parce que tu crois.mp3';
song.id = 1;
song.y = mean(audioread(song.path, [1 20 * f_ech]), 2);
song.t0 = 0.634;
song.bpm = 124;
song.samples = [
	create_sample(song.t0, 4.403, 92/124, 2^(-5/12))
];

songs = [song];

sheet.bpm = 92;
sheet.result_path = "../Samples/What's The Difference.mp3";
sheet.result = mean(audioread(sheet.result_path, round([10 20] * f_ech)), 2);
% sheet.result = song.y
sheet.notes = [
	create_note(song, song.samples(1), 0, 8);
];

save mystere_3;