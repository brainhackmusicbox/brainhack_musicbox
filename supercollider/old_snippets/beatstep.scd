(
o = Server.local.options;
//o.device ="ASIO4ALL"; //must die
o.sampleRate= 44100;
o.blockSize = 8192*2;
o.memSize = 8192*32;
o.dump;

s.boot;
)


Platform.userExtensionDir;

(
~filter_f = 800;
~filter_q = 0.1;

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

		var adsr = Env.asr(attackTime:0.1, releaseTime:sustain+1);
		var env = EnvGen.kr(adsr, gate, doneAction: 2);


		var lfo = {LFTri.kr(freq:0.01)};

		var sinfb = SinOscFB.ar(
			freq: freq,
			feedback: 2,
			mul: 0.5*env*amp
		);


		var moogff = MoogFF.ar(
			in: sinfb,
			freq: 100,
			gain: 2,
			reset: 0
		);

		//var reverb = FreeVerb.ar(in: bmoog, mix: 0.8, room:0.5, damp:0.9);
		//var moogladder = MoogLadder.ar();

		Out.ar(0, sinfb ! 2);
});
~synth.add;


~bind = Pbind(*[
	instrument: \test,
	root: 2,
	octave: 4,
	degree: Pseq((0..7) ++ (6..0) ++ [\rest], inf),
	scale: Scale.minor,
	dur: Pgauss(mean: 1.8, dev: 0.25),
	sustain: Pgauss(mean: 1.7, dev: 0.5),
	//legato: Pgauss(mean: 0.5, dev: 0.3),
	amp: Pgbrown(lo:0.4, hi: 0.7),

	bmoog_mode: 2,
	bmoog_freq: ~filter_f,
	bmoog_q: ~filter_q
]).trace.play;


//========================================================
//========== CONTROLLER ==================================
//========================================================

a = ArturiaBeatStep();
// register a function to be evaluted when fader1 is changed
a.knob1.onChange = {|val| (200+val).postln; ~filter_f = 200+val };
a.knob2.onChange = {|val| (val/127).postln; ~filter_q = val/127 };

)