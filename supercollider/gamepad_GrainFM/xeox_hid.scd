
(
HID.findAvailable;
~gamepad = HID.open( 3141, 17184 ); // XEOX Gamepad SL-6556-BK

~printing = { |...args| args.postln; };



~gamepad_mapping = (
	// by usage ID
	button_A: [\b1, ~carrier_300_up],
	button_B: [\b2, ~carrier_700_up],
	button_X: [\b3, ~modulator_300_up],
	button_Y: [\b4, ~modulator_700_up],

	button_L1: [\b5, ~index_up],
	button_R1: [\b6, ~carrier_500_up],
	button_L2: [\b7, ~index_down],
	button_R2: [\b8, ~modulator_500_up],

	button_L3: [\b11, ~carrier_900_up],
	button_R3: [\b12, ~modulator_900_up],

	button_back: [\b9, ~volume_down],
	button_start: [\b10, ~volume_up],

	// joysticks
	left_X: [\Joystick, ~set_carrier_freq],
	left_Y: [\Pointer, ~set_modulator_freq],

	right_X: [\X, ~set_density],
	right_Y: [\Y, ~set_overlap],
);

~gamepad_mapping.keys.do{
	|key|
	var control_id = ~gamepad_mapping[key][0];
	var function = ~gamepad_mapping[key][1];
	HIDdef.usage(key, {|val| function.value(key, val)}, control_id);
	// control.postln;
};


// forward, back, up, down
HIDdef.usage( \cross, {
	|...args|
	var button_id = args[1];

	switch(button_id.asInt,
		// 8, {"OFF".postln;},
		8, {x.set(\pan, 0); "PAN 0".postln},

		// 0, {"UP".postln},
		0, {~delay_time_up.value()},

		// 4, {"DOWN".postln},
		4, {~delay_time_down.value()},

		// 2, {"RIGHT".postln},
		2, {~pan_R.value()},

		// 6, {"LEFT".postln},
		6, {~pan_L.value()},
	);
}, \Hat_switch );


"========================= HID RESPONDERS READY".postln;
)




