## The variables/procedures here include our interface for controlling
## event-loops as well as procedures that are also used in our segmentation
## startup event-loop.




# An event loop is a set of linked nodes: [n1] <-> [n2] <-> [n3] <-> ... 
# Typically, each node is a procedure that displays a form to the user. During
# each procedure, a value called .result_node$ is computed which indicates 
# whether the wizard should go forward, backward or abort.

# Values for .result_node$
node_quit$ = "quit"
node_next$ = "next"
node_back$ = "back"

# Map a .result_node$ value onto the name of node in the wizard.
procedure next_back_quit(.status$, .next_step$, .last_step$, .quit$) 
	if .status$ == node_next$
		.result$ = .next_step$
	elsif .status$ == node_back$
		.result$ = .last_step$
	else
		.result$ = .quit$
	endif
endproc




## These procedures are generic start-up event-loop nodes we also use in other
## scripts (i.e., segmentation). These include:
## 		@startup_initials
## 		@startup_id
## 		@startup_load_audio
## 		@startup_wordlist
##		@startup_segm_textgrid

# [NODE] Get user's initials and where they are working from
procedure startup_initials()
	beginPause ("'procedure$' - Initializing session, step 1.")
		# Prompt the user to enter the user's initials.
		comment ("Please enter your initials in the field below.")
  		word    ("Your initials", "")
		# Prompt the user to specify where the script is being run.
		comment ("Please specify where the machine is on which you are working.")
			optionMenu ("Location", 1)
			option ("Generic")
			option ("WaismanLab")
			option ("ShevlinHallLab")
			option ("Mac via RDC")
			option ("Mac via VPN")
			option ("Other (Beckman)")
			option ("Other (not Beckman)")
	button = endPause ("Quit", "Continue", 2)
	
	# Use the 'button' variable to determine which node to transition to next.
	if button == 1
		.result_node$ = node_quit$
	else
		# If the segmenter has entered initials and location and wishes to
		# continue to the next step of the start-up procedure (button = 2),
		# then set the value of the .initials$ variable
		.initials$ = your_initials$
		.location$ = location$
		
		# Use the value of the '.location$' variable to set up the 'drive$' variables.
		if (.location$ == "Generic")
			dirLength = length (defaultDirectory$) - 46
			.drive$ = left$(defaultDirectory$, dirLength)
			.audio_drive$ = left$(defaultDirectory$, dirLength)
		elsif (.location$ == "WaismanLab")
			.drive$ = "L:/"
			.audio_drive$ = "L:/"
		elsif (.location$ == "ShevlinHallLab")
			.drive$ = "//l2t.cla.umn.edu/tier2/"
			.audio_drive$ = "//l2t.cla.umn.edu/tier2/"
		elsif (.location$ == "Mac via RDC")
			.drive$ = "I:/"
			.audio_drive$ = "I:/"
		elsif (.location$ == "Mac via VPN")
			.drive$ = "/Volumes/tier2/"
			.audio_drive$ = "/Volumes/tier2onUSB/"
		elsif (.location$ == "Other (Beckman)")
			.drive$ = "/Volumes/tier2/"		
			.audio_drive$ = "/LearningToTalk/Tier2/"
		elsif (.location$ == "Other (not Beckman)")
			exit Contact Mary Beckman and your segmentation guru to request another location
		endif
		.result_node$ = node_next$
	endif
endproc

# console output for debugging
procedure log_initials()
	if debug_mode
		appendInfoLine("---- log_initials() ----")
		appendInfoLine("Exit Status: ", startup_initials.result_node$)
		if startup_initials.result_node$ == node_next$
			appendInfoLine("derived values: ")
			appendInfoLine(tab$, ".initials$: ", startup_initials.initials$)
			appendInfoLine(tab$, ".drive$: ", startup_initials.drive$)
			appendInfoLine(tab$, ".audio_drive$: ", startup_initials.audio_drive$)
		endif
		appendInfoLine("")
	endif
endproc




# [NODE] Prompt the user to choose the subject's experimental ID.
procedure startup_id()
	# Open a dialog box and prompt the user to specify the subject's 3-digit id no.
	beginPause ("'procedure$' - Initializing session, step 5 (participant ID).")
		comment ("Please enter the participant's 3-digit ID number in the field below.")
		word    ("id number", "")
	button = endPause ("Back", "Quit", "Continue", 3, 1)
	# Use the 'button' variable to determine which node to transition to next.
	if button == 1
		.result_node$ = node_back$
	elsif button == 2
		.result_node$ = node_quit$
	else
		# If the segmenter wishes to continue to the next step in the
		# start-up procedure (ie. loading the data files necessary to
		# segment an audio recording) (button = 3), then transition to
		# the next node.
		.id_number$ = id_number$
		.result_node$ = node_next$
	endif
endproc

# console output for debugging
procedure log_startup_id()
	if debug_mode
		appendInfoLine("---- log_startup_id() ----")
		appendInfoLine("Exit Status: ", startup_id.result_node$)
		if startup_id.result_node$ == node_next$
			appendInfoLine(tab$, "derived values: ")
			appendInfoLine(tab$, ".id_number$: ", startup_id.id_number$)
		endif
		appendInfoLine("")
	endif
endproc




# [NODE] Load the audio file for this task.
procedure startup_load_audio(.audio_dir$, .task$, .id_number$)
	# Make the pattern to search for
	.ext$ = if (macintosh or unix) then "WAV" else "wav" endif
# The above is a problem, since mac OS and unix filenames are case-sensitive, so 
# need to look for either.  Need to fix in next version.
	.audio_pattern$ = .audio_dir$ + "/" + .task$ + "_" + .id_number$ + "*." + .ext$
	
	# Determine which .wav (or .WAV) file in the 'audio_dir$' directory has a filename
	# that includes the id number of the subject presently being segmented.
	Create Strings as file list: "wavFile", .audio_pattern$
	n_wavs = Get number of strings
	
	# The resulting Strings object 'wavFile' should list exactly one .wav (or .WAV) 
	# filename that corresponds to the correct audio file for this subject.
	if (n_wavs > 0)
		# If the Strings object 'wavFile' has at least one filename,
		# use the filename in this Strings object to make string
		# variables for the filename, basename, and filepath of the
		# audio file on the local filesystem.
		select Strings wavFile
		.audio_filename$ = Get string... 1
		.audio_basename$ = .audio_filename$ - ".wav" - ".WAV"
		.audio_filepath$ = "'.audio_dir$'/'.audio_filename$'"
		# Also make the corresponding experimental_ID$ variable that need later.
		.experimental_ID$ = mid$(.audio_basename$, length(.task$)+2, length(.audio_basename$))
		.audio_sound$  = "'.experimental_ID$'_Audio"
		# Remove the Strings object from the Praat object list.
		select Strings wavFile
		Remove
		# Read in the audio file, and rename it to the value of the
		# 'audio_sound$' string variable.
		Read from file... '.audio_filepath$'
		select Sound '.audio_basename$'
		Rename... '.audio_sound$'
		
		.result_node$ = node_next$
	else
		# If the Strings object 'wavFile' has no filenames on it,
		# then the script was unable to find a candidate .wav file.
		# Display an error message to the segmenter and then
		# quit this segmentation session.
		beginPause ("'procedure$' - Initialization error 1. Cannot load audio file.")
			comment ("There doesn't seem to be an audio file for subject '.id_number$'")
			comment ("   on the local filesystem.")
			comment ("Check that the following directory exists on the local filesystem:")
			comment ("'.audio_dir$'")
			comment ("Also check that this directory contains a wave file whose basename")
			comment ("      begins with 'task$'_'id_number$'.")
		endPause ("Quit segmenting & check filesystem", 1, 1)
	
		.result_node$ = node_quit$
	endif
endproc

# console output for debugging
procedure log_load_audio()
	if debug_mode
		appendInfoLine("---- log_load_audio() ----")
		appendInfoLine("Exit Status: ", startup_load_audio.result_node$)
		
		appendInfoLine("input parameters: ")
		appendInfoLine(tab$, ".audio_dir$: ", startup_load_audio.audio_dir$)
		appendInfoLine(tab$, ".task$: ", startup_load_audio.task$)
		appendInfoLine(tab$, ".id_number$: ", startup_load_audio.id_number$)
		appendInfoLine("")
		
		appendInfoLine("derived values: ")
		appendInfoLine(tab$, ".ext$: ", startup_load_audio.ext$)
		appendInfoLine(tab$, ".audio_pattern$: ", startup_load_audio.audio_pattern$)

		if startup_load_audio.result_node$ == node_next$
			appendInfoLine(tab$, ".audio_filename$: ", startup_load_audio.audio_filename$)
			appendInfoLine(tab$, ".audio_basename$: ", startup_load_audio.audio_basename$)
			appendInfoLine(tab$, ".audio_filepath$: ", startup_load_audio.audio_filepath$)
			appendInfoLine(tab$, ".experimental_ID$: ", startup_load_audio.experimental_ID$)
			appendInfoLine(tab$, ".audio_sound$: ", startup_load_audio.audio_sound$)
		endif
		appendInfoLine("")
	endif
endproc




# [NODE] Load the wordlist for this task.
procedure startup_wordlist(.task$, .experimental_ID$, .drive$, .wordList_dir$)
	# Make string variables for the word list table's basename,
	# filename, and filepath on the local filesystem, using the
	# 'subject's experimental ID.
	.wordList_basename$ = "'.task$'_'.experimental_ID$'_WordList"
	.wordList_filename$ = "'.wordList_basename$'.txt"
	.wordList_filepath$ = "'.wordList_dir$'/'.wordList_filename$'"
	.wordList_table$    = "'.experimental_ID$'_WordList"
	
	.wordList_exists = fileReadable(.wordList_filepath$)
	
	# What we do with this information depends on the task, because ...
	if .task$ == "GFTA"
		# If the task is GFTA, there is usually just one file for everyone.
		if (.wordList_exists == 0)
			.wordList_basename$ = "GFTA_info"
			.wordList_filepath$ = "'.drive$'DataAnalysis/GFTA/GFTA_info.txt"
		endif
		# But in either case we want the Table Object to be called the same 
		# thing so we'll reset the wordList_table$ variable.
		.wordList_table$    =  "gfta_wordlist"
	endif
	
	# Determine again whether a Word List table exists on the local file system.
	.wordList_exists = fileReadable(.wordList_filepath$)
	if (.wordList_exists)
		# Read the word list table from the local filesystem, and then rename
        # it according to the 'wordList_table$' variable.
		Read Table from tab-separated file... '.wordList_filepath$'
		select Table '.wordList_basename$'
		Rename... '.wordList_table$'
		
		# Determine the number of trials (both Familiarization and Test trials) 
		# in this experimental session.
		select Table '.wordList_table$'
		.n_trials = Get number of rows
		
		.result_node$ = node_next$
		
	else
		# If there is no Word List table on the local filesystem, first
		# display an error message to the segmenter and then quit this 
		# segmentation session.
		beginPause ("'procedure$' - Initialization error 2. Cannot load word list file.")
			comment ("There doesn't seem to be a word list table for this subject on the local filesystem.")
			comment ("Check that the following directory exists on the local filesystem:")
			comment ("'.wordList_dir$'")
			comment ("Also check that this directory contains a word list table whose filename is '.task$'_'.experimental_ID$'_WordList.txt.")
		endPause ("Quit segmenting & check filesystem", 1, 1)
		
		.result_node$ = node_quit$
	endif
endproc

# console output for debugging
procedure log_startup_wordlist()
	if debug_mode
		appendInfoLine("---- log_startup_wordlist() ----")
		appendInfoLine("Exit Status: ", startup_wordlist.result_node$)
		
		appendInfoLine("input parameters: ")
		appendInfoLine(tab$, ".task$: ", startup_wordlist.task$)
		appendInfoLine(tab$, ".experimental_ID$: ", startup_wordlist.experimental_ID$)
		appendInfoLine(tab$, ".wordList_dir$: ", startup_wordlist.wordList_dir$)
		appendInfoLine("")
		
		appendInfoLine("derived values: ")
		appendInfoLine(tab$, ".wordList_basename$: ", startup_wordlist.wordList_basename$)
		appendInfoLine(tab$, ".wordList_filename$: ", startup_wordlist.wordList_filename$)
		appendInfoLine(tab$, ".wordList_filepath$: ", startup_wordlist.wordList_filepath$)
		appendInfoLine(tab$, ".wordList_table$: ", startup_wordlist.wordList_table$)
		appendInfoLine(tab$, ".wordList_exists: ", startup_wordlist.wordList_exists)
		
		if startup_wordlist.result_node$ != node_quit$
			appendInfoLine(tab$, ".n_trials: ", startup_wordlist.n_trials)
		endif
		
		appendInfoLine("")
	endif
endproc




# [NODE] Load a segmentation textgrid
procedure startup_segm_textgrid(.directory$, .task$, .experimental_ID$)
	# Numeric and string constants for the Segmented TextGrid.
	.trial       = 1
	.trial$      = "Trial"
	.word        = 2
	.word$       = "Word"
	.context     = 3
	.context$    = "Context"
	.repetition  = 4
	.repetition$ = "Repetition"
	.segmnotes   = 5
	.segmnotes$  = "SegmNotes"

	# Search for possible segmentation textgrids 
	.segm_pattern$ = .directory$ + "/" + .task$ + "_" + .experimental_ID$ + "*segm.TextGrid"
	Create Strings as file list: "segmentedTextGrids", .segm_pattern$
	.n_grids = Get number of strings

	# Load the textgrid if there is at least one match
	if (0 < .n_grids)
		.filename$ = Get string: 1
		.filepath$ = .directory$ + "/" + .filename$
		.basename$ = .filename$ - ".TextGrid"
		selectObject("Strings segmentedTextGrids")
		Remove
		
		# Create a Table from the segmented TextGrid.
		Read from file: .filepath$
		@selectTextGrid(.basename$)
		Down to Table: "no", 6, "yes", "no"
		
		.result_node$ = node_next$
	# Otherwise, alert the user.
	else
		beginPause ("'procedure$' - Initialization error 1. No segmentations found.")
			comment("There doesn't seem to be an segmentation textgrid for subject '.experimental_ID$'")
			comment("     on the local filesystem.")
		button = endPause("Back", "Quit and check file-system", 1)

		if button == 1
			.result_node$ = node_back$
		else 
			.result_node$ = node_quit$
		endif
	endif
endproc

# console output for debugging
procedure log_startup_segm_textgrid()
	if debug_mode
		appendInfoLine("---- log_startup_segm_textgrid() ----")
		appendInfoLine("Exit Status: ", startup_segm_textgrid.result_node$)
		
		appendInfoLine("input parameters: ")
		appendInfoLine(tab$, ".directory$: ", startup_segm_textgrid.directory$)
		appendInfoLine(tab$, ".task$: ", startup_segm_textgrid.task$)
		appendInfoLine(tab$, ".experimental_ID$: ", startup_segm_textgrid.experimental_ID$)
		appendInfoLine("")
		
		appendInfoLine("derived values: ")
		appendInfoLine(tab$, ".segm_pattern$: ", startup_segm_textgrid.segm_pattern$)
		appendInfoLine(tab$, ".n_grids: ", startup_segm_textgrid.n_grids)
		
		if startup_segm_textgrid.result_node$ == node_next$			
			appendInfoLine(tab$, ".filename$: ", startup_segm_textgrid.filename$)
			appendInfoLine(tab$, ".filepath$: ", startup_segm_textgrid.filepath$)
			appendInfoLine(tab$, ".basename$: ", startup_segm_textgrid.basename$)
		endif
		appendInfoLine("")
	endif
endproc
