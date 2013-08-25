(
~cs = ~cs ? EM();

~cs.wulpmix = ~cs.wulpmix ? EM();

~cs.wulpmix.amp = 0.75;

~cs.wulpmix.playTime = 10; // in minutes
~cs.wulpmix.weight = 1; 
~cs.wulpmix.density = 0.25; 

~cs.wulpmix.loadBuffers = { |evt, action|
	evt.buffers = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
		"/moniek/vogels_puur/wulp", nil, "wav", action: {
		evt.loopbuffers = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
			"/moniek/loops", nil, "aif", action: { action.value(evt) } );
	});
};

/*
~cs.wulpmix.loadBuffers( { "done".postln } ); "";
*/

SynthDef( "cs_playbuf_loop",{  |bufnum = 0, amp = 0.5, sustain = 1, 
		rate = 1, verblevel = 0,
		fadeTime = 0.05, puurGate = 1|
	var sig, pan, freq;	
	pan = LFDNoise3.kr( 0.1 );
	sig = PlayBuf.ar( 2, bufnum, rate, loop: 1 ) * amp;
	freq = SinOsc.kr( 1/Rand(10,15) ).exprange(1000,20000);
	sig = OnePole.ar( sig, ( -2pi * (freq / SampleRate.ir) ).exp );
	sig = Balance2.ar( sig[0], sig[1], pan );
	sig = sig * Env([0,1,1,0],[
		fadeTime,
		sustain,
		fadeTime]
	).kr(2);
	sig = sig * Env.cutoff.kr(2,puurGate);
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

SynthDef( "cs_playbuf_stretch", { |bufnum = 0, amp = 0.5, pan = 0, sustain = 1, 
		rate = 1, stretch = 1, tvar = 0, pvar = 0, shuffleAmt = 0, shuffleSpeed = 0.5, shuffleRate = 1,
		speed = 0.1, verblevel = 0,
		fadeTime = 0.05, puurGate = 1|
	var sig, trigger, startPos;	
	rate = rate * stretch;
	startPos = Phasor.ar( 0, 
		rate * shuffleRate * Duty.ar( Dwhite(0.5, 2) / rate, 0, Dseq([1,-1],inf) ), 
		Impulse.ar(0) * Rand( 0, BufFrames.ir( bufnum ) ), BufFrames.kr( bufnum )
	);
	trigger = TDuty.ar( Dwhite( 0.5/shuffleSpeed, 2/shuffleSpeed ) );
	sig = PlayBufCF.ar( 2, bufnum, rate, trigger, 
		startPos + WhiteNoise.ar( shuffleAmt * SampleRate.ir 
	), lag: 0.025 loop: 1 ) * amp;
	sig = PitchShift.ar( sig, [0.1,0.11], 1/stretch, pvar, tvar );
	sig = Balance2.ar( sig[0], sig[1], pan );
	sig = sig * Env([0,1,1,0],[
		fadeTime,
		sustain,
		fadeTime]
	).kr(2);
	sig = sig * Env.cutoff.kr(2,puurGate);
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

~cs.wulpmix.start = { |evt|
	evt.end;
	evt.pat1 = 2.collect({	
			Pbind(
			\instrument, "cs_playbuf_stretch",
			\bufnum, Prand( ~cs.wulpmix.buffers, inf ),
			\dur, Pwhite( 5, 40, inf ),
			\amp, Pwhite(0,1).linexp(0,1,0.5,1) * Pfunc({ evt.amp ? 0.5 }),
			\legato, Pwrand([1,0.5], [evt.density, 1 - evt.density].normalizeSum, inf),
			\stretch, Pwhite(0.0,1).linexp(0,1,0.75,3),
			\rate, Pwhite(0.0,1).linexp(0,1,0.75,2),
			\shuffleAmt, Prand([0,0.1], inf),
			\tvar, Pwrand([0,0.1], [0.75, 0.25], inf), 
			\pvar, Pwrand([0,0.01], [0.75,0.25], inf),
			\verblevel, Pwhite( 0.0, 0.4, inf ),
			\pan, Pwhite( -1, 1 )
		).play;
	});
	evt.pat2 = Pbind(
		\instrument, "cs_playbuf_loop",
		\bufnum, Prand( ~cs.wulpmix.loopbuffers, inf ),
		\dur, Pwhite( 5, 40, inf ),
		\amp, Pfunc({ evt.amp ? 0.5 }),
		\legato, Pwrand([2,1,0.5], [evt.density, 0.5, 1 - evt.density].normalizeSum, inf)
	).play;
};

~cs.wulpmix.end = { |evt|
	evt.pat1.do(_.stop);
	evt.pat2.stop;
	RootNode(s).set( \puurGate, 0 );
};
)

/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.wulpmix.start;
);
~cs.wulpmix.end;
~srw.stop;
*/


/*
(
2.do({
		Pbind(
		\instrument, "cs_playbuf_stretch",
		\bufnum, Prand( ~cs.wulpmix.buffers, inf ),
		\dur, Pwhite( 5, 40, inf ),
		\amp, Pwhite(0,1).linexp(0,1,0.25,0.5),
		\legato, Prand([1,0.5], inf),
		\stretch, Pwhite(0.0,1).linexp(0,1,0.75,3),
		\rate, Pwhite(0.0,1).linexp(0,1,0.75,2),
		\shuffleAmt, Prand([0,0.1], inf),
		\tvar, Prand([0,0.1], inf), 
		\pvar, Prand([0,0.01], inf),
		\verblevel, Pwhite( 0.0, 0.2, inf ),
		\pan, Pwhite( -0.5, 0.5 )
	).play;
});

Pbind(
	\instrument, "cs_playbuf_loop",
	\bufnum, Prand( ~cs.wulpmix.loopbuffers, inf ),
	\dur, Pwhite( 5, 40, inf ),
	\amp, 0.5,
	\legato, Prand([2,1,0.5], inf),
).play;
)
*/
