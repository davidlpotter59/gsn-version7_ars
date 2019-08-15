

include "startend.inc"

define string l_prog_number ="ARSCANCEL/LAPSE"

define string l_type = if arscancel:billing_ctr one of 1 and 
                          arscancel:trans_code one of 14 then "LAPSE"
else
"CANCEL"

where arscancel:trans_date >= l_starting_date and 
      arscancel:trans_date <= l_ending_date

list
/nobanner
/domain="arscancel"
/title="Cancellations by Transaction Date and Type"

arscancel:policy_no 
arscancel:trans_date 
arscancel:cx_status 
arscancel:cx_eff_date 
arscancel:billing_ctr 
arscancel:trans_code 

Sorted by l_type/newpage
          arscancel:policy_no 

include "reporttop.inc"
l_type/heading="Non-Pay Type"/newline=2
