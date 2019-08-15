include "startend.inc"

string l_prog_number = "AUDIT LISTING"

where arsbilling:due_date => l_starting_date 
and   arsbilling:due_date <= l_ending_date 
and   arsbilling:status one of "B","O"
and   arsbilling:bill_plan <> "AC"
and   arsbilling:trans_code one of 15
and   arsbilling:net_amount_due <> 0

list
/nobanner
/domain="arsbilling"
/title="Audits Outstanding"

arsbilling:policy_no 
arsbilling:trans_date 
arsbilling:trans_code 
arsbilling:status 
arsbilling:due_date 
arsbilling:installment_amount 
arsbilling:write_off_amount 
arsbilling:total_amount_paid 
arsbilling:net_amount_due 
 
sorted by arsbilling:policy_no 

include "reporttop.inc"
