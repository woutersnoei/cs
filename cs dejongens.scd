
(
~cs = ~cs ? EM();

~cs.dejongens = ~cs.dejongens ? EM();

~cs.dejongens.playTime = 30; // in minutes
~cs.dejongens.weight = 1; 

~cs.dejongens.loadBuffers = { |evt, action|
	~cs.geenRitme.loadBuffers({
		~cs.loops.loadBuffers({ action.value( evt ) });
	});
};

~cs.dejongens.start = { |evt|
	~cs.geenRitme.start;
	~cs.loops.start;
};

~cs.dejongens.end = { |evt|
	~cs.geenRitme.end;
	~cs.loops.end;
};


)

/*
~cs_freeTask.stop;
~cs_playSetTask.stop;
*/