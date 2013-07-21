(

~cs = ~cs ? EM();

~cs.geenRitme = ~cs.geenRitme ? EM();

// load;
~cs.geenRitme.folder = "geenritme";

~cs.geenRitme.amp = 0.8;

~cs.geenRitme.loadBuffers = { |evt, action|
	evt.buffers = Buffer.readDir( 
		thisProcess.nowExecutingPath.dirname.dirname +/+
		evt.folder, 
		ext: "aif", 
		action: { action.value( evt ) },
		nlevels: 0
	);
	evt.indices = _.value!(evt.buffers.size);
	evt.played = [];
};

/*
~cs.geenRitme.loadBuffers( { "done".postln } );
~cs.geenRitme.buffers.collect(_.duration).collect(_.asSMPTEString).dopostln;
*/

(
SynthDef( "cs_free", { |amp = 0.4, bufnum = 0, startOffset = 0,
		startFreq = 1000, endFreq = 1000, sustain = 10, rate = 1, freeGate = 1|
	var lowcutEnv, hicutEnv, env;
	var sig, distance, verb;
	var times, level;
	times = Rand( 0.dup(3), 4 ) + 0.00000001; // random times
	times = times / (times.sum/sustain);
	
	lowcutEnv = Env( [ startFreq, 20, 20, endFreq ].cpsmidi, 
		times, \sin ).kr.midicps;
	hicutEnv = Env( [ startFreq, 20000, 2000, endFreq ].cpsmidi, 
		times, \sin ).kr.midicps;
	env = Env( [0,1,1,0], times, [4,0,-4] ).kr(2);
	
	sig = PlayBufCF.ar( 2, bufnum, rate, 
		Dwhite( 1, BufDur.kr(bufnum) / 4 ), 
		Dwhite( 0, BufFrames.kr(bufnum) ), 
		loop: 1,
		lag: 0.5
	);
	
	sig = BLowCut.ar( sig, lowcutEnv.lag(0.1).clip(20,20000), 2 );
	sig = BHiCut.ar( sig, hicutEnv.lag(0.1).clip(20,20000), 2 );
	
	sig = Balance2.ar( sig[0], sig[1], LFDNoise3.kr(0.2).sqrt );
	
	//distance = LFDNoise3.kr(0.2).exprange(1,5);
	//verb = FreeVerb2.ar( sig[0], sig[1], 1, 0.6 ) * 0.25;
	//sig = (sig * (1/distance)) + (verb * (1/(distance**0.25)));
	
	level = LFDNoise3.kr(0.05).exprange(0.25,1);
	
	//sig = FreeVerb2.ar( sig[0], sig[1], LFDNoise3.kr(0.1).exprange(0.01,0.7), 0.6 );
	
	PrivateOut.ar( 0, sig * LFDNoise3.kr(0.1).exprange(0.01,1) );
	
	sig = sig * Env.cutoff.kr(2, freeGate);
	
	sig = sig * level;
	Out.ar(0, sig * env * amp );
	
}).load(s);

);

(
~cs.geenRitme.start = { |evt|
	evt.end;
	evt.task = {
		var buf, time, offset;
		var index = 0; 
		loop {
			//index = evt.buffers.size.xrand( index );
			if( evt.indices.size == 0 ) {
				evt.indices = evt.played;
				evt.played = [];
			};
			index = evt.indices.choose;
			evt.indices.remove( index );
			evt.played = evt.played.add(index);
			buf = evt.buffers[index];
			//time = buf.duration * (0.5 rrand: 2);
			time = 20 rrand: 100; // 
			offset = 0.0 rrand: (buf.duration - time);
			// time.postln;
			if( ~cs.verbose ? true ) { "playing % % (geenritme)\n".postf( time.asSMPTEString, buf.path.basename ); };
			Synth( "cs_free", [ 
				\amp, evt.amp ? 0.3,
				\bufnum, buf, 
				\startFreq, 20 exprand: 20000,
				\endFreq, 20 exprand: 20000,
				\sustain, time,
				\startOffset, offset
		 	]);
		 	(time * (0.125 exprand: 1.5)).wait;
		};
	}.fork;
};

~cs.geenRitme.end = { |evt|
	evt.task.stop;
	RootNode(s).set( \freeGate, 0 );
};
);

)
