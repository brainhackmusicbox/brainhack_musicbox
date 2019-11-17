// CONTROL FUNCTIONS to modify parameters of the synth 'x' (expected to be ready)
// ----------------------------------------------------------------------------------

~set_parameter = {
	|param_symbol, param_value, map_range|
	(param_symbol.asString++":"+map_range.map(param_value)).postln;
	x.set(param_symbol, map_range.map(param_value));
};
// ====================================================
~parameter_up = {
	|param_symbol, param_max, delta|
	x.get(param_symbol, {
		|current_value|
		if ((current_value + delta) < param_max)
		{
			current_value = current_value + delta;
			(param_symbol.asString++":"+current_value).postln;
			x.set(param_symbol, current_value)
		}
		{
			("MAX"+param_symbol.asString).postln;
		}
	});
};

~parameter_down = {
	|param_symbol, param_min, delta|
	x.get(param_symbol, {
		|current_value|

		if ((current_value - delta) > param_min)
		{
			current_value = current_value - delta;
			(param_symbol.asString++":"+current_value).postln;
			x.set(param_symbol, current_value)
		}
		{
			("MIN"+param_symbol.asString).postln;
		}
	});
};

~parameter_up_down = {
	|param_symbol, button_value, delta|

	x.get(param_symbol, {
		|current_value|
		if (button_value == 1)
		{
			x.set(param_symbol, (current_value+delta));
			(param_symbol.asString+"UP"+(current_value+delta)).postln;
		}
		{
			x.set(param_symbol, (current_value-delta));
			(param_symbol.asString+"BACK"+(current_value-delta)).postln;
		}
	}
		);
};
// ====================================================
~set_density = {
	|key, value|
	~set_parameter.value(\density, value, [10, 110].asSpec);
};
// ====================================================
~set_overlap = {
	|key, value|
	~set_parameter.value(\overlap, value, [0.2, 4.0].asSpec);
};
// ====================================================
~set_carrier_freq = {
	|key, value|
	~set_parameter.value(\carrier_freq, value, [20, 2000, \exp].asSpec);
};
~set_modulator_freq = {
	|key, value|
	~set_parameter.value(\modulator_freq, value, [50, 2000, \exp].asSpec);
};
// ====================================================
~volume_up = {~parameter_up.value(\amp, ~volume_max, 0.01)};
~volume_down = {~parameter_down.value(\amp, ~volume_min, 0.01)};

~index_up = {~parameter_up.value(\index, ~index_max, 1)};
~index_down = {~parameter_down.value(\index, ~index_min, 1)};

~pan_L = {~parameter_down.value(\pan, ~pan_min, 0.8)};
~pan_R = {~parameter_up.value(\pan, ~pan_max, 0.8)};

~delay_time_up = {~parameter_up.value(\delay_time, ~delay_max, 0.2)};
~delay_time_down = {~parameter_down.value(\delay_time, ~delay_min, 0.2)};

~carrier_300_up = {|key, button_value| ~parameter_up_down.value(\carrier_freq, button_value, 300)};
~modulator_300_up = {|key, button_value| ~parameter_up_down.value(\modulator_freq, button_value, 300)};

~carrier_500_up = {|key, button_value| ~parameter_up_down.value(\carrier_freq, button_value, 500)};
~modulator_500_up = {|key, button_value| ~parameter_up_down.value(\modulator_freq, button_value, 500)};

~carrier_700_up = {|key, button_value| ~parameter_up_down.value(\carrier_freq, button_value, 700)};
~modulator_700_up = {|key, button_value| ~parameter_up_down.value(\modulator_freq, button_value, 700)};

~carrier_900_up = {|key, button_value| ~parameter_up_down.value(\carrier_freq, button_value, 900)};
~modulator_900_up = {|key, button_value| ~parameter_up_down.value(\modulator_freq, button_value, 900)};


"========================= CONTROL FUNCTIONS LOADED".postln;