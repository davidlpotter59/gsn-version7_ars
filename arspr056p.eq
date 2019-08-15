/*   arspr056p

     december 17, 2001

     scips.com

     a/r report to list fees billed billed within a 
     user defined date range - sorted by policy number and billed date
*/

description 
Late Fees Billed within a Starting and Ending Date Range - Sorted by Policy Number and Billed Date;         

include "startend.inc"

define signed ascii number l_total_current = if 
arsbilling:trans_eff <= l_ending_date then 
arsbilling:installment_amount
else
0.00

define signed ascii number l_total_future = if 
arsbilling:trans_eff > l_ending_date then arsbilling:installment_amount 
else
0.00

define signed ascii number l_total_current2 = if
arsbilling:status not one of "C" then l_total_current 
else l_total_current * -1

define signed ascii number l_total_future2 = if
arsbilling:status not one of "C" then l_total_future 
else l_total_future * -1

define signed ascii number l_installment_amount = if
arsbilling:status not one of "C" then arsbilling:installment_amount 
else
arsbilling:installment_amount * -1 

define l_prog_number = "ARSPR056p - Version 7.00"

define signed ascii number l_paid = if arsbilling:status = "P" and
arsbilling:status_date >= l_starting_date and 
arsbilling:status_date <= l_ending_date then 
arsbilling:total_amount_paid 
else
0.00

where (arsbilling:billed_date >= l_starting_date and
      arsbilling:billed_date <= l_ending_date and
      arsbilling:trans_code one of 70)
-- and arsbilling:status not one of "C"

list
/nobanner
/domain="arsbilling"
/title="Late Fees Charges Billed - Policy Number" 

arsbilling:policy_no 
arsbilling:trans_eff 
arsbilling:trans_exp
arsbilling:payment_plan 
arsbilling:billing_ctr 
arsbilling:bill_plan   
arsbilling:status /heading="Current-Status"  
arsbilling:status_date/heading="Current-Date-Date"  
--arsbilling:prior_status_date/heading="Prior-Status-Date"/width=15
--arsbilling:prior_status/heading="Prior-Status"/width=10
arsbilling:billed_date 
arsbilling:due_date
l_installment_amount/heading="Installment-Amount"  /total  
l_paid/heading="Amount-Paid"

sorted by arsbilling:policy_no/newlines/total/heading="@ Total" 
          arsbilling:billed_date

include "reporttop.inc"

end of report

"TOTALS"/column=1/newline
total[l_total_current2]/column=1/mask="(ZZ,ZZZ,ZZZ.ZZ)"/heading="TOTAL Billed"/newline 
-- total[l_total_future2]/column=1/mask="(ZZ,ZZZ,ZZZ.ZZ)"/heading="TOTAL Future"/newline
