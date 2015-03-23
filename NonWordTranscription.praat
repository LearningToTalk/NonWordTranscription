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
#       (on 06 May 2014) added "noise" to both, for noise or TOS or the like.
# Left to do:
# If we decide to adopt this strategy, should add way of making the correct transcription
# be the default choice at each of the two steps.

# NonWordTranscription.praat
# Version 4
# Author: Franzo Law II
# Date: 02 October 2014
#  12)  Restructured prosody scoring, such that transcriber is prompted to assign prosody score
#       after transcribing each segment, then prompted to score a frame prosody score for the
#       frame involving the two transcribed segments.
#  12a) Transcriber is prompted to include a WorldBet transcription that is reflective
#       of the production if the frame prosody score is transcribed as incorrect (0)
#  13)  Transcriber is able to more easily transcribe if the target matches the production
#       through the inclusion of a default prompt.
#  14)  Cosmetic changes added, such as phonemic slashes (//) and reminders of the target and
#       and how it has been transcribed, wherever appropriate.
#  15)  Experiment exits gracefully.
#  16) Update to allow for 4-point diphthong offglide scoring 

#######################################################################
# Controls whether the @log_[...] procedures write to the InfoLines.
# debug_mode = 1
debug_mode = 0
abort = 0

# Include the other files mentioned in change 7 of version 2.
include check_version.praat
include segment_features.praat
include ../L2T-utilities/L2T-Utilities.praat
include ../L2T-Audio/L2T-Audio.praat
include ../L2T-StartupForm/L2T-StartupForm.praat
include ../L2T-WordList/L2T-WordList.praat
include ../L2T-SegmentationTextGrid/L2T-SegmentationTextGrid.praat
include ../L2T-Transcription/L2T-Transcription.praat

# Values for .result_node$
node_quit$ = "quit"
node_next$ = "next"
node_back$ = "back"

# Set the session parameters.
defaultExpTask = 1
defaultTestwave = 1
defaultActivity = 3
@session_parameters: defaultExpTask, defaultTestwave, defaultActivity

# Load the audio file
@audio

# Load the WordList.
@wordlist

# Load the checked segmented TextGrid.
@segmentation_textgrid

# Set the transcription-specific parameters.
@transcription_parameters

# Numeric and string constants for the Word List Table.
wordListBasename$ = wordlist.praat_obj$
wordListTrialNumber$ = wordlist_columns.trial_number$
wordListWorldBet$ = wordlist_columns.worldbet$
wordListTarget1$ = wordlist_columns.target1$
wordListTarget2$ = wordlist_columns.target2$
wordListTargetStructure$ = wordlist_columns.target_structure$

# Column numbers from the segmented textgrid
segTextGridTrial = segmentation_textgrid_tiers.trial
segTextGridContext = segmentation_textgrid_tiers.context

# Count the trials of structure type
@count_nwr_wordlist_structures(wordListBasename$, wordListTargetStructure$)
nTrialsCV = count_nwr_wordlist_structures.nTrialsCV
nTrialsVC = count_nwr_wordlist_structures.nTrialsVC
nTrialsCC = count_nwr_wordlist_structures.nTrialsCC

@participant: audio.read_from$, session_parameters.participant_number$

# Check whether the log and textgrid exist already
@transcription_log("check", session_parameters.experimental_task$,  participant.id$, session_parameters.initials$, transcription_parameters.logDirectory$, nTrialsCV, nTrialsVC, nTrialsCC)
@transcription_textgrid("check", session_parameters.experimental_task$,  participant.id$, session_parameters.initials$, transcription_parameters.textGridDirectory$))

# Load or initialize the transcription log/textgrid iff
# the log/textgrid both exist already or both need to be created.
if transcription_log.exists == transcription_textgrid.exists
	@transcription_log("load", session_parameters.experimental_task$, participant.id$, session_parameters.initials$, transcription_parameters.logDirectory$, nTrialsCV, nTrialsVC, nTrialsCC)
	@transcription_textgrid("load", session_parameters.experimental_task$, participant.id$, session_parameters.initials$, transcription_parameters.textGridDirectory$)
# Otherwise exit with an error message
else
	log_part$ = "Log " + transcription_log.filename$
	grid_part$ = "TextGrid " + transcription_textgrid.filename$
	if transcription_log.exists
		msg$ = "Initialization error: " + log_part$ + " was found, but " + grid_part$ + " was not."
	else
		msg$ = "Initialization error: " + grid_part$ + " was found, but " + log_part$ + " was not."
	endif
	exitScript: msg$
endif

# Export values to global namespace
segmentBasename$ = segmentation_textgrid.praat_obj$
segmentTableBasename$ = segmentation_textgrid.tablePraat_obj$
audioBasename$ = audio.praat_obj$
transBasename$ = transcription_textgrid.praat_obj$
transLogBasename$ = transcription_log.praat_obj$

# These are column names
transLogCVs$ = transcription_log.cvs$
transLogCVsTranscribed$ = transcription_log.cvs_transcribed$
transLogVCs$ = transcription_log.vcs$
transLogVCsTranscribed$ = transcription_log.vcs_transcribed$
transLogCCs$ = transcription_log.ccs$
transLogCCsTranscribed$ = transcription_log.ccs_transcribed$

#######################################################################
# Open an Edit window with the segmentation textgrid, so that the transcriber can examine
# the larger segmentation context to recoup from infelicitous segmenting of false starts
# and the like. 
selectObject(segmentBasename$)
Edit

# Open a separate Editor window with the transcription textgrid object and audio file.
selectObject(transBasename$)
plusObject(audioBasename$)
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
while current_type < current_type_limit & !abort
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
		
		# Trial numbers here refer to rows in the Word List table
		trial = n_transcribed + 1

		# If the user chooses no, skip the transcription loop and break out of this loop.
		if button == 1
			trial = n_trials + 1
			current_type = current_type_limit
		endif

		# Loop through the trials of the current type
		while trial <= n_trials & !abort
			# Get the Trial Number (a string value) of the current trial.
			selectObject(wordListBasename$ + "_" + trial_type$)
			trialNumber$ = Get value: trial, wordListTrialNumber$

			# Look up trial number in segmentation table. Compute trial midpoint from table.
			selectObject(segmentTableBasename$)
			segTableRow = Search column: "text", trialNumber$

			@get_xbounds_from_table(segmentTableBasename$, segTableRow)
			trialXMid = get_xbounds_from_table.xmid

			# Find bounds of the textgrid interval containing the trial midpoint
			@get_xbounds_in_textgrid_interval(segmentBasename$, segTextGridTrial, trialXMid)

			# Use the XMin and XMax of the current trial to extract that portion of the segmented 
			# TextGrid, preserving the times. The TextGrid Object that this operation creates will 
			# have the name:
			# ::ExperimentalTask::_::ExperimentalID::_::SegmentersInitials::segm_part
			selectObject(segmentBasename$)
			Extract part: get_xbounds_in_textgrid_interval.xmin, get_xbounds_in_textgrid_interval.xmax, "yes"

			# Convert the (extracted) TextGrid to a Table, which has the
			# same name as the TextGrid from which it was created.
			selectObject(segmentBasename$ + "_part")
			Down to Table: "no", 6, "yes", "no"
			selectObject(segmentBasename$ + "_part")
			Remove

			# Subset the 'segmentBasename$'_part Table to just the intervals on the Context Tier.
			selectObject(segmentTableBasename$ + "_part")
			Extract rows where column (text): "tier", "is equal to", "Context"
			selectObject(segmentTableBasename$ + "_part")
			Remove

			# Count the number of segmented intervals.
			selectObject(segmentTableBasename$ + "_part_Context")
			numResponses = Get number of rows
			# If there is more than one segmented interval, ...
			if numResponses > 1
				# Zoom to the entire trial in the segmentation TextGrid object and 
				# invite the transcriber to select the interval to transcribe.
				editor 'segmentBasename$'
					Zoom: get_xbounds_in_textgrid_interval.xmin, get_xbounds_in_textgrid_interval.xmax
				endeditor
				beginPause("Choose repetition number to transcribe")
					choice("Repetition number", numResponses)
						for repnum from 1 to 'numResponses'
							option("'repnum'")
						endfor
				button = endPause("Back", "Quit", "Choose repetition number", 3)
			else
				repetition_number = 1
			endif

			# Get the Context label of the chosen segmented interval of this trial and also then
			# mark it off in the transcription textgrid ready to transcribe or skip as a NonResponse.
			selectObject(segmentTableBasename$ + "_part_Context")
			contextLabel$ = Get value: repetition_number, "text"

			# Determine the XMin and XMax of the segmented interval.
			@get_xbounds_from_table(segmentTableBasename$ + "_part_Context", repetition_number)
			segmentXMid = get_xbounds_from_table.xmid

			@get_xbounds_in_textgrid_interval(segmentBasename$, segTextGridContext, segmentXMid)
			segmentXMin = get_xbounds_in_textgrid_interval.xmin
			segmentXMax = get_xbounds_in_textgrid_interval.xmax

			# Add interval boundaries on each tier.
			selectObject(transBasename$)
			Insert boundary: transcription_textgrid.target1_seg, segmentXMin
			Insert boundary: transcription_textgrid.target1_seg, segmentXMax
			Insert boundary: transcription_textgrid.target2_seg, segmentXMin
			Insert boundary: transcription_textgrid.target2_seg, segmentXMax
			Insert boundary: transcription_textgrid.prosody, segmentXMin
			Insert boundary: transcription_textgrid.prosody, segmentXMax

			# Determine the target word and target segments. 
			selectObject(wordListBasename$ + "_" + trial_type$)
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
			trans_node_extract_snippet$ = "extract_snippet"
			trans_node_save$ = "save"
			trans_node_next_trial$ = "next_trial"
			trans_node_quit$ = "quit"

			trans_node$ = trans_node_context$
			transcriptionNecessary = 0

			while (trans_node$ != trans_node_quit$) & (trans_node$ != trans_node_next_trial$)


				# [CHECK IF RESPONSE, ETC.]
				if trans_node$ == trans_node_context$
					if (contextLabel$ == "Response") or (contextLabel$=="UnpromptedResponse")
					# If chosen interval is either of the transcribable types of response, proceed to transcription. 
						trans_node$ = trans_node_zoom$
					elsif (contextLabel$ == "NonResponse") or (contextLabel$=="Perseveration")
						# If chosen interval is a non-response of some kind, assign it a score of 0 on each tier
						# and invite the transcriber to insert a note. 
						transcription$ = "NonResponse; ;0"
						selectObject(transBasename$)
						segmentInterval = Get interval at time: transcription_textgrid.target1_seg, segmentXMid
						Set interval text: transcription_textgrid.target1_seg, segmentInterval, transcription$
						segmentInterval = Get interval at time: transcription_textgrid.target2_seg, segmentXMid
						Set interval text: transcription_textgrid.target2_seg, segmentInterval, transcription$
						segmentInterval = Get interval at time: transcription_textgrid.prosody, segmentXMid
						Set interval text: transcription_textgrid.prosody, segmentInterval, transcription$

						#target1$, target2$
						transcription1$ = ""
						transcription2$ = ""
						trans_node$ = trans_node_notes_prompt$
					else
						# Otherwise, assume something is wrong and just invite the transcriber to insert a note. 
						#target1$, target2$
						transcription1$ = ""
						transcription2$ = ""						
						trans_node$ = trans_node_notes_prompt$
					endif
				endif

				# [ZOOM TO SEGMENTED INTERVAL AND CHECK IT]
				if trans_node$ == trans_node_zoom$
					# Zoom to the segmented interval in the editor window.
					editor 'transBasename$'
						Zoom: segmentXMin - 0.25, segmentXMax + 0.25
					endeditor

					trans_node$ = trans_node_t1$

				endif
			
				# [TRANSCRIBE T1]
				if trans_node$ == trans_node_t1$
					@transcribe_segment(trialNumber$, targetNonword$, target1$, target2$, 1)
					@next_back_quit(transcribe_segment.result_node$, trans_node_t1_score$, "", trans_node_quit$)
					trans_node$ = next_back_quit.result$
					if trans_node$ != trans_node_quit$
						transcription1$ = transcribe_segment.segmentTranscription$
					endif
				endif

				# [SCORE T1]
				if trans_node$ == trans_node_t1_score$
					selectObject(transBasename$)
					segmentInterval = Get interval at time: transcription_textgrid.target1_seg, segmentXMid
					Set interval text: transcription_textgrid.target1_seg, segmentInterval, transcribe_segment.transcription$
					trans_node$ = trans_node_t2$
				endif

				# [TRANSCRIBE T2]
				if trans_node$ == trans_node_t2$
					@transcribe_segment(trialNumber$, targetNonword$, target1$, target2$, 2)
					@next_back_quit(transcribe_segment.result_node$, trans_node_t2_score$, "", trans_node_quit$)				
					trans_node$ = next_back_quit.result$
					if trans_node$ != trans_node_quit$
						transcription2$ = transcribe_segment.segmentTranscription$
					endif
				endif

				# [SCORE T2]
				if trans_node$ == trans_node_t2_score$
					selectObject(transBasename$)
					segmentInterval = Get interval at time: transcription_textgrid.target2_seg, segmentXMid
					Set interval text: transcription_textgrid.target2_seg, segmentInterval, transcribe_segment.transcription$
					trans_node$ = trans_node_prosody$
				endif

				# [TRANSCRIBE PROSODY]
				if trans_node$ == trans_node_prosody$
					@transcribe_prosody(targetNonword$, target1$, transcription1$, target2$, transcription2$)
					prosodyInterval = Get interval at time: transcription_textgrid.prosody, segmentXMid
					@check_worldBet(targetNonword$, transcribe_prosody.prosodyScore$)
					Set interval text: transcription_textgrid.prosody, prosodyInterval, check_worldBet.text$
					@next_back_quit(check_worldBet.result_node$, trans_node_notes_prompt$, "", trans_node_quit$)
					trans_node$ = next_back_quit.result$
				endif

				# [PROMPT FOR NOTES]
				if trans_node$ == trans_node_notes_prompt$
					@transcribe_notes(trialNumber$, targetNonword$, target1$, target2$, transcription1$, transcription2$)
	
					@next_back_quit(transcribe_notes.result_node$, trans_node_notes_save$, "", trans_node_quit$)
					trans_node$ = next_back_quit.result$
				endif

				# [WRITE NOTES]
				if trans_node$ == trans_node_notes_save$
				
					# Add a point only if there are notes to write down
					if !transcribe_notes.no_notes
						selectObject(transBasename$)
						Insert point: transcription_textgrid.notes, segmentXMid, transcribe_notes.notes$
					endif
					trans_node$ = trans_node_extract_snippet$
				endif

				# [EXTRACT AND SAVE SNIPPET]
#### Issue: As soon as Mary or Pat has the time, this maybe should be rewritten as a call to a proc  
####    that is stored in a separate file, for use in other scripts such as the segmentation script.
				if trans_node$ == trans_node_extract_snippet$
					# Extract and save a snippet only if the extract_snippet box was checked.
					if transcribe_notes.snippet
						selectObject(audioBasename$)
						Extract part: segmentXMin, segmentXMax, "rectangular", 1, "yes"
						selectObject(transBasename$)
						Extract part: segmentXMin, segmentXMax, "yes"
						selectObject(segmentBasename$)
						Extract part: segmentXMin, segmentXMax, "yes"
						# The extracted snippet collection will be named by the basename for the transcription
						# TextGrid plus the orthographic form for the nonword plus the repetition number.

						selectObject(transBasename$)
						.basename$ = selected$ ("TextGrid")
						snippet_pathname$ = transcription_parameters.transSnippetDirectory$ + "/" + .basename$ + "_" + targetNonword$ + "_" + "'repetition_number'" + ".Collection"

						# It will be saved as a binary praat .Collection file. 
						selectObject(audioBasename$ + "_part")
						plusObject(transBasename$ + "_part")
						plusObject(segmentBasename$ + "_part")
						Save as binary file: snippet_pathname$
						# The three extracted bits are removed from the Objects: window afterwards. 
						selectObject(audioBasename$ + "_part")
						plusObject(transBasename$ + "_part")
						plusObject(segmentBasename$ + "_part")
						Remove
					endif
					trans_node$ = trans_node_save$
				endif
	
				# [SAVE RESULTS]
				if trans_node$ == trans_node_save$
					selectObject(transBasename$)
					Save as text file: transcription_textgrid.filepath$

					# Update the number of CV-trials that have been transcribed.
					selectObject(transLogBasename$)
					log_col$ = transLog'trial_type$'sTranscribed$
					Set numeric value: 1, log_col$, trial
					Save as tab-separated file: transcription_log.filepath$

					trans_node$ = trans_node_next_trial$
				endif
			endwhile

			# [QUIT]
			if trans_node$ == trans_node_quit$
				# If the transcriber decided to quit, then set the 'trial'
				# variable so that the script breaks out of the while-loop.
				trial = nTrialsCV + 1
				abort = 1
			endif
##### This results in a very ungraceful way to quit midstream.  Figure out a better way.

			# [NEXT TRIAL]
			if trans_node$ == trans_node_next_trial$
				# Increment the 'trial'.
				trial = trial + 1
				# Remove the segmented interval's Table from the Praat Object list.
				selectObject(segmentTableBasename$ + "_part_Context")
				Remove
			endif
		endwhile
	endif
endwhile

select all 
Remove

#######################################################################
# PROCEDURE definitions start here


#### PROCEDURE to count NWR wordlist structures for each of the three structure types.
# This should work for RWR wordlist structures, too, when those are modified so that 
# the 24 (or 26?) real words that are matched with nonwords for the lexicality effect
# are transcribed, if we make sure that the TargetStructure column is in the same 
# place and includes "CV" only for those 24 (or 26?) rows. 
procedure count_nwr_wordlist_structures(.wordList_table$, .targetStructure$)
	# Get the number of CV-trials in the Word List table.
	selectObject(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "CV"
	.nTrialsCV = Get number of rows

	# Get the number of VC-trials in the Word List table.
	selectObject(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "VC"
	.nTrialsVC = Get number of rows

	# Get the number of CC-trials in the Word List table.
	selectObject(.wordList_table$)
	Extract rows where column (text): .targetStructure$, "is equal to", "CC"
	.nTrialsCC = Get number of rows
endproc

#### PROCEDURE to count the remaining trials yet to be transribed.
procedure count_remaining_trials(.log_basename$, .row, .trials_col$, .done_col$)
	selectObject(.log_basename$)
	.n_trials = Get value: .row, .trials_col$
	.n_transcribed = Get value: .row, .done_col$
	.n_remaining = .n_trials - .n_transcribed
endproc

#### PROCEDURE to find xmin and xmax from Table representation of TextGrid
# Find the xboundaries of an interval from a tabular representation of a textgrid
procedure get_xbounds_from_table(.table$, .row)
	selectObject(.table$)
	.xmin = Get value: .row, "tmin"
	.xmax = Get value: .row, "tmax"
	.xmid = (.xmin + .xmax) / 2
endproc

#### PROCEDURE to get xmin and xmax of interval in TextGrid object from time point 
# Find the xboundaries of a textgrid interval that contains a given point.
# The .point argument is usually the .xmid value obtained from the above
# get_xbounds_from_table procedure.
procedure get_xbounds_in_textgrid_interval(.textgrid$, .tier_num, .point)
	selectObject(.textgrid$)
	.interval = Get interval at time: .tier_num, .point
	.xmin = Get start point: .tier_num, .interval
	.xmax = Get end point: .tier_num, .interval
	.xmid = (.xmin + .xmax) / 2
endproc


#######################################################################
# TIER-SPECIFIC PROCEDURE definitions start here

#### PROCEDURE to transcribe attributes of prosodic structure on tier for prosody points 
# Prompt the transcriber to transcribe the target sequence prosodically.
procedure transcribe_prosody(.targetNonword$, .target1$, .transcription1$, .target2$, .transcription2$)
	beginPause("Prosodic Transcription for '.targetNonword$'")
		comment("Is prosody /'.target1$'/ transcribed as ['.transcription1$'] in its target position?")
		boolean ("Target1 correct", 1)
		comment("Is prosody /'.target2$'/ transcribed as ['.transcription2$'] in its target position?")
		boolean ("Target2 correct", 1)
		comment("Does the production of '.targetNonword$' have at least the target number of syllables?")
		boolean ("Frame not shortened", 1)
	button = endPause("Quit (without saving this trial)", "Rate Prosody", 2, 1)
	if button == 1
		.result_node$ = node_quit$
	else
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
		.segmentTranscription$ = '.vowel_status$'Symbol$
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
				vowelOffglide$ = omitted$
				vowel_node$ = vowel_node_score$

			# Skip ahead to scoring node also if vowel was unclassifiable.
			elsif vowelLength$ == unclassifiable$
				vowelSymbol$ = unclassifiable$
				vowelLength$ = unclassifiable$
				vowelHeight$ = unclassifiable$
				vowelFrontness$ = unclassifiable$
				vowelOffglide$ = unclassifiable$
				vowel_node$ = vowel_node_score$

			# Skip ahead to scoring node also if token could not be transcribed because of noise.
			elsif vowelLength$ == noise$
				vowelSymbol$ = noise$
				vowelLength$ = missing_data$
				vowelHeight$ = missing_data$
				vowelFrontness$ = missing_data$
				vowelOffglide$ = missing_data$
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
				vowelOffglide$ = transcribe_vowel_height_frontness.offglide$
			endif

			@next_back_quit(transcribe_vowel_height_frontness.result_node$, vowel_node_score$, vowel_node_symbol$, vowel_node_quit$)
			vowel_node$ = next_back_quit.result$
		endif

		# [SCORE VOWEL]
		if vowel_node$ == vowel_node_score$
			# Compute the vowel's segmental score.
			@score_vowel(.target_v$, vowelSymbol$, vowelLength$, vowelHeight$, vowelFrontness$, vowelOffglide$)
			.transcription$ = score_vowel.transcription$
			vowel_node$ = vowel_node_next$
		endif
	endwhile

	.result_node$ = if (vowel_node$ == vowel_node_next$) then node_next$ else node_quit$ endif
endproc

#### PROCEDURE for [VOWEL LENGTH]
procedure transcribe_vowel_length(.trial_number$, .word$, .target1$, .target2$, .target_number)
	.target$ = .target'.target_number'$

	beginPause("Vowel Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", .target_number)
		comment("Does the production match the target /'.target$'/?")
		choice("Correct", 1)
			option("Yes")
			option("No")
		comment("If not, choose from the following 3 sets of English vowel phones:")
		comment("    diphthongs : /aI/, /aU/, /oI/") 
		comment("    tense or long vowels : /i/, /e/, /ae/, /a/, /o/, /u/")
		comment("    short or lax vowels : /I/, /E/, /3r/, /6/, /V/, /U/")
		comment("or specify how the production does not fit into these sets.") 
		choice("Vowel length", 2)
			option(diphthong$)
			option(tense$)
			option(lax$)
			option(omitted$)
			option(other$)
			option(unclassifiable$)
			option(noise$)
	button = endPause("Quit", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = vowel_node_quit$
	else
		.result_node$ = vowel_node_next$
		if correct$ == "Yes"
			.length$ = "skip"
		else
			.length$ = vowel_length$
		endif
	endif
endproc

#### PROCEDURE for [VOWEL SYMBOL] if production is one of 14 vowels of target dialects or a know.
procedure transcribe_vowel_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, .length$)
	# If the vowel was not omitted or unclassifiable, then prompt the transcriber to select the vowel's
	# transcription from a list of WorldBet symbols for the 14 vowel phonemes or some other already
	# attested and analyzed transcription for a vowel.
	if .length$ == "skip"
		.result_node$ = vowel_node_next$
		.symbol$ = .target'.target_number'$
	else
		beginPause("Vowel Transcription")
			@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", .target_number)

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
					option("6")
					option("V")
					option("U")
				elsif .length$ == other$
					option("or")
					option(other$)
				endif
		button = endPause("Back", "Quit", "Transcribe it!", 3)

		if button == 1
			.result_node$ = vowel_node_back$
		elsif button == 2
			.result_node$ = vowel_node_quit$
		else
			.result_node$ = vowel_node_next$
			.symbol$ = vowel_transcription$
		endif
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
		.offglide$ = offglide_'.key$'$
		.result_node$ = vowel_node_next$

	else
	# If the transcriber did not select a WorldBet symbol from either the 14 English vowels or from the
	# already added set of other substitutions, then prompt her to provide a worldbet symbolization.
		beginPause("")
			@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", 0)

			comment("Enter the worldbet for this (non-English?) syllable nucleus: ")
			text("Vowel transcription", "")
	
		button = endPause("Back", "Quit", "Transcribe it!", 3)

		if button == 1
			.result_node$ = vowel_node_back$
		elsif button == 2
			.result_node$ = vowel_node_quit$
		else
			.result_node$ = vowel_node_next$
			.symbol$ = vowel_transcription$
			.length$ = to_be_determined$
			.height$ = to_be_determined$
			.frontness$ = to_be_determined$
			.offglide$ = to_be_determined$
		endif

	endif

endproc


#### PROCEDURE to [SCORE VOWEL].
procedure score_vowel(.target_v$, .symbol$, .length$, .height$, .frontness$, .offglide$)
	if .symbol$ == noise$
		if (.length$ == diphthong$)
			.transcription$ = "'.symbol$';'.length$','.height$','.frontness$','offglide$';'missing_data$'"
		else
			.transcription$ = "'.symbol$';'.length$','.height$','.frontness$';'missing_data$'"
		endif
	else
		# True = 1, False = 0, so we just add the truth values to the score
		.score = 0
		.score = .score + (length_'.target_v$'$ == .length$)
		.score = .score + (height_'.target_v$'$ == .height$)
		.score = .score + (frontness_'.target_v$'$ == .frontness$)
		if (.length$ == diphthong$) 
       			.score = .score + (offglide_'.target_v$'$ == .offglide$)
			.transcription$ = "'.symbol$';'.length$','.height$','.frontness$','.offglide$';'.score'"
		else
			.transcription$ = "'.symbol$';'.length$','.height$','.frontness$';'.score'"
		endif		
	endif
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

			# Skip ahead to scoring node also if consonant could not be transcribed 
			# because of noise or the like.
			elsif consonantManner$ == noise$
				consonantSymbol$ = noise$
				consonantManner$ = missing_data$
				consonantPlace$ = missing_data$
				consonantVoicing$ = missing_data$
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
	.target$ = .target'.target_number'$

	beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", .target_number)
		comment("Does the production match the target /'.target$'/?")
		choice("Correct", 1)
			option("Yes")
			option("No")
		comment("If not, choose from the following 5 sets of English consonants:")
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
			option(noise$)
	button = endPause("Quit", "Transcribe it!", 2)

	if button == 1
		.result_node$ = cons_node_quit$
	else
		.result_node$ = cons_node_next$
		if correct$ == "Yes"
			.manner$ = "skip"
		else
			.manner$ = consonant_manner$
		endif
	endif
endproc

#### PROCEDURE for [CONSONANT SYMBOL]
procedure transcribe_cons_symbol(.trial_number$, .word$, .target1$, .target2$, .target_number, .manner$)

	if .manner$ == "skip"
		.result_node$ = node_next$
		.symbol$ = .target'.target_number'$
	else
		# If the consonant is one of the 24 consonant phonemes (or some other symbolizable sound),
		# then prompt the transcriber to select the consonant's transcription from the list of WorldBet 
		# symbols for the 24 phonemes (or from the list of other recognized sounds).
		beginPause("Consonant Transcription")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", .target_number)

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
			.result_node$ = cons_node_back$
		elsif button == 2
			.result_node$ = cons_node_quit$
		else
			.result_node$ = cons_node_next$
			.symbol$ = consonant_transcription$
		endif
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
			@trial_header(.trial_number$, .word$, .target1$, .target2$, "", "", 0)

			comment("Enter the worldbet for this non-English consonant: ")
			text("Consonant transcription", "")
	
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
	endif

endproc

#### PROCEDURE for scoring a CONSONANT
procedure score_consonant(.target_c$, .symbol$, .manner$, .place$, .voicing$)
	if .symbol$ == noise$
		.transcription$ = "'.symbol$';'.manner$','.place$','.voicing$';'missing_data$'"
	else
		# True = 1, False = 0, so we just add the truth values to the score
		.score = 0
		.score = .score + (manner_'.target_c$'$ == .manner$)
		.score = .score + (place_'.target_c$'$ == .place$)
		.score = .score + (voicing_'.target_c$'$ == .voicing$)
		.transcription$ = "'.symbol$';'.manner$','.place$','.voicing$';'.score'"
	endif
endproc


#### PROCEDURE for entering a NOTE on the notes tier
# Prompt the user to enter notes about the transcription and / or to extract a snippet
# of the Sound Object and the transcription and segmentation TextGrid Objects to 
# save in the ExtractedSnippets directory. 
procedure transcribe_notes(.trial_number$, .word$, .target1$, .target2$, .transcription1$, .transcription2$)
	beginPause("Transcription Notes")
		@trial_header(.trial_number$, .word$, .target1$, .target2$, .transcription1$, .transcription2$, 0)

		comment("You may enter any notes about this transcription below: ")
		text("transcriber_notes", "")

		comment("Should an audio and textgrid snippet be extracted for this trial?")
		boolean("Extract snippet", 0)
		
	button = endPause("Quit (without saving this trial)", "Transcribe it!", 2, 1)

	if button == 1
		.result_node$ = node_quit$
	else
		.notes$ = transcriber_notes$
		.no_notes = length(.notes$) == 0
		.snippet = extract_snippet
		.result_node$ = node_next$
	endif
endproc


#### PROCEDURE for FORMAT of PROMPT
# These lines appear in every transcription prompt
procedure trial_header(.trial_number$, .word$, .target1$, .target2$, .transcription1$, .transcription2$, .target_number)
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

	line_3$ = "Target " + .type1$ + target1_is_current$ + ": /" + .target1$ + "/"
	line_4$ = "Target " + .type2$ + target2_is_current$ + ": /" + .target2$ + "/"

	if .transcription1$ != ""
		line_3$ =  line_3$ + ", transcribed as ['.transcription1$']"
	endif

	if .transcription2$ != ""
		line_4$ =  line_4$ + ", transcribed as ['.transcription2$']"
	endif

	comment("Trial number: '.trial_number$'")
	comment("Target nonword: '.word$'")
	comment(line_3$)
	comment(line_4$)
endproc

procedure check_worldBet(.word$)
	if !(target1_correct & target2_correct & frame_not_shortened)
		beginPause("Adjust Transcription")
		comment("Please alter the WorldBet transcription to conform with your prosody rating")
			text("transcription", .word$)
			button = endPause("Quit (without saving this trial)", "Transcribe it!", 2, 1)

		if button == 1
			.result_node$ = node_quit$
		else
			.result_node$ = node_next$
			.text$ = transcription$ + ";" +  string$ (target1_correct) + ";" + string$ (target2_correct) + ";" + string$ (frame_not_shortened)
		endif
	else
		.result_node$ = node_next$
		.text$ = string$ (target1_correct) + ";" + string$ (target2_correct) + ";" + string$ (frame_not_shortened)
	endif
endproc

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