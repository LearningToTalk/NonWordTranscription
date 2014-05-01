######### PROCEDURES
# This procedure checks to see if the current target segment is one of the 14 
# vowel phonemes that occur in stressed syllables in the target English dialects.
procedure is_vowel(.x$)
	.id$ = "_" + .x$ + "_"
	match = rindex("_i_I_e_E_ae_3r_a_V_o_U_u_aI_aU_oi_", .id$)
	.result = (match != 0)
	.name$ = if .result then "vowel" else "consonant" endif
endproc

##### VALUES for "how the segment doesn't fit in the caononical set. 
# Spell-out values for choices other than the canonical ones at each step. 
omitted$   = "Omitted"
other$ = "Other"
unclassifiable$ = "Unclassifiable"
to_be_determined$ = "TBA"


##### CONSONANT -- MANNER
# Manner feature values for consonants.
stop$      = "Stop"
affricate$ = "Affricate"
fricative$ = "Fricative"
nasal$     = "Nasal"
glide$     = "Glide"

# Manner feature specifications for the 24 English consonant phonemes.
manner_p$        = stop$
manner_t$        = stop$
manner_k$        = stop$
manner_b$        = stop$
manner_d$        = stop$
manner_g$        = stop$

manner_tS$       = affricate$
manner_dZ$       = affricate$

manner_f$        = fricative$
manner_T$        = fricative$
manner_s$        = fricative$
manner_S$        = fricative$
manner_h$        = fricative$
manner_v$        = fricative$
manner_D$        = fricative$
manner_z$        = fricative$
manner_Z$        = fricative$

manner_m$        = nasal$
manner_n$        = nasal$
manner_N$        = nasal$

manner_j$        = glide$
manner_w$        = glide$
manner_l$        = glide$
manner_r$        = glide$

# Manner feature specifications for other consonant phones that have been transcribed.
manner_hl$       = fricative$

# Manner feature specifications for other consonants we might add later.
manner_tr$       = stop$
manner_dr$       = stop$
manner_tFlap$    = stop$
manner_dFlap$    = stop$
manner_c$        = stop$
manner_J$        = stop$
manner_q$        = stop$
manner_Q$        = stop$
manner_glotStop$ = stop$
manner_ts$       = affricate$
manner_dz$       = affricate$
manner_F$        = fricative$
manner_V$        = fricative$
manner_C$        = fricative$
manner_jV$       = fricative$
manner_x$        = fricative$
manner_G$        = fricative$
manner_X$        = fricative$
manner_K$        = fricative$
manner_H$        = fricative$
manner_exclaim$  = fricative$
manner_hv$       = fricative$
manner_Zl$      = fricative$

##### CONSONANT PLACE
# Place feature values for consonants.
labial$       = "Bilabial"
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
lateral$      = "Lateral"

# Place feature specifications for the 24 English consonant phonemes.
place_p$        = labial$
place_t$        = alveolar$
place_k$        = velar$
place_b$        = labial$
place_d$        = alveolar$
place_g$        = velar$
# affricates
place_tS$       = postalveolar$
place_dZ$       = postalveolar$
# fricatives
place_f$        = labiodental$
place_T$        = dental$
place_s$        = alveolar$
place_S$        = postalveolar$
place_h$        = glottal$
place_v$        = labiodental$
place_D$        = dental$
place_z$        = alveolar$
place_Z$        = postalveolar$
# nasals
place_m$        = labial$
place_n$        = alveolar$
place_N$        = velar$
# glides
place_j$        = palatal$
place_w$        = labiovelar$
place_l$        = lateral$
place_r$        = alveolar$

# Place feature specifications for other consonant phones that have been transcribed.
place_hl$       = lateral$

# Place feature specifications for other consonants we might add later.
place_tr$       = retroflex$
place_dr$       = retroflex$
place_tFlap$    = alveolar$
place_dFlap$    = alveolar$
place_c$        = palatal$
place_J$        = palatal$
place_q$        = uvular$
place_Q$        = uvular$
place_glotStop$ = glottal$
place_ts$       = alveolar$
place_dz$       = alveolar$
place_F$        = labial$
place_V$        = labial$
place_C$        = palatal$
place_jV$       = palatal$
place_x$        = velar$
place_G$        = velar$
place_X$        = uvular$
place_K$        = uvular$
place_H$        = pharyngeal$
place_exclaim$  = pharyngeal$
place_hv$       = glottal$
place_Zl$      = lateral$

##### CONSONANT VOICING
# Voicing feature values for the consonants.
voiced$    = "Voiced"
voiceless$ = "Voiceless"

# Voicing feature specifications for the 24 English consonant phonemes.
voicing_p$        = voiceless$
voicing_t$        = voiceless$
voicing_k$        = voiceless$
voicing_b$        = voiced$
voicing_d$        = voiced$
voicing_g$        = voiced$
# affricates
voicing_tS$       = voiceless$
voicing_dZ$       = voiced$
# fricatives
voicing_f$        = voiceless$
voicing_T$        = voiceless$
voicing_s$        = voiceless$
voicing_S$        = voiceless$
voicing_h$        = voiceless$
voicing_v$        = voiced$
voicing_D$        = voiced$
voicing_z$        = voiced$
voicing_Z$        = voiced$
# nasals
voicing_m$        = voiced$
voicing_n$        = voiced$
voicing_N$        = voiced$
# glides
voicing_j$        = voiced$
voicing_w$        = voiced$
voicing_l$        = voiced$
voicing_r$        = voiced$

# Voicing feature specifications for other consonant phones that have been transcribed.
voicing_hl$       = voiceless$

# Place feature specifications for other consonants we might add later.
voicing_tr$       = voiceless$
voicing_dr$       = voiced$
voicing_tFlap$    = voiceless$
voicing_dFlap$    = voiced$
voicing_c$        = voiceless$
voicing_J$        = voiced$
voicing_q$        = voiceless$
voicing_Q$        = voiced$
voicing_glotStop$ = voiceless$
voicing_ts$       = voiceless$
voicing_dz$       = voiced$
voicing_F$        = voiceless$
voicing_V$        = voiced$
voicing_C$        = voiceless$
voicing_jV$       = voiced$
voicing_x$        = voiceless$
voicing_G$        = voiced$
voicing_X$        = voiceless$
voicing_K$        = voiced$
voicing_H$        = voiceless$
voicing_exclaim$  = voiced$
voicing_hv$       = voiced$
voicing_Zl$      = voiced$

##### VOWEL LENGTH
# Length feature values for vowels.
diphthong$ = "Diphthong"
tense$     = "Tense"
lax$       = "Lax"
# Length feature specifications for the 14 vowels of the target dialects.
length_aU$  = diphthong$
length_aI$  = diphthong$
length_oI$  = diphthong$
# tense or long vowels
length_i$   = tense$
length_e$   = tense$
length_u$   = tense$
length_o$   = tense$
length_a$ = tense$
length_ae$  = tense$
# lax or short vowels
length_I$   = lax$
length_E$   = lax$
length_U$   = lax$
length_V$   = lax$
length_3r$ = lax$

##### VOWEL HEIGHT
# Vowel height feature values
high$      = "High"
mid$       = "Mid"
low$       = "Low"
# Height feature specifications for the 14 vowels of the target dialects.
height_i$  = high$
height_I$  = high$
height_u$  = high$
height_U$  = high$
height_e$ = mid$
height_E$ = mid$
height_V$  = mid$
height_o$  = mid$
height_3r$ = mid$
height_ae$ = low$
height_a$  = low$
# Diphthong height features are coded using the starting vowel (nucleus)
height_aU$ = height_a$
height_aI$ = height_a$
height_oI$ = height_o$

##### VOWEL FRONTNESS
# Vowel frontness feature values.
front$        = "Front"
central$      = "Central"
# Alternatively, conceive of this as "vowel place" ...
rhotic$  = "Rhotic"
back$         = "Back"
# Frontness feature specifications for the 14 vowels of the target dialects.
frontness_i$  = front$
frontness_I$  = front$
frontness_e$ = front$
frontness_E$ = front$
frontness_ae$ = front$
frontness_3r$ = central$
# frontness_3r$ = rhotic$
frontness_u$  = back$
frontness_U$  = back$
frontness_o$  = back$
frontness_V$  = back$
frontness_a$  = back$
# Diphthong frontness features are coded using the part that is contrastive, 
# which is the offglide part for /aI/ versus /aU/, but ...
frontness_aI$ = frontness_I$
frontness_aU$ = frontness_U$
# the nucleus vowel for /oI/ (versus the other two diphthongs).
frontness_oI$ = frontness_o$

######## Transcribed nuclei that don't fit the above. 
length_or$ = to_be_determined$
height_or$ = to_be_determined$
frontness_or$ = to_be_determined$
