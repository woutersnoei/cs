(
~cs = ~cs ? EM();

~cs.loops = ~cs.loops ? EM();

~cs.loops.sets = ~cs.loops.sets ? Order();

~cs.loops.amp = 0.33;

~cs.loops.sets[0] = (	
	name: "footsteps1",
	folder: "footsteps1",
	begin: "lopenbegin(85bpm).wav", 
	beginOverlap: 0,
	loopdur: 1, // one loop
	weight: 1,
	loopsets: [
		lopen: (
			files: [ 
				"lopen1(85bpm).wav", 
				"lopen2(85bpm).wav", 
				"lopen3(85bpm).wav", 
				"lopen4(85bpm).wav", 
				"lopen5(85bpm).wav", 
				"lopen6(85bpm).wav"
			],
			density: [1, 0.25], // 2 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		piano: (
			files: [
				"piano(85bpm).wav", 
				"piano2(85bpm).wav", 
			],
			density: 0.5,
			crossfadeTime: 2
		)
	]
);


~cs.loops.sets[1]  = (	
	name: "uitstappen",
	folder: "uitstappen",
	begin: "centr7intro.wav", 
	beginOverlap: 6, 
	loopdur: 2,
	weight: 1,
	loopsets: [
		loop: (
			files: [
				"centr7loop1.wav", 
				"centr7loop1effect.wav", 
				"centr7loop2.wav", 
				"centr7loop2effect.wav", 
				"centr7loop3.wav", 
				"centr7loop3echo.wav", 
				"centr7loop3echo2.wav", 
			],
			density: [1, 0.5, 0.1], // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		sound: (
			files: [
				"centr7sound1.wav", 
				"centr7sound2.wav"
			],
			density: 0.2,
			crossfadeTime: 0.5
		)
	]
);
//~cs_set3.loopdur = 2;

~cs.loops.sets[2]  = (	
	name: "hakjes",
	folder: "hakjes",
	loopdur: 2,
	weight: 1,
	loopsets: [
		hakjes: (
			files: [
				"hakjes1(120bpm).wav", 
				"hakjes2(120bpm).wav", 
				"hakjes3(120bpm).wav", 
				"hakjesritme(120bpm).wav", 
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		dropping: (
			files: [
				"dropping.wav", 
			],
			density: 0.2,
			crossfadeTime: 0.1
		),
		viool: (
			files: [
				"viool(120bpm).wav", 
			],
			density: 0.2,
			crossfadeTime: 0.1
		)
	]
);


~cs.loops.sets[3]  = (	// kort
	name: "78bpm",
	folder: "78bpm",
	loopdur: 2,
	weight: 0.25,
	loopsets: [
		stoomhoorn: (
			files: [
				"stoomhoorn.aif", 
			],
			density: 0.76,
			crossfadeTime: 0.1
		),
		trein: (
			files: [
				"trein.aif", 
			],
			density: 0.5,
			crossfadeTime: 2
		)
	]
);

~cs.loops.sets[4] = (	// kort
	name: "90bpm",
	folder: "90bpm",
	loopdur: 1,
	weight: 1,
	loopsets: [
		drums: (
			files: [
				"bass.aif", 
			],
			density: 0.5, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		stoomhoorn: (
			files: [
				"drums.aif", 
			],
			density: 0.05,
			crossfadeTime: 0.1
		),
		trein: (
			files: [
				"kikkers.aif", 
			],
			density: 0.5,
			crossfadeTime: 0.1
		)
	]
);

~cs.loops.sets[5] = (	
	name: "120bpm",
	folder: "120bpm",
	loopdur: 1,
	weight: 1,
	loopsets: [
		voetstappen: (
			files: [
				"120bpmvoetstappen.aif", 
			],
			density: 0.75, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		belletjes: (
			files: [
				"belletjes.aif", 
			],
			density: 0.25,
			crossfadeTime: 1
		),
		trommeltje: (
			files: [
				"trommeltje.aif", 
			],
			density: 0.5,
			crossfadeTime: 0.1
		)
	]
);

~cs.loops.sets[6]  = (	
	name: "99bpm",
	folder: "99bpm",
	loopdur: 1,
	weight: 0.5,
	loopsets: [
		drums: (
			files: [
				"drums.aif", 
			],
			density: 0.5, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		roeien: (
			files: [
				"roeien.aif", 
			],
			density: 0.75,
			crossfadeTime: 0.1
		)
	]
);

~cs.loops.sets[7] = (	
	name: "pingbirds",
	folder: "pingbirds",
	begin: "pingintro.wav", 
	loopdur: 1,
	weight: 1,
	gain: -6,
	loopsets: [
		ping1: (
			files: [
				"ping1.wav",
				"ping2.wav" 
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.1
		),
		ping2: (
			files: [
				"pinglaag2-1.wav", 
				"pinglaag2-2.wav", 
				"pinglaag2-3.wav", 
			],
			density: 0.5,
			crossfadeTime: 0.1
		)
	]
);

~cs.loops.sets[8] = (	
	name: "hi-tekbus",
	folder: "hi-tekbus",
	begin: "hi-tekbusintro.wav", 
	loopdur: 1,
	weight: 1,
	loopsets: [
		laag1: (
			files: [
				"hi-tekbus1.wav",
				"hi-tekbus2.wav",
				"hi-tekbus3.wav",
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.01
		),
	]
);

~cs.loops.sets[9] = (	
	name: "owls",
	folder: "owls",
	loopdur: 1,
	weight: 0.5,
	loopsets: [
		drums: (
			files: [
				"drums1(81 bpm).wav",
				"drums2(81 bpm).wav",
			],
			density: 0.5, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.01
		),
		loop: (
			files: [
				"loop1(81 bpm).wav",
				"loop1pitch(81 bpm).wav",
				"loop2(81 bpm).wav",
				"loop2pitch(81 bpm).wav",
				"loop3(81 bpm).wav",
				"loop3pitch(81 bpm).wav",
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.01
		),
	]
);

~cs.loops.sets[10] = (	
	name: "hi-birds",
	folder: "oneshots",
	begin: "hi-birds.wav", 
	loopdur: 1,
	weight: 0.2,
	loopsets: [
		file: (
			files: [
				"stilte.aif",	
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.01
		),
	]
);

~cs.loops.sets[11] = (	
	name: "theblackfunkybirds",
	folder: "oneshots",
	begin: "theblackfunkybirds.wav",
	loopdur: 1,
	weight: 0.2,
	loopsets: [
		file: (
			files: [
				"stilte.aif",
			],
			density: 1, // 3 layers; 0 = no sound, 1 = always sound
			crossfadeTime: 0.01
		),
	]
);

(
(thisProcess.nowExecutingPath.dirname.dirname +/+ "CS 2013 Timon/Clusters/*/").pathMatch.do({ |path, i|
	var subfolders, begin, paths;
	var set = (
		loopdur: 1,
		weight: 1,
		gain: 12
	);
	path.basename[10..].postln;
	path[ thisProcess.nowExecutingPath.dirname.dirname.size+1..].postln;
	subfolders = (path +/+ "*/").pathMatch;
	begin = subfolders.detect({ |item|
		item.basename== "Intro";
	});
	subfolders.remove( begin );
	if( begin.notNil ) {
		begin = (begin +/+ "*.aif").pathMatch.first;
		begin = begin.dirname.basename +/+ begin.basename;
	};
	subfolders.do({ |item|
		(item +/+ "*.aif").pathMatch.do({ |subitem|
			paths = paths.add( subitem.dirname.basename +/+ subitem.basename );
		});
	});	
	
	set[ \name ] = path.basename[10..];
	set[ \folder ] = path[ thisProcess.nowExecutingPath.dirname.dirname.size+1..];
	set[ \begin ] = begin;
	set[ \loopsets ] = [];
	paths.do({ |item, i|
		set[ \loopsets ] = set[ \loopsets ].addAll([
			item[path.basename.size + 8..].removeExtension.asSymbol,
			(
				files: [ item ],
				density: ($1: 0.75, $2: 0.5, $3: 0.25)[ item[5] ] ? 1,
				crossfadeTime: 0.01
			)
		]);
	});
	~cs.loops.sets[ i+12 ] = set;

});
);

~cs.loops.sets[17].loopdur = 0.5;
~cs.loops.sets[17].loopsets.pairsDo({ |a,b| b.crossfadeTime_(5) });

~cs.loops.loadBuffers = { |evt, action|
	{
		var cond;
		cond = Condition(false);
		evt.sets.do({ |setx|
			var folder;
			folder = thisProcess.nowExecutingPath.dirname.dirname +/+ setx.folder;
			if( setx.begin.notNil ) {
				setx.beginBuffer = Buffer.read( s, 
					folder +/+ setx.begin, 
					action: { 
						"reading buffer '%' done\n".postf( setx.begin );
						cond.test = true; cond.signal 
					}
				);
				cond.wait;
				cond.test = false;
			};
			setx.loopsets.pairsDo({ |key, set|
				cond.test = false;
				set.buffers = Buffer.readMultiple( 
					set.files,
					folder,
					action: { cond.test = true; cond.signal }
				);
				cond.wait;
				"-- done reading loopset '%'\n".postf( key );
			});
		});
		"done".postln;
		action.value(evt);
	}.fork;
};

(
SynthDef( "cs_singleloop", { |amp = 0.2, bufnum = 0, loopGate = 1|
	Out.ar( 0, 
		amp * Env.cutoff.kr(2, loopGate ) *
		PlayBuf.ar( 2, bufnum, loop: 0, doneAction: 2 );
	);
}).load(s);
);

(
3.do({ |iii|
	iii = iii + 1;
	(1..9).do({ |ii|			 // num voices, num loops
		SynthDef( "cs_testloops_" ++ iii ++ "_" ++ ii, { |amp = 0.1, timeToNext = 1,
				sustain = 20, release = 0.1, loopGate = 1|
			var buffers, signals, amps, output, index, env;
			
			buffers = \buffers.kr( 0!ii ).asArray;
			signals = buffers.collect({ |buf|
				PlayBuf.ar( 2, buf, loop: 1 );
			});
			
			amps = 0;
			
			index = iii.collect({ |item|
				("index" ++ item).asSymbol.kr(0);
			});
			
			iii.do({ |item, ix|
				amps = buffers.collect({ |item, i|
					Slew.kr(
						InRange.kr( index[ix], i-0.25, i+0.25 ) * 0.5pi, 
						1/timeToNext, 
						1/timeToNext 
					).sin
				}).max(amps);
			});
			
			amps = amps * amp;
			
			output = signals.collect({ |item, i| amps[i] * item }).sum;
			
			env = Env([1,1,0], [sustain, release], -4).kr(2);
			
			output = output * Env.cutoff.kr(2, loopGate );
			Out.ar(0,output * env);
		}).load(s);		
	})
});
);

(
~cs.loops.startSet = { |evt, set, dur = 40, amp = 0.1| // dur includes intro
	var loopdur, synths = (), introdur = 0;
	var getIndices, task;
	loopdur = set.loopsets[1].buffers[0].duration * (set.loopdur ? 1); 
	amp = amp * (set.gain ? 0).dbamp;
	getIndices = { |loopset|
		var size = loopset.files.size;
		loopset.density.asCollection.collect({ |item, i|
			[ "index" ++ i, (size/item).rand.asInteger ]
		}).flatten(1);
	};
	if( ~cs.verbose ? true ) { "playing % % (loop)\n".postf( dur.asSMPTEString, set.name ); };
	task = {
		var t = loopdur;
		
		if( set.begin.notNil ) { // play intro
			introdur = set.beginBuffer.duration - (set.beginOverlap ? 0);
			s.makeBundle( 0.2, { Synth( "cs_singleloop", [ bufnum: set.beginBuffer ] ); });
			introdur.wait;
		};
		
		s.makeBundle( 0.2, {
			set.loopsets.pairsDo({ |key, loopset|
				synths[ key ] = Synth( 
					"cs_testloops_%_%".format(
						loopset.density.size.max(1),
						loopset.buffers.size
					), 
					[ 
						buffers: loopset.buffers,
						timeToNext: loopset.crossfadeTime,
						sustain: (dur - introdur) - 10,
						release: 10,
						amp: amp
					] ++ getIndices.value( loopset )
				);
			});
		});
		
		while { t < (dur - introdur ) } {
			loopdur.wait;
			s.makeBundle( 0.2, {
				set.loopsets.pairsDo({ |key, loopset|
					synths[ key ].set( *getIndices.value( loopset ) );
				});
			});
			t = t + loopdur;
		};
		evt.loopTasks.remove( task );
		//"ended".postln;
	}.fork;
	evt.loopTasks = evt.loopTasks.add( task );
};
);

(
~cs.loops.last = 0;
~cs.loops.start = { |evt|
	evt.end;
	evt.task = {
		var next = 0;
		var time;
		var weights;
		
		( 0 rrand: 120 ).wait;
		loop {
			weights = evt.sets.collectAs({ |item| item.weight ? 1 }, Array);
			weights[ evt.last ] = 0;
			next = evt.sets.collectAs({ |item,i| i }, Array).wchoose( weights.normalizeSum );
			evt.last = next;
			evt.startSet( 
				evt.sets[ next ], 
				time = (30 rrand: 90), 
				evt.amp ? 0.1
			);
			(time + ( 0 rrand: 240 )).wait;
				
		};

	}.fork;
};

~cs.loops.end = { |evt|
	evt.task.stop;
	evt.loopTasks.do(_.stop);
	evt.loopTasks = [];
	RootNode(s).set( \loopGate, 0 );
};
);

)

/*
~cs.loops.start;
~cs.loops.end;
~cs.loops.amp = 0.25;
*/