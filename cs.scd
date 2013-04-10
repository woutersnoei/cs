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
	"globaltask",
	"verb"
].do({ |item|
	(thisProcess.nowExecutingPath.dirname +/+ "cs" + item ++ ".scd").load;
});

~cs.timeScale = 10; 
~cs.loadBuffers({ 
	~cs.globalStart;
}); "";
)

/*
~cs.startSpecific( \dejongens );
~cs.startSpecific( \klapperen );
~cs.startSpecific( \spectrum );
~cs.startSpecific( \vogelspuur );
~cs.startSpecific( \wulpmix );
~cs.globalEnd;
*/
