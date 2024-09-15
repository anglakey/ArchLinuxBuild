//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	/* {"⌨", "sb-kbselect", 0, 30}, */
	/*{"", "cat /tmp/recordingicon 2>/dev/null",	0,	9},*/
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-tasks",	10,	26},*/
	 {"",	"/home/angus/.config/dwmblocks/scripts/sb-music",	0,	11}, 
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-pacpackages",	0,	8},*/
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-news",		0,	6},*/
	/* {"",	"/home/angus/.config/dwmblocks/scripts/sb-price xmr-btc \"Monero to Bitcoin\" 🔒 25",	9000,	25}, */
	/* {"",	"/home/angus/.config/dwmblocks/scripts/sb-price xmr Monero 🔒 24",			9000,	24}, */
	 {"",	"/home/angus/.config/dwmblocks/scripts/sb-price eth Ethereum 🍸 23",			9000,	23}, 
	/* {"",	"/home/angus/.config/dwmblocks/scripts/sb-price btc Bitcoin 💰 21",			9000,	21}, */
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-torrent",	20,	7},*/
	 {"",	"/home/angus/.config/dwmblocks/scripts/sb-memory",	10,	14}, 
	 {"",	"/home/angus/.config/dwmblocks/scripts/sb-cpu",		10,	18}, 
	 {"",	"/home/angus/.config/dwmblocks/scripts/sb-moonphase",	18000,	17}, 
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-doppler",	0,	13},*/
	{"",	"/home/angus/.config/dwmblocks/scripts/sb-forecast",	18000,	5},
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-mailbox",	180,	12},*/
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-nettraf",	1,	16},*/
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-volume",	0,	10},*/
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-battery",	5,	3},*/
	{"",	"/home/angus/.config/dwmblocks/scripts/sb-clock",	60,	1},
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-internet",	5,	4},
	/* {"",	"/home/angus/.config/dwmblocks/scripts/sb-iplocate", 0,	27}, */
	/*{"",	"/home/angus/.config/dwmblocks/scripts/sb-help-icon",	0,	15},*/
};

//Sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char *delim = " ";
static unsigned int delimLen = 5;

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
