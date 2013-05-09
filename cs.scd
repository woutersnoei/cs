(
~cs = ~cs ? EM();

[
	"geenritme",
	"loops",
	"dejongens",
	"klapperen",
	"spectrum",
	"vogelspuur",
	"wulpmix",
	"losseroepen",
	"globaltask",
	"verb"
].do({ |item|
	(thisProcess.nowExecutingPath.dirname +/+ "cs" + item ++ ".scd").load;
});

~cs.timeScale = 20; 
~cs.losseroepen.waitTime = 120;
~cs.verbose = false;
~cs.loadBuffers({ 
	~cs.globalStart;
	{
	 	MasterEQ(2);
	 	s.volume = -12;
	 	x = s.meter;
	 	x.window.bounds = x.window.bounds.left_( 650 ).top_(700);
 	}.defer;
}); "";
)

/*
~cs.startSpecific( \dejongens );
~cs.startSpecific( \klapperen );
~cs.startSpecific( \spectrum );
~cs.startSpecific( \vogelspuur );
~cs.startSpecific( \wulpmix );
~cs.globalEnd;
~cs.globalStart;
~cs.verbose = true;
*/
