(
SynthDef(\diskIn2, {
	|bufnum, out, gate=1, sustain, amp=1, ar=0, dr=0.01, pitch_ratio=1|
	var signal = DiskIn.ar(2, bufnum)
	* Linen.kr(gate, ar, 1, dr, 2)
	* EnvGen.kr(Env.linen(0, sustain - ar - dr max: 0 ,dr),1, doneAction: 2) * amp;
	Out.ar(out, PitchShift.ar(in:signal, pitchRatio:pitch_ratio))
}).add;

SynthDef(\compressor, {
	|in, out, thresh, slopeabove|
	ReplaceOut.ar(out,
		Compander.ar(in:in, control:in, thresh:thresh, slopeBelow:1, slopeAbove: slopeabove, clampTime: 0.01, relaxTime: 0.01);)
}).add;


~samples_folder = "/media/data/works/2016.07.19 - beatstep sampler/*.wav".standardizePath;
~samples = SoundFile.collect(~samples_folder)[0..15];
~pitches = Array.fill(16, {1});
//~samples.do{|x| x.path.postln};

// Beatstep controller
a = ArturiaBeatStep();
a.knobs.do {|knob, i|
    knob.onChange = {|val|
		~pitches[i] = val.linlin(0, 127, 0.25, 4).round(0.05);
		"pitch %: %\n".postf(i+1, ~pitches[i]);
    };
};

a.pads.do {|pad, i|
    pad.onPress = {|val|
		val = val.lincurve(0, 127, 0, 100).round(0.1);
		"Pad % pressure: %\n".postf(i+1, val);
		~samples[i].cue(ev:(out:0, amp:val, instrument:\diskIn2, pitch_ratio:~pitches[i], group: 1), playNow: true, closeWhenDone: true);
	};
};
)