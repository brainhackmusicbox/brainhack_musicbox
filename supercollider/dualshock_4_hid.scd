
(
HID.findAvailable;

// ~gamepad = HID.open( 1356, 1476); // dual shock 4

~gamepad = HID.open( 1356, 2508); // dual shock 4
// ~gamepad.postElements;

// ~gamepad.action = { | value, physValue, rawValue, arrayValue, usage, page, elid | "HID device action: ".post; [value, physValue, rawValue, arrayValue, usage, page, elid].postln; };

//
// ~gamepad.action = {
// 	| value, physValue, rawValue, arrayValue, usage, page, elid |
// "HID device action: ".post; [value, usage, page, elid].postln};
//

)

(
HIDdef.usage( \example,
	{ |...args|
		x = args[5];
		// v = args[1];
		// args.postln;
		x.id.postln;


		// 545, 548, 549 WTF
		/*if(
			(x.id > 549) && (x.id < 580 ),
			{(x.id.asString + x.value.asString).postln},
			{"x>549".postln}
			{(x.id.asString + x.value.asString).postln
		);*/

});

)
HIDFunc.element({ |...args| args[12].postln; }, [0]);//square










HIDdef.freeAll