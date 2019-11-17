(



// load settings and configs from current folder
["settings.scd", "control_functions.scd", "xeox_hid.scd"].do{
	|filename| (thisProcess.nowExecutingPath.dirname +/+ filename).loadPaths;
};

// SYNTH ====================================================

SynthDef(\grain_FM, {
	|out, gate = 1,
	amp = 0.5,
	pan = 0,

	density = 5,
	overlap = 0.5,
	min_grain_dur = 0.0001,

	filter_freq = 500,

	carrier_freq = 440,
	modulator_freq = 220,
	index = 1,

	delay_time = 1.5,
	decay_time = 7
	|
	// end of synth args

    var grain_dur;
	grain_dur = max(density.reciprocal * overlap, min_grain_dur);

	~grains = GrainFM.ar(
		numChannels: 2,
		trigger: Dust.kr(density),
		dur: grain_dur,
		carfreq: carrier_freq,
		modfreq: modulator_freq,
		index: index,
		pan: pan,
		envbufnum: -1
	);

	~delayed = CombC.ar(
		in: ~grains,
	 	maxdelaytime: 10,
		delaytime:  Lag.kr(delay_time, ~delay_lag),
		decaytime: decay_time
	);

	~mix = Mix.ar([~grains*0.4, ~delayed*0.4]);

	Out.ar(out,	~mix*amp)

}).add;

// SYNTH END =================================================
)

x = Synth(\grain_FM)

s.scope

x.free

