(
var subtr, fx;

SynthDef(\synth, {
	|out, freq=20, width=0.1, ff=220, q=0, amp=0, attack=4, decay=0.5, sustain=0.8, release=2.5, gate=0|
	var env, signal, filter, out_signal;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	signal = Pulse.ar(freq.lag(0.2), width: width)*env*amp;
	filter = MoogFF.ar(signal, ff, q);
	out_signal = filter!2;
	ScopeOut.ar(out_signal, 0);
	Out.ar(out, out_signal)
	}
).add;

//==================================================================================
// UI ------------------------------------------------------------------------------

Window.closeAll;
w = Window('dronegen', 800@750, resizable:false).front.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 10@10, 10@10));
w.onClose_(){s.freeAll; ~fscope.kill};
w.front();
~voices_num = 6;
~wwidth = 25; // widgets width
~wheight = 100; // widgets height
~bgcolor = Color(0.15, 0.50, 0.8);
~knobcolor = Color.red;
~numberbox_font = Font("Arial", 9);
~slider_font = Font("Arial", 11, bold: true);

//subtractive synths sectors
subtr = Array.fill(6, {
	|view|
	view = CompositeView(w, 250@250).background_(Color.new255(28, 93, 130));
	view.decorator_(FlowLayout(view.bounds, 5@5, 5@2));
});

//effects sectors
//fx = Array.fill(2, {
//	|view|
//	view = CompositeView(w, 250@250).background_(Color.new255(28, 93, 130));
//	view.decorator_(FlowLayout(view.bounds, 5@5, 5@5));
//});
~fscope = FreqScopeView(w, 770@200);
~fscope.active_(true).freqMode_(1).dbRange_(100);



~slider_amp = nil ! ~voices_num;
~slider_freq = nil ! ~voices_num;
~slider_width = nil ! ~voices_num;
~slider_ff = nil ! ~voices_num;
~slider_q  = nil ! ~voices_num;

~numberbox_freq = nil ! ~voices_num;
~numberbox_width = nil ! ~voices_num;
~numberbox_amp = nil ! ~voices_num;
~numberbox_ff = nil ! ~voices_num;
~numberbox_q = nil ! ~voices_num;

~synth = nil ! ~voices_num;
~button_off = nil ! ~voices_num;

~knob_q = nil ! ~voices_num;





~voices_num.do({
	|sector|
	var sub, sliders, numberboxes, labels;
	sub = subtr[sector];
	sliders = CompositeView(sub, 250@100);
	sliders.decorator_(FlowLayout(sliders.bounds, 10@0, 20@5));
	~slider_amp = Slider(sliders, Rect(0,0,~wwidth,~wheight)).background_(~bgcolor).thumbSize_(20).knobColor_(~knobcolor).action_({
		|obj|
		var val = obj.value;
		~numberbox_amp[sector].value_(val);
		if(~synth[sector].isPlaying, {~synth[sector].set('amp', val)});
	});

	~slider_freq[sector] = Slider(sliders, Rect(0,0,~wwidth,~wheight)).background_(~bgcolor).thumbSize_(20).knobColor_(~knobcolor).action_({
		|obj|
		var val = obj.value.linexp(0, 1, 20, 5000);
		~numberbox_freq[sector].value_(val);
		if(~synth[sector].isPlaying, {~synth[sector].set('freq', val)});
	});

	~slider_width[sector] = Slider(sliders, Rect(0,0,~wwidth,~wheight)).background_(~bgcolor).thumbSize_(20).knobColor_(~knobcolor).action_({
		|obj|
		var val = obj.value.linlin(0,1, 0.1, 0.95);
		~numberbox_width[sector].value_(val);
		if(~synth[sector].isPlaying, {~synth[sector].set('width', val)});
	});

	~slider_ff[sector] = Slider(sliders, Rect(0,0,~wwidth,~wheight)).background_(~bgcolor).thumbSize_(20).knobColor_(~knobcolor).action_({
		|obj|
		var val = obj.value.linexp(0, 1, 20, 10000);
		~numberbox_ff[sector].value_(val);
		if(~synth[sector].isPlaying, {~synth[sector].set('ff', val)});
	});

	~slider_q[sector] = Slider(sliders, Rect(0,0,~wwidth,~wheight)).background_(~bgcolor).thumbSize_(20).knobColor_(~knobcolor).action_({
		|obj|
		var val = obj.value.linlin(0, 1, 0, 4);
		~numberbox_q[sector].value_(val);
		if(~synth[sector].isPlaying, {~synth[sector].set('q', val)});
	});

	//sub.decorator.nextLine;
	numberboxes = CompositeView(sub, 250@30);
	numberboxes.decorator_(FlowLayout(numberboxes.bounds, 10@0, 15@0));
	~numberbox_amp[sector] = NumberBox(numberboxes, Rect(0, 0, ~wwidth+5, ~wheight/5)).font = ~numberbox_font;
	~numberbox_freq[sector] = NumberBox(numberboxes, Rect(0, 0, ~wwidth+5, ~wheight/5)).font = ~numberbox_font;
	~numberbox_width[sector] = NumberBox(numberboxes, Rect(0, 0, ~wwidth+5, ~wheight/5)).font = ~numberbox_font;
	~numberbox_ff[sector] = NumberBox(numberboxes, Rect(0, 0, ~wwidth+5, ~wheight/5)).font = ~numberbox_font;
	~numberbox_q[sector] = NumberBox(numberboxes, Rect(0, 0, ~wwidth+5, ~wheight/5)).font = ~numberbox_font;

	//sub.decorator.nextLine;
	labels = CompositeView(sub, 250@18);
	labels.decorator_(FlowLayout(labels.bounds, 10@0, 18@2));
	~text_amp = StaticText(labels, Rect(0, 0, ~wwidth+4, ~wheight/5)).stringColor_(Color.white).string_('Amp').font = ~slider_font;
	~text_freq = StaticText(labels, Rect(0, 0, ~wwidth, ~wheight/5)).stringColor_(Color.white).string_('Freq').font = ~slider_font;
	~text_width = StaticText(labels, Rect(0, 0, ~wwidth+2, ~wheight/5)).stringColor_(Color.white).string_('Wave').font = ~slider_font;
	~text_ff = StaticText(labels, Rect(0, 0, ~wwidth+2, ~wheight/5)).stringColor_(Color.white).string_('Filter').font = ~slider_font;
	~text_q = StaticText(labels, Rect(0, 0, ~wwidth+10, ~wheight/5)).stringColor_(Color.white).string_('Fltr Q').font = ~slider_font;
	//-----------------------------------------------------------------



	30.do(){sub.decorator.nextLine};

	//-----------------------------------------------------------------
	~button_off[sector] = Button(sub, Rect(0, 200, 50, ~wwidth)).states_([
		['OFF', Color.black, Color.gray(0.8)],
		['ON', Color.white, ~bgcolor]]).action_(){
		|obj|
		if(obj.value==1,
			{~synth[sector] = Synth(\synth, [gate: 1, freq: ~slider_freq[sector].value.linexp(0, 1, 80, 800)]).register},
			{~synth[sector].set('gate', obj.value)});
	};
})




)


~synth.set('gate', 0)
