/*  arspr755

    scips.com, inc.

    december 8, 2004

    report to show transaction codes 25 (cx balance due) only
*/
description     report to show transaction codes 25 (cx balance due) only;

include "startend.inc"

define string l_prog_number = "arspr755 - Version 4.10"

where arsbilling:trans_code one of 25
and (arsbilling:trans_date => l_starting_date 
     and arsbilling:trans_date <= l_ending_date )  
and arsbilling:status one of "B"

list
/nobanner 
/domain="arsbilling"
/duplicates 
/pagelength=0
/title="Cancellation Balance Due Listing"

policy_no trans_date 
trans_eff 
trans_code 
arsbilling:status 
arsbilling:due_date 
arsbilling:billed_date 
arsbilling:installment_amount/total 
arsbilling:total_amount_paid /total 
arsbilling:disbursement_amount /total 
arsbilling:write_off_amount /total 
arsbilling:installment_amount - arsbilling:total_amount_paid + arsbilling:disbursement_amount 
- arsbilling:write_off_amount /heading="NET-DUE"

sorted by arsbilling:trans_date 
          arsbilling:policy_no 

include "reporttop.inc"
