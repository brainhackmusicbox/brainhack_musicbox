thisProcess.platform.userExtensionDir
GUI.stethoscope.defaultServer.boot;
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



SynthDef('test',{
	Out.ar(0, )
}).send(s);

SynthDef(\playfile, {|bufnum, bus, rate=1, amp=1, pitch_ratio=1|
	var audio, shifted, gate;
	audio = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)*rate, doneAction:2)*amp;
	shifted = PitchShift.ar(audio, pitchRatio:pitch_ratio, timeDispersion:0)* LFTri.ar(0.05, 0, 1);

	Out.ar(bus, Mix.ar([audio, shifted]));
}).add;