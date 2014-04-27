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
manner_hl$       = fricative$
manner_hlv$      = fricative$
manner_m$        = nasal$
manner_n$        = nasal$
manner_N$        = nasal$
manner_j$        = glide$
manner_w$        = glide$
manner_l$        = glide$
manner_r$        = glide$

# Place feature values for the consonants.
labial$     = "Labial"
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
lateral$      = "lateral"
other$        = "Other"

# /p,b,f,v/ have the same place feature.
place_p$        = labial$
place_b$        = labial$
place_f$        = labial$
place_v$        = labial$

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

place_F$        = labial$
place_V$        = labial$
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
place_hl$       = lateral$
place_hlv$      = lateral$
place_m$        = labial$
place_n$        = alveolar$
place_N$        = velar$
place_j$        = palatal$
place_w$        = labiovelar$
place_l$        = alveolar$
place_r$        = alveolar$

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
voicing_hl$       = voiceless$
voicing_hv$       = voiced$
voicing_hlv$      = voiced$
voicing_m$        = voiced$
voicing_n$        = voiced$
voicing_N$        = voiced$
voicing_j$        = voiced$
voicing_w$        = voiced$
voicing_l$        = voiced$
voicing_r$        = voiced$

# Height feature values for the target vowels.
high$      = "High"
mid$       = "Mid"
low$       = "Low"
xxxxxxx$   = "XXXXXXXXXX"
height_ae$ = low$
height_i$  = high$
height_I$  = high$
height_u$  = high$
height_U$  = high$
height_V$  = mid$

# Frontness feature values for the target vowels.
front$        = "Front"
central$      = "Central"
back$         = "Back"
frontness_ae$ = front$
frontness_i$  = front$
frontness_I$  = front$
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

# Diphthongs are coded using their starting vowel. "aw" refers to worldbet ">"
height_a$ = low$
height_aU$ = height_a$

height_aw$ = mid$
height_oi$ = height_aw$

frontness_a$ = back$
frontness_aU$ = frontness_a$

frontness_aw$ = back$
frontness_oi$ = frontness_aw$

# We will have to update the look-up list if more vowels are ever considered
procedure is_vowel(.x$)
	.id$ = "_" + .x$ + "_"
	match = rindex("_ae_aU_i_I_oi_u_U_V_a_aw_", .id$)
	.result = (match != 0)
	.name$ = if .result then "vowel" else "consonant" endif
endproc
