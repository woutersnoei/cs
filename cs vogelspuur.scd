(
~cs = ~cs ? EM();

~cs.vogelspuur = ~cs.vogelspuur ? EM();

~cs.vogelspuur.amp = 0.75;

~cs.vogelspuur.playTime = 10; // in minutes
~cs.vogelspuur.weight = 1; 
~cs.vogelspuur.density = 0.5; 

~cs.vogelspuur.loadBuffers = { |evt, action|
	evt.buffers = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
		"/moniek/vogels_puur/full", nil, "wav", action: { 
		evt.bufferLos = Buffer.readDir( thisProcess.nowExecutingPath.dirname.dirname +/+ 
			"/moniek/vogels_puur/separate_calls", nil, "wav", action: { action.value(evt) } );
	});
};

/*
~cs.vogelspuur.loadBuffers( { "done".postln } ); "";
*/

SynthDef( "cs_playbuf2", { |bufnum = 0, 
		startPos = 0, amp = 0.5, pan = 0, sustain = 1, rate = 1, verblevel = 0,
		fadeTime = 0.05, playbuf2gate = 1|
	var sig;
	sig = PlayBuf.ar( 2, bufnum, rate, 1, startPos * SampleRate.ir ) * amp;
	sig = Balance2.ar( sig[0], sig[1], pan );
	sig = sig * Env([0,1,1,0],[
		fadeTime,
		sustain.min( BufDur.kr( bufnum ) - (startPos + fadeTime) ),
		fadeTime]
	).kr(2);
	sig = sig * Env.cutoff.kr(2,playbuf2gate);
	PrivateOut.ar( 0, sig * verblevel );
	OffsetOut.ar( 0, sig );
}).store;

~cs.vogelspuur.start = { |evt|
	evt.end;
	evt.pat1 = 2.collect({		
		Pbind( 
			\instrument, "cs_playbuf2",
			\stutterTime, Pwhite( 1, 6 ),
			\bufIndex, Pstutter( Pkey( \stutterTime ), Pwhite(0, evt.buffers.size.asInt - 1) ),
			\dur, Pwhite( 0.1, 0) + Pstutter( Pkey( \stutterTime ), Pwhite( 0.5, 2.75 ) ),
			\legato, Pstutter( Pkey( \stutterTime ), Pwrand([0.5,1],[0.1,0.9],inf)),
			\amp, Pstutter( Pkey( \stutterTime ), Pwrand([0,1],[1-evt.density,evt.density],inf) 
				* Pfunc({ evt.amp ? 1 }) * 0.75),
			\rate, Pwhite( 0.99, 1.01 ),
			\bufnum, Pindex( evt.buffers, Pkey( \bufIndex ) , inf ),
			\startPos, Pstutter( 
				Pkey( \stutterTime ), 
				Pwhite( 0.0, Pindex(evt.buffers.collect(_.duration), Pkey( \bufIndex ) ) -
					Pkey( \dur ) 
				)
			),
			\verblevel, Pstutter( Pkey( \stutterTime ), Pwhite( 0.0, 0.125 ) ),
			\pan, Pstutter( Pkey( \stutterTime ), Pwhite( -1.0, 1.0 ) )
		).play;
	});
	evt.pat2 = Pbind( 
		\instrument, "cs_playbuf2",
		\bufIndex, Pwhite(0, evt.bufferLos.size.asInt - 1 ),
		\dur, Pstutter( Pwhite(1,3), Pwhite( 1, 15 ) ),
		\sustain, 1.9,
		\amp, Pwhite( 0.0, 1 ).linexp(0,1,0.25,1) * Pfunc({ evt.amp ? 1 }) ,
		\rate, Pwhite( 0.99, 1.01 ),
		\bufnum, Pindex( evt.bufferLos, Pkey( \bufIndex ), inf ),
		\startPos, 
			Pwhite( 0, Pindex( evt.bufferLos.collect({ |item| (item.duration / 2).asInt }),
				Pkey( \bufIndex ), inf ) ) * 2,
		\verblevel, Pwhite( 0.0, 0.25 ),
		\pan, Pwhite( -1.0, 1.0 )
	).play;
};

~cs.vogelspuur.end = { |evt|
	evt.pat1.do(_.stop);
	evt.pat2.stop;
	RootNode(s).set( \playbuf2gate, 0 );
};
)

/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.vogelspuur.start;
);
~cs.vogelspuur.end;
~srw.stop;
*/

/*

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
