(
// memSize is just some reserved memory for use by plug-ins like delay lines
/*o = Server.local.options;
o.device ="ASIO4ALL"; //must die
o.sampleRate= 44100;
o.blockSize = 8192*2;
o.memSize = 8192*32;
o.dump;
s.boot;*/
)

(
var gamepad, buttons, joysticks;
// SYNTHS ------------------------------------------------------
SynthDef(\player, {|bufnum, loop, gate=1, bus=0, rate=1, amp=1, pitch_ratio=1|
	var audio, shifted, env;
	env = EnvGen.kr(Env([0, 1, 0], [1, 3], \sin, 1),gate, levelScale: amp,doneAction: 2);
	audio = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)*rate, doneAction:2, loop: loop)*amp*env;
	shifted = PitchShift.ar(audio, pitchRatio:pitch_ratio, timeDispersion:0)* LFTri.ar(0.05, 0, 1);
	Out.ar(bus, shifted);
}).add;

SynthDef(\grain, {|out=0, amp=0, pitchshift=1, grainsize_delta=0, trigrate=10, startpos=0.2, dispersion=0.2, rate=1,                                                    sndbuf, gate|
	var env, grain;
	env = EnvGen.kr(Env([0, 1, 0], [1, 3], \sin, 1),gate, doneAction: 2);
	grain = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(trigrate),
		dur: grainsize_delta+0.3,//+SinOsc.kr(0.12, mul:0.19),
		sndbuf: sndbuf,
		rate: rate,
		pos: rrand(startpos, startpos+dispersion),
		interp: 2,
		pan: LFNoise2.kr(50),
		envbufnum: -1
	)*env*amp;
	Out.ar(out, grain)
}).add;
/*
SynthDef(\delay, {|inbus, outbus, delaytime=2, wet=0.5, dry=0.5, feedback=0.2|
	var output;
	//output = DelayL.ar(in: In.ar(inbus), maxdelaytime:2, delaytime:delaytime, mul: 1);
	//output = SwitchDelay.ar(inbus, dry, wet, delaytime, feedback);
	Out.ar(outbus, output);
}).add;*/

//PATHS ------------------------------------------------------------
//~allsamples = "E:/tmp/ready";
~allsamples = "/media/data/works/2016.03.07 - glass samples/ready";

//mono buffers for granulator
~wetL = (~allsamples+/+"wet/long/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};
~wetS = (~allsamples+/+"wet/short/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};

~ballL = (~allsamples+/+"balls/long/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};
~ballS = (~allsamples+/+"balls/short/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};

~bellL = (~allsamples+/+"bells/long/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};
~bellS = (~allsamples+/+"bells/short/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};

// stereo -----------------------------------
~wl = SoundFile.collect(~allsamples+/+"wet/long/*wav");
~bal = SoundFile.collect(~allsamples+/+"balls/long/*wav");
~bel = SoundFile.collect(~allsamples+/+"bells/long/*wav");

~ws = SoundFile.collect(~allsamples+/+"wet/long/*wav");
~bas = SoundFile.collect(~allsamples+/+"balls/long/*wav");
~bes = SoundFile.collect(~allsamples+/+"bells/long/*wav");

~hold = false;
~trigrate = 10;
~grainsize_delta = -0.3;
~startpos = 0.3;
~dispersion = 0.2;

~grain_amp = 0.5;
~loop_amp = 0.2;
~sampler_amp = 0.2;

~cmp_thresh=0.5;
~cmp_slopeAbove=0.25;

~delaytime=1;
~delay_dry=0.5;
~delay_det=0.5;
~delay_fb=0.2;

~loopbus = Bus.audio(s, 2);
~grains = Group();
~loop_group = Group();
~sampler_group = Group();

~pitch_ratio1 = 1;
~pitch_ratio2 = 1;
~pitch_ratio3 = 1;
// LOOPS --------------------------------------------------------
~loops = (~allsamples+/+"loops/*wav").pathMatch.collect { |path| Buffer.read(s, path)};
~looper = Synth.head(~loop_group, \player, [bus: 0, bufnum: ~loops.choose, loop: 1, amp:~loop_amp]);
//~delay = Synth.head(~loop_group, \delay, [inbus: ~loopbus, outbus: 0, delaytime: ~delaytime, wet: ~delay_wet, dry: ~delay_dry, feedback: ~delay_fb]);

Compander.ar(in: 0, control: 0, thresh:~cmp_thresh, slopeBelow:1, slopeAbove: ~cmp_slopeAbove, clampTime: 0.01, relaxTime: 0.01);

// GAMEPAD SETUP --------------------------------------------------

GeneralHID.buildDeviceList;
//GeneralHID.postDevices;
gamepad = GeneralHID.open(GeneralHID.findBy(3141, 17184));
//gamepad.caps;
gamepad.debug_(false);
//gamepad.debug_(true);
//gamepad.makeGui;,


buttons = (
	288: {|x| if(x.asBoolean,
		{"Button 1".postln; ~grain1 = ~grain1 ?? Group(~grains);
			Synth.head(~grain1, \grain, [gate: 1, sndbuf: ~wetL.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate, amp: ~grain_amp])},
		{~hold.not.if({~grain1.release})})},

	289: {|x| if(x.asBoolean,
		{"Button 2".postln; ~grain2 = ~grain2 ?? Group(~grains);
			Synth.head(~grain2, \grain, [gate: 1, sndbuf: ~wetS.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate,  amp: ~grain_amp])},
		{~hold.not.if({~grain2.release}); ~hold.postln})},

	290: {|x| if(x.asBoolean,
		{"Button 3".postln; ~grain3 = ~grain3 ?? Group(~grains);
			Synth.head(~grain3, \grain, [gate: 1, sndbuf: ~ballL.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate, amp: ~grain_amp])},
		{~hold.not.if({~grain3.release}); ~hold.postln})},

	291: {|x| if(x.asBoolean,
		{"Button 4".postln; ~grain4 = ~grain4 ?? Group(~grains);
			Synth.head(~grain4, \grain, [gate: 1, sndbuf: ~bellL.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate,  amp: ~grain_amp])},
		{~hold.not.if({~grain4.release}); ~hold.postln})},

	292: {|x| if(x.asBoolean,
		{"Button 5".postln; ~grain5 = ~grain5 ?? Group(~grains);
			Synth.head(~grain5,\grain, [gate: 1, sndbuf: ~ballS.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate, amp: ~grain_amp])},
		{~hold.not.if({~grain5.release}); ~hold.postln})},

	293: {|x| if(x.asBoolean,
		{"Button 6".postln; ~grain6 = ~grain6 ?? Group(~grains);
			Synth.head(~grain6, \grain, [gate: 1, sndbuf: ~bellS.choose, grainsize_delta: ~grainsize_delta, trigrate: ~trigrate, amp: ~grain_amp])},
		{~hold.not.if({~grain6.release}); ~hold.postln})},

	294: {|x| if(x.asBoolean, {"Button 7 HOLD".postln; ~hold = true}, {~hold = false})},
	295: {|x| if(x.asBoolean, {
		"Button 8 FREE".postln;
		~grains ?? {~grains.release; ~grains = Group()};
	})},

	296: {|x| if(x.asBoolean, {"Button 9".postln;})},
	297: {|x| if(x.asBoolean, {"Button 10".postln;})},
	298: {|x| if(x.asBoolean, {
		var rate = [1, 2, 0.5, 0.75, 0,625, 0,875, 0,5625].choose;
		("Button 11 grain rate: "++rate).postln;
		~grains.set(\rate, rate);
	})},
	299: {|x| if(x.asBoolean, {"Button 12".postln;})},
);

joysticks =(
	0: {|x| ~grainsize_delta=(x.value.lincurve(0, 1, 0.05, 1, -1.5)).round(0.001);
		~grains.set(\grainsize_delta, ~grainsize_delta);     ("LX: grain "++~grainsize_delta).postln},
	5: {|x|~dispersion = x.value.lincurve(0, 1, 0.05, 0.8, -1.5).round(0.001);
		~grains.set(\dispersion, ~dispersion); 		("LY: dispersion "++~dispersion).postln},


	2: {|x| ~startpos = x.value.lincurve(0, 1, 0.01, 0.8, -1.5).round(0.001);
		~grains.set(\startpos, ~startpos);	("RX: startpos "++~startpos).postln},
	1: {|x| ~trigrate=(x.value.lincurve(0, 1, 1, 50, -1.5)).round(0.001);
		~grains.set(\trigrate, ~trigrate); ("RY: trig rate "++~trigrate).postln},



	16: {|x| ("8bitX: "++x.value).postln},
	17: {|x| ("8bitY: "++x.value).postln},
);

Interval(288, 299).do{|i|
	gamepad.slots[1][i].action_({
		buttons[i].value(gamepad.slots[1][i].value);
})};

[1, 2, 5, 0, 16, 17].do{|i|
	gamepad.slots[3][i].action_({
		joysticks[i].value(gamepad.slots[3][i].value);
})};

// Beatstep controller
a = ArturiaBeatStep();
a.knob1.onChange = {|val|
	~grain_amp = (val.lincurve(0, 127, 0, 2)).round(0.001);
	~grains.set(\amp, ~grain_amp);
	("AMP1: "++~grain_amp).postln;};

a.knob2.onChange = {|val|
	~loop_amp = (val.lincurve(0, 127, 0, 10, -2)*0.5).round(0.001);
	~loop_group.set(\amp, ~loop_amp);
	("AMP2: "++~loop_amp).postln;};

a.knob3.onChange = {|val|
	~sampler_amp = (val.lincurve(0, 127, 0, 10, -2)).round(0.001);
	~sampler_group.set(\amp, ~sampler_amp);
	("AMP3: "++~sampler_amp).postln;};

a.knob9.onChange = {|val|
	~cmp_thresh = val.lincurve(0, 127, 0, 1).round(0.01);
	("CMP THR: "++~cmp_thresh).postln;
};
a.knob10.onChange = {|val|
	~cmp_slopeAbove = val.lincurve(0, 127, 0, 1).round(0.01);
	("CMP SLOPE: "++~cmp_slopeAbove).postln;
};

a.knob11.onChange = {|val|
	~pitch_ratio1 = val.lincurve(0, 127, 0.2, 20).round(0.01);
	~sampler_group.set(\pitch_ratio,~pitch_ratio1);
	("pitch1: "++~pitch_ratio1).postln;
};

a.knob12.onChange = {|val|
	~pitch_ratio2 = val.lincurve(0, 127, 0.2, 20).round(0.01);
	~sampler_group.set(\pitch_ratio,~pitch_ratio2);
	("pitch2: "++~pitch_ratio2).postln;
};

a.knob13.onChange = {|val|
	~pitch_ratio3 = val.lincurve(0, 127, 0.2, 20).round(0.01);
	~sampler_group.set(\pitch_ratio,~pitch_ratio3);
	("pitch3: "++~pitch_ratio3).postln;
};

a.knob14.onChange = {|val|
	~delay_fb = val.lincurve(0, 127, 0.2, 20).round(0.01);
	~delay.set(\delaytime,~delay_fb);
	("dl FB: "++~delay_fb).postln;
};


a.pad1.onPress = {
	"loop".postln;
	~loop_group ?? ~loop_group = Group();
	~looper ?? ~looper = Synth.tail(~loop_group, \player, [bus: 0, bufnum: ~loops.choose, loop: 1, amp:~loop_amp]);};

a.pad2.onPress = {
	"stopping...".postln; ~looper.release};



// LONG SAMPLES ---------------------------------
a.pad3.onPress = {
	"3".postln;
	~wl.choose.play};
a.pad4.onPress = {
	"4".postln;
	~bal.choose.play};
a.pad5.onPress = {
	"5".postln;
	~bel.choose.play};

// SHORT SAMPLES ---------------------------------
a.pad6.onPress = {
	"6".postln;
	~ws.choose.play};
a.pad7.onPress = {
	"7".postln;
	~bal.choose.play};
a.pad8.onPress = {
	"8".postln;
	~bel.choose.play};


a.pad9.onPress = {
	~looper ?? {"no looper".postln};
	~looper.set(\bufnum, ~loops.choose);
	"next loop".postln;
};

a.pad10.onPress = {
	"10".postln;
	~sampler_group.release;
	};
)

~grains.query;