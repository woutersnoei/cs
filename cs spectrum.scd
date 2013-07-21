(
~cs = ~cs ? EM();

~cs.spectrum = ~cs.spectrum ? EM();

~cs.spectrum.amp = 0.8;

~cs.spectrum.playTime = 10; // in minutes
~cs.spectrum.weight = 1; 

~cs.spectrum.loadBuffers = { |evt, action|
	evt.buffersSlow = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
		"/moniek/spectrum/slow", nil, "aif", action: {	
			evt.buffersRitme = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
				"/moniek/spectrum/met_ritme", nil, "aif", action: { action.value( evt ) } );
		}
	);
};

/*
~cs.spectrum.loadBuffers( { "done".postln } );
*/

SynthDef( "cs_playbuf_long", { |bufnum = 0, 
		amp = 0.5, panSpeed = 0.1, sustain = 1, rate = 1, verblevel = 0,
		jumpTime = 30, fadeTime = 4, shift = 0, spectrumGate = 1|
	var sig, pan;
	sig = PlayBufCF.ar( 2, bufnum, rate, 
		TDuty.kr( Dwhite( jumpTime * 0.5, jumpTime * 2 ) ),
		WhiteNoise.kr.range(0,BufFrames.kr(bufnum) ),
		loop: 1,
		lag: jumpTime * 0.25
	) * amp;
	sig = BLowCut.ar(sig,50,3);
	sig = FreqShift.ar( sig, shift );
	pan = LFDNoise3.kr(panSpeed);
	sig = Balance2.ar( sig[0], sig[1], pan );
	sig = sig * Env([0,1,1,0],[
		fadeTime,
		sustain,
		fadeTime]
	).kr(2);
	sig = sig * Env.cutoff.kr(2,spectrumGate);
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

/*
Synth( "cs_playbuf_long", [ \bufnum, ~cs.spectrum.buffersSlow[0], \sustain, 10, \verblevel, 0.2 ] );

(
Synth( "cs_playbuf_long", [ 
	\bufnum, ~cs.spectrum.buffersSlow[0], \sustain, 10, \verblevel, 0.2,
	\rate, 0.9, \shift, 700
] );
);
*/

~cs.spectrum.start = { |evt|
	evt.end;
	evt.pat1 = 2.collect({		
		Pbind( 
			\instrument, "cs_playbuf_long",
			\dur, Pwhite( 15, 35 ),
			\legato, Prand( [0.5,1],inf ),
			\amp, Pfunc({ evt.amp ? 0.5 }),
			\rate, Pwhite( 0.5, 1.2 ),
			\shift, Pwhite( -200, 600 ),
			\bufnum, Prand( evt.buffersSlow, inf ),
			\verblevel, Pwhite( 0.0, 0.4 ),
			\pan, Pwhite( -1.0, 1.0 )
		).play;
	});
	evt.pat2 = Pbind( 
			\instrument, "cs_playbuf_long",
			\dur, Pwhite( 15, 35 ),
			\legato, Prand( [0.25,0.5,1],inf ),
			\amp, Pseq( [0, Pseq([Pfunc({ evt.amp ? 0.5 })],inf)],1),
			\rate, Pwhite( 0.25, 1 ),
			\fadeTime, 0.1,
			\shift, Pwhite( -100, 700 ),
			\bufnum, Prand( evt.buffersRitme, inf ),
			\verblevel, Pwhite( 0.0, 0.5 ),
			\pan, Pwhite( -1.0, 1.0 )
	).play;
};

~cs.spectrum.end = { |evt|
	evt.pat1.do(_.stop);
	evt.pat2.stop;
	RootNode(s).set( \spectrumGate, 0 );
};
)

/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.spectrum.start;
);
~cs.spectrum.end;
~srw.stop;
*/

/*

 RootNode(s).set( \spectrumGate, 0 );

(
a.do(_.stop);
a = 2.collect({	
		Pbind( 
		\instrument, "cs_playbuf2",
		\stutterTime, Pwhite( 1, 6 ),
		\bufIndex, Pstutter( Pkey( \stutterTime ), Pwhite(0, ~cs.vogelspuur.buffers.size.asInt - 1) ),
		\dur, Pwhite( 0.1, 0) + Pstutter( Pkey( \stutterTime ), Pwhite( 0.5, 2.5 ) ),
		\legato, Pstutter( Pkey( \stutterTime ), Pwrand([0.5,1],[0.1,0.9],inf)),
		\amp, Pstutter( Pkey( \stutterTime ), Pwrand([0,1],[0.25,0.75],inf) * 0.75 ),
		\rate, Pwhite( 0.99, 1.01 ),
		\bufnum, Pindex( ~cs.vogelspuur.buffers, Pkey( \bufIndex ) , inf ),
		\startPos, Pstutter( 
			Pkey( \stutterTime ), 
			Pwhite( 0.0, Pindex( ~cs.vogelspuur.buffers.collect(_.duration), Pkey( \bufIndex ) ) -
				Pkey( \dur ) 
			)
		),
		\verblevel, Pstutter( Pkey( \stutterTime ), Pwhite( 0.0, 0.25 ) ),
		\pan, Pstutter( Pkey( \stutterTime ), Pwhite( -1.0, 1.0 ) )
	).play;
});
)

(
b.stop;
b = Pbind( 
	\instrument, "cs_playbuf2",
	//\bufIndex, Pwhite(0, ~cs.vogelspuur.bufferLos.size.asInt - 1 ),
	\bufIndex, 0,
	\dur, Pstutter( Pwhite(1,3), Pwhite( 1, 15 ) ),
	//\dur, 2,
	\sustain, 1.9,
	\amp, Pwhite( 0.0, 1 ).linexp(0,1,0.25,1),
	\rate, Pwhite( 0.99, 1.01 ),
	\bufnum, Pindex( ~cs.vogelspuur.bufferLos, Pkey( \bufIndex ), inf ),
	\startPos, 
		Pwhite( 0, Pindex( ~cs.vogelspuur.bufferLos.collect({ |item| (item.duration / 2).asInt }),
			Pkey( \bufIndex ), inf ) ) * 2,
	\verblevel, Pwhite( 0.0, 0.5 ),
	\pan, Pwhite( -1.0, 1.0 )
).play;
)

*/


/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.klapperen.start;
);
~cs.klapperen.end;
~srw.stop;
*/
