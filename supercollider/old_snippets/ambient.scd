//API quark required (for JSON support)
Server.local.options.device ="ASIO4ALL";
s.options.sampleRate= 44100;
//s.options.memSize = 8192*32;
s.boot;
s.plotTree;
s.meter;
Platform.userExtensionDir;
s.stop;
s.quit;
FreqScope.new

(
var sound_sources, sounds, player, next_start_time, drone, delay, drone_process, bus_drone, bus_fx, bus_synth, synth, mix, reverb, outfile, freq, hasFreq, effect, synths_limit;


// sound_sources = "F:/sounds/window/drone/".standardizePath
sound_sources = "F:/sounds/metal_44100/".standardizePath;
sounds = SoundFile.collect(sound_sources+/+"*.wav").sort({|x, y| x.duration > y.duration});
synths_limit=12;
//===============================================================
// synths
SynthDef(\playfile, {|bufnum, bus, rate=1, amp=1, pitch_ratio=1|
	var audio, shifted, gate;
	audio = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)*rate, doneAction:2)*amp;
	shifted = PitchShift.ar(audio, pitchRatio:pitch_ratio, timeDispersion:0)* LFTri.ar(0.05, 0, 1);

	Out.ar(bus, Mix.ar([audio, shifted]));
}).add;

SynthDef(\fx, {|inbus, src, outbus|
	var input, conv, amp, kernel;
	input =  In.ar(inbus, numChannels: 2);
	amp = LFTri.ar(0.08, 0, 5.0);
	kernel = Buffer.read(s, src);
	conv = Convolution.ar(input, kernel, 4096, mul: amp);
	Out.ar(outbus, conv);
}).add;

SynthDef(\delay, {|inbus, outbus, delaytime|
	var output;
	output = DelayL.ar(in: In.ar(inbus), maxdelaytime:15.0, delaytime:delaytime, mul: LFTri.ar(0.15, 0, 2.5));
	Out.ar(outbus, output);
}).add;

//===============================================================

50.do{"".postln};
"================================================================================".postln;
"% files found".format(sounds.size.asString).postln;

drone = Routine({|soundset, bus, overlap_min=0.25, overlap_max=0.95, rate_min=0.2, rate_max=2, pitch_min=0.5, pitch_max=2.5|
	var prev_sound, sound, buffer, overlap, before_next_sound, rate, pitch_ratio, amp, sustain;
	s.sync;
	//1.wait;
	inf.do{
		sound = soundset.choose;
		if(prev_sound != nil, {while({sound == prev_sound},{sound = soundset.choose})}); //no repeats

		rate = rrand(rate_min, rate_max);
		overlap = rrand(overlap_min,overlap_max)+rrand(-0.05,0.15);
		pitch_ratio = rrand(pitch_min, pitch_max);
		amp = if(s.numSynths > 0, {s.numSynths.reciprocal.round(0.01)}, {Env.asr(0.5)});

		before_next_sound = {|sound| (sound.duration-(overlap*sound.duration)).round(0.01)};

		//debug info
		"[%]%:\t time: %s\t|%s (%)\t|rate: %\t|pitch: %|%".format(
			s.numSynths,
			sound.path.basename,
			sound.duration.round(0.01),
			before_next_sound.value(sound),
			(overlap*100).round(0.01).asString++"%",
			rate.round(0.01),
			pitch_ratio.round(0.01),
			if(s.numSynths < synths_limit, {"*"}, {"-"}),
		).postln;

		buffer = Buffer.read(s, sound.path);

		if(s.numSynths < (synths_limit-4)){
			Synth(\playfile, [
				bufnum: buffer.bufnum,
				bus: bus,
				amp: amp,
				rate: rate,
				pitch_ratio: pitch_ratio
			]);

		};

		before_next_sound.value(sound).wait;
		rrand(1.0, 3.5).wait;
		prev_sound = sound;
	};
}).play;

drone.value(sounds, bus_drone);

bus_drone = Bus.audio(s,2);
bus_fx = Bus.audio(s,2);


effect = Routine({
	var conv_path, conv_files, src, synth;
	conv_path = "F:/sounds/conv/".standardizePath;
	conv_files = SoundFile.collect(conv_path+/+"*.wav").sort({|x, y| x.duration > y.duration});
	loop{
		src = conv_files.choose;
		if(s.numSynths < synths_limit){
			synth = Synth(\fx, [inbus: bus_drone, outbus: bus_fx, src: src]);
			("conv:"+src.path).postln;
		};
		(src.duration+rrand(-1.0, 4.0)).wait;
		10.wait;
		synth.free;
	};
}).play;


delay =  Routine({
	var tmp, delaytime;
	loop{
		delaytime = rrand(0.1, 5.5);
		("delay:"+delaytime).postln;
		if(s.numSynths < synths_limit){
			tmp = Synth(\delay, [inbus: bus_fx, outbus: bus_synth, delaytime: delaytime]);
			120.wait;
			tmp.free;
		};
	};
}).play;


outfile = "F:/sounds/metal_ready.wav";
s.prepareForRecord(outfile);
s.record;
)


s.stopRecording;


s.quit;