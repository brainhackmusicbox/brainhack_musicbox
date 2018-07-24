thisProcess.platform.userExtensionDir;
Platform.userAppSupportDir; //quarks
(
o = Server.local.options;
o.device ="ASIO4ALL"; //must die
o.sampleRate= 44100;
o.blockSize = 8192*2;
o.memSize = 8192*32;
o.dump;

s.boot;
)

(
b = Buffer.readChannel(s, "E:/tmp/042.wav", channels: [0, 1].choose);

SynthDef(\grainbuf, {
	|gate=1, amp=1, pitchshift=1, sndbuf, envbuf,
	trigrate|
	var env, grain, shifted, out;
	env = EnvGen.kr(Env([0, 1, 0], [1, 3], \sin, 1),gate, levelScale: amp,doneAction: 2);
	grain = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(trigrate),
		dur: 0.01+SinOsc.kr(0.2, mul:0.008),
		sndbuf: sndbuf,
		rate: pitchshift,
		pos: rrand(0.2, 0.8),
		interp: 2,
		pan: LFNoise2.kr(100),
		envbufnum: -1
	)*env;
	Out.ar(0, grain)
}).send(s);


SynthDef(\playfile, {|bufnum, bus=0, rate=1, amp=1, pitch_ratio=1|
	var audio, shifted;
	audio = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)*rate, doneAction:2)*amp;
	shifted = PitchShift.ar(audio, pitchRatio:pitch_ratio, timeDispersion:0)* LFTri.ar(0.05, 0, 1);

	Out.ar(bus, shifted);
}).add;
)




y = Synth(\grainbuf, [sndbuf: b, trigrate:30, pitchift: 1.5]);
y.set(\gate, 0)

Quarks.gui

//Synth(\playfile, [bufnum: b.bufnum]);
~trig_rate = 50

(
var grain;
grain = Synth(\grainbuf, [sndbuf: b, trigrate:30, pitchift: 1]);

w = Window.new.front;
s = Slider.new(w,Rect(0,0,250,20));
stop = Button.new(w,Rect(260,0,40,20)).states_([["start"]]).action({grain.set(\gate, 1)});
b = Button.new(w,Rect(300,0,40,20)).states_([["stop"]]).action({grain.set(\gate, 0)});
c = CompositeView.new(w,Rect(20,35,100,60));
StaticText.new(c,Rect(0,0,80,30)).string_("X synth control");

)


