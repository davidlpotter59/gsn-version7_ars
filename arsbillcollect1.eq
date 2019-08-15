define wdate l_starting_date=parameter/prompt="Enter Starting Date:<NL>"
define wdate l_ending_date=parameter/prompt="<NL>Enter Ending Date:<NL>"

list
/nobanner
/domain="arsbilling"
/nodetail
/title="ARSBILLING Master File Written Premium"

arsbilling:installment_amount/total/mask="ZZZ,ZZZ,ZZZ.99-"

top of page
""/newline
l_starting_date/noheading/column=20/mask="MM/DD/YYYY"
" - "
l_ending_date/noheading/column=35/mask="MM/DD/YYYY"
