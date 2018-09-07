thisProcess.platform.userExtensionDir
GUI.stethoscope.defaultServer.boot;
(
o = Server.local.options;
//o.device ="ASIO4ALL"; //must die
o.sampleRate= 48000;
//o.blockSize = 8192*2;
o.memSize = 8192*64;
// o.dump;

s.boot;
)

Scale.directory;

s.scope;



(
//~outfile = "/media/data/render4.wav";
//~outfile = "D:\\test.wav";
// s.waitForBoot({
// 	File.exists(~outfile).if(
// 		{("\n\n% already exists".format(~outfile)).postln},
// 	{s.prepareForRecord(~outfile); s.sync; s.record});
// });




SynthDef(\bass, {
	|out, freq=440, ff=400, width=0.4, fq=4, fenvscale, fb, pan=0, amp=1, attack=0.05, decay=0.1, sustain=0.8, release=0.3, gate=1|
	var sig, sig2, filter, env, mixcurve, mix;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	sig = Pulse.ar(freq, width+LFTri.kr(0.012, mul:1.2));
	sig2 = SinOscFB.ar(freq, feedback:fb+env*1.5);

	mixcurve = LFTri.kr(0.25, pi*0.5);
	mix = Mix([sig*(mixcurve+0.5), sig2*(0.5-mixcurve)]);

	filter = MoogFF.ar(mix, ff+env*fenvscale+LFTri.kr(0.005), fq);
	Out.ar(out, Pan2.ar(filter*env*amp, pan))
}).add;

SynthDef(\pads, {
	|out, freq=440, ff=800, fq=2, fb=0.2, fenvscale, attack=0.5, decay=0.1, sustain=0.8, release=0.5, gate=1, amp=1, pan=0|
	var sig, filter, env;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	sig = SinOscFB.ar(freq, feedback:fb+env*1.5);
	filter = MoogFF.ar(sig, ff+env*fenvscale+LFTri.kr(0.007), fq);
	Out.ar(out, Pan2.ar(filter*env*amp, pan))
}).add;

SynthDef(\hihat, {
	|out, freq=880, fb=0.5, ff=440, q=2, attack, decay, sustain, release, amp=1, pan=0, gate=1|
	var sig, filter, env;
	env = 	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	sig = SinOscFB.ar(freq, fb);
	filter = RLPF.ar(sig, ff, q);
	Out.ar(out, Pan2.ar(filter*env*amp, pan))
}).add;


SynthDef(\reverb, {
	|out mix, room, damp|
	var in = In.ar(out, 2);
	ReplaceOut.ar(out, FreeVerb2.ar(in: in[0], in2: in[1], mix: mix, room: 0.5, damp:0.5))
}).add;


SynthDef(\compressor, {
	|out=0, thresh=0.3, slopeBelow=1, slopeAbove=0.12, clampTime=0.02, relaxTime=0.1, pregain=1.0, postgain=1.0|
	var in = In.ar(out, 2)*pregain;
	ReplaceOut.ar(out, Compander.ar(in, in, thresh, slopeBelow, slopeAbove, clampTime, relaxTime)*postgain)
}).add;



~bass = PmonoArtic(
	\bass,
	\dur, Pwrand([0.125, 0.25, 0.5, 1], [1.9, 3, 1, 1.5].normalizeSum, inf),
	\degree, Pwrand([-4, -2, 0, 1, 3, 5, 6], [1.1, 1, 1.3, 0.9, 1, 0.9, 2].normalizeSum, inf)-14,
	\scale, Pseq([Pn(Scale.harmonicMinor, 8), Pn(Scale.lydian, 8), Pn(Scale.mixolydian, 8)], inf),
	\legato, Pwrand([0.2, 0.4, 0.5, 0.8, 1], [1.3, 1.6, 1.3, 0.9, 0.3].normalizeSum, inf),
	\pan, Pgauss(-0.05, 0.1, inf),

	\width, Pgauss(0.6, 0.05, inf),
	\attack, Pwrand([0.005, 0.01, 0.05], [1, 1.5, 0.8].normalizeSum, inf),
	\decay, Pwrand([0.1, 0.2, 0.3], [0.7, 1.2, 0.8].normalizeSum,  inf),
	\release, Pwrand([0.2, 0.4, 0.5, 0.8], [0.5, 1, 0.8, 0.1].normalizeSum, inf),

	\fb, Prand(Array.fill(100, {exprand(0, 2.5)}), inf),
	\ff, Prand(Array.fill(100, {exprand(300, 800)}), inf),
	\fq, Pwrand([1,2,3,4], [0.8, 1, 1.3, 0.5].normalizeSum,inf),
	\fenvscale, Pwrand([0.5, 0.75, 1.0, 1.3, 1.5, 1.8, 2.0, 2.3], [0.8, 2, 3, 3.3, 3.2, 2.5, 2, 0.8].normalizeSum, inf),
	\amp, Prand(Array.fill(100, {exprand(1.0, 0.4)}), inf)

);

~winds = PmonoArtic(
	\pads,
	\dur, Pwrand([0.125, 0.25, 0.5, 1, 1.5, 2.5], [0.3, 0.5, 1, 1.5, 0.7, 0.9].normalizeSum, inf),
	\degree, Pwrand([-4, -3, -2, -1, 0, 1, 3, 4, 5, 6, 7, \rest], [0.8, 1.5, 2, 2.5, 2, 2.2, 1.8, 1, 1.5, 1.8, 0.9, 1.2].normalizeSum, inf),
	\scale, Pseq([Pn(Scale.harmonicMinor, 2), Pn(Scale.lydian, 4)], inf),
	\legato, Pwrand([0.2, 0.4, 0.6, 1.1], [2.5, 2, 1.5, 1.3].normalizeSum, inf),
	\pan, Pgauss(0.05, 0.15, inf),

	\attack, Pwrand([0.01, 0.05, 0.1, 0.3, 0.5, 0.7], [0.5, 0.7, 0.8, 1.3, 1.4, 1.2].normalizeSum, inf),
	\decay, Pwrand([0.05, 0.1, 0.2], [0.7, 1, 0.6].normalizeSum,  inf),
	\release, Pwrand([0.2, 0.3, 0.4, 0.5], [0.5, 0.4, 1, 0.5].normalizeSum, inf),

	\fb, Prand(Array.fill(30, {rrand(0, 2.0)}), inf),
	\ff, Prand(Array.fill(200, {exprand(600, 1000)}), inf),
	\fq, Pwrand([1, 2, 3, 3.5, 4], [0.8, 1, 1.2, 0.5, 0.2].normalizeSum,inf),
	\fenvscale, Pwrand([0.5, 0.75, 1.0, 1.3, 1.5, 1.8, 2.0, 2.3], [0.8, 2, 2.5, 3, 2.7, 2.5, 2, 0.8].normalizeSum, inf),
	\amp, Prand(Array.fill(30, {exprand(0.5, 0.2)}), inf)

);

~hat = Pbind();
//~bass.play;

Pfx(pattern: Pfx(
	pattern: Pfindur(60*5, Ppar([~bass, ~winds])),
	fxname: \reverb,
	pairs: [mix: 0.25, room: 0.4, damp: 0.6]
	),
	fxname: \compressor,
	pairs: [pregain: 2.5, postgain:1.0, thresh: -15.dbamp, slopeAbove: 5.reciprocal, clampTime: 0.02, relaxTime: 0.25]
).play;



)

s.scope;
s.stopRecording;