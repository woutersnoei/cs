(
~cs = ~cs ? EM();

~cs.losseroepen = ~cs.losseroepen ? EM();

~cs.losseroepen.amp = 0.5;

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
	sig = BHiShelf.ar(sig, 1500, 1, 7 );
	sig = BPeakEQ.ar(sig, 400, 1, -5 );
	sig = Balance2.ar( sig[0], sig[1], pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

SynthDef( "cs_mindyourwords", { |bufnum = 0, amp = 0.1, pan = 0, verblevel = 0|
	var sig;
	sig = PlayBuf.ar( 1, bufnum, doneAction: 2) * amp;
	sig = BHiShelf.ar(sig, 1500, 1, 14 );
	sig = BPeakEQ.ar(sig, 400, 1, -5 );
	sig = Pan2.ar( sig, pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

SynthDef( "cs_meeuwenmix", { |bufnum = 0, sustain = 2, startOffset = 0, 
		amp = 0.1, pan = 0, verblevel = 0|
	var sig;
	startOffset = startOffset * ( ( BufDur.kr( bufnum ) - sustain ) * SampleRate.ir );
	sig = PlayBuf.ar( 2, bufnum, 1, 1, startOffset ) * 2 * amp;
	sig = sig * Env([0,1,0], [0.5,0.5] * sustain, [-2,2]).kr(2);
	sig = BPeakEQ.ar(sig, 1000, 1, 6 );
	sig = BHiShelf.ar(sig, 1500, 1, -6 );
	sig = Balance2.ar( sig[0], sig[1], pan );
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;


(
~cs.losseroepen.startMokraai = { |evt|
	var startBuf, buffers, durs, amps, amp;
	startBuf = (evt.mokraai.size / 3).asInteger.rand * 3;
	buffers = evt.mokraai[startBuf..startBuf+2];
	durs = buffers.collect(_.duration);
	amps = evt.mokraai_amps[startBuf..startBuf+2];
	amp = evt.mokraai_amps.mean / amps.mean;
	Pbind( 
		\instrument, "cs_mokraai", 
		\amp, evt.amp * amp,
		\bufnum, Pseq( evt.mokraai[startBuf..startBuf+2], 1 ),
		\dur, (1.0 rrand: 1.4) * durs.mean,
		\pan, Pseq([0,1,2].linlin(0,2,1.0.rand2,1.0.rand2),1),
		\verblevel, Pseq([0,1,2].linlin(0,2,0.1.rand,0.1.rand),1)
	).play;
};

~cs.losseroepen.startMindyourwords = { |evt|
	var index, amp;
	index = evt.mindyourwords.size.asInteger.rand;
	amp = evt.mindyourwords_amps.mean / evt.mindyourwords_amps[ index ];
	Synth( "cs_mindyourwords", [ 
		\bufnum, evt.mindyourwords[ index ], 
		\amp, evt.amp * amp * 0.75,
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
		\verblevel, 0.2.rand
	]);
};
);

~cs.losseroepen.setVolume = {
	if( Date.localtime.hour.inclusivelyBetween( 2, 4 ) ) {
		s.volume = -16.5;
	} {
		s.volume = -12;
	};
};

/*
~cs.losseroepen.startMeeuwenmix;
~cs.losseroepen.startMindyourwords;
~cs.losseroepen.startMokraai;
~cs.losseroepen.setVolume;
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
			evt.setVolume;
			(evt.waitTime * (0.5 exprand: 2)).wait;
		};
	}).start;
};

~cs.losseroepen.end = { |evt|
	evt.task.stop;
};

(
~cs.losseroepen.mokraai_amps = [ 0.458984375, 0.60861206054688, 0.48779296875, 0.44894409179688, 0.3907470703125, 0.5648193359375, 0.26461791992188, 0.33770751953125, 0.31021118164062, 0.4324951171875, 0.3212890625, 0.5074462890625, 0.18634033203125, 0.121826171875, 0.23248291015625, 0.04705810546875, 0.071319580078125, 0.10189819335938, 0.15725708007812, 0.1810302734375, 0.15740966796875, 0.343017578125, 0.376220703125, 0.27017211914062, 0.070526123046875, 0.097320556640625, 0.082611083984375, 0.092437744140625, 0.084503173828125, 0.12826538085938, 0.10214233398438, 0.11148071289062, 0.10784912109375, 0.0989990234375, 0.12762451171875, 0.12533569335938 ];
);

~cs.losseroepen.mindyourwords_amps = [ 0.056693185120821, 0.065642490983009, 0.1377746462822 ];
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
