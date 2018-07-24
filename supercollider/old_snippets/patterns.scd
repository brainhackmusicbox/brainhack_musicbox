thisProcess.platform.userExtensionDir
(
o = Server.local.options;
o.device ="ASIO4ALL"; //must die
o.sampleRate= 44100;
o.blockSize = 8192*2;
o.memSize = 8192*32;
//o.threads see supernova
o.dump;

s.boot;
)




(
var chords, bmoog_q;

~synth = SynthDef(\test,
	{ | out,
		sustain=0.5,
		feedback=0,
		bmoog_freq=100,
		bmoog_q = 0.2,
		bmoog_mode = 0,
		freq = 220,
		amp = 1,
		gate = 1|

		var adsr = Env.asr(attackTime:sustain, releaseTime:sustain+1);
		var env = EnvGen.kr(adsr, gate, doneAction: 2);


		var lfo = {LFTri.kr(freq:0.01)};

		var sinfb = SinOscFB.ar(
			freq: freq,
			feedback: 2,
			mul: 0.5*env*amp
		);

		//var audio = Mix.ar([pulse, sin]); SinOsc.kr(freq:0.03, phase:0, mul:200)
		var bmoog = BMoog.ar(
			in: sinfb,
			freq: bmoog_freq+LFTri.kr(freq: 3, mul:5),
			q: bmoog_q,
			mode: bmoog_mode
		);

		/*var moogff = MoogFF.ar(
			in: sinfb,
			freq: 100,
			gain: 2,
			reset: 0
		);*/

		//var reverb = FreeVerb.ar(in: bmoog, mix: 0.8, room:0.5, damp:0.9);
		//var moogladder = MoogLadder.ar();

		Out.ar(0, bmoog ! 2);
});
~synth.add;


chords = [
	[1,2,4], [2,4,6], [4,6,8], [1,4,7],
	[3, 4, 8], [4, 8, 12], [4, 7, 13], [10, 7, 3],
	[3, 9, 10, 13], [2, 7, 9], [1, 5, 10, 12], [4, 7, 9],
	[2, 4, 5, 8], [1,3,4], [5, 10, 16], [3,7,4],
	[7, 10, 17], [3,4,7], [5, 7, 10,18],
	[5, 13, 15], [5, 13, 15, 17], [5, 13, 14],
	[6, 12, 15], [4,9,11]
];


//bmoog_q = Prand((1..100).collect{|x| x*0.01}, inf);
bmoog_q = Pbrown(lo:0, hi:0.99, step: 0.015);
//=======================================================
~bind = Pbind(*[
	instrument: \test,
	root: 2,
	octave: 4,
	degree: Prand(chords, inf),
	scale: Scale.partch_o1,
	dur: Pgauss(mean: 1.8, dev: 0.25),
	sustain: Pgauss(mean: 1.7, dev: 0.5),
	//legato: Pgauss(mean: 0.5, dev: 0.3),
	amp: Pgbrown(lo:0.4, hi: 0.7),

	bmoog_mode: 2,
	bmoog_freq: Pgauss(mean: 550, dev: 100),
	bmoog_q: bmoog_q
]).trace.play;

)


s.prepareForRecord("F:\\output.wav");
s.record;
s.stopRecording;


