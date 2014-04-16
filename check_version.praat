min_version$ = "5.3.64"
@check_min_version(min_version$)

# Check that the user has an appropriate version of Praat
procedure check_min_version(.min_version$)
	# Break apart version numbers
	@chomp(praatVersion$, ".")
	.major = number(chomp.bite$)

	@chomp(chomp.leftover$, ".")
	.minor = number(chomp.bite$)

	@chomp(chomp.leftover$, ".")
	.final = number(chomp.bite$)

	@chomp(.min_version$, ".")
	.min_major = number(chomp.bite$)

	@chomp(chomp.leftover$, ".")
	.min_minor = number(chomp.bite$)

	@chomp(chomp.leftover$, ".")
	.min_final = number(chomp.bite$)

	# Compare the digits in the two version numbers
	pass1 = .min_major < .major
	pass2 = .min_major == .major and .min_minor < .minor
	pass3 = .min_major == .major and .min_minor == .minor and .min_final < .final	
	pass = pass1 or pass2 or pass3

	if pass != 1
		msg$ = "You are using Praat " + praatVersion$ + ". This script requires version " + .min_version$
		writeInfoLine(msg$)
		exitScript('msg$')
	endif
endproc


# Bite off chunks from a delimited string
procedure chomp(.string$, .boundary$)
	.index = index(.string$, .boundary$)
	if .index == 0
		.bite$ = .string$
		.leftover$ = ""
	else
		.bite$ = left$(.string$, .index - 1)
		.leftover$ = replace$(.string$, .bite$ + .boundary$, "", 1)
	endif
endproc
