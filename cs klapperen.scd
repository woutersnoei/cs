(
~cs = ~cs ? EM();

~cs.klapperen = ~cs.klapperen ? EM();

~cs.klapperen.amp = 0.75;

~cs.klapperen.playTime = 10; // in minutes
~cs.klapperen.weight = 1; 
~cs.klapperen.density = 0.75; 

~cs.klapperen.loadBuffers = { |evt, action|
	evt.buffer =  Buffer.readChannel( s, thisProcess.nowExecutingPath.dirname.dirname +/+ 
		"/moniek/opnamen/StevigWapperen17Jan.aif", channels:[0], action: { action.value(evt) } );
};

/*
~cs.klapperen.loadBuffers( { "done".postln } );
*/

(
SynthDef( "cs_klapperen", { |
		bufnum = 0, freq = #[500,4000], rate = 1, sustain = 20, ratevar = 12, res = 0.5,
		grainrate = 50, modfreq = 5, modrange = 0, graingate = 1, amp = 0.1, cutoff = 0, 
		cutstart = 0.5, cutstartamp = 1, distort = 1|
	var sig, env, times, filtlevels, filtfreqs, filtresses;
	var n = 4;
	//sig = PlayBuf.ar(1, bufnum, loop: 1);
	times = [ IRand(0,1), 0.1, IRand(0,1) ];
	times = times / times.sum;
	env = Env([0,1,1,0], times * sustain).kr(2);
	sig = TGrains.ar(
		2, 
		Impulse.ar(grainrate) - 0.0001, 
		bufnum, 
		rate * WhiteNoise.ar(ratevar).midiratio,
		DemandEnvGen.ar( Dwhite(0,60), Dwhite(5,120) ) + WhiteNoise.ar(0.1),
		LFDNoise3.ar(0.05).exprange(0.5,4)/grainrate,
		WhiteNoise.ar(1).range( *LFDNoise3.kr(0.05.dup) )
	) * 2;
	//sig = (sig * distort).tanh;
	sig = BLowCut.ar( sig, freq[0], cutoff );
	sig = BHiCut.ar( sig, freq[1], cutoff );
	filtlevels = LFDNoise3.kr(0.05.dup(n)).exprange(0.125,1);
	filtlevels = filtlevels / filtlevels.sum;
	filtfreqs = Rand(freq[0].dup(n), freq[1]) * LFDNoise3.kr(0.05.dup(n)).exprange(0.98,1/0.98);
	filtresses = LFDNoise3.kr(0.05.dup(n)).exprange(0.25,1) * res;
	sig = (DynKlank.ar( `[ 
		filtfreqs,
		filtlevels, 
		filtresses
	], sig ) 
	- ( DynKlank.ar( `[ 
		filtfreqs,
		filtlevels, 
		filtresses * cutstart
	], sig ) * cutstartamp )
	) * amp * 4;
	sig = sig * SinOsc.ar(modfreq + Rand(-0.05.dup,0.05)).range(1-modrange,modrange);
	sig = BHiShelf.ar( sig, 2000, 1, 10 );
	sig = Limiter.ar( sig, amp );
	sig = sig * env * Env.cutoff.kr(2,graingate);
	PrivateOut.ar( 0, sig * LFDNoise3.kr(0.05).exprange(0.01,1) );
	Out.ar( 0, sig);
}).load(s)
);

~cs.klapperen.start = { |evt|
	evt.end;
	evt.task = {	
		loop {	
			evt.subTasks.do(_.stop);
			RootNode(s).set( \graingate, 0 );
			evt.subTasks = 4.collect({
				{
					var timeToNext = 0;
					loop {
						timeToNext.wait;
						timeToNext = 20 rrand: 60;
						if( evt.density.coin) {
							Synth("cs_klapperen", [ 
								\bufnum, evt.buffer, 
								\freq, ({ 200 exprand: 7500 }!2).sort,
								\rate, (0.25 exprand: 3) * [-1,1].choose,
								\sustain, timeToNext * (0.33 rrand: 1 ),
								\ratevar, 0.1 exprand: 10,
								\res, 0.01 exprand: 1,
								\grainrate, 3.0 exprand: 100,
								\modfreq, 0.1 exprand: 10,
								\modrange, 0.0 rrand: 1,
								\amp, (0.75 exprand: 1) * (evt.amp ? 0.75),
								\cutoff, 3.rand,
								\cutstart, 0.01 exprand: 0.5,
								\cutstartamp, 0.0 rrand: 1,
								\distort, 1.0 exprand: 4.0
							]);
						};
					};
				}.fork;
			});
			(40 rrand: 120).wait;
		};
	}.fork;
};

~cs.klapperen.end = { |evt|
	evt.task.stop;
	evt.subTasks.do(_.stop);
	RootNode(s).set( \graingate, 0 );
};
)

/*
~srw = ServerRecordWindow(s);
(
~srw.record;
~cs.klapperen.start;
);
~cs.klapperen.end;
~srw.stop;
*/
