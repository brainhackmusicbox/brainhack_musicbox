thisProcess.platform.userExtensionDir

(
var step;
step=40;
w = Window.new('test', Rect(20, 20, 800, step*3.6)).front;

SynthDef(\square, {
	|out, freq=440, pw=0.5, ff=440, fq=0.2, pan=0, attack=0.05, decay=0.1, sustain=0.8, release=0.3, amp=1|
	var signal, filter, env;
	env = env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate:1, doneAction:2);
	signal = Pulse.ar(freq, pw);
	filter = MoogFF.ar(in: signal, freq:ff, gain:fq);
	Out.ar(out, Pan2.ar(filter*env*amp, pan))
}).send(s);

Synth(\square).autogui(window: w, step:step);
)