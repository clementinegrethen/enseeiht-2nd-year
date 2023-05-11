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