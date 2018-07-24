thisProcess.platform.userExtensionDir;
MIDIClient.init;
MIDIClient.destinations[1];
//~mOut = MIDIOut.new("MS-20 mini-MS-20 mini MIDI 1").latency_(Server.default.latency);
~mOut = MIDIOut(1);
~mOut.connect(1);
~mOut.noteOn(0, note: 62, veloc: 64);
~mOut.noteOff(0);
~mOut.allNotesOff(0);


(
//MIDIClient.init;
//~mOut = MIDIOut(1);
//~mOut.connect(1);
TempoClock.default.tempo = 200/60;

~seq2pattern = {
	|sequence|
	//(seq: ..., start:..., end:..., repeats: ...)
	var notes, durs, legato, ranges;

//	ranges = {
//		|x|
//		var start, end, repeats;
//		if(x.start==nil, {start=0}, {start=x.start});
//		if(x.end==nil, {end=x.seq.notes.size+1}, {end=x.end});
//		if(x.repeats==nil, {repeats=1}, {repeats=x.repeats});
//		[start, end, repeats]
//	};

	"=======>>>>>>".postln;
	//ranges.value(sequence).postln;

	notes = sequence.collect({
		|x|
		var start, end, repeats;
		if(x.start==nil, {start=0}, {start=x.start});
		if(x.end==nil, {end=x.seq.notes.size+1}, {end=x.end});
		if(x.repeats==nil, {repeats=1}, {repeats=x.repeats});
		[start, end, repeats].postln;
		x.seq.notes[start..end] ! repeats}
	).flatten(2);

	notes.postln;

	durs = sequence.collect({
		|x|
		var start, end, repeats;
		if(x.start==nil, {start=0}, {start=x.start});
		if(x.end==nil, {end=x.seq.notes.size+1}, {end=x.end});
		if(x.repeats==nil, {repeats=1}, {repeats=x.repeats});
		x.seq.durs[start..end] ! repeats}
	).flat;

	legato = sequence.collect({
		|x|
		var start, end, repeats;
		if(x.start==nil, {start=0}, {start=x.start});
		if(x.end==nil, {end=x.seq.notes.size+1}, {end=x.end});
		if(x.repeats==nil, {repeats=1}, {repeats=x.repeats});
		x.seq.legato[start..end] ! repeats}
	).flat;
	(notes: notes, durs: durs, legato: legato)
};

SynthDef(\bass, {
	|out, freq=440, ff=600, width=0.4, fq=4, fenvscale, fb, pan=0, amp=1, attack=0.01, decay=0.04, sustain=0.8, release=0.2, gate=1|
	var sig, filter, env;

	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	sig = Pulse.ar(freq, width: width+LFTri.kr(TempoClock.default.tempo/100, iphase:0.25*pi)*1.3);
	filter = MoogFF.ar(Mix.ar([sig, (sig*40).distort*0.25]), freq:ff+env*1.2+LFTri.kr(TempoClock.default.tempo/16, iphase:0.5*pi)*2.5, gain:2)*env*amp;

	Out.ar(out, filter!2)
}).add;



~seq = "D:/tmp/sequence.scd".load.();
~seq.main.size.postln;

~pat = ~seq2pattern.(
	//((seq:~seq.part1, repeats: 2) ! 4) ++
	//((seq: {[~seq.alt1, ~seq.alt2, ~seq.alt3].choose}, repeats: 2) ! 6) ++
	//((seq:~seq.part1, repeats: 2) ! 4) ++
	((seq: {[~seq.part2, ~seq.part2_1].choose}, repeats: 2) ! 4)

);



PmonoArtic(
//Pbind(
	//\type, \midi,
	//\midicmd, \noteOn,
	//\midiout, ~mOut,
	//\chan, 0,
	\bass,
	//\midinote, Pseq(~pat.notes.namemidi),
	\note, Pseq(~pat.notes.namemidi)-12,
	\dur, Pseq(~pat.durs),
	\legato, Pseq(~pat.legato),
	\amp, Pseq([1], inf)
).play;



)