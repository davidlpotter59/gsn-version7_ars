/*  arspr810

    september 16, 2004

    scips.com, inc.

    report to indicate possible double posting
*/

description Report to Possibly indicate double check posting errors ;

include "startend.inc"

define string l_prog_number = "ARSPR810 - Version 4.10"


where arspayment:payment_trans_date => l_starting_date and 
      arspayment:payment_trans_date <= l_ending_date  

list
/nobanner
/domain="arspayment"
/nodetail 
/nototals 

arspayment:payment_trans_date /column=1
arspayment:policy_no /column=15
total[amount]/heading="Payment-Total"/column=30
arschksu:checK_amount /column=50
total[arspayment:amount] - arschksu:check_amount /heading="Over-Booked"
/column=70
arspayment:check_reference /column=90

sorted by policy_no 

end of policy_no 

if total[amount] > arschksu:check_amount then 
{
box/noheadings 
arspayment:payment_trans_date /column=1
arspayment:policy_no /column=15
total[amount]/column=30
arschksu:checK_amount /column=50
total[arspayment:amount] - arschksu:check_amount /column=70
arspayment:check_reference /column=90

xob
}

include "reporttop.inc"
