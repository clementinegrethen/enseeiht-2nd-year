clear;
close all;

f_ech = 44100;

% Données
song.path = '../Samples/more_spell_on_you.mp3';
song.id = 1;
song.y = mean(audioread('../Samples/more_spell_on_you.mp3', [1 30 * f_ech]), 2);
song.t0 = 18.581;
song.bpm = 132;
song.samples = [
	create_sample(song.t0 + 3 * 60/song.bpm, song.t0 + 5 * 60/song.bpm, 1, 0.95)
	create_sample(song.t0 + 8 * 60/song.bpm - 0.02, song.t0 + 10 * 60/song.bpm - 0.02, 1, 0.95)
	create_sample(song.t0 + 12 * 60/song.bpm - 0.02, song.t0 + 13 * 60/song.bpm - 0.02, 1, 0.95)
];

songs = [song];

sheet.bpm = 132;
sheet.result_path = "../Samples/Daft Punk - One More Time.mp3";
sheet.result = mean(audioread(sheet.result_path, round([30.40 47.2] * f_ech)), 2);
sheet.notes = [
	create_note(song, song.samples(2), 0, 2);
	create_note(song, song.samples(2), 2, 4);
	create_note(song, song.samples(2), 4, 6);
	create_note(song, song.samples(1), 6, 8);

	create_note(song, song.samples(2), 8 + 0, 8 + 2);
	create_note(song, song.samples(2), 8 + 2, 8 + 4);
	create_note(song, song.samples(2), 8 + 4, 8 + 6);
	create_note(song, song.samples(1), 8 + 6, 8 + 8);

	create_note(song, song.samples(2), 16 + 0, 16 + 2);
	create_note(song, song.samples(2), 16 + 2, 16 + 4);
	create_note(song, song.samples(2), 16 + 4, 16 + 6);
	create_note(song, song.samples(1), 16 + 6, 16 + 8);

	create_note(song, song.samples(3), 24, 25);
	create_note(song, song.samples(3), 25, 26);
	create_note(song, song.samples(3), 26, 27);
	create_note(song, song.samples(3), 27, 28);
	create_note(song, song.samples(3), 28, 29);
	create_note(song, song.samples(3), 29, 30);
	create_note(song, song.samples(3), 30, 30.5);
	create_note(song, song.samples(1), 30.5, 32, "end");
];

save mystere_2;