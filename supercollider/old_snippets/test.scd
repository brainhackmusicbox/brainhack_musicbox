(
SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.01, sustain, 0.1), doneAction: 2);
    Out.ar(0, sig ! 2)
}).add;
)

~notes = ["C3", "C4"]
~durs = [1, 0.5]

(
p = Pbind(
    \instrument, \smooth,
    \midinote, Pseq(~notes.namemidi, inf),
    \dur, Pseq(~durs, inf)
).play;


)

72.midiname