clear;
close all;

f_ech = 44100;

% Données
song.path = '../Samples/Daly Wilson Big Band Dirty Feet.mp3';
song.id = 1;
song.y = mean(audioread(song.path, [8*f_ech 16 * f_ech]), 2);
song.t0 = 10.482 - 8;
song.bpm = 107;
song.samples = [
	create_sample(song.t0 + 0 * 60/song.bpm, song.t0 + 0.5 * 60/song.bpm, 95/107);
	create_sample(song.t0 + 0.5 * 60/song.bpm, song.t0 + 1 * 60/song.bpm, 95/107);
	create_sample(song.t0 + 1 * 60/song.bpm, song.t0 + 1.5 * 60/song.bpm, 95/107);
	create_sample(song.t0 + 1.5 * 60/song.bpm, song.t0 + 2 * 60/song.bpm, 95/107);
	create_sample(song.t0 - 1/4 * 60/song.bpm, song.t0 + 0 * 60/song.bpm, 95/107);
];

songs = [song];

song.path = '../Samples/Nana Caymmi - Tens (Calmaria).mp3';
song.id = 2;
song.y = mean(audioread(song.path, [1 18 * f_ech]), 2);
song.t0 = 0.225;
song.bpm = 107;
song.samples = [
	create_sample(song.t0, 13.505, 95/72, 1.26);
];

songs = [songs; song];

sheet.bpm = 2*95;
sheet.result_path = "../Samples/Nujabes - luv (sic.) pt 3.mp3";
sheet.result = mean(audioread(sheet.result_path, round([33.80 44.10] * f_ech)), 2);
sheet.notes = [
	create_note(songs(1), songs(1).samples(1), 0, 1);
	create_note(songs(1), songs(1).samples(2), 1, 2);
	create_note(songs(1), songs(1).samples(3), 2, 3);
	create_note(songs(1), songs(1).samples(4), 3, 3.5);
	create_note(songs(1), songs(1).samples(5), 3.5, 4);

	create_note(songs(1), songs(1).samples(1), 4 + 0, 4 + 1);
	create_note(songs(1), songs(1).samples(2), 4 + 1, 4 + 2);
	create_note(songs(1), songs(1).samples(3), 4 + 2, 4 + 3);
	create_note(songs(1), songs(1).samples(4), 4 + 3, 4 + 4);

	create_note(songs(1), songs(1).samples(1), 8 + 0, 8 + 1);
	create_note(songs(1), songs(1).samples(2), 8 + 1, 8 + 2);
	create_note(songs(1), songs(1).samples(3), 8 + 2, 8 + 3);
	create_note(songs(1), songs(1).samples(4), 8 + 3, 8 + 3.5);
	create_note(songs(1), songs(1).samples(5), 8 + 3.5, 8 + 4);

	create_note(songs(1), songs(1).samples(1), 12 + 0, 12 + 1);
	create_note(songs(1), songs(1).samples(1), 12 + 1, 12 + 2);
	create_note(songs(1), songs(1).samples(3), 12 + 2, 12 + 3);
	create_note(songs(1), songs(1).samples(4), 12 + 3, 12 + 4);

	create_note(songs(1), songs(1).samples(1), 16 + 0, 16 + 1);
	create_note(songs(1), songs(1).samples(2), 16 + 1, 16 + 2);
	create_note(songs(1), songs(1).samples(3), 16 + 2, 16 + 3);
	create_note(songs(1), songs(1).samples(4), 16 + 3, 16 + 3.5);
	create_note(songs(1), songs(1).samples(5), 16 + 3.5, 16 + 4);

	create_note(songs(1), songs(1).samples(1), 16 + 4 + 0, 16 + 4 + 1);
	create_note(songs(1), songs(1).samples(2), 16 + 4 + 1, 16 + 4 + 2);
	create_note(songs(1), songs(1).samples(3), 16 + 4 + 2, 16 + 4 + 3);
	create_note(songs(1), songs(1).samples(4), 16 + 4 + 3, 16 + 4 + 4);

	create_note(songs(1), songs(1).samples(1), 16 + 8 + 0, 16 + 8 + 1);
	create_note(songs(1), songs(1).samples(2), 16 + 8 + 1, 16 + 8 + 2);
	create_note(songs(1), songs(1).samples(3), 16 + 8 + 2, 16 + 8 + 3);
	create_note(songs(1), songs(1).samples(4), 16 + 8 + 3, 16 + 8 + 3.5);
	create_note(songs(1), songs(1).samples(5), 16 + 8 + 3.5, 16 + 8 + 4);

	create_note(songs(1), songs(1).samples(1), 16 + 12 + 0, 16 + 12 + 1);
	create_note(songs(1), songs(1).samples(1), 16 + 12 + 1, 16 + 12 + 2);
	create_note(songs(1), songs(1).samples(3), 16 + 12 + 2, 16 + 12 + 3);
	create_note(songs(1), songs(1).samples(4), 16 + 12 + 3, 16 + 12 + 4);

	create_note(songs(2), songs(2).samples(1), 0, 32);
];

save mystere_1;