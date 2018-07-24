thisProcess.platform.userExtensionDir

(
o = Server.local.options;
o.device ="ASIO4ALL"; //must die
o.sampleRate= 44100;
o.blockSize = 8192*2;
o.memSize = 8192*32;
//o.threads see supernova
//o.dump;
s.boot;

)


~newQuarksSourceForge = Quarks.new( "https://svn.code.sf.net/p/quarks/code/", Platform.userAppSupportDir +/+ "quarks");
~newQuarksSourceForge.updateDirectory;
~newQuarksSourceForge.gui;


Platform.userAppSupportDir;
Quarks.install("E:/dl_quarks");
Quarks.install("wslib");
Quarks.initClass
Server.default.makeWindow
Quarks.gui



(
f = SimpleMIDIFile.read("F:\tmp\bass.mid");
f.postln;
f.timeMode = \seconds;

(//play midi file
SynthDef( "organ", { |freq = 440, sustain = 1, amp = 0.1|
var sig;
sig = LFCub.ar( freq * [1,2,3,5], 0, amp/[2,4,5,7] );
Out.ar( 0, Env([0,1,1,0], [0.025,sustain,0.025]).kr(2) * sig.dup )
}).add;
);

x = f.p( \organ ).play;
)
