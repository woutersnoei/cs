(

/*
~cs.loadBuffers({ ~cs.globalStart }); // start the whole thing
*/

~cs = ~cs ? EM();

~cs.useNames = [ \spectrum, \wulpmix, \vogelspuur, \klapperen, \dejongens ];
~cs.useScapes = { |evt| evt.useNames.collect({ |item| evt[ item ] }) };

~cs.timeScale = 60; // minutes

~cs.loadBuffers = { |evt, action|
	{
		var cond;
		cond = Condition(false);
		evt.useScapes.do({ |item|
			item.loadBuffers( { cond.test = true; cond.signal } );
			cond.wait;
			cond.test = false;
		});
		evt.losseroepen.loadBuffers( { cond.test = true; cond.signal } );
		cond.wait;
		action.value(evt);
	}.fork;
};

~cs.startSoundScapes = { |evt, startWith|
	evt.endSoundScapes;
	evt.task = {
		var scapes, weights, index = -1;
		var time;
		scapes = evt.useScapes;
		index = (evt.useNames.size + 1).rand;
		if( startWith.notNil ) { index = evt.useNames.indexOf( startWith ) ? index; };
		loop { 
			scapes.do(_.end);
			scapes[index] !? _.start;
			time = ((1 rrand: ((scapes[index] !? _.playTime) ? 10)) * evt.timeScale);
			if( evt.verbose ? true ) { "playing % %\n".postf( evt.useNames[index], time.asSMPTEString ) };
			time.wait;
			weights = scapes.collect(_.weight) ++ [1];
			if( index >= 0 ) {
				weights.put( index, 0 );
			};
			index = (..weights.size-1).wchoose( weights.normalizeSum );
		};
	}.fork;
};

~cs.endSoundScapes = { |evt|
	evt.task.stop;
	evt.useScapes.do(_.end);
};

~cs.startSpecific = { |evt, which, playForever = false|
	if( playForever ) {
		evt.endSoundScapes;
		evt[ which ] !? _.start;
	} {
		evt.startSoundScapes( which );
	}
};

~cs.globalStart = { |evt|
	evt.globalEnd;
	evt.startSoundScapes;
	evt.losseroepen.start;
};

~cs.globalEnd = { |evt|
	evt.endSoundScapes;
	evt.losseroepen.end;
};

)