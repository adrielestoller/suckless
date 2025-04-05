//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	 /*Command*/	/*Update Interval*/	/*Update Signal*/
	{" ",		"systemstats",		10,			1},
	{" ",		"date '+%d %B,%A'", 	5, 			0},
	{" ",		"date '+%I:%M'", 	5, 			0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
