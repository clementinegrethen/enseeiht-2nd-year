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