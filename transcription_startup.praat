

# [STARTUP WIZARD EVENT LOOP]

# The user enters their [initials] and their location. They choose the 
# appropriate [testwave] for the NWR task and specify the [subject] they wish to
# transcribe. From this information the script loads the [audio], [wordlist] and
# [segdata] data required for transcription. The event-loop is exited if a user 
# chooses to [quit], if a file cannot be found, or if the user can [transcribe]
# a trial.


startup_node_initials$    = "initials"
startup_node_testwave$    = "testwave"
startup_node_subject$     = "subject"
startup_node_audio$       = "audio"
startup_node_wordlist$    = "wordlist"
startup_node_segdata$     = "segdata"
startup_node_transcribe$  = "transcribe"
startup_node_quit$        = "quit"

startup_node$ = startup_node_initials$

if debug_mode
	writeInfoLine("Node: ", startup_node$)
	appendInfoLine("")
endif

# Start-up wizard runs as long as the user has not quit or finished.
while startup_node$ != startup_node_quit$ and startup_node$ != startup_node_transcribe$
	# [INITIALS, LOCATION]
	if startup_node$ == startup_node_initials$
		@startup_initials()
		@log_initials()
		
		@next_back_quit(startup_initials.result_node$, startup_node_testwave$, "", startup_node_quit$)
		startup_node$ = next_back_quit.result$
		
	# [TASK, TIMEPOINT]
	elsif startup_node$ == startup_node_testwave$
		@startup_nwr_testwave()
		@log_nwr_testwave()

		@next_back_quit(startup_nwr_testwave.result_node$, startup_node_subject$, startup_node_initials$, startup_node_quit$)
		startup_node$ = next_back_quit.result$
	
	# [SUBJECT]
	elsif startup_node$ == startup_node_subject$
		
		# [LOCAL FILE SYSTEM VARIABLES] Use results from the previous nodes to generate filepaths
		drive$ = startup_initials.drive$
		audio_drive$ = startup_initials.audio_drive$
		task$ = startup_nwr_testwave.task$
		testwave$ = startup_nwr_testwave.testwave$
		initials$ = startup_initials.initials$
		
		@transcription_filepaths(drive$, audio_drive$, task$, testwave$)
		@log_transcription_filepaths()
		
		audio_dir$ = transcription_filepaths.audio_dir$
		segmentDirectory$ = transcription_filepaths.segmentDirectory$
		transDirectory$ = transcription_filepaths.transDirectory$
		transLogDirectory$ = transcription_filepaths.transLogDirectory$
		wordList_dir$ = transcription_filepaths.wordList_dir$
		
		# Prompt for ID
		@startup_id()
		@log_startup_id()
		
		@next_back_quit(startup_id.result_node$, startup_node_audio$, startup_node_testwave$, startup_node_quit$)
		startup_node$ = next_back_quit.result$

	# [AUDIO FILE]
	elsif startup_node$ == startup_node_audio$
		id_number$ = startup_id.id_number$
		@startup_load_audio(audio_dir$, task$, id_number$)
		@log_load_audio()
		
		@next_back_quit(startup_load_audio.result_node$, startup_node_wordlist$, "", startup_node_quit$)
		startup_node$ = next_back_quit.result$

	# [WORD LIST TABLE]
	elsif startup_node$ == startup_node_wordlist$
		audio_sound$ = startup_load_audio.audio_sound$
		experimental_ID$ = startup_load_audio.experimental_ID$
		@startup_nwr_wordlist(task$, experimental_ID$, drive$, wordList_dir$)

		@next_back_quit(startup_wordlist.result_node$, startup_node_segdata$, "", startup_node_quit$)
		startup_node$ = next_back_quit.result$
	
	# [SEGMENTATION TEXTGRID]
	elsif startup_node$ == startup_node_segdata$
		@startup_segm_textgrid(segmentDirectory$, task$, experimental_ID$)
		@log_startup_segm_textgrid()
		
		@next_back_quit(startup_wordlist.result_node$, startup_node_quit$, "", startup_node_quit$)
		startup_node$ = next_back_quit.result$
	
	endif
endwhile




## Startup procedures that are currently specific to just non-word transcription
## 		@start_nwr_testwave
## 		@transcription_filepaths
## 		@startup_nwr_wordlist - wrapper for @startup-wordlist


# [NODE] Get the experimental task and the timepoint ("testwave") of the recording
procedure startup_nwr_testwave()
	beginPause ("'procedure$' - Initializing session, step 3 (task and test wave of recording).")
		comment ("Please choose the experimental task of the recording.")
			optionMenu ("Task", 1)
			option ("NonWordRep")
		# Prompt the segmenter to specify the testwave (i.e., the "TimePoint") of the data.
		comment ("Please specify the test wave of the recording.")
		optionMenu ("Testwave", 1)
			option ("TimePoint1")
			option ("TimePoint2")
			option ("Other")
	button = endPause ("Back", "Quit", "Continue", 3)
	
	# Use the 'button' variable to determine which node to transition to next.
	if button == 1
		.result_node$ = node_back$
	elsif button == 2
		.result_node$ = node_quit$
	elsif button == 3
		# If the segmenter chooses to 'Continue', then store the value
		# of the 'task$' and 'testwave$' variables
		.testwave$ = testwave$
		.task$ = task$
		
		.result_node$ = node_next$
	endif
endproc

# console output for debugging
procedure log_nwr_testwave()
	if debug_mode
		appendInfoLine("---- log_nwr_testwave() ----")
		appendInfoLine("Exit Status: ", startup_nwr_testwave.result_node$)
		if startup_nwr_testwave.result_node$ == node_next$
			appendInfoLine("derived values: ")
			appendInfoLine(tab$, ".task$: ", startup_nwr_testwave.task$)
			appendInfoLine(tab$, ".testwave$: ", startup_nwr_testwave.testwave$)
		endif
		appendInfoLine("")
	endif
endproc




# [SUBNODE] Setup directory path names for navigating the local filesystem.
procedure transcription_filepaths(.drive$, .audio_drive$, .task$, .testwave$)
	
	# Where is the non-audio data located?
	data_dir$ = .drive$ + "DataAnalysis/" + .task$ + "/" + .testwave$
	
	# Where are audio files saved?
	.audio_dir$ = .audio_drive$ + "DataAnalysis/" + .task$ + "/" + .testwave$ + "/Recordings"
	
	# Segmentations ready to be transcribed from
	.segmentDirectory$ = data_dir$ + "/Segmentation/TranscriptionReady"
	
	# Where transcriptions and transcription logs go
	.transDirectory$ = data_dir$ + "/Transcription/TranscriptionTextGrids"
	.transLogDirectory$ = data_dir$ + "/Transcription/TranscriptionLogs"

	.wordList_dir$ = data_dir$ + "/WordLists"
	
	# Word List table columns
	if .task$ == "RealWordRep"
		.wl_trial  = 1
		.wl_trial$ = "TrialNumber"
		.wl_word   = 3
		.wl_word$  = "Word"
	elsif .task$ == "NonWordRep"
		.wl_trial  = 1
		.wl_trial$ = "TrialNumber"
		.wl_word   = 3
		.wl_word$  = "Orthography"
	elsif .task$ == "GFTA"
		.wl_trial  = 1
		.wl_trial$ = "word"
		.wl_word   = 3
		.wl_word$  = "ortho"
	endif
endproc

# console output for debugging
procedure log_transcription_filepaths()
	if debug_mode
		appendInfoLine("---- log_transcription_filepaths() ----")
		appendInfoLine("input parameters: ")
		appendInfoLine(tab$, ".drive$: ", transcription_filepaths.drive$)
		appendInfoLine(tab$, ".audio_drive$: ", transcription_filepaths.audio_drive$)
		appendInfoLine(tab$, ".task$: ", transcription_filepaths.task$)
		appendInfoLine(tab$, ".testwave$: ", transcription_filepaths.testwave$)
		appendInfoLine("")
		
		appendInfoLine("derived values: ")
		appendInfoLine(tab$, ".audio_dir$: ", transcription_filepaths.audio_dir$)
		appendInfoLine(tab$, ".segmentDirectory$: ", transcription_filepaths.segmentDirectory$)
		appendInfoLine(tab$, ".transDirectory$: ", transcription_filepaths.transDirectory$)
		appendInfoLine(tab$, ".transLogDirectory$: ", transcription_filepaths.transLogDirectory$)
		appendInfoLine(tab$, ".wordList_dir$: ", transcription_filepaths.wordList_dir$)
		appendInfoLine(tab$, ".wl_trial: ", transcription_filepaths.wl_trial)
		appendInfoLine(tab$, ".wl_trial$: ", transcription_filepaths.wl_trial$)
		appendInfoLine(tab$, ".wl_word: ", transcription_filepaths.wl_word)
		appendInfoLine(tab$, ".wl_word$: ", transcription_filepaths.wl_word$)
		appendInfoLine("")
	endif
endproc




# [NODE] Load a NWR wordlist and store information about the NWR wordlist table
procedure startup_nwr_wordlist(.task$, .experimental_ID$, .drive$, .wordList_dir$)
	# Column number and name constants for a NWR rep table.
	.trial_number      = 1
	.trial_number$     = "TrialNumber"
	.trial_type        = 2
	.trial_type$       = "TrialType"
	.orthography      = 3
	.orthography$     = "Orthography"
	.worldbet         = 4
	.worldbet$        = "WorldBet"
	.frame1           = 5
	.frame1$          = "Frame1"
	.target1          = 6
	.target1$         = "Target1"
	.target2          = 7
	.target2$         = "Target2"
	.frame2           = 8
	.frame2$          = "Frame2"
	.target_structure  = 9
	.target_structure$ = "TargetStructure"
	.frequency        = 10
	.frequency$       = "Frequency"
	.comparison_pair   = 11
	.comparison_pair$  = "ComparisonPair"

	# Try to load the wordlist using the generic word-list loader
	@startup_wordlist(.task$, .experimental_ID$, .drive$, .wordList_dir$)
	@log_startup_wordlist()
	
	.basename$ = startup_wordlist.wordList_basename$
	.filename$ = startup_wordlist.wordList_filename$
	.filepath$ = startup_wordlist.wordList_filepath$
	.table$ = startup_wordlist.wordList_table$
	.exists = startup_wordlist.wordList_exists
	.result_node$ = startup_wordlist.result_node$
endproc



