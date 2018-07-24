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


//http://blog.rumblesan.com/post/53271713909/drum-sounds-in-supercollider-part-2

(
SynthDef('kickdrum', {
	var osc, noise, env, filtered;

	env = {EnvGen.kr(Env.perc(0.01, 0.5), doneAction:2)};
	osc = {Pulse.ar(80, width: 0.8-env)};

	//noise = {Decay2.ar(Impulse.ar(80))};
	filtered = {RLPF.ar(osc, freq: 200-env*1.2, rq:6.reciprocal)};

	Out.ar(0, Pan2(filtered*env, 0))
}).send(s);


SynthDef('openhat', {
	var hatosc, hatenv, hatnoise, hatoutput;
	hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};
	hatosc = {HPF.ar(hatnoise,2000)};
	hatenv = {Line.ar(1, 0, 0.3)};
	hatoutput = (hatosc * hatenv);
	Out.ar(0,Pan2.ar(hatoutput, 0))
}).send(s);


SynthDef('closedhat', {
	var hatosc, hatenv, hatnoise, hatoutput;
	hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};
	hatosc = {HPF.ar(hatnoise,2000)};
	hatenv = {Line.ar(1, 0, 0.1)};
	hatoutput = (hatosc * hatenv);
	Out.ar(0, Pan2.ar(hatoutput, 0))
}).send(s);

SynthDef('snaredrum', {
	var drumosc, filterenv, volenv, drumoutput, snaposc, snapenv, fulloutput;
	drumosc = {Pulse.ar(100)};
	filterenv = {Line.ar(1, 0, 0.2, doneAction: 0)};
	volenv = {Line.ar(1, 0, 0.6, doneAction: 2)};
	drumoutput = {LPF.ar(drumosc,(filterenv *1000) + 30)};
	snaposc = {BPF.ar(HPF.ar(WhiteNoise.ar(1),500),1500)};
	snapenv = {Line.ar(1, 0, 0.2, doneAction: 0)};

	fulloutput = (drumoutput * volenv) + (snaposc * snapenv);
	//fulloutput = (drumoutput * volenv);

	Out.ar(0, Pan2.ar(fulloutput, 0))
}).send(s);

)


/*({ var excitation = EnvGen.kr(Env.perc(releaseTime:0.5), MouseButton.kr(0, 1, 0),timeScale: 0.1, doneAction: 0) * PinkNoise.ar(0.4);
	var tension = MouseX.kr(0.01, 0.1);
	var loss = MouseY.kr(0.999999, 0.999, 1);
	MembraneCircle.ar(excitation, tension, loss);
}.play)*/

~snare = Synth('snaredrum');
~kick = Synth('kickdrum');