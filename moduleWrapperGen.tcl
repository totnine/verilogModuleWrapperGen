proc moduleWrapperGen {fileHandle} {
	set FH [open ./$fileHandle r]
	set i 1
	# patterns
	set modulePattern {.*(module).*\s+(\w+)}
	set ioPattern {.*(input|output|inout).*\s+(\w+)}
	while {![eof $FH]} {
		set line [gets $FH]
		if {[regexp $modulePattern $line match sub1 sub2] == 1} {
			puts "$sub1 instanceName("
		} elseif {[regexp $ioPattern $line match sub1 sub2] == 1} {
			# command line for port width and io direction
			if {[regexp {\[.*:.*\]} $line] == 1} {
				regexp {(\d+)} $line width
				set commandLineWidth $width
			} else {
				set commandLineWidth 1
			}
			# wrapper output
			if {[regexp {,} $line] == 1} {
				puts "\t.$sub2\(\),\t\/\/ $sub1 width $commandLineWidth"
			} else {
			puts "\t.$sub2\(\)\t\/\/\ $sub1 width $commandLineWidth"
			puts "\);"
			}
		}
		incr i
	}
	close $FH
}
