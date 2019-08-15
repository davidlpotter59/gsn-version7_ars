define wdate l_starting_date=parameter/prompt="Enter Starting Date:<NL>"
define wdate l_ending_date=parameter/prompt="<NL>Enter Ending Date:<NL>"

list
/nobanner
/domain="arsmaster"
/nodetail
/title="ARSMASTER File Written Premium"

arsmaster:premium/mask="ZZZ,ZZZ,ZZZ.99-"

top of page
""/newline
l_starting_date/column=20/noheading/mask="MM/DD/YYYY"
" - "
l_ending_date/column=35/noheading/mask="MM/DD/YYYY"
