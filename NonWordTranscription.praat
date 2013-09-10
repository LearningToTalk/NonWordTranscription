# Author: Patrick Reidy
# Date: 10 August 2013





# Local filesystem constants.
segmentDirectory$     = "/media/bluelacy/patrick/Code/L2T-NonwordTranscription/Testing/SegmentedTextGrids"
audioDirectory$       = "/media/bluelacy/patrick/Code/L2T-NonwordTranscription/Testing/Audio"
wordListDirectory$    = "/media/bluelacy/patrick/Code/L2T-NonwordTranscription/Testing/WordLists"
transLogDirectory$      = "/media/bluelacy/patrick/Code/L2T-NonwordTranscription/Testing/NonwordTranscriptionLogs"
transDirectory$  = "/media/bluelacy/patrick/Code/L2T-NonwordTranscription/Testing/NonwordTranscriptionTextGrids"

# Manner feature values for the consonants.
stop$      = "Stop"
affricate$ = "Affricate"
fricative$ = "Fricative"
nasal$     = "Nasal"
glide$     = "Glide"
omitted$   = "Omitted"
manner_p$        = stop$
manner_b$        = stop$
manner_t$        = stop$
manner_d$        = stop$
manner_tr$       = stop$
manner_dr$       = stop$
manner_tFlap$    = stop$
manner_dFlap$    = stop$
manner_c$        = stop$
manner_J$        = stop$
manner_k$        = stop$
manner_g$        = stop$
manner_q$        = stop$
manner_Q$        = stop$
manner_glotStop$ = stop$
manner_ts$       = affricate$
manner_dz$       = affricate$
manner_tS$       = affricate$
manner_dZ$       = affricate$
manner_F$        = fricative$
manner_V$        = fricative$
manner_f$        = fricative$
manner_v$        = fricative$
manner_T$        = fricative$
manner_D$        = fricative$
manner_s$        = fricative$
manner_z$        = fricative$
manner_S$        = fricative$
manner_Z$        = fricative$
manner_C$        = fricative$
manner_jV$       = fricative$
manner_x$        = fricative$
manner_G$        = fricative$
manner_X$        = fricative$
manner_K$        = fricative$
manner_H$        = fricative$
manner_exclaim$  = fricative$
manner_h$        = fricative$
manner_hv$       = fricative$
manner_m$        = nasal$
manner_n$        = nasal$
manner_N$        = nasal$
manner_j$        = glide$
manner_w$        = glide$

# Place feature values for the consonants.
bilabial$     = "Bilabial"
labiodental$  = "Labiodental"
dental$       = "Dental"
alveolar$     = "Alveolar"
postalveolar$ = "Postalveolar"
retroflex$    = "Retroflex"
palatal$      = "Palatal"
velar$        = "Velar"
uvular$       = "Uvular"
pharyngeal$   = "Pharyngeal"
glottal$      = "Glottal"
labiovelar$   = "Labiovelar"
other$        = "Other"
place_p$        = bilabial$
place_b$        = bilabial$
place_t$        = alveolar$
place_d$        = alveolar$
place_tr$       = retroflex$
place_dr$       = retroflex$
place_tFlap$    = alveolar$
place_dFlap$    = alveolar$
place_c$        = palatal$
place_J$        = palatal$
place_k$        = velar$
place_g$        = velar$
place_q$        = uvular$
place_Q$        = uvular$
place_glotStop$ = glottal$
place_ts$       = alveolar$
place_dz$       = alveolar$
place_tS$       = postalveolar$
place_dZ$       = postalveolar$
place_F$        = bilabial$
place_V$        = bilabial$
place_f$        = labiodental$
place_v$        = labiodental$
place_T$        = dental$
place_D$        = dental$
place_s$        = alveolar$
place_z$        = alveolar$
place_S$        = postalveolar$
place_Z$        = postalveolar$
place_C$        = palatal$
place_jV$       = palatal$
place_x$        = velar$
place_G$        = velar$
place_X$        = uvular$
place_K$        = uvular$
place_H$        = pharyngeal$
place_exclaim$  = pharyngeal$
place_h$        = glottal$
place_hv$       = glottal$
place_m$        = bilabial$
place_n$        = alveolar$
place_N$        = velar$
place_j$        = palatal$
place_w$        = labiovelar$

# Voicing feature values for the consonants.
voiced$    = "Voiced"
voiceless$ = "Voiceless"
voicing_p$        = voiceless$
voicing_b$        = voiced$
voicing_t$        = voiceless$
voicing_d$        = voiced$
voicing_tr$       = voiceless$
voicing_dr$       = voiced$
voicing_tFlap$    = voiceless$
voicing_dFlap$    = voiced$
voicing_c$        = voiceless$
voicing_J$        = voiced$
voicing_k$        = voiceless$
voicing_g$        = voiced$
voicing_q$        = voiceless$
voicing_Q$        = voiced$
voicing_glotStop$ = voiceless$
voicing_ts$       = voiceless$
voicing_dz$       = voiced$
voicing_tS$       = voiceless$
voicing_dZ$       = voiced$
voicing_F$        = voiceless$
voicing_V$        = voiced$
voicing_f$        = voiceless$
voicing_v$        = voiced$
voicing_T$        = voiceless$
voicing_D$        = voiced$
voicing_s$        = voiceless$
voicing_z$        = voiced$
voicing_S$        = voiceless$
voicing_Z$        = voiced$
voicing_C$        = voiceless$
voicing_jV$       = voiced$
voicing_x$        = voiceless$
voicing_G$        = voiced$
voicing_X$        = voiceless$
voicing_K$        = voiced$
voicing_H$        = voiceless$
voicing_exclaim$  = voiced$
voicing_h$        = voiceless$
voicing_hv$       = voiced$
voicing_m$        = voiced$
voicing_n$        = voiced$
voicing_N$        = voiced$
voicing_j$        = voiced$
voicing_w$        = voiced$

# Height feature values for the target vowels.
high$      = "High"
mid$       = "Mid"
low$       = "Low"
xxxxxxx$   = "XXXXXXXXXX"
height_ae$ = mid$
height_aU$ = xxxxxxx$
height_i$  = high$
height_I$  = high$
height_oi$ = xxxxxxx$
height_u$  = high$
height_U$  = high$
height_V$  = mid$

# Frontness feature values for the target vowels.
front$        = "Front"
central$      = "Central"
back$         = "Back"
frontness_ae$ = front$
frontness_aU$ = xxxxxxx$
frontness_i$  = front$
frontness_I$  = front$
frontness_oi$ = xxxxxxx$
frontness_u$  = back$
frontness_U$  = back$
frontness_V$  = back$

# Length feature values for the target vowels.
tense$     = "Tense"
lax$       = "Lax"
diphthong$ = "Diphthong"
length_ae$  = lax$
length_aU$  = diphthong$
length_i$   = tense$
length_I$   = lax$
length_oi$  = diphthong$
length_u$   = tense$
length_U$   = lax$
length_V$   = lax$

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
# - NumberOfCCsTranscribed (numeric): the number of CC-trails that
#     have been transcribed.
# Numeric and string constants for the NonwordTranscription Log.
transLogTranscriber     = 1
transLogTranscriber$    = "NonwordTranscriber"
transLogStart           = 2
transLogStart$          = "StartTime"
transLogEnd             = 3
transLogEnd$            = "EndTime"
transLogCVs             = 4
transLogCVs$            = "NumberOfCVs"
transLogCVsTranscribed  = 5
transLogCVsTranscribed$ = "NumberOfCVsTranscribed"
transLogVCs             = 6
transLogVCs$            = "NumberOfVCs"
transLogVCsTranscribed  = 7
transLogVCsTranscribed$ = "NumberOfVCsTranscribed"
transLogCCs             = 8
transLogCCs$            = "NumberOfCCs"
transLogCCsTranscribed  = 9
transLogCCsTranscribed$ = "NumberOfCCsTranscribed"

# Description of the Nonword Transcription TextGrid.
transTextGridTarget1Seg   = 1
transTextGridTarget1Seg$  = "Target1Seg"
transTextGridTarget2Seg   = 2
transTextGridTarget2Seg$  = "Target2Pros"
transTextGridProsody      = 3
transTextGridProsody$     = "Prosody"

# Numeric and string constants for the Segmented TextGrid.
segTextGridTrial       = 1
segTextGridTrial$      = "Trial"
segTextGridWord        = 2
segTextGridWord$       = "Word"
segTextGridContext     = 3
segTextGridContext$    = "Context"
segTextGridRepetition  = 4
segTextGridRepetition$ = "Repetition"
segTextGridSegmNotes   = 5
segTextGridSegmNotes$  = "SegmNotes"

# Numeric and string constants for the Word List Table.
wordListTrialNumber      = 1
wordListTrialNumber$     = "TrialNumber"
wordListTrialType        = 2
wordListTrialType$       = "TrialType"
wordListOrthography      = 3
wordListOrthography$     = "Orthography"
wordListWorldBet         = 4
wordListWorldBet$        = "WorldBet"
wordListFrame1           = 5
wordListFrame1$          = "Frame1"
wordListTarget1          = 6
wordListTarget1$         = "Target1"
wordListTarget2          = 7
wordListTarget2$         = "Target2"
wordListFrame2           = 8
wordListFrame2$          = "Frame2"
wordListTargetStructure  = 9
wordListTargetStructure$ = "TargetStructure"
wordListFrequency        = 10
wordListFrequency$       = "Frequency"
wordListComparisonPair   = 11
wordListComparisonPair$  = "ComparisonPair"



# Prompt the transcriber for her initials.
beginPause ("Transcriber's initials")
  comment ("Please enter your initials in the field below.")
  word    ("Your initials", "")
button = endPause ("Quit", "Continue", 2, 1)
if button == 2
  transcribersInitials$ = your_initials$
endif

# Prompt the transcriber to choose the subject's experimental ID.
Create Strings as file list... segmentedTextGrids 'segmentDirectory$'/*segm.TextGrid
select Strings segmentedTextGrids
Sort
beginPause ("Subject's experimental ID")
  comment ("Choose the subject's experimental ID from the menu below.")
  select Strings segmentedTextGrids
  nTextGrids = Get number of strings
  optionMenu ("Experimental ID", 1)
  for nTextGrid to nTextGrids
    segmentedFilename$ = Get string... nTextGrid
    # 'segmentedFilename$' has the form:
    #    "(RealWordRep|NonWordRep)_::ExperimentalID::_XXsegm.TextGrid"
    # Parse the experimental ID from 'segmentedFilename$'.
    experimentalID$ = extractWord$(segmentedFilename$, "_")
    suffixPosition  = rindex(experimentalID$, "_")
    experimentalID$ = left$(experimentalID$, suffixPosition - 1)
    option ("'experimentalID$'")
  endfor
button = endPause ("Quit", "Continue", 2, 1)
  experimentalID$ = experimental_ID$
endif

# Read in the segmented TextGrid from the local filesystem.
segmentExpID$ = ""
nTextGrid     = 0
while segmentExpID$ <> experimentalID$
  # Iterate through the 'segmentedTextGrids' Strings list, parsing
  # out the experimental ID from each filename and comparing it to
  # the experimental ID chosen by the tagger above.
  nTextGrid = nTextGrid + 1
  select Strings segmentedTextGrids
  segmentFilename$ = Get string... nTextGrid
  segmentExpID$    = extractWord$(segmentFilename$, "_")
  suffixPosition   = rindex(segmentExpID$, "_")
  segmentExpID$    = left$(segmentExpID$, suffixPosition - 1)
endwhile
# Set the filepath and basename of the segmented TextGrid.
segmentBasename$ = left$(segmentFilename$, length(segmentFilename$) - 9)
segmentFilepath$ = "'segmentDirectory$'/'segmentFilename$'"
# Read in the segmented TextGrid.
Read from file... 'segmentFilepath$'
# Create a Table from the segmented TextGrid.
select TextGrid 'segmentBasename$'
Down to Table... 0 6 1 0
# Remove the 'segmentedTextGrids' Strings object from the Praat
# objects list.
select Strings segmentedTextGrids
Remove

# Read in the audio file from the local filesystem.
# Create a Strings object from the list of .wav (and .WAV) files in
# the audio directory, and sort it alpha-numerically.
Create Strings as file list... audioFiles 'audioDirectory$'/*.wav
if (macintosh or unix)
  Create Strings as file list... audioFiles2 'audioDirectory$'/*.WAV
  select Strings audioFiles
  plus Strings audioFiles2
  Append
  select Strings audioFiles
  plus Strings audioFiles2
  Remove
  select Strings appended
  Rename... audioFiles
endif
select Strings audioFiles
Sort
nAudioFiles = Get number of strings
# Iterate through the 'audioFiles' Strings list, parsing out the
# experimental ID from each filename and comparing it to the 
# experimental ID chosen by the tagger.
audioExpID$ = ""
nAudioFile  = 0
while (audioExpID$ <> experimentalID$) & (nAudioFile <= nAudioFiles)
  nAudioFile = nAudioFile + 1
  select Strings audioFiles
  audioFilename$ = Get string... nAudioFile
  audioExpID$    = extractWord$(audioFilename$, "_")
  audioExpID$    = left$(audioExpID$, length(audioExpID$) - 4)
endwhile
if nAudioFile <= nAudioFiles
  # If the 'nAudioFile' variable is less than the 'nAudioFiles'
  # constant, then an appropriately named audio file was found.
  # Set the filepath and basename of the audio file.
  audioBasename$ = left$(audioFilename$, length(audioFilename$) - 4)
  audioFilepath$ = "'audioDirectory$'/'audioFilename$'"
  # Read in the audio file.
  Read from file... 'audioFilepath$'
else
  # Otherwise, an appropriately named audio file was not found.
  # Print a message to the Praat output window.
  printline Error when loading the audio file:
  printline   No audio file with experimental ID:
  printline     'experimentalID$' 
  printline   was found in the audio directory:
  printline     'audioDirectory$'
  printline
endif
# Remove the 'audioFiles' Strings object from the Praat objects list.
select Strings audioFiles
Remove

# Read in the Word List table from the local filesystem.
Create Strings as file list... wordLists 'wordListDirectory$'/*WordList.txt
select Strings wordLists
Sort
nWordLists = Get number of strings
wordListExpID$ = ""
nWordList   = 0
while (wordListExpID$ <> experimentalID$) & (nWordList <= nWordLists)
  nWordList = nWordList + 1
  select Strings wordLists
  wordListFilename$ = Get string... nWordList
  wordListExpID$ = extractWord$(wordListFilename$, "_")
  suffixPosition = rindex(wordListExpID$, "_")
  wordListExpID$ = left$(wordListExpID$, suffixPosition - 1)
endwhile
if nWordList <= nWordLists
  # If the 'nWordList' variable is less than the 'nWordLists' constant,
  # then an appropriately named Word List table was found.
  # Set the filepath and basename of the Word List table.
  wordListBasename$ = left$(wordListFilename$, length(wordListFilename$) - 4)
  wordListFilepath$ = "'wordListDirectory$'/'wordListFilename$'"
  # Read in the Word List table.
  Read Table from tab-separated file... 'wordListFilepath$'
  # Get the number of CV-trials in the Word List table.
  select Table 'wordListBasename$'
  Extract rows where column (text)... 'wordListTargetStructure$' "is equal to" CV
  select Table 'wordListBasename$'_CV
  nTrialsCV = Get number of rows
  # Get the number of VC-trials in the Word List table.
  select Table 'wordListBasename$'
  Extract rows where column (text)... 'wordListTargetStructure$' "is equal to" VC
  select Table 'wordListBasename$'_VC
  nTrialsVC = Get number of rows
  # Get the number of CC-trials in the Word List table.
  select Table 'wordListBasename$'
  Extract rows where column (text)... 'wordListTargetStructure$' "is equal to" CC
  select Table 'wordListBasename$'_CC
  nTrialsCC = Get number of rows
else
  # Otherwise, an appropriately named Word List table was not found.
  # Print a message to the Praat output window.
  printline Error when loading the Word List table:
  printline   No Word List table with experimental ID:
  printline    'experimentalID$' 
  printline   was found in the Word List directory:
  printline     'wordListDirectory$'
  printline
endif
select Strings wordLists
Remove

# Look for a Nonword Transcription Log and a Nonword Transcription
# TextGrid on the local filesystem.
# Declare the string constants for the locations of the Nonword 
# Transcription Log and the Nonword Transcription TextGrid.
transLogBasename$ = "'audioBasename$'_'transcribersInitials$'transLog"
transLogFilename$ = "'transLogBasename$'.txt"
transLogFilepath$ = "'transLogDirectory$'/'transLogFilename$'"
transBasename$    = "'audioBasename$'_'transcribersInitials$'trans"
transFilename$    = "'transBasename$'.TextGrid"
transFilepath$    = "'transDirectory$'/'transFilename$'"
# Check if the 'transLogFilepath$' points to a readable file on the
# local filesystem.
transLogExists = fileReadable(transLogFilepath$)
if transLogExists
  # If an appropriately named Nonword Transcription Log exists on the
  # filesystem.
  Read Table from tab-separated file... 'transLogFilepath$'
  # Since a Nonword Transcription Log exists, a Nonword Transcription
  # TextGrid should also exist on the local filesystem.
  transTextGridExists = fileReadable(transFilepath$)
  if transTextGridExists
    # If a Nonword Transcription TextGrid is found on the filesystem,
    # read it into Praat.
    Read from file... 'transFilepath$'
  else
    # If a Nonword Transcription TextGrid is not found on the filesystem,
    # print an error message to the Praat Info window.
    printline Error when loading the Nonword Transcription TextGrid:
    printline   No Nonword Transcription TextGrid with filename:
    printline     'transFilename$'
    printline   was found in the Nonword Transcription TextGrid directory:
    printline     'transDirectory$'
    printline
  endif
else
  # Otherwise create a Nonword Transcription Log.
  Create Table with column names... 'transLogBasename$' 1 'transLogTranscriber$' 'transLogStart$' 'transLogEnd$' 'transLogCVs$' 'transLogCVsTranscribed$' 'transLogVCs$' 'transLogVCsTranscribed$' 'transLogCCs$' 'transLogCCsTranscribed$'
  # Initialize the values of the Nonword Transcription Log.
  currentTime$ = replace$(date$(), " ", "_", 0)
  select Table 'transLogBasename$'
  Set string value... 1 'transLogTranscriber$' 'transcribersInitials$'
  Set string value... 1 'transLogStart$' 'currentTime$'
  Set string value... 1 'transLogEnd$' 'currentTime$'
  Set numeric value... 1 'transLogCVs$' 'nTrialsCV'
  Set numeric value... 1 'transLogCVsTranscribed$' 0
  Set numeric value... 1 'transLogVCs$' 'nTrialsVC'
  Set numeric value... 1 'transLogVCsTranscribed$' 0
  Set numeric value... 1 'transLogCCs$' 'nTrialsCC'
  Set numeric value... 1 'transLogCCsTranscribed$' 0
  # And create a Nonword Transcription TextGrid.
  select Sound 'audioBasename$'
  To TextGrid... "'transTextGridTarget1Seg$' 'transTextGridTarget2Seg$' 'transTextGridProsody$'"
  select TextGrid 'audioBasename$'
  Rename... 'transBasename$'
endif

# Open an Editor window.
select TextGrid 'transBasename$'
plus Sound 'audioBasename$'
Edit
# Set the Spectrogram settings, etc., here.

# Check if there are any CV trials to transcribe.
select Table 'transLogBasename$'
nTrialsCV = Get value... 1 'transLogCVs$'
nTrialsTranscribedCV = Get value... 1 'transLogCVsTranscribed$'
nTrialsLeftCV = nTrialsCV - nTrialsTranscribedCV
if nTrialsTranscribedCV < nTrialsCV
  # If there are still CV trials to transcribe, ask the transcriber
  # if she would like to transcribe them.
  beginPause ("Transcribe CV-trials")
    comment ("There are 'nTrialsLeftCV' CV-trials to transcribe.")
    comment ("Would you like to transcribe them?")
  button = endPause ("No", "Yes", 2, 1)
  if button == 2
    # If the transcriber decided to transcribe the remaining CV-trials
    # Determine the trial (i.e., the row of the CV-Word List table)
    # to start at.
    trial = nTrialsTranscribedCV + 1
    # Loop through the trials (i.e., the rows of the CV-Word List table)
    while trial <= nTrialsCV
      # Get the Trial Number of the current CV-trial.
      select Table 'wordListBasename$'_CV
      trialNumber$ = Get value... 'trial' 'wordListTrialNumber$'
      # Use the 'trialNumber$' to determine, from the segmented TextGrid,
      # the XMin and XMax of the current trial.
      select Table 'segmentBasename$'
      segTableRow = Search column... text 'trialNumber$'
      trialXMin   = Get value... 'segTableRow' tmin
      trialXMax   = Get value... 'segTableRow' tmax
      trialXMid   = (trialXMin + trialXMax) / 2
      select TextGrid 'segmentBasename$'
      trialInterval = Get interval at time... 'segTextGridTrial' 'trialXMid'
      trialXMin     = Get start point... 'segTextGridTrial' 'trialInterval'
      trialXMax     = Get end point... 'segTextGridTrial' 'trialInterval'
      # Use the XMin and XMax of the current trial to extract that 
      # portion of the segmented TextGrid.  The TextGrid that this
      # operation creates will have the name:
      # ::ExperimentalTask::_::ExperimentalID::_::SegmentersInitials::segm_part
      select TextGrid 'segmentBasename$'
      Extract part... 'trialXMin' 'trialXMax' 1
      # Convert the (extracted) TextGrid to a Table, which has the
      # same name as the TextGrid from which it was created.
      select TextGrid 'segmentBasename$'_part
      Down to Table... 0 6 1 0
      # Remove the extracted TextGrid
      select TextGrid 'segmentBasename$'_part
      Remove
      # Subset the 'segmentBasename$'_part Table to just the intervals 
      # on the Context Tier.
      select Table 'segmentBasename$'_part
      Extract rows where column (text)... tier "is equal to" Context
      # Remove the 'segmentBasename$'_part Table.
      select Table 'segmentBasename$'_part
      Remove
      # Get the Context label of the first segmented interval of this
      # trial.
      select Table 'segmentBasename$'_part_Context
      contextLabel$ = Get value... 1 text
      # Check that the segmentation was an actual response.
      if contextLabel$ <> "NonResponse"
        # If the segmentation wasn't a NonResponse, then it needs to
        # be transcribed.
        # Determine the XMin and XMax of the segmented interval.
        select Table 'segmentBasename$'_part_Context
        segmentXMin = Get value... 1 tmin
        segmentXMax = Get value... 1 tmax
        segmentXMid = (segmentXMin + segmentXMax) / 2
        select TextGrid 'segmentBasename$'
        segmentInterval = Get interval at time... 'segTextGridContext' 'segmentXMid'
        segmentXMin     = Get start point... 'segTextGridContext' 'segmentInterval'
        segmentXMax     = Get end point... 'segTextGridContext' 'segmentInterval'
        segmentXMid     = (segmentXMin + segmentXMax) / 2
        # Add interval boundaries on each tier.
        select TextGrid 'transBasename$'
        Insert boundary... 'transTextGridTarget1Seg' 'segmentXMin'
        Insert boundary... 'transTextGridTarget1Seg' 'segmentXMax'
        Insert boundary... 'transTextGridTarget2Seg' 'segmentXMin'
        Insert boundary... 'transTextGridTarget2Seg' 'segmentXMax'
        Insert boundary... 'transTextGridProsody' 'segmentXMin'
        Insert boundary... 'transTextGridProsody' 'segmentXMax'
        # Zoom to the segmented interval in the editor window.
        editor TextGrid 'transBasename$'
          zoomXMin = segmentXMin - 0.25
          zoomXMax = segmentXMax + 0.25
          Zoom... zoomXMin zoomXMax
        endeditor
        # Information to display to the tagger.
        # - Trial Number
        # - Target Word (WorldBet transcription)
        # - Target Consonant (WorldBet transcription)
        # - Target Vowel (WorldBet transcription)
        select Table 'wordListBasename$'_CV
        targetNonword$   = Get value... 'trial' 'wordListWorldBet$'
        targetConsonant$ = Get value... 'trial' 'wordListTarget1$'
        targetVowel$     = Get value... 'trial' 'wordListTarget2$'
        # Prompt the transcriber to the select the consonant's manner feature.
        ######## begin edit #####################
        beginPause ("Consonant Transcription")
          comment ("Trial number: 'trialNumber$'")
          comment ("Target nonword: 'targetNonword$'")
          comment ("Target consonant: 'targetConsonant$'")
          comment ("Target vowel: 'targetVowel$'")
          optionMenu ("Consonant manner", 1)
            option (stop$)
            option (affricate$)
            option (fricative$)
            option (nasal$)
            option (glide$)
            option (omitted$)
        button = endPause ("Quit", "Transcribe it!", 2, 1)
        # Check whether the transcriber decided to transcribe the consonant or quit.
        if button == 2
          # If the transcriber chose to transcribe the consonant, then
          # check the value of the 'consonant_manner$' feature.
          if consonant_manner$ <> omitted$
            # If the consonant was not omitted, then prompt the transcriber
            # to select the consonant's transcription from a list of
            # WorldBet symbols.
            consonantManner$ = consonant_manner$
            beginPause ("Consonant Transcription")
              comment ("Trial number: 'trialNumber$'")
              comment ("Target nonword: 'targetNonword$'")
              comment ("Target consonant: 'targetConsonant$'")
              comment ("Target vowel: 'targetVowel$'")
              optionMenu ("Consonant transcription", 1)
                if consonantManner$ == stop$
                  option ("p")
                  option ("b")
                  option ("t")
                  option ("d")
                  option ("tr")
                  option ("dr")
                  option ("t(")
                  option ("d(")
                  option ("c")
                  option ("J")
                  option ("k")
                  option ("g")
                  option ("q")
                  option ("Q")
                  option ("?")
                  option (other$)
                elsif consonantManner$ == affricate$
                  option ("ts")
                  option ("dz")
                  option ("tS")
                  option ("dZ")
                  option (other$)
                elsif consonantManner$ == fricative$
                  option ("F")
                  option ("V")
                  option ("f")
                  option ("v")
                  option ("T")
                  option ("D")
                  option ("s")
                  option ("z")
                  option ("S")
                  option ("Z")
                  option ("C")
                  option ("j^")
                  option ("x")
                  option ("G")
                  option ("X")
                  option ("K")
                  option ("H")
                  option ("!")
                  option ("h")
                  option ("hv")
                  option (other$)
                elsif consonantManner$ == nasal$
                  option ("m")
                  option ("n")
                  option ("N")
                  option (other$)
                elsif consonantManner$ == glide$
                  option ("j")
                  option ("w")
                  option (other$)
                endif
            button = endPause ("", "Transcribe it!", 2, 1)
            # Check which button the transcriber clicked.
            if button == 2
              # Check whether the transcriber selected a WorldBet symbol.
              if consonant_transcription$ <> "Other"
                # If the transcriber selected a WorldBet symbol, then
                # parse its features.
                # Translate the 'consonant_transcription$' to a character
                # key that can be used to look up the Place and Voicing
                # features.
                if consonant_transcription$ == "t("
                  consonantKey$ = "tFlap"
                elsif consonant_transcription$ == "d("
                  consonantKey$ = "dFlap"
                elsif consonant_transcription$ == "?"
                  consonantKey$ = "glotStop"
                elsif consonant_transcription$ == "j^"
                  consonantKey$ = "jV"
                elsif consonant_transcription$ == "!"
                  consonantKey$ = "exclaim"
                else
                  consonantKey$ = consonant_transcription$
                endif
                # Use the 'consonantKey$' to look up the Place and
                # Voicing features.
                consonantSymbol$ = consonant_transcription$
                consonantPlace$ = place_'consonantKey$'$
                consonantVoicing$ = voicing_'consonantKey$'$
                # Set the switch to transcribe the vowel.
                transcribeVowel = 1
              else
                # If the transcriber did not select a WorldBet symbol,
                # then prompt her to select the Place and Voicing features
                # from drop-down menus.
                beginPause ("Consonant Transcription")
                  comment ("Trial number: 'trialNumber$'")
                  comment ("Target nonword: 'targetNonword$'")
                  comment ("Target consonant: 'targetConsonant$'")
                  comment ("Target vowel: 'targetVowel$'")
                  optionMenu ("Consonant place", 1)
                    option (bilabial$)
                    option (labiodental$)
                    option (labiovelar$)
                    option (dental$)
                    option (alveolar$)
                    option (postalveolar$)
                    option (retroflex$)
                    option (palatal$)
                    option (velar$)
                    option (uvular$)
                    option (pharyngeal$)
                    option (glottal$)
                  optionMenu ("Consonant voicing", 1)
                    option (voiced$)
                    option (voiceless$)
                button = endPause ("", "Transcribe it!", 2, 1)
                if button == 2
                  # Use the transcriber's selections to set the 
                  # Place and Voicing features of the consonant.
                  consonantSymbol$ = ""
                  consonantPlace$ = consonant_place$
                  consonantVoicing$ = consonant_voicing$
                  # Set the switch to transcribe the vowel.
                  transcribeVowel = 1
                else
                  # If the transcriber (accidentally) hit the blank button
                  # (i.e., the left-most button) during the vowel-transcription
                  # phase, then print a message letting them know that they
                  # need to clear all of their Praat objects and rerun the
                  # script.
                  printline Error during Vowel Transcription:
                  printline   Clicking the blank button during the Consonant Transcription phase
                  printline   causes a fatal script error.
                  printline   Clear all of the objects from the Praat Object list, and then
                  printline   rerun the script if you would like to continue transcribing.
                  printline
                  trial = nTrialsCV + 1
                  # Set the switch not to transcribe the vowel.
                  transcribeVowel = 0
                endif
              endif
            else 
              # If the transcriber (accidentally) hit the blank button
              # (i.e., the left-most button) during the vowel-transcription
              # phase, then print a message letting them know that they
              # need to clear all of their Praat objects and rerun the
              # script.
              printline Error during Vowel Transcription:
              printline   Clicking the blank button during the Consonant Transcription phase
              printline   causes a fatal script error.
              printline   Clear all of the objects from the Praat Object list, and then
              printline   rerun the script if you would like to continue transcribing.
              printline
              trial = nTrialsCV + 1
              # Set the switch not to transcribe the vowel.
              transcribeVowel = 0
            endif
          else
            # If the consonant was omitted (i.e., not produced in the
            # attempted repetition of the target word), then ...
            # ... the consonant symbol is Omitted.
            consonantSymbol$ = omitted$
            # ... each of the consonant's features is Omitted.
            consonantManner$   = omitted$
            consonantPlace$    = omitted$
            consonantVoicing$  = omitted$
            # Set the switch to transcribe the vowel.
            transcribeVowel = 1
          endif
          # Decisions made up to this point:
          # 1. Transcribe the consonant, but the blank button may
          #    have been pressed during the Consonant Transcription
          #    phase, which will ruin everything below.
          #    Relevant variable: transcribeVowel
          # 2. If transcribeVowel == 1, then the consonant has been
          #    transcribed for its Manner, Place, and Voicing features.
          if transcribeVowel == 1
            # If the vowel is to be transcribed, then the consonant's
            # feature values have been determined, which means that its
            # segmental score and its transcription can be determined
            # and entered into the TextGrid.
            # Compute the consonant's segmental score.
            consonantScore = 0
            if manner_'targetConsonant$'$ == consonantManner$
              consonantScore = consonantScore + 1
            endif
            if place_'targetConsonant$'$ == consonantPlace$
              consonantScore = consonantScore + 1
            endif
            if voicing_'targetConsonant$'$ == consonantVoicing$
              consonantScore = consonantScore + 1
            endif
            # Determine the consonant's transcription.
            consonantTranscription$ = "'consonantSymbol$';'consonantManner$','consonantPlace$','consonantVoicing$';'consonantScore'"
            # Add the 'consonantTranscription$' to the TextGrid
            select TextGrid 'transBasename$'
            consonantSegInterval = Get interval at time... 'transTextGridTarget1Seg' 'segmentXMid'
            Set interval text... 'transTextGridTarget1Seg' 'consonantSegInterval' 'consonantTranscription$'
        ########  end edit  #####################
#        beginPause ("Consonant Transcription")
#          comment ("Trial number: 'trialNumber$'")
#          comment ("Target nonword: 'targetNonword$'")
#          comment ("Target consonant: 'targetConsonant$'")
#          comment ("Target vowel: 'targetVowel$'")
#          optionMenu ("Consonant manner", 1)
#            option (stop$)
#            option (affricate$)
#            option (fricative$)
#            option (nasal$)
#            option (glide$)
#            option (omitted$)
#          optionMenu ("Consonant place", 1)
#            option (bilabial$)
#            option (alveolar$)
#            option (labiodental$)
#            option (velar$)
#            option (palatal$)
#            option (labiovelar$)
#          optionMenu ("Consonant voicing", 1)
#            option (voiced$)
#            option (voiceless$)
#        button = endPause ("Quit", "Transcribe it!", 2, 1)
#        # Check whether the transcriber decided to transcribe the consonant or quit.
#        if button == 2
#          # If the transcriber chose to transcribe the consonant...
#          # Concatenate the consonant's manner, place, and voicing
#          # feature values into a string that determines its transcription.
#          consonantFeatures$ = "'consonant_manner$', 'consonant_place$', 'consonant_voicing$'"
#          consonantTranscription$ = consonantFeatures$
#          select TextGrid 'transBasename$'
#          consonantSegInterval = Get interval at time... 'transTextGridTarget1Seg' 'segmentXMid'
#          Set interval text... 'transTextGridTarget1Seg' 'consonantSegInterval' 'consonantTranscription$'
            # Prompt the transcriber to select the vowel's feature values.
            beginPause ("Vowel Transcription")
              comment ("Trial number: 'trialNumber$'")
              comment ("Target nonword: 'targetNonword$'")
              comment ("Target consonant: 'targetConsonant$'")
              comment ("Target vowel: 'targetVowel$'")
              optionMenu ("Vowel height", 1)
                option (high$)
                option (mid$)
                option (low$)
              optionMenu ("Vowel frontness", 1)
                option (front$)
                option (central$)
                option (back$)
              optionMenu ("Vowel length", 1)
                option (tense$)
                option (lax$)
                option (diphthong$)
            button = endPause ("", "Transcribe it!", 2, 1)
            if button == 2
              # Compute the vowel's segmental score.
              vowelScore = 0
              if height_'targetVowel$'$ == vowel_height$
                vowelScore = vowelScore + 1
              endif
              if frontness_'targetVowel$'$ == vowel_frontness$
                vowelScore = vowelScore + 1
              endif
              if length_'targetVowel$'$ == vowel_length$
                vowelScore = vowelScore + 1
              endif
              # Concatenate the vowel's height, frontness, and length
              # feature values into a string that determines its transcription.
              #vowelFeatures$ = "'vowel_height$', 'vowel_frontness$', 'vowel_length$'"
              # Add the vowel transcription to the TextGrid.
              #vowelTranscription$ = "'vowelScore'"
              vowelTranscription$ = "'vowel_height$','vowel_frontness$','vowel_length$';'vowelScore'"
              select TextGrid 'transBasename$'
              vowelSegInterval = Get interval at time... 'transTextGridTarget2Seg' 'segmentXMid'
              Set interval text... 'transTextGridTarget2Seg' 'vowelSegInterval' 'vowelTranscription$'
              # Prompt the transcriber to transcribe the target CV prosodically.
              beginPause ("Prosodic Transcription")
                comment ("Trial number: 'trialNumber$'")
                comment ("Target nonword: 'targetNonword$'")
                comment ("Target consonant: 'targetConsonant$'")
                comment ("Target vowel: 'targetVowel$'")
                comment ("Is the target sequence prosodically organized correctly?")
                optionMenu ("Prosodic organization", 1)
                  option ("Yes")
                  option ("No")
              button = endPause ("", "Transcribe it!", 2, 1)
              if button == 2
                # Use the value of 'prosodic_transcription' to determine
                # whether the transcriber must judge the number of syllables
                # spanned by the target sequence.
                if prosodic_organization <> 1
                  beginPause ("Prosodic Transcription")
                    comment ("Trial number: 'trialNumber$'")
                    comment ("Target nonword: 'targetNonword$'")
                    comment ("Target consonant: 'targetConsonant$'")
                    comment ("Target vowel: 'targetVowel$'")
                    comment ("Does the target sequence span the correct number of syllables?")
                    optionMenu ("Syllable span", 1)
                      option ("Yes")
                      option ("No")
                  button = endPause ("", "Transcribe it!", 2, 1)
                  if button == 2
                    # Use the value of 'syllable_span' to determine the score
                    # for the prosodic transcription.
                    if syllable_span <> 1
                      # The target sequence was neither prosodically organized 
                      # correctly, nor did it span the correct number of syllables.
                      prosodyScore = 0
                    else
                      # The target sequence was not prosodically organized
                      # correctly, but it did span the correct number of 
                      # syllables---e.g., an emergent production of a fricative.
                      prosodyScore = 1
                    endif
                    # Add the 'prosodyScore' transcription to the Nonword
                    # Transcription TextGrid.
                    prosodyTranscription$ = "'prosodyScore'"
                    select TextGrid 'transBasename$'
                    prosodyInterval = Get interval at time... 'transTextGridProsody' 'segmentXMid'
                    Set interval text... 'transTextGridProsody' 'prosodyInterval' 'prosodyTranscription$'
                    # Save the Nonword Transcription TextGrid.
                    select TextGrid 'transBasename$'
                    Save as text file... 'transFilepath$'
                    # Update the number of CV-trials that have been transcribed.
                    select Table 'transLogBasename$'
                    Set numeric value... 1 'transLogCVsTranscribed$' 'trial'
                    # Save the Nonword Transcription Log.
                    Save as tab-separated file... 'transLogFilepath$'
                  else
                    # If the transcriber (accidentally) hit the blank button
                    # (i.e., the left-most button) during the prosody-transcription
                    # phase, then print a message letting them know that they
                    # need to clear all of their Praat objects and rerun the
                    # script.
                    printline Error during Prosody Transcription:
                    printline   Clicking the blank button during the Prosody Transcription phase
                    printline   causes a fatal script error.
                    printline   Clear all of the objects from the Praat Object list, and then
                    printline   rerun the script if you would like to continue transcribing.
                    printline
                    trial = nTrialsCV + 1
                  endif
                else
                  # The target sequence was prosodically organized correctly;
                  # hence, it also spanned the correct number of syllables.
                  prosodyScore = 2
                endif
                # Add the 'prosodyScore' transcription to the TextGrid.
                prosodyTranscription$ = "'prosodyScore'"
                select TextGrid 'transBasename$'
                prosodyInterval = Get interval at time... 'transTextGridProsody' 'segmentXMid'
                Set interval text... 'transTextGridProsody' 'prosodyInterval' 'prosodyTranscription$'
                # Save the Nonword Transcription TextGrid.
                select TextGrid 'transBasename$'
                Save as text file... 'transFilepath$'
                # Update the number of CV-trials that have been transcribed.
                select Table 'transLogBasename$'
                Set numeric value... 1 'transLogCVsTranscribed$' 'trial'
                # Save the Nonword Transcription Log.
                Save as tab-separated file... 'transLogFilepath$'
              else
                # If the transcriber (accidentally) hit the blank button
                # (i.e., the left-most button) during the prosody-transcription
                # phase, then print a message letting them know that they
                # need to clear all of their Praat objects and rerun the
                # script.
                printline Error during Prosody Transcription:
                printline   Clicking the blank button during the Prosody Transcription phase
                printline   causes a fatal script error.
                printline   Clear all of the objects from the Praat Object list, and then
                printline   rerun the script if you would like to continue transcribing.
                printline
                trial = nTrialsCV + 1
              endif
            else
              # If the transcriber (accidentally) hit the blank button
              # (i.e., the left-most button) during the vowel-transcription
              # phase, then print a message letting them know that they
              # need to clear all of their Praat objects and rerun the
              # script.
              printline Error during Vowel Transcription:
              printline   Clicking the blank button during the Vowel Transcription phase
              printline   causes a fatal script error.
              printline   Clear all of the objects from the Praat Object list, and then
              printline   rerun the script if you would like to continue transcribing.
              printline
              trial = nTrialsCV + 1
            endif
          endif
        else
          # If the transcriber decided to quit, then set the 'trial'
          # variable so that the script breaks out of the while-loop.
          trial = nTrialsCV + 1
        endif
      else
        # If the segmented interval was a NonResponse, skip it, 
        # and count it as a transcribed CV-trial.
        select Table 'transLogBasename$'
        Set numeric value... 1 'transLogCVsTranscribed$' 'trial'
        # Save the Nonword Transcription Log
        Save as tab-separated file... 'transLogFilepath$'
      endif
      # Increment the 'trial'.
      trial = trial + 1
      # Remove the segmented interval's Table from the Praat Object list.
      select Table 'segmentBasename$'_part_Context
      Remove
    endwhile
  endif
endif



