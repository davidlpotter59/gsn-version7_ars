include "startend.inc"

where arsmaster:trans_date => l_starting_date and 
      arsmaster:trans_date <= l_ending_date and
      arsmaster:bill_plan = "DB" /* and
      arsmaster:trans_code <> 11    */

list
/nobanner
/domain="arsmaster"
/title="ARSMASTER Audit Report"
/pagewidth=132
/duplicates                       
/pagetotals 
/nodetail 

arsmaster:policy_no/heading="Policy-No"/column=1
arsmaster:trans_date/heading="Trans-Date"/column=11
arsmaster:trans_eff/heading="Trans-Eff"/column=22
arsmaster:trans_code/heading="Trans-Code"/column=33
arsmaster:line_of_business/heading="Line"/column=44/duplicates 
arsmaster:comm_rate/nototal/heading="Comm-Rate"/column=50
arsmaster:premium/mask="ZZ,ZZZ,ZZZ.99-"/column=70/heading="Premium"

sorted by arsmaster:policy_no 

end of arsmaster:policy_no 
arsmaster:policy_no/noheading/column=1
arsmaster:trans_date/noheading/column=11
arsmaster:trans_eff/noheading/column=22
arsmaster:trans_code/noheading/column=33
arsmaster:line_of_business/noheading/column=44/duplicates 
arsmaster:comm_rate/noheading/column=50
total[arsmaster:premium,arsmaster:policy_no]/mask="ZZ,ZZZ,ZZZ.99-"/column=70/noheading

top of page
l_starting_date/noheading/mask="MM/DD/YYYY"
" - " 
l_ending_date/noheading/mask="MM/DD/YYYY"/newline
