# NonWordTranscription.praat
# Version 1
# Author: Patrick Reidy
# Date: 10 August 2013

# NonWordTranscription.praat
# Version 2
# Author: Tristan Mahr
# Date: 16-18 April 2014
# 1) Most of the code is now encapsulated in procedures. 
# 2) CV trial type has been generalized so VC and CV trials are now supported.
# 3) Start-up wizard now re-uses code from segmentation start-up.
# 4) Minimum version of praat is now enforced, so can use "Command: [args]" notation.
# 5) Procedures are also used to contain or (hide) related variables in a common namespace. 
# 6) Multistep transcription wizards (consonants, prosody) support a back-button.
# 7) Functionality is now broken up over multiple files.
# 8) Script can now transition to next type of trial when finished with CV

# NonWordTranscription.praat
# Version 3
# Author: Mary Beckman
# Date: 01 May 2014
# 09) vowel transcription changed to parallel consonant transcription
# 10) transcription and scoring separated for non-canonical substitutions
# 11) category of "unclassifiable" added to both C and V transcription (and then later
#       (on 06 May 2014) added "missing_data" to both, for noise or TOS or the like.
# Left to do:
# If we decide to adopt this strategy, should add way of making the correct transcription
# be the default choice at each of the two steps.

#######################################################################
# Controls whether the @log_[...] procedures write to the InfoLines.
debug_mode = 1

# Include the other files mentioned in change 7 of version 2.
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

#######################################################################
# Open an Edit window with the segmentation textgrid, so that the transcriber can examine
# the larger segmentation context to recoup from infelicitous segmenting of false starts
# and the like. 
@selectTextGrid(segmentBasename$)
Edit

# Open a separate Editor window with the transcription textgrid object and audio file.
@selectTextGrid(transBasename$)
plusObject("Sound " + audioBasename$)
Edit
# Set the Spectrogram settings, etc., here.

#######################################################################
# Loop through the trial types
trial_type1$ = "CV"
trial_type2$ = "VC"
trial_type3$ = "CC"
current_type = 1
current_type_limit = 4

# [TRIAL TYPE LOOP]
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

		# Use the XMin and XMax of the current trial to extract that portion of the segmented 
		# TextGrid, preserving the times. The TextGrid Object that this operation creates will 
		# have the name:
		# ::ExperimentalTask::_::ExperimentalID::_::SegmentersInitials::segm_part
		@selectTextGrid(segmentBasename$)
		Extract part: get_xbounds_in_textgrid_interval.xmin, get_xbounds_in_textgrid_interval.xmax, "yes"

		# Convert the (extracted) TextGrid to a Table, which has the
		# same name as the TextGrid from which it was created.
		@selectTextGrid(segmentBasename$ + "_part")
		Down to Table: "no", 6, "yes", "no"
		@selectTextGrid(segmentBasename$ + "_part")
		Remove

		# Subset the 'segmentBasename$'_part Table to just the intervals on the Context Tier.
		@selectTable(segmentBasename$ + "_part")
		Extract rows where column (text): "tier", "is equal to", "Context"
		@selectTable(segmentBasename$ + "_part")
		Remove

		# Count the number of segmented intervals.
		@selectTable(segmentBasename$ + "_part_Context")
		numResponses = Get number of rows
		# If there is more than one segmented interval, ...
		if numResponses > 1
			# Zoom to the entire trial in the segmentation TextGrid object and 
			# invite the transcriber to select the interval to transcribe.
			editor TextGrid 'segmentBasename$'
				Zoom: get_xbounds_in_textgrid_interval.xmin, get_xbounds_in_textgrid_interval.xmax
			endeditor
			beginPause("Choose repetition number to transcribe")
				choice("Repetition number", 1)
					for repnum from 1 to 'numResponses'
						option("'repnum'")
					endfor
			button = endPause("Back", "Quit", "Choose repetition number", 3)
		else
			repetition_number = 1
		endif

		# Get the Context label of the chosen segmented interval of this trial and also then
		# mark it off in the transcription textgrid ready to transcribe or skip as a NonResponse.
		@selectTable(segmentBasename$ + "_part_Context")
		contextLabel$ = Get value: repetition_number, "text"

		# Determine the XMin and XMax of the segmented interval.
		@get_xbounds_from_table(segmentBasename$ + "_part_Context", repetition_number)
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

		# Determine the target word and target segments. 
		@selectTable(wordListBasename$ + "_" + trial_type$)
		targetNonword$ = Get value: trial, wordListWorldBet$
		target1$ = Get value: trial, wordListTarget1$
		target2$ = Get value: trial, wordListTarget2$


		# [TRANSCRIPTION EVENT LOOP]

		# If the trial [context] is a Response or UnpromptedResponse, [zoom] into the interval
		# to be transcribed. Prompt user to transcribe [t1]. Determine [t1_score].
		# Prompt user to transcribe [t2]. Determine [t2_score].
		# Prompt user for [prosody] features. Determine [prosody_score], record [notes], 
		# [save] and move onto [next_trial]. At any point, the user may [quit].
		trans_node_context$ = "context"
		trans_node_zoom$ = "zoom"
		trans_node_t1$ = "t1"
		trans_node_t1_score$ = "t1_score"
		trans_node_t2$ = "t2"
		trans_node_t2_score$ = "t2_score"
		trans_node_prosody$ = "prosody"
		trans_node_prosody_score$ = "prosody_score"
		trans_node_notes_prompt$ = "notes_prompt"
		trans_node_notes_save$ = "notes_save"
		trans_node_save$ = "save"
		trans_node_next_trial$ = "next_trial"
		trans_node_quit$ = "quit"

		trans_node$ = trans_node_context$

		while (trans_node$ != trans_node_quit$) and (trans_node$ != trans_node_next_trial$)


			# [CHECK IF RESPONSE, ETC.]
			if trans_node$ == trans_node_context$
				if (contextLabel$ == "Response") or (contextLabel$=="UnpromptedResponse")
					# If chosen interval is either of the transcribable types of response, proceed to transcription. 
					trans_node$ = trans_node_zoom$
				elsif (contextLabel$ == "NonResponse") or (contextLabel$=="Perseveration")
					# If chosen interval is a non-response of some kind, assign it a score of 0 on each tier
					# and invite the transcriber to insert a note. 
					transcription$ = "NonResponse; ;0"
					@selectTextGrid(transBasename$)
					segmentInterval = Get interval at time: nwr_trans_textgrid.target1_seg, segmentXMid
					Set interval text: nwr_trans_textgrid.target1_seg, segmentInterval, transcription$
					segmentInterval = Get interval at time: nwr_trans_textgrid.target2_seg, segmentXMid
					Set interval text: nwr_trans_textgrid.target2_seg, segmentInterval, transcription$
					segmentInterval = Get interval at time: nwr_trans_textgrid.prosody, segmentXMid
					Set interval text: nwr_trans_textgrid.prosody, segmentInterval, transcription$

					trans_node$ = trans_node_notes_prompt$
				else
					# Otherwise, assume something is wrong and just invite the transcriber to insert a note. 
					trans_node$ = trans_node_notes_prompt$
				endif
			endif

			# [ZOOM TO SEGMENTED INTERVAL AND CHECK IT]
			if trans_node$ == trans_node_zoom$
				# Zoom to the segmented interval in the editor window.
				editor TextGrid 'transBasename$'
					Zoom: segmentXMin - 0.25, segmentXMax + 0.25
				endeditor

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
				# 3 points possible
				# -1 for deleting a segment
				# -1 for inserting a segment
				# -1 for adding or omitting syllables
				prosodyTranscription$ = transcribe_prosody.transcription$
				@selectTextGrid(transBasename$)
				prosodyInterval = Get interval at time: nwr_trans_textgrid.prosody, segmentXMid
				Set interval text: nwr_trans_textgrid.prosody, prosodyInterval, prosodyTranscription$
				trans_node$ = trans_node_notes_prompt$
			endif

			# [PROMPT FOR NOTES]
			if trans_node$ == trans_node_notes_prompt$
				@transcribe_notes(trialNumber$, targetNonword$, target1$, target2$)
				
				@next_back_quit(transcribe_notes.result_node$, trans_node_notes_save$, "", trans_node_quit$)
				trans_node$ = next_back_quit.result$
			endif
			
			# [WRITE NOTES]
			if trans_node$ == trans_node_notes_save$
				
				# Add a point only if there are notes to write down
				if !transcribe_notes.no_notes
					@selectTextGrid(transBasename$)
					Insert point: nwr_trans_textgrid.notes, segmentXMid, transcribe_notes.notes$
				endif
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
##### This results in a very ungraceful way to quit midstream.  Figure out a better way.

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


#######################################################################
# PROCEDURE definitions start here


#### PROCEDURE to count NWR wordlist structures for each of the three structure types.
# This should work for RWR wordlist structures, too, when those are modified so that 
# the 24 (or 26?) real words that are matched with nonwords for the lexicality effect
# are transcribed, if we make sure that the TargetStructure column is in the same 
# place and includes "CV" only for those 24 (or 26?) rows. 
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


#### PROCEDURE to load the transcription log file or create the transcription log Table object.
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


#### PROCEDURE to load the transcription textgrid file or create the TextGrid object.
procedure nwr_trans_textgrid(.method$, .task$, .experimental_ID$, .initials$, .directory$)
	# Numeric and string constants for the NWR transcription textgrid
	.target1_seg = 1
	.target2_seg = 2
	.prosody = 3
	.notes = 4
	
	.target1_seg$ = "Target1Seg"
	.target2_seg$ = "Target2Seg"
	.prosody$ = "Prosody"
	.notes$ = "TransNotes"
	level_names$ = "'.target1_seg$' '.target2_seg$' '.prosody$' '.notes$'"
	
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
			To TextGrid: level_names$, .notes$
			@selectTextGrid(audio_basename$)
			Rename: .basename$
		endif
	endif
endproc


#### PROCEDURE to count the remaining trials yet to be transribed.
procedure count_remaining_trials(.log_basename$, .row, .trials_col$, .done_col$)
	@selectTable(.log_basename$)
	.n_trials = Get value: .row, .trials_col$
	.n_transcribed = Get value: .row, .done_col$
	.n_remaining = .n_trials - .n_transcribed
endproc


#### PROCEDURE to find xmin and xmax from Table representation of TextGrid
# Find the xboundaries of an interval from a tabular representation of a textgrid
procedure get_xbounds_from_table(.table$, .row)
	@selectTable(.table$)
	.xmin = Get value: .row, "tmin"
	.xmax = Get value: .row, "tmax"
	.xmid = (.xmin + .xmax) / 2
endproc

#### PROCEDURE to get xmin and xmax of interval in TextGrid object from time point 
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


#######################################################################
# TIER-SPECIFIC PROCEDURE definitions start here

#### PROCEDURE to transcribe attributes of prosodic structure on tier for prosody points 
# Prompt the transcriber to transcribe the target sequence prosodically.
procedure transcribe_prosody(.trial_number$, .word$, .target1$, .target2$)
	beginPause("Prosodic Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, 0)

		comment("Were any segments in the sequence deleted?")
		boolean("One or both of the segments were deleted", 0)
# Need to modify above so that it is calculated directly from the choice of omitted at the 
# initial stage of choosing [MANNER] for a consonant or [LENGTH] for a vowel. 
		
		comment("Were any extra segments inserted into or next to the target sequence?")
		boolean("An extra consonant was added", 0)
		boolean("An extra vowel was added", 0)
		
		comment("Were any syllables inserted or deleted (anywhere) in the target word?")
		boolean("An extra syllable was added", 0)
		boolean("A syllable was deleted (production is a fragment)", 0)
		comment("Note: Check these 2 boxes only when there too few or too many syllables")
# QUESTION: Do we need to modify above so that transcriber cannot choose both? 

	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		# Score each of the 3 points
		.deletion = one_or_both_of_the_segments_were_deleted
		
		.cons_added = an_extra_consonant_was_added
		.vowel_added = an_extra_vowel_was_added
		.insertion = .cons_added or .vowel_added
		
		.syl_added = an_extra_syllable_was_added
		.syl_deleted = a_syllable_was_deleted
		.syllable = .syl_added or .syl_deleted
		
		.score = 3 - (.insertion + .deletion + .syllable)
		
		# Make text for four-part transcription: [deletion];[insertion];[syllable];[score]
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
		
		if .syl_added and .syl_deleted
			.prosody3$ = "syl_added,syl_deleted,this_point_is_not_reliable"
		elsif .syl_added
			.prosody3$ = "syl_added"
		elsif .syl_deleted
			.prosody3$ = "syl_deleted"
		else
			.prosody3$ = "syl_correct"
		endif
		
		.transcription$ = "'.prosody1$';'.prosody2$';'.prosody3$';'.score'"

		.result_node$ = node_next$
	endif
endproc


#### PROCEDURE to transcribe a segment on tiers for target segment 1 and target segment 2 
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


####  PROCEDURE : outer wrapper for nodes to prompt stages of VOWEL transcription
# Vowels involve multiple prompts/procedures contained in an event loop
procedure transcribe_vowel(.trial_number$, .word$, .target1$, .target2$, .target_number)
	.target_v$ = .target'.target_number'$

	# Prompt user for [LENGTH] then prompt for a  worldbet [VOWEL SYMBOL] of English or
	# for a potentially free-form symbolic worldbet representation of some [OTHER] sound(s).
	# [SCORE] vowel, and continue to the [NEXT] step. At any point, the user may [QUIT].
	vowel_node_length$ = "length"
	vowel_node_symbol$ = "symbol"
	vowel_node_height_frontness$ = "height_frontness"
	vowel_node_score$ = "score"
	vowel_node_quit$ = "quit"
	vowel_node_next$ = "next"

	vowel_node$ = vowel_node_length$

	while (vowel_node$ != vowel_node_quit$) and (vowel_node$ != vowel_node_next$)
		# [LENGTH]
		if vowel_node$ == vowel_node_length$
			@transcribe_vowel_length(.trial_number$, .word$, .target1$, .target2$, .target_number)

			@next_back_quit(transcribe_vowel_length.result_node$, vowel_node_symbol$, "", vowel_node_quit$)
			vowel_node$ = next_back_quit.result$
		endif

		# [SYMBOL]
		if vowel_node$ == vowel_node_symbol$
			vowelLength$ = transcribe_vowel_length.length$
			# Skip ahead to scoring node if vowel was omitted.
			if vowelLength$ == omitted$
				vowelSymbol$ = omitted$
				vowelLength$ = omitted$
				vowelHeight$ = omitted$
				vowelFrontness$ = omitted$
				vowel_node$ = vowel_node_score$

			# Skip ahead to scoring node also if vowel was unclassifiable.
			elsif vowelLength$ == unclassifiable$
				vowelSymbol$ = unclassifiable$
				vowelLength$ = unclassifiable$
				vowelHeight$ = unclassifiable$
				vowelFrontness$ = unclassifiable$
				vowel_node$ = vowel_node_score$

			# Otherwise, user chooses a worldbet symbol
			else
				@transcribe_vowel_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, vowelLength$)

				@next_back_quit(transcribe_vowel_symbol.result_node$, vowel_node_height_frontness$, vowel_node_length$, vowel_node_quit$)
				vowel_node$ = next_back_quit.result$
			endif
		endif

		# [HEIGHT AND FRONTNESS]
		if vowel_node$ == vowel_node_height_frontness$
			vowelSymbol$ = transcribe_vowel_symbol.symbol$
			@transcribe_vowel_height_frontness(.trial_number$, .word$, .target1$, .target2$, .target_number, vowelSymbol$)

			# Export symbol to namespace
			if transcribe_vowel_height_frontness.result_node$ == node_next$
				vowelLength$ = transcribe_vowel_height_frontness.length$
				vowelHeight$ = transcribe_vowel_height_frontness.height$
				vowelFrontness$ = transcribe_vowel_height_frontness.frontness$
			endif

			@next_back_quit(transcribe_vowel_height_frontness.result_node$, vowel_node_score$, vowel_node_symbol$, vowel_node_quit$)
			vowel_node$ = next_back_quit.result$
		endif

		# [SCORE VOWEL]
		if vowel_node$ == vowel_node_score$
			# Compute the vowel's segmental score.
			@score_vowel(.target_v$, vowelSymbol$, vowelLength$, vowelHeight$, vowelFrontness$)
			.transcription$ = score_vowel.transcription$
			vowel_node$ = vowel_node_next$
		endif
	endwhile

	.result_node$ = if (vowel_node$ == vowel_node_next$) then node_next$ else node_quit$ endif
endproc

#### PROCEDURE for [VOWEL LENGTH]
procedure transcribe_vowel_length(.trial_number$, .word$, .target1$, .target2$, .target_number)
	beginPause("Vowel Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
		comment("Choose from the following 3 sets of English vowel phones:")
		comment("    diphthongs : /aI/, /aU/, /oI/") 
		comment("    tense or long vowels : /i/, /e/, /ae/, /a/, /o/, /u/")
		comment("    short or lax vowels : /I/, /E/, /3r/, /V/, /U/")
		comment("or specify how the production does not fit into these sets.") 
		choice("Vowel length", 2)
			option(diphthong$)
			option(tense$)
			option(lax$)
			option(omitted$)
			option(other$)
			option(unclassifiable$)
			option(missing_data$)
	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		.result_node$ = node_next$
		.length$ = vowel_length$
	endif
endproc

#### PROCEDURE for [VOWEL SYMBOL] if production is one of 14 vowels of target dialects or a know.
procedure transcribe_vowel_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, .length$)
	# If the vowel was not omitted or unclassifiable, then prompt the transcriber to select the vowel's
	# transcription from a list of WorldBet symbols for the 14 vowel phonemes or some other already
	# attested and analyzed transcription for a vowel.

	beginPause("Vowel Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)

		choice("Vowel transcription", 1)
			if .length$ == diphthong$
				option("aI")
				option("aU")
				option("oI")
			elsif .length$ == tense$
				option("i")
				option("e")
				option("ae")
				option("a")
				option("o")
				option("u")
			elsif .length$ == lax$
				option("I")
				option("E")
				option("3r")
				option("V")
				option("U")
			elsif .length$ == other$
				option("or")
				option(other$)
			endif
	button = endPause("Back", "Quit", "Transcribe it!", 3)

	if button == 1
		.result_node$ = node_back$
	elsif button == 2
		.result_node$ = node_quit$
	else
		.result_node$ = node_next$
		.symbol$ = vowel_transcription$
	endif
endproc

#### PROCEDURE for parsing the features for a VOWEL from its symbol.
procedure transcribe_vowel_height_frontness(.trial_number$, .word$, .target1$, .target2$, .target_number, .symbol$)
	# If the transcriber selected a WorldBet symbol, then parse its features.
	if .symbol$ != "Other"
		.key$ = .symbol$

		# If the transcriber selected a WorldBet symbol from the list of transcribed substitutions of something
		# other than an English vowel phoneme, we need to use the '.key$' to look up the Length feature,
		# so may as well redundantly do that for all.
		.length$ = length_'.key$'$

		# Use the '.key$' to look up the Height and Frontness features.
		.height$ = height_'.key$'$
		.frontness$ = frontness_'.key$'$
		.result_node$ = node_next$

	else
	# If the transcriber did not select a WorldBet symbol from either the 14 English vowels or from the
	# already added set of other substitutions, then prompt her to provide a worldbet symbolization.
		beginPause("")
			@trial_header(.trial_number$, .word$, .target1$, .target2$, 0)

			comment("Enter the worldbet for this (non-English?) syllable nucleus: ")
			text("Vowel transcription", "")
	
#		button = endPause("Quit (without saving this trial)", "Transcribe it!", 2, 1)
		button = endPause("Back", "Quit", "Transcribe it!", 3)

		if button == 1
			.result_node$ = node_back$
		elsif button == 2
			.result_node$ = node_quit$
		else
			.result_node$ = node_next$
			.symbol$ = vowel_transcription$
			.length$ = to_be_determined$
			.height$ = to_be_determined$
			.frontness$ = to_be_determined$
		endif

	endif

endproc


#### PROCEDURE to [SCORE VOWEL].
procedure score_vowel(.target_v$, .symbol$, .length$, .height$, .frontness$)
	# True = 1, False = 0, so we just add the truth values to the score
	.score = 0
	.score = .score + (length_'.target_v$'$ == .length$)
	.score = .score + (height_'.target_v$'$ == .height$)
	.score = .score + (frontness_'.target_v$'$ == .frontness$)
	.transcription$ = "'.symbol$';'.length$','.height$','.frontness$';'.score'"
endproc

####  PROCEDURE : outer wrapper for nodes to prompt stages of CONSONANT transcription
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

			# Skip ahead to scoring node also if consonant was unclassifiable.
			elsif consonantManner$ == unclassifiable$
				consonantSymbol$ = unclassifiable$
				consonantManner$ = unclassifiable$
				consonantPlace$ = unclassifiable$
				consonantVoicing$ = unclassifiable$
				cons_node$ = cons_node_score$

			# Otherwise, user chooses a WorldBet symbol from among those offered 
			# for the 24 consonant phonemes of the target dialects of English, etc.. 
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
				consonantManner$ = transcribe_cons_place_voice.manner$
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

#### PROCEDURE for [CONSONANT MANNER]
procedure transcribe_cons_manner(.trial_number$, .word$, .target1$, .target2$, .target_number)
	beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
		comment("Choose from the following 5 sets of English consonants:")
		comment("   stops : /p/, /t/, /k/, /b/, /d/, /g/")
		comment("   affricates : /tS/, /dZ/")
		comment("   fricatives : /f/, /T/, /s/, /S/, /h/, /v/, /D/, /z/, /Z/")
		comment("   nasals : /m/, /n/, /N")
		comment("   glides : /w/, /j/, /r/, /l/")
		comment("or specify how the production does not fit into any of the sets.") 
		choice("Consonant manner", 1)
			option(stop$)
			option(affricate$)
			option(fricative$)
			option(nasal$)
			option(glide$)
			option(omitted$)
			option(other$)
			option(unclassifiable$)
			option(missing_data$)
	button = endPause("Quit", "Transcribe it!", 2)

	if button == 1
		.result_node$ = node_quit$
	else
		.result_node$ = node_next$
		.manner$ = consonant_manner$
	endif
endproc

#### PROCEDURE for [CONSONANT SYMBOL]
procedure transcribe_cons_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, .manner$)

	# If the consonant is one of the 24 consonant phonemes (or some other symbolizable sound),
	# then prompt the transcriber to select the consonant's transcription from the list of WorldBet 
	# symbols for the 24 phonemes (or from the list of other recognized sounds).
	beginPause("Consonant Transcription")
	@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)

		choice("Consonant transcription", 1)
			if .manner$ == stop$
				option("p")
				option("t")
				option("k")
				option("b")
				option("d")
				option("g")
			elsif .manner$ == affricate$
				option("tS")
				option("dZ")
			elsif .manner$ == fricative$
				option("f")
				option("T")
				option("s")
				option("S")
				option("h")
				option("v")
				option("D")
				option("z")
				option("Z")
			elsif .manner$ == nasal$
				option("m")
				option("n")
				option("N")
			elsif .manner$ == glide$
				option("j")
				option("w")
				option("l")
				option("r")
			elsif .manner$ == other$
				option("hl")
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


#### PROCEDURE for parsing the features for a CONSONANT from its symbol.
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

		# If the transcriber selected a WorldBet symbol from the list of transcribed substitutions of something
		# other than an English consonant phoneme, we need to use the '.key$' to look up the Manner feature,
		# so may as well redundantly do that for all.
		.manner$ = manner_'.key$'$

		# Use the '.key$' to look up the Place and Voicing features.
		.place$ = place_'.key$'$
		.voicing$ = voicing_'.key$'$
		.result_node$ = node_next$

	else
	# If the transcriber did not select a WorldBet symbol from either the 24 English consonants or from the
	# already added set of other sounds, then prompt her to provide a worldbet symbolization.
		beginPause("")
			@trial_header(.trial_number$, .word$, .target1$, .target2$, 0)

			comment("Enter the worldbet for this non-English consonant: ")
			text("Consonant transcription", "")
	
#		button = endPause("Quit (without saving this trial)", "Transcribe it!", 2, 1)
		button = endPause("Back", "Quit", "Transcribe it!", 3)

		if button == 1
			.result_node$ = node_back$
		elsif button == 2
			.result_node$ = node_quit$
		else
			.result_node$ = node_next$
			.symbol$ = consonant_transcription$
			.manner$ = to_be_determined$
			.place$ = to_be_determined$
			.voicing$ = to_be_determined$
		endif

	# Alternatively, we might also prompt her to select the Manner, Place, and Voicing features 
	# from drop-down menus? 
#		beginPause("Consonant Transcription")
#		@trial_header(.trial_number$, .word$, .target1$, .target2$, .target_number)
#
#			optionMenu("Consonant manner", 1)
#				option(stop$)
#				option(affricate$)
#				option(fricative$)
#				option(nasal$)
#				option(glide$)
#			optionMenu("Consonant place", 1)
#				option(labial$)
#				option(labiodental$)
#				option(labiovelar$)
#				option(dental$)
#				option(alveolar$)
#				option(postalveolar$)
#				option(velar$)
#				option(glottal$)
#			optionMenu("Consonant voicing", 1)
#				option(voiced$)
#				option(voiceless$)
#		button = endPause("Back", "Quit", "Transcribe it!", 3)
#
#		if button == 1
#			.result_node$ = node_back$
#		elsif button == 2
#			.result_node$ = node_quit$
#		else
#			.result_node$ = node_next$
#			.place$ = consonant_place$
#			.voicing$ = consonant_voicing$
#		endif

	endif

endproc

#### PROCEDURE for scoring a CONSONANT
procedure score_consonant(.target_c$, .symbol$, .manner$, .place$, .voicing$)
	# True = 1, False = 0, so we just add the truth values to the score
	.score = 0
	.score = .score + (manner_'.target_c$'$ == .manner$)
	.score = .score + (place_'.target_c$'$ == .place$)
	.score = .score + (voicing_'.target_c$'$ == .voicing$)
	.transcription$ = "'.symbol$';'.manner$','.place$','.voicing$';'.score'"
endproc


#### PROCEDURE for entering a NOTE on the notes tier
# Prompt the user to enter notes about the transcription
procedure transcribe_notes(.trial_number$, .word$, .target1$, .target2$)
	beginPause("Transcription Notes")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, 0)

		comment("You may enter any notes about this transcription below: ")
		text("transcriber_notes", "")
		
	button = endPause("Quit (without saving this trial)", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		.notes$ = transcriber_notes$
		.no_notes = length(.notes$) == 0
		.result_node$ = node_next$
	endif
endproc


#### PROCEDURE for FORMAT of PROMPT
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
