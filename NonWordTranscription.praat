# Controls whether the @log_[...] procedures write to the InfoLines.
debug_mode = 1

include check_version.praat
include procs.praat
include segment_features.praat
include startup_procs.praat
include transcription_startup.praat





# Numeric and string constants for the Word List Table.
wordListBasename$ = startup_nwr_wordlist.table$
wordListTrialNumber$ = startup_nwr_wordlist.trial_number$
wordListWorldBet$ = startup_nwr_wordlist.worldbet$
wordListTarget1$ = startup_nwr_wordlist.target1$
wordListTarget2$ = startup_nwr_wordlist.target2$
wordListTargetStructure$ = startup_nwr_wordlist.target_structure$

# Column numbers from the segmented textgrid
segTextGridTrial = startup_segm_textgrid.trial
segTextGridContext = startup_segm_textgrid.context




# Count the trials of structure type
@count_nwr_wordlist_structures(wordListBasename$, wordListTargetStructure$)
nTrialsCV = count_nwr_wordlist_structures.nTrialsCV
nTrialsVC = count_nwr_wordlist_structures.nTrialsVC
nTrialsCC = count_nwr_wordlist_structures.nTrialsCC



# Check that the log and textgrid exist already
@nwr_trans_log("check", task$, experimental_ID$, initials$, transLogDirectory$, nTrialsCV, nTrialsVC, nTrialsCC)
@nwr_trans_textgrid("check", task$, experimental_ID$, initials$, transDirectory$)

# Load or initialize the transcription log/textgrid iff
# the log/textgrid both exist already or both need to be created.
if nwr_trans_log.exists == nwr_trans_textgrid.exists
	@nwr_trans_log("load", task$, experimental_ID$, initials$, transLogDirectory$, nTrialsCV, nTrialsVC, nTrialsCC)
	@nwr_trans_textgrid("load", task$, experimental_ID$, initials$, transDirectory$)
# Otherwise exit with an error message
else
	log_part$ = "Log " + nwr_trans_log.filename$
	grid_part$ = "TextGrid " + nwr_trans_textgrid.filename$
	if nwr_trans_log.exists
		msg$ = "Initialization error: " + log_part$ + "was found, but " + grid_part$ + " was not."
	else
		msg$ = "Initialization error: " + grid_part$ + "was found, but " + log_part$ + " was not."
	endif
	exitScript: msg$
endif




# Export values to global namespace
segmentBasename$ = startup_segm_textgrid.basename$
audioBasename$ = startup_load_audio.audio_sound$
transBasename$ = nwr_trans_textgrid.basename$
transLogBasename$ = nwr_trans_log.basename$

# These are column names
transLogCVs$ = nwr_trans_log.cvs$
transLogCVsTranscribed$ = nwr_trans_log.cvs_transcribed$
transLogVCs$ = nwr_trans_log.vcs$
transLogVCsTranscribed$ = nwr_trans_log.vcs_transcribed$
transLogCCs$ = nwr_trans_log.ccs$
transLogCCsTranscribed$ = nwr_trans_log.ccs_transcribed$




# Open an Editor window.
@selectTextGrid(transBasename$)
plusObject("Sound " + audioBasename$)
Edit
# Set the Spectrogram settings, etc., here.







# Loop through the trial types
trial_type1$ = "CV"
trial_type2$ = "VC"
trial_type3$ = "CC"
current_type = 1
current_type_limit = 4

while current_type < current_type_limit
	trial_type$ = trial_type'current_type'$

	# Check if there are any trials to transcribe for this trial type.
	trials_col$ = transLog'trial_type$'s$
	done_col$ = transLog'trial_type$'sTranscribed$

	@count_remaining_trials(transLogBasename$, 1, trials_col$, done_col$)
	n_trials = count_remaining_trials.n_trials
	n_transcribed = count_remaining_trials.n_transcribed
	n_remaining = count_remaining_trials.n_remaining

	# Jump to next type if there are no remaining trials to transcribe
	if n_remaining == 0
		current_type = current_type + 1
	# If there are still trials to transcribe, ask the transcriber if she would like to transcribe them.
	elsif n_transcribed < n_trials
		beginPause("Transcribe 'trial_type$'-trials")
			comment("There are 'n_remaining' 'trial_type$'-trials to transcribe.")
			comment("Would you like to transcribe them?")
		button = endPause("No", "Yes", 2, 1)
	endif	
		
	# Trial numbers here refer to rows in the Word List table
	trial = n_transcribed + 1

	# If the user chooses no, skip the transcription loop and break out of this loop.
	if button == 1
		trial = n_trials + 1
		current_type = current_type_limit
	endif

	# Loop through the trials of the current type
    while trial <= n_trials
		# Get the Trial Number (a string value) of the current trial.
		@selectTable(wordListBasename$ + "_" + trial_type$)
		trialNumber$ = Get value: trial, wordListTrialNumber$

		# Look up trial number in segmentation table. Compute trial midpoint from table.
		@selectTable(segmentBasename$)
		segTableRow = Search column: "text", trialNumber$
		@get_xbounds_from_table(segmentBasename$, segTableRow)
		trialXMid = get_xbounds_from_table.xmid

		# Find bounds of the textgrid interval containing the trial midpoint
		@get_xbounds_in_textgrid_interval(segmentBasename$, segTextGridTrial, trialXMid)

		# Use the XMin and XMax of the current trial to extract that
		# portion of the segmented TextGrid. The TextGrid that this
		# operation creates will have the name:
		# ::ExperimentalTask::_::ExperimentalID::_::SegmentersInitials::segm_part
		@selectTextGrid(segmentBasename$)
		Extract part: get_xbounds_in_textgrid_interval.xmin, get_xbounds_in_textgrid_interval.xmax, "yes"

		# Convert the (extracted) TextGrid to a Table, which has the
		# same name as the TextGrid from which it was created.
		@selectTextGrid(segmentBasename$ + "_part")
		Down to Table: "no", 6, "yes", "no"
		@selectTextGrid(segmentBasename$ + "_part")
		Remove

		# Subset the 'segmentBasename$'_part Table to just the intervals
		# on the Context Tier.
		@selectTable(segmentBasename$ + "_part")
		Extract rows where column (text): "tier", "is equal to", "Context"
		@selectTable(segmentBasename$ + "_part")
		Remove

		# Get the Context label of the first segmented interval of this
		# trial.
		@selectTable(segmentBasename$ + "_part_Context")
		contextLabel$ = Get value: 1, "text"

		# [TRANSCRIPTION EVENT LOOP]

		# If the trial [context] is not a nonresponse, [zoom] into the interval
		# to be transcribed. Prompt user to transcribe [t1]. Determine [t1_score].
		# Prompt user to transcribe [t2]. Determine [t2_score].
		# Prompt user for [prosody_organization] and if necessary
		# [prosody_span]. Determine [prosody_score], [save] and
		# move onto [next_trial]. At any point, the user may [quit].
		trans_node_context$ = "context"
		trans_node_zoom$ = "zoom"
		trans_node_t1$ = "t1"
		trans_node_t1_score$ = "t1_score"
		trans_node_t2$ = "t2"
		trans_node_t2_score$ = "t2_score"
		trans_node_prosody$ = "prosody"
		trans_node_prosody_score$ = "prosody_score"
		trans_node_save$ = "save"
		trans_node_next_trial$ = "next_trial"
		trans_node_quit$ = "quit"

		trans_node$ = trans_node_context$

		while (trans_node$ != trans_node_quit$) and (trans_node$ != trans_node_next_trial$)
			# [CHECK IF NONRESPONSE]
			if trans_node$ == trans_node_context$
				if contextLabel$ != "NonResponse"
					trans_node$ = trans_node_zoom$
				# Skip trial if nonresponse
				else
					trans_node$ = trans_node_save$
				endif
			endif

			# [PREP TEXTGRID FOR TRANSCRIPTION]
			if trans_node$ == trans_node_zoom$
				# Determine the XMin and XMax of the segmented interval.
				@get_xbounds_from_table(segmentBasename$ + "_part_Context", 1)
				segmentXMid = get_xbounds_from_table.xmid

				@get_xbounds_in_textgrid_interval(segmentBasename$, segTextGridContext, segmentXMid)
				segmentXMin = get_xbounds_in_textgrid_interval.xmin
				segmentXMax = get_xbounds_in_textgrid_interval.xmax

				# Add interval boundaries on each tier.
				@selectTextGrid(transBasename$)
				Insert boundary: nwr_trans_textgrid.target1_seg, segmentXMin
				Insert boundary: nwr_trans_textgrid.target1_seg, segmentXMax
				Insert boundary: nwr_trans_textgrid.target2_seg, segmentXMin
				Insert boundary: nwr_trans_textgrid.target2_seg, segmentXMax
				Insert boundary: nwr_trans_textgrid.prosody, segmentXMin
				Insert boundary: nwr_trans_textgrid.prosody, segmentXMax

				# Zoom to the segmented interval in the editor window.
				editor TextGrid 'transBasename$'
					Zoom: segmentXMin - 0.25, segmentXMax + 0.25
				endeditor

				@selectTable(wordListBasename$ + "_" + trial_type$)
				targetNonword$ = Get value: trial, wordListWorldBet$
				target1$ = Get value: trial, wordListTarget1$
				target2$ = Get value: trial, wordListTarget2$
				trans_node$ = trans_node_t1$
			endif

			# [TRANSCRIBE T1]
			if trans_node$ == trans_node_t1$
				@transcribe_segment(trialNumber$, targetNonword$, target1$, target2$, 1)
				@next_back_quit(transcribe_segment.result_node$, trans_node_t1_score$, "", trans_node_quit$)
				trans_node$ = next_back_quit.result$
			endif

			# [SCORE T1]
			if trans_node$ == trans_node_t1_score$
				@selectTextGrid(transBasename$)
				segmentInterval = Get interval at time: nwr_trans_textgrid.target1_seg, segmentXMid
				Set interval text: nwr_trans_textgrid.target1_seg, segmentInterval, transcribe_segment.transcription$
				trans_node$ = trans_node_t2$
			endif

			# [TRANSCRIBE T2]
			if trans_node$ == trans_node_t2$
				@transcribe_segment(trialNumber$, targetNonword$, target1$, target2$, 2)
				@next_back_quit(transcribe_segment.result_node$, trans_node_t2_score$, "", trans_node_quit$)
				trans_node$ = next_back_quit.result$
			endif

			# [SCORE T2]
			if trans_node$ == trans_node_t2_score$
				@selectTextGrid(transBasename$)
				segmentInterval = Get interval at time: nwr_trans_textgrid.target2_seg, segmentXMid
				Set interval text: nwr_trans_textgrid.target2_seg, segmentInterval, transcribe_segment.transcription$
				trans_node$ = trans_node_prosody$
			endif

			# [TRANSCRIBE PROSODY]
			if trans_node$ == trans_node_prosody$
				@transcribe_prosody(trialNumber$, targetNonword$, target1$, target2$)

				@next_back_quit(transcribe_prosody.result_node$, trans_node_prosody_score$, "", trans_node_quit$)
				trans_node$ = next_back_quit.result$
			endif

			# [PROSODY SCORE]
			if trans_node$ == trans_node_prosody_score$
				# 2 points possible
				# -1 for deleting a segment
				# -1 for inserting a segment
				prosodyTranscription$ = transcribe_prosody.transcription$
                @selectTextGrid(transBasename$)
                prosodyInterval = Get interval at time: nwr_trans_textgrid.prosody, segmentXMid
                Set interval text: nwr_trans_textgrid.prosody, prosodyInterval, prosodyTranscription$
				trans_node$ = trans_node_save$
			endif

			# [SAVE RESULTS]
			if trans_node$ == trans_node_save$
                @selectTextGrid(transBasename$)
                Save as text file: nwr_trans_textgrid.filepath$

                # Update the number of CV-trials that have been transcribed.
                @selectTable(transLogBasename$)
				log_col$ = transLog'trial_type$'sTranscribed$
                Set numeric value: 1, log_col$, trial
                Save as tab-separated file: nwr_trans_log.filepath$

				trans_node$ = trans_node_next_trial$
			endif
		endwhile

		# [QUIT]
		if trans_node$ == trans_node_quit$
			# If the transcriber decided to quit, then set the 'trial'
			# variable so that the script breaks out of the while-loop.
			trial = nTrialsCV + 1
		endif

		# [NEXT TRIAL]
		if trans_node$ == trans_node_next_trial$
			# Increment the 'trial'.
			trial = trial + 1
			# Remove the segmented interval's Table from the Praat Object list.
			@selectTable(segmentBasename$ + "_part_Context")
			Remove
		endif

    endwhile
endwhile















procedure count_nwr_wordlist_structures(.wordList_table$, .targetStructure$)
	# Get the number of CV-trials in the Word List table.
	@selectTable(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "CV"
	.nTrialsCV = Get number of rows

	# Get the number of VC-trials in the Word List table.
	@selectTable(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "VC"
	.nTrialsVC = Get number of rows

	# Get the number of CC-trials in the Word List table.
	@selectTable(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "CC"
	.nTrialsCC = Get number of rows
endproc



procedure nwr_trans_log(.method$, .task$, .experimental_ID$, .initials$, .directory$, .n_cv, .n_vc, .n_cc)
	# Description of the Nonword Transcription Log.
	# A table with one row and the following columns (values).
	# - NonwordTranscriber (string): the initials of the nonword
	#     transcriber.
	# - StartTime (string): the date & time that the transcription began.
	# - EndTime (string): the date & time that the transcription ended.
	# - NumberOfCVs (numeric): the number of trials (rows) in the Word
	#     List table whose target sequence is a CV.
	# - NumberOfCVsTranscribed (numeric): the number of CV-trials that
	#     have been transcribed.
	# - NumberOfVCs (numeric): the number of trials (rows) in the Word
	#     List table whose target sequence is a VC.
	# - NumberOfVCsTranscribed (numeric): the number of VC-trials that
	#     have been transcribed.
	# - NumberOfCCs (numeric): the number of trials (rows) in the Word
	#     List table whose target sequence is a CC.
	# - NumberOfCCsTranscribed (numeric): the number of CC-trials that
	#     have been transcribed.
	# Numeric and string constants for the NonwordTranscription Log.

	# Numeric and string constants for the NWR transcription log
	.transcriber     = 1
	.transcriber$    = "NonwordTranscriber"
	.start           = 2
	.start$          = "StartTime"
	.end             = 3
	.end$            = "EndTime"
	.cvs             = 4
	.cvs$            = "NumberOfCVs"
	.cvs_transcribed  = 5
	.cvs_transcribed$ = "NumberOfCVsTranscribed"
	.vcs             = 6
	.vcs$            = "NumberOfVCs"
	.vcs_transcribed  = 7
	.vcs_transcribed$ = "NumberOfVCsTranscribed"
	.ccs             = 8
	.ccs$            = "NumberOfCCs"
	.ccs_transcribed  = 9
	.ccs_transcribed$ = "NumberOfCCsTranscribed"

	# Concatenate column names argument for the Create Table command
	column_names$ = "'.transcriber$' '.start$' '.end$' '.cvs$' '.cvs_transcribed$' '.vcs$' '.vcs_transcribed$' '.ccs$' '.ccs_transcribed$'"

	# Filename constants
	audio_basename$ = .experimental_ID$ + "_Audio"
	.basename$ = .task$ + "_" + .experimental_ID$ + "_" + .initials$ + "transLog"
	.filename$ = .basename$ + ".txt"
	.filepath$ = .directory$ + "/" + .filename$
	.exists = fileReadable(.filepath$)

	## Pseudo-methods

	if .method$ == "check"
		# Do nothing. The checking already happened above. But we make a
		# pseudomethod called "check" so we can describe what happens when
		# only the above code is executed.
	endif

	if .method$ == "load"
		if .exists
			Read Table from tab-separated file: .filepath$
		else
			# Initialize the values of the Nonword Transcription Log.
			Create Table with column names: .basename$, 1, column_names$

			currentTime$ = replace$(date$(), " ", "_", 0)
			@selectTable(.basename$)

			Set string value: 1, .transcriber$, .initials$
			Set string value: 1, .start$, currentTime$
			Set string value: 1, .end$, currentTime$

			Set numeric value: 1, .cvs_transcribed$, 0
			Set numeric value: 1, .vcs_transcribed$, 0
			Set numeric value: 1, .ccs_transcribed$, 0

			Set numeric value: 1, .cvs$, .n_cv
			Set numeric value: 1, .vcs$, .n_vc
			Set numeric value: 1, .ccs$, .n_cc
		endif
	endif
endproc

procedure nwr_trans_textgrid(.method$, .task$, .experimental_ID$, .initials$, .directory$)
	# Numeric and string constants for the NWR transcription textgrid
	.target1_seg   = 1
	.target1_seg$  = "Target1Seg"
	.target2_seg   = 2
	.target2_seg$  = "Target2Pros"
	.prosody      = 3
	.prosody$     = "Prosody"
	level_names$ = "'.target1_seg$' '.target2_seg$' '.prosody$'"

	audio_basename$ = .experimental_ID$ + "_Audio"
	.basename$ = .task$ + "_" + .experimental_ID$ + "_" + .initials$ + "trans"
	.filename$ = .basename$ + ".TextGrid"
	.filepath$ = .directory$ + "/" + .filename$
	.exists = fileReadable(.filepath$)

	## Pseudo-methods

	if .method$ == "check"
		# Do nothing. The checking already happened above. But we make a
		# pseudomethod called "check" so we can describe what happens when
		# only the above code is executed.
	endif

	if .method$ == "load"
		if .exists
			Read from file: .filepath$
		else
			# Initialize the textgrid
			@selectSound(audio_basename$)
			To TextGrid: level_names$, ""
			@selectTextGrid(audio_basename$)
			Rename: .basename$
		endif
	endif
endproc

procedure count_remaining_trials(.log_basename$, .row, .trials_col$, .done_col$)
	@selectTable(.log_basename$)
	.n_trials = Get value: .row, .trials_col$
	.n_transcribed = Get value: .row, .done_col$
	.n_remaining = .n_trials - .n_transcribed
endproc



# Find up the xboundaries of an interval from a tabular representation of a textgrid
procedure get_xbounds_from_table(.table$, .row)
	@selectTable(.table$)
	.xmin = Get value: .row, "tmin"
	.xmax = Get value: .row, "tmax"
	.xmid = (.xmin + .xmax) / 2
endproc

# Find the xboundaries of a textgrid interval that contains a given point.
# The .point argument is usually the .xmid value obtained from the above
# get_xbounds_from_table procedure.
procedure get_xbounds_in_textgrid_interval(.textgrid$, .tier_num, .point)
	@selectTextGrid(.textgrid$)
	.interval = Get interval at time: .tier_num, .point
	.xmin = Get start point: .tier_num, .interval
	.xmax = Get end point: .tier_num, .interval
	.xmid = (.xmin + .xmax) / 2
endproc







# Prompt the transcriber to transcribe the target CV prosodically.
procedure transcribe_prosody(.trial_number$, .word$, .target1$, .target2$)
	beginPause("Prosodic Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, 0)

		comment("Were any segments in the sequence deleted?")
		boolean("One or both of the segments were deleted", 0)
		
		comment("Were any extra segments inserted into or next to the target sequence?")
		boolean("An extra consonant was added", 0)
		boolean("An extra vowel was added", 0)
	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		.deletion = one_or_both_of_the_segments_were_deleted
		.cons_added = an_extra_consonant_was_added
		.vowel_added = an_extra_vowel_was_added
		.insertion = .cons_added or .vowel_added
		
		.score = 2 - (.insertion + .deletion)
		
		# Make text for three-part transcription: [deletion];[insertion];[score]
		if .deletion
			.prosody1$ = "segment_deleted"
		else
			.prosody1$ = "nothing_deleted"
		endif
				
		if .cons_added and .vowel_added
			.prosody2$ = "C_added,V_added"
		elsif .cons_added 
			.prosody2$ = "C_added"
		elsif .vowel_added
			.prosody2$ = "V_added"
		else
			.prosody2$ = "nothing_added"
		endif
		
		.transcription$ = "'.prosody1$';'.prosody2$';'.score'"

		.result_node$ = node_next$
	endif
endproc



procedure transcribe_segment(.trial_number$, .word$, .target1$, .target2$, .target_number)
	# Dispatch based on vowel status
	@is_vowel(.target'.target_number'$)
	.vowel_status$ = is_vowel.name$

	if .vowel_status$ == "vowel"
		@transcribe_vowel(.trial_number$, .word$, .target1$, .target2$, .target_number)
		.result_node$ = transcribe_vowel.result_node$
	else
		@transcribe_consonant(.trial_number$, .word$, .target1$, .target2$, .target_number)
		.result_node$ = transcribe_consonant.result_node$
	endif

	# Store the transcription if it exists
	if .result_node$ != node_quit$
			.transcription$ = transcribe_'.vowel_status$'.transcription$
	endif
endproc

# Vowels are straightforward
procedure transcribe_vowel(.trial_number$, .word$, .target1$, .target2$, .target_number)
	.target_v$ = .target'.target_number'$

	beginPause("Vowel Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
		optionMenu("Vowel height", 1)
			option(high$)
			option(mid$)
			option(low$)
		optionMenu("Vowel frontness", 1)
			option(front$)
			option(central$)
			option(back$)
		optionMenu("Vowel length", 1)
			option(tense$)
			option(lax$)
			option(diphthong$)
		comment("Note: Diphthongs are scored for height and frontness using ")
		comment("the first vowel in the diphthong (/o/ for /oi/ and /a/ for /aU/)")
	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		@score_vowel(.target_v$, vowel_height$, vowel_frontness$, vowel_length$)
		.transcription$ = score_vowel.transcription$
		.result_node$ = node_next$
	endif
endproc

procedure score_vowel(.target_v$, .height$, .frontness$, .length$)
	# True = 1, False = 0, so we just add the truth values to the score
	.score = 0
	.score = .score + (height_'.target_v$'$ == .height$)
	.score = .score + (frontness_'.target_v$'$ == .frontness$)
	.score = .score + (length_'.target_v$'$ == .length$)
	.transcription$ = "'.height$','.frontness$','.length$';'.score'"
endproc


# Consonants involve multiple prompts/procedures contained in an event loop
procedure transcribe_consonant(.trial_number$, .word$, .target1$, .target2$, .target_number)
	.target_c$ = .target'.target_number'$

	# Prompt user for [manner] then prompt for a  worldbet [symbol].
	# Determine [place_voice] features for consonant. [score] consonant, and
	# continue to the [next] step. At any point, the user may [quit].
	cons_node_manner$ = "manner"
	cons_node_symbol$ = "symbol"
	cons_node_place_voice$ = "place_voice"
	cons_node_score$ = "score"
	cons_node_quit$ = "quit"
	cons_node_next$ = "next"

	cons_node$ = cons_node_manner$

	while (cons_node$ != cons_node_quit$) and (cons_node$ != cons_node_next$)
		# [MANNER]
		if cons_node$ == cons_node_manner$
			@transcribe_cons_manner(.trial_number$, .word$, .target1$, .target2$, .target_number)

			@next_back_quit(transcribe_cons_manner.result_node$, cons_node_symbol$, "", cons_node_quit$)
			cons_node$ = next_back_quit.result$
		endif

		# [SYMBOL]
		if cons_node$ == cons_node_symbol$
			consonantManner$ = transcribe_cons_manner.manner$
			# Skip ahead to scoring node if consonant was omitted.
			if consonantManner$ == omitted$
				consonantSymbol$ = omitted$
				consonantManner$ = omitted$
				consonantPlace$ = omitted$
				consonantVoicing$ = omitted$
				cons_node$ = cons_node_score$

			# Otherwise, user chooses a worldbet symbol
			else
				@transcribe_cons_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, consonantManner$)

				@next_back_quit(transcribe_cons_symbol.result_node$, cons_node_place_voice$, cons_node_manner$, cons_node_quit$)
				cons_node$ = next_back_quit.result$
			endif
		endif

		# [PLACE AND VOICING]
		if cons_node$ == cons_node_place_voice$
			consonantSymbol$ = transcribe_cons_symbol.symbol$
			@transcribe_cons_place_voice(.trial_number$, .word$, .target1$, .target2$, .target_number, consonantSymbol$)

			# Export place and voicing features to namespace
			if transcribe_cons_place_voice.result_node$ == node_next$
				consonantPlace$ = transcribe_cons_place_voice.place$
				consonantVoicing$ = transcribe_cons_place_voice.voicing$
			endif

			@next_back_quit(transcribe_cons_place_voice.result_node$, cons_node_score$, cons_node_symbol$, cons_node_quit$)
			cons_node$ = next_back_quit.result$
		endif

		# [SCORE CONSONANT]
		if cons_node$ == cons_node_score$
			# Compute the consonant's segmental score.
			@score_consonant(.target_c$, consonantSymbol$, consonantManner$, consonantPlace$, consonantVoicing$)
			.transcription$ = score_consonant.transcription$
			cons_node$ = cons_node_next$
		endif
	endwhile

	.result_node$ = if (cons_node$ == cons_node_next$) then node_next$ else node_quit$ endif
endproc


procedure transcribe_cons_manner(.trial_number$, .word$, .target1$, .target2$, .target_number)
	beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
		optionMenu("Consonant manner", 1)
			option(stop$)
			option(affricate$)
			option(fricative$)
			option(nasal$)
			option(glide$)
			option(omitted$)
	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		.result_node$ = node_next$
		.manner$ = consonant_manner$
	endif
endproc

procedure transcribe_cons_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, .manner$)
	# If the consonant was not omitted, then prompt the transcriber
	# to select the consonant's transcription from a list of
	# WorldBet symbols.

	beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)

		optionMenu("Consonant transcription", 1)
			if .manner$ == stop$
				option("p")
				option("b")
				option("t")
				option("d")
				option("t(")
				option("d(")
				option("k")
				option("g")
				option("?")
				option(other$)
			elsif .manner$ == affricate$
				option("tS")
				option("dZ")
				option(other$)
			elsif .manner$ == fricative$
				option("f")
				option("v")
				option("T")
				option("D")
				option("s")
				option("z")
				option("S")
				option("Z")
				option("h")
				option("hv")
				option("hl")
				option("hlv")
				option(other$)
			elsif .manner$ == nasal$
				option("m")
				option("n")
				option("N")
				option(other$)
			elsif .manner$ == glide$
				option("j")
				option("w")
				option("l")
				option("r")
				option(other$)
			endif
	button = endPause("Back", "Quit", "Transcribe it!", 3)

	if button == 1
		.result_node$ = node_back$
	elsif button == 2
		.result_node$ = node_quit$
	else
		.result_node$ = node_next$
		.symbol$ = consonant_transcription$
	endif
endproc


procedure transcribe_cons_place_voice(.trial_number$, .word$, .target1$, .target2$, .target_number, .symbol$)
	# If the transcriber selected a WorldBet symbol, then parse its features.
	if .symbol$ != "Other"
		# Translate the '.symbol$' to a character key that can be used to look up the Place and Voicing features.
		if .symbol$ == "t("
			.key$ = "tFlap"
		elsif .symbol$ == "d("
			.key$ = "dFlap"
		elsif .symbol$ == "?"
			.key$ = "glotStop"
		else
			.key$ = .symbol$
		endif

		# Use the '.key$' to look up the Place and Voicing features.
		.place$ = place_'.key$'$
		.voicing$ = voicing_'.key$'$
		.result_node$ = node_next$

	# If the transcriber did not select a WorldBet symbol, then prompt her to select the Place and Voicing features from drop-down menus.
	else
		beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)

			optionMenu("Consonant place", 1)
				option(bilabial$)
				option(labiodental$)
				option(labiovelar$)
				option(dental$)
				option(alveolar$)
				option(postalveolar$)
				option(velar$)
				option(glottal$)
			optionMenu("Consonant voicing", 1)
				option(voiced$)
				option(voiceless$)
		button = endPause("Back", "Quit", "Transcribe it!", 3)

		if button == 1
			.result_node$ = node_back$
		elsif button == 2
			.result_node$ = node_quit$
		else
			.result_node$ = node_next$
			.place$ = consonant_place$
			.voicing$ = consonant_voicing$
		endif

	endif

endproc

procedure score_consonant(.target_c$, .symbol$, .manner$, .place$, .voicing$)
	# True = 1, False = 0, so we just add the truth values to the score
	.score = 0
	.score = .score + (manner_'.target_c$'$ == .manner$)
	.score = .score + (place_'.target_c$'$ == .place$)
	.score = .score + (voicing_'.target_c$'$ == .voicing$)
	.transcription$ = "'.symbol$';'.manner$','.place$','.voicing$';'.score'"
endproc


# These lines appear in every transcription prompt
procedure trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
	# Neither sound is currently being transcribed by default
	target1_is_current$ = ""
	target2_is_current$ = ""

	if .target_number = 1
		target1_is_current$ = " (currently transcribing)"
	elsif .target_number = 2
		target2_is_current$ = " (currently transcribing)"
	endif

	@is_vowel(.target1$)
	.type1$ = is_vowel.name$
	@is_vowel(.target2$)
	.type2$ = is_vowel.name$

	line_3$ = "Target " + .type1$ + target1_is_current$ + ": " + .target1$
	line_4$ = "Target " + .type2$ + target2_is_current$ + ": " + .target2$

	comment("Trial number: '.trial_number$'")
	comment("Target nonword: '.word$'")
	comment(line_3$)
	comment(line_4$)
endproc



