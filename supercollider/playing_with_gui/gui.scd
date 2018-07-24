(
SynthDef(\test, {
	|out, freq=220, width=0.5, ff=440, q=1, amp=1, attack=4, decay=0.5, sustain=0.8, release=2.5, gate=0|
	var env, signal, filter;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	signal = Pulse.ar(freq.lag(0.2), width: width)*env*amp;
	filter = MoogFF.ar(signal, ff, q);
	Out.ar(out, filter!2)
	}
).add;


//==================================================================================
// UI ------------------------------------------------------------------------------
Window.closeAll;
w = Window('gui', Rect(750, 50, 530, 530)).front.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 10@10, 10@10));
~wh = 25;
~bgcolor = Color(0.15, 0.50, 0.8);

c = Array.fill(4, {
	|view|
	view = CompositeView(w, 250@250).background_(Color.new255(28, 93, 130));
	view.decorator_(FlowLayout(view.bounds, 5@5, 5@5));
});

//=================================================================

~slider_freq = Slider(c[0], Rect(0,0,100,~wh)).background_(~bgcolor).thumbSize_(20).action_({
	|obj|
	var val = obj.value.linexp(0, 1, 80, 800);
	~numberbox_freq.value_(val);
	if(~synth.isPlaying, {~synth.set('freq', val)});
});
~numberbox_freq = NumberBox(c[0], Rect(0, 0, 30, ~wh));



//CompositeView(c[0], Rect(0, 0, 25, ~wh));

~knob_width = Knob(c[0], Rect(0, 0, 30, ~wh)).action_({
	|obj|
	var val = obj.value.linlin(0,1, 0.2, 0.9);
	~numberbox_width.value_(val);
	if(~synth.isPlaying, {~synth.set('width', val)});
});
~numberbox_width = NumberBox(c[0], Rect(0, 0, 30, ~wh));
//-----------------------------------------------------------------
c[0].decorator.nextLine;
~text_freq = StaticText(c[0], Rect(0, 0, 135, ~wh/2)).stringColor_(Color.white).string_('Freq');
~text_width = StaticText(c[0], Rect(0, 0, 55, ~wh/2)).stringColor_(Color.white).string_('Width');
//-----------------------------------------------------------------
c[0].decorator.nextLine;
c[0].decorator.nextLine;
c[0].decorator.nextLine;

~slider_ff = Slider(c[0], Rect(0,0,100,~wh)).background_(~bgcolor).thumbSize_(20).action_({
	|obj|
	var val = obj.value.linexp(0, 1, 80, 800);
	~numberbox_ff.value_(val);
	if(~synth.isPlaying, {~synth.set('ff', val)});
});
~numberbox_ff = NumberBox(c[0], Rect(0, 0, 30, ~wh));

~knob_q = Knob(c[0], Rect(0, 0, 30, ~wh)).action_({
	|obj|
	var val = obj.value.linlin(0, 1, 0, 4);
	~numberbox_q.value_(val);
	if(~synth.isPlaying, {~synth.set('q', val)});
});
~numberbox_q = NumberBox(c[0], Rect(0, 0, 30, ~wh));
//-----------------------------------------------------------------
c[0].decorator.nextLine;
~text_freq = StaticText(c[0], Rect(0, 0, 135, ~wh/2)).stringColor_(Color.white).string_('Filter Freq');
~text_width = StaticText(c[0], Rect(0, 0, 55, ~wh/2)).stringColor_(Color.white).string_('Filter Q');


//and 4 spaces before the button
2.do{ c[0].decorator.nextLine; CompositeView(c[0], Rect(0, 0, 25, ~wh)); c[0].decorator.nextLine};

//-----------------------------------------------------------------
~button_off = Button(c[0], Rect(0, 200, 50, ~wh))
.states_([
	['OFF', Color.black, Color.gray(0.8)],
	['ON', Color.white, ~bgcolor]
]).action_(){
	|obj|
	if(obj.value==1,
		{~synth = Synth(\test, [gate: 1, freq: ~slider_freq.value.linexp(0, 1, 80, 800)]).register},
		{~synth.set('gate', obj.value)});
};

// END OF UI -----------------------------------------------------------------------
//----------------------------------------------------------------------------------
)

~synth.set('gate', 0)

