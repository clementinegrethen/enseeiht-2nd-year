clear;
close all;

f_ech = 44100;

% Données
song.path = '../Samples/Sister Sledge - IL Macquillage Lady.mp3';
song.id = 1;
song.y = mean(audioread(song.path, [20 40] * f_ech), 2);
song.t0 = 4.620;
song.bpm = 123;
song.samples = [
	create_sample(song.t0 + 0 * 60/song.bpm, song.t0 + 0.5 * 60/song.bpm);
	create_sample(song.t0 + 3.5 * 60/song.bpm + 0.02, song.t0 + 4 * 60/song.bpm + 0.02);
	create_sample(song.t0 + 4 * 60/song.bpm, song.t0 + 4.5 * 60/song.bpm);
	create_sample(song.t0 + 8 * 60/song.bpm, song.t0 + 8.5 * 60/song.bpm);
	create_sample(song.t0 + 12 * 60/song.bpm, song.t0 + 12.5 * 60/song.bpm);
];

songs = [song];

song.path = '../Samples/Sister Sledge - IL Macquillage Lady.mp3';
song.id = 2;
song.y = mean(audioread(song.path, [20 40] * f_ech), 2);
song.t0 = 4.630;
song.bpm = 123;
song.samples = [
	create_sample(song.t0 + 0.5 * 60/song.bpm, song.t0 + 1 * 60/song.bpm);
	create_sample(song.t0 + 2.5 * 60/song.bpm, song.t0 + 3 * 60/song.bpm);
	create_sample(song.t0 + 3 * 60/song.bpm, song.t0 + 3.5 * 60/song.bpm);
	create_sample(song.t0 + 6.5 * 60/song.bpm, song.t0 + 7 * 60/song.bpm);
	create_sample(song.t0 + 7 * 60/song.bpm, song.t0 + 7.5 * 60/song.bpm);
];

songs = [songs; song];

sheet.bpm = 123;
sheet.result_path = "../Samples/Daft Punk - Aerodynamic.mp3";
sheet.result = mean(audioread(sheet.result_path, round([15 25] * f_ech)), 2);
sheet.notes = [
	create_note(songs(1), songs(1).samples(1), 0, 3/4);
	create_note(songs(1), songs(1).samples(2), 3/4, 6/4);
	create_note(songs(1), songs(1).samples(1), 6/4, 8/4);
	create_note(songs(1), songs(1).samples(5), 3.5, 4);
	create_note(songs(1), songs(1).samples(3), 4, 4.5);
	create_note(songs(1), songs(1).samples(4), 5.5, 6);
	create_note(songs(1), songs(1).samples(5), 7.5, 8);

	create_note(songs(2), songs(2).samples(2), 0.5, 1);
	create_note(songs(2), songs(2).samples(3), 1, 1.5);
	create_note(songs(2), songs(2).samples(1), 2, 2.5);
	create_note(songs(2), songs(2).samples(4), 2.5, 3);
	create_note(songs(2), songs(2).samples(5), 3, 3.5);

	create_note(songs(2), songs(2).samples(2), 4 + 0.5, 4 + 1);
	create_note(songs(2), songs(2).samples(1), 4 + 0.5, 4 + 1);
	create_note(songs(2), songs(2).samples(3), 4 + 1, 4 + 1.5);
	create_note(songs(2), songs(2).samples(1), 4 + 2, 4 + 2.5);
	create_note(songs(2), songs(2).samples(4), 4 + 2.5, 4 + 3);
	create_note(songs(2), songs(2).samples(5), 4 + 3, 4 + 3.5);
];

save mystere_4;