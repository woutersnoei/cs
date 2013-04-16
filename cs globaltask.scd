(

/*
~cs.loadBuffers({ ~cs.globalStart }); // start the whole thing
*/

~cs = ~cs ? EM();

~cs.useNames = [ \spectrum, \wulpmix, \vogelspuur, \klapperen, \dejongens ];
~cs.useScapes = { |evt| evt.useNames.collect({ |item| evt[ item ] }) };

~cs.timeScale = 60; // minutes
~cs.verbose = true;

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

~cs.globalStart = { |evt|
	evt.globalEnd;
	evt.task = {
		var scapes, weights, index = -1;
		var time;
		scapes = evt.useScapes;
		loop { 
			weights = scapes.collect(_.weight) ++ [1];
			if( index >= 0 ) {
				weights.put( index, 0 );
			};
			index = (..weights.size-1).wchoose( weights );
			scapes.do(_.end);
			scapes[index] !? _.start;
			time = ((1 rrand: ((scapes[index] !? _.playTime) ? 10)) * evt.timeScale);
			if( evt.verbose ) { "playing % %\n".postf( evt.useNames[index], time.asSMPTEString ) };
			time.wait;
		};
	}.fork;
	evt.losseroepen.start;
};

~cs.startSpecific = { |evt, which|
	evt.globalEnd;
	evt[ which ] !? _.start;
};

~cs.globalEnd = { |evt|
	evt.task.stop;
	evt.losseroepen.end;
	evt.stopAll;
};

~cs.stopAll = { |evt|
	evt.useScapes.do(_.end)
};

)