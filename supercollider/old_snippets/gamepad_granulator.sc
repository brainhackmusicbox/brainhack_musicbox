(
// SYNTHS ------------------------------------------------------
// SynthDef(\grain, {|out=0, amp=0, pitchshift=1, grainsize_delta=0, trigrate=10, startpos=0.2, dispersion=0.2, rate=1,                                                    sndbuf, gate|
// 	var env, grain;
// 	env = EnvGen.kr(Env([0, 1, 0], [1, 3], \sin, 1),gate, doneAction: 2);
// 	grain = GrainBuf.ar(
// 		numChannels: 2,
// 		trigger: Impulse.kr(trigrate),
// 		dur: grainsize_delta+0.3,//+SinOsc.kr(0.12, mul:0.19),
// 		sndbuf: sndbuf,
// 		rate: rate,
// 		pos: rrand(startpos, startpos+dispersion),
// 		interp: 2,
// 		pan: LFNoise2.kr(50),
// 		envbufnum: -1
// 	)*env*amp;
// 	Out.ar(out, grain)
// }).add;
/*
SynthDef(\delay, {|inbus, outbus, delaytime=2, wet=0.5, dry=0.5, feedback=0.2|
	var output;
	//output = DelayL.ar(in: In.ar(inbus), maxdelaytime:2, delaytime:delaytime, mul: 1);
	//output = SwitchDelay.ar(inbus, dry, wet, delaytime, feedback);
	Out.ar(outbus, output);
}).add;*/

//PATHS ------------------------------------------------------------
//~allsamples = "E:/tmp/ready";
//~allsamples = "/media/data/works/2016.03.07 - glass samples/ready";

//mono buffers for granulator
//~wetL = (~allsamples+/+"wet/long/*wav").pathMatch.collect { |path|	Buffer.readChannel(s, path, channels: 0)};


//CONFIG ------------------------------------------------------------


//~delay = Synth.head(~loop_group, \delay, [inbus: ~loopbus, outbus: 0, delaytime: ~delaytime, wet: ~delay_wet, dry: ~delay_dry, feedback: ~delay_fb]);
//Compander.ar(in: 0, control: 0, thresh:~cmp_thresh, slopeBelow:1, slopeAbove: ~cmp_slopeAbove, clampTime: 0.01, relaxTime: 0.01);

// GAMEPAD SETUP --------------------------------------------------
GeneralHID.buildDeviceList;
GeneralHID.postDevices;
~gamepad = GeneralHID.open(GeneralHID.findBy(3141, 17184)); //XEOX Gamepad SL-6556-BK
//gamepad.caps;
~gamepad.debug_(false);
//gamepad.debug_(true);
//gamepad.makeGui;,


~buttons = (
	288: {|x| if(x.asBoolean,
		{"1 ON".postln},
		{"1 OFF".postln})},

	289: {|x| if(x.asBoolean,
		{"2 ON".postln},
		{"2 OFF".postln})},

	290: {|x| if(x.asBoolean,
		{"3 ON".postln},
		{"3 OFF".postln})},

	291: {|x| if(x.asBoolean,
		{"4 ON".postln},
		{"4 OFF".postln})},

	292: {|x| if(x.asBoolean,
		{"5 ON".postln},
		{"5 OFF".postln})},

	293: {|x| if(x.asBoolean,
		{"6 ON".postln},
		{"6 OFF".postln})},

	294: {|x| if(x.asBoolean,
		{"7 ON".postln},
		{"7 OFF".postln})},

	295: {|x| if(x.asBoolean,
		{"8 ON".postln},
		{"8 OFF".postln})},

	296: {|x| if(x.asBoolean,
		{"9 ON".postln},
		{"9 OFF".postln})},

	297: {|x| if(x.asBoolean,
		{"10 ON".postln},
		{"10 OFF".postln})},

	298: {|x| if(x.asBoolean,
		{"11 ON".postln},
		{"11 OFF".postln})},

	299: {|x| if(x.asBoolean,
		{"12 ON".postln},
		{"12 OFF".postln})},
);

~joysticks =(
	0: {|x| ("LX: "++x.value).postln},
	1: {|x| ("LY: "++x.value).postln},

	2: {|x| ("RX: "++x.value).postln},
	5: {|x|	("RY: "++x.value).postln},

	16: {|x| ("8bitX: "++x.value).postln},
	17: {|x| ("8bitY: "++x.value).postln},
);

//two irregular buttons
Interval(288, 299).do{|number| ~gamepad.slots[1][number].action_({~buttons[number].value(~gamepad.slots[1][number].value)})};

//joysticks
[0, 5, 2, 1, 16, 17].do{|i|	~gamepad.slots[3][i].action_({~joysticks[i].value(~gamepad.slots[3][i].value)})};

)

//~grains.query;