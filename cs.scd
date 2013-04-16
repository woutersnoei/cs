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

~cs.timeScale = 10; 
~cs.losseroepen.waitTime = 60;
~cs.loadBuffers({ 
	~cs.globalStart;
	{
	 	MasterEQ(2);
	 	s.volume = -12;
	 	s.meter;
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
*/
