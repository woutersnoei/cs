(
~cs = ~cs ? EM();

~cs.losseroepen = ~cs.losseroepen ? EM();

~cs.losseroepen.amp = 0.75;

~cs.losseroepen.waitTime = 30; // gemiddelde wachttijd

~cs.losseroepen.loadBuffers = { |evt, action|
	{	
		var cond;
		cond = Condition(false);
		evt.mokraai = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
			"/moniek/mokraai", nil, "aif", action: { cond.test = true; cond.signal });
		cond.wait;
		cond.test = false;
		evt.mindyourwords = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
			"/moniek/mind_your_words", nil, "wav", action: { cond.test = true; cond.signal });
		cond.wait;
		cond.test = false;
		evt.meeuwenmix = Buffer.read( s, thisProcess.nowExecutingPath.dirname.dirname +/+ 
			"/moniek/meeuwenmix.wav", action: { cond.test = true; cond.signal });
		cond.wait;
		action.value;
	}.fork;
};

/*
~cs.losseroepen.loadBuffers( { "done".postln } ); "";
*/

SynthDef( "cs_mokraai", { |bufnum = 0, amp = 0.1, pan = 0, verblevel = 0|
	var sig;
	sig = PlayBuf.ar( 2, bufnum, doneAction: 2) * amp;
	sig = Balance2.ar( sig[0], sig[1], pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

SynthDef( "cs_mindyourwords", { |bufnum = 0, amp = 0.1, pan = 0, verblevel = 0|
	var sig;
	sig = PlayBuf.ar( 1, bufnum, doneAction: 2) * amp;
	sig = Pan2.ar( sig, pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

SynthDef( "cs_meeuwenmix", { |bufnum = 0, sustain = 2, startOffset = 0, 
		amp = 0.1, pan = 0, verblevel = 0|
	var sig;
	startOffset = startOffset * ( ( BufDur.kr( bufnum ) - sustain ) * SampleRate.ir );
	sig = PlayBuf.ar( 2, bufnum, 1, 1, startOffset ) * amp;
	sig = sig * Env([0,1,0], [0.5,0.5] * sustain, [-2,2]).kr(2);
	sig = Balance2.ar( sig[0], sig[1], pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;


(
~cs.losseroepen.startMokraai = { |evt|
	var startBuf;
	startBuf = (evt.mokraai.size / 3).asInt.rand;
	Pbind( 
		\instrument, "cs_mokraai", 
		\amp, evt.amp,
		\bufnum, Pseq( evt.mokraai[startBuf..startBuf+2], 1 ),
		\dur, 1.0 rrand: 1.4,
		\pan, Pseq([0,1,2].linlin(0,2,1.0.rand2,1.0.rand2),1),
		\verblevel, Pseq([0,1,2].linlin(0,2,0.1.rand,0.1.rand),1)
	).play;
};

~cs.losseroepen.startMindyourwords = { |evt|
	Synth( "cs_mindyourwords", [ 
		\bufnum, evt.mindyourwords.choose, 
		\amp, evt.amp,
		\pan, 1.0.rand2
	]);
};

~cs.losseroepen.startMeeuwenmix = { |evt|
	Synth( "cs_meeuwenmix", [ 
		\bufnum, evt.meeuwenmix, 
		\sustain, 3.0 rrand: 5.0,
		\startOffset, 1.0.rand,
		\amp, evt.amp,
		\pan, 1.0.rand2,
		\verblevel, 0.1.rand
	]);
};
);

/*
~cs.losseroepen.startMeeuwenmix;
~cs.losseroepen.startMindyourwords;
~cs.losseroepen.startMokraai;
*/

~cs.losseroepen.start = { |evt|
	evt.end;
	evt.task = Task({
		loop {			
			evt.perform( [
				\startMeeuwenmix,
				\startMindyourwords,
				\startMokraai
			].choose );
			(evt.waitTime * (0.5 exprand: 2)).wait;
		};
	}).start;
};

~cs.losseroepen.end = { |evt|
	evt.task.stop;
};
)

/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.losseroepen.start;
);
~cs.losseroepen.end;
~srw.stop;
*/
