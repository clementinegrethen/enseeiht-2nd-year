clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Pause (en secondes) entre chaque lecture
duree_pause = 1;

load ExSamples/exsample_1;

result = zeros(ceil(max([sheet.notes.stop]) * 60/sheet.bpm * f_ech), 1);

for i = 1:length(sheet.notes)
	note = sheet.notes(i);
	
	sample = note.song.y(round(note.sample.start * f_ech):round(note.sample.stop * f_ech));

	if (note.sample.pitch_shift < 1 && note.sample.time_stretch < 1) || (note.sample.pitch_shift > 1 && note.sample.time_stretch > 1)
		ratio = min(note.sample.pitch_shift, note.sample.time_stretch);
		sample = resample(sample, 100, round(ratio * 100));
		note.sample.pitch_shift = note.sample.pitch_shift / ratio;
		note.sample.time_stretch = note.sample.time_stretch / ratio;
	end

	if note.sample.pitch_shift ~= 1
		sample = transposition(sample, f_ech, note.sample.pitch_shift);
	end

	if note.sample.time_stretch ~= 1
		sample = etirement_temporel(sample, f_ech, note.sample.time_stretch);
	end

	start = round(note.start * 60/sheet.bpm * f_ech) + 1;
	stop =  round(note.stop * 60/sheet.bpm * f_ech);
	if (stop - start + 1) > length(sample)
		result(start:start + length(sample) - 1) = result(start:start + length(sample) - 1) + sample;
	else
		if note.align == 'start'
			result(start:stop) = result(start:stop) + sample(1:stop - start + 1);
		else
			result(start:stop) = result(start:stop) + sample(end - (stop - start):end);
		end
	end
end


% Affichage

% Afficage des samples dans chaque morceau
figure('Name','','Position',[0,0,L,H]);
for i = 1:length(songs)
	song = songs(i);
	
	subplot(length(songs) + 2, 1 , i);
	plot((0:length(song.y) - 1) / f_ech, song.y);
	title(song.path);

	player = audioplayer(song.y, f_ech);
	h = xline(0);
	player.TimerFcn = {@update player, f_ech, h};
	play(player);
	pause(length(song.y) / f_ech + duree_pause)

	
	for j = 1:length(song.samples)
		sample = song.samples(j);
		sample_y = song.y(round(sample.start * f_ech):round(sample.stop * f_ech));
		
		rectangle(Position=[sample.start, -1, sample.stop - sample.start, 2], FaceColor=sample.color);

		if length(song.samples) > 2
			player = audioplayer(sample_y, f_ech);
			h = xline(0);
			player.TimerFcn = {@update_sample player, f_ech, h, sample};
			play(player);
			pause(length(sample_y) / f_ech + duree_pause)
		end
	end
end

% Affichage du résultat
subplot(length(songs) + 2, 1, length(songs) + 1);
plot((0:length(result) - 1) / f_ech, result);
xlim([0 (length(result) - 1) / f_ech]);
ylim([-1 1]);
title("Résultat");
for i = 1:length(sheet.notes)
	note = sheet.notes(i);
	rectangle(Position=[note.start * 60/sheet.bpm, 1 - sheet.notes(i).song.id * 2/length(songs), (note.stop - note.start) * 60/sheet.bpm, 2/length(songs)], FaceColor=note.sample.color);
end

player = audioplayer(result, f_ech);
h = xline(0);
player.TimerFcn = {@update player, f_ech, h};
play(player);
pause(length(result) / f_ech)

% Affichage du morceau final
subplot(length(songs) + 2, 1, length(songs) + 2);
plot((0:length(sheet.result) - 1) / f_ech, sheet.result);
xlim([0 (length(sheet.result) - 1) / f_ech]);
title(sheet.result_path);

player = audioplayer(sheet.result, f_ech);
h = xline(0);
player.TimerFcn = {@update player, f_ech, h};
play(player);

function sample = create_sample(start, stop, time_stretch, pitch_shift)
	sample.start = start;
	sample.stop = stop;
	if nargin < 3 
		time_stretch = 1;
	end
	if nargin < 4
		pitch_shift = 1;
	end
	sample.time_stretch = time_stretch;
	sample.pitch_shift = pitch_shift;
	sample.color = [rand, rand, rand, 0.5];
end

function note = create_note(song, sample, start, stop, align)
	note.song = song;
	note.sample = sample;
	note.start = start;
	note.stop = stop;
	if nargin == 4 
		align = "start";
	end
	note.align = align;
end

function update(obj, event, player, f_ech, h)
	n = player.CurrentSample;
	h.Value = n / f_ech;
end

function update_sample(obj, event, player, f_ech, h, sample)
	n = player.CurrentSample;
	h.Value = sample.start + n / f_ech;
end