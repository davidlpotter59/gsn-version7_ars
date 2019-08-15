/*   arspr053

     december 17, 2001

     scips.com

     a/r report to list installment charges billed within a 
     user defined date range
*/

description Installments Billed within a Starting and Ending Date Range ;         

include "startend.inc"

define signed ascii number l_paid = if arsbilling:status = "P" and
arsbilling:status_date >= l_starting_date and 
arsbilling:status_date <= l_ending_date then 
arsbilling:total_amount_paid 
else
0.00

where (arsbilling:billed_date >= l_starting_date and
      arsbilling:billed_date <= l_ending_date and
      arsbilling:trans_code one of 18, 28)    and status = "P"

list
/nobanner
/domain="arsbilling"
/title="Installment Charges Billed" 
/pagewidth=255

arsbilling:policy_no 
arsbilling:trans_eff 
arsbilling:trans_exp
arsbilling:payment_plan 
arsbilling:billing_ctr 
arsbilling:bill_plan   
arsbilling:status /heading="Current-Status"  
arsbilling:status_date/heading="Current-Date-Date"  
arsbilling:prior_status_date/heading="Prior-Status-Date"/width=15
arsbilling:prior_status/heading="Prior-Status"/width=10
arsbilling:billed_date 
arsbilling:due_date
arsbilling:installment_amount  /total  
arsbilling:write_off_amount /total 
arsbilling:write_off_date

sorted by month(arsbilling:status_date)/total/newpage/heading="@"
          month(arsbilling:billed_date)/total/newpage/heading="@"
          arsbilling:policy_no 

top of page
"Report Number: arspr053"/newline 
"For The Period"/center/newline 
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,
"MM/DD/YYYY"))/newline/centre 
