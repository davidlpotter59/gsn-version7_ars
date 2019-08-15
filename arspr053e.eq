/*   arspr0532

     december 17, 2001

     scips.com

     a/r report to list installment charges billed within a 
     user defined date range - sorted by effective date
*/

description 
Installments Billed within a Starting and Ending Date Range - Sorted by Effective Date;         

include "startend.inc"

define file arsmastera = access arsmaster, set arsmaster:company_id = arsbilling:company_id,
                                               arsmaster:policy_no = arsbilling:policy_no, one to many, generic 

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

define l_prog_number = "ARSPR053e - Version 4.10"

define signed ascii number l_paid = if arsbilling:status = "P" and
arsbilling:status_date >= l_starting_date and 
arsbilling:status_date <= l_ending_date then 
arsbilling:total_amount_paid 
else
0.00

where (arsbilling:billed_date >= l_starting_date and
      arsbilling:billed_date <= l_ending_date and
      arsbilling:trans_code one of 18, 28)
-- and arsbilling:status not one of "C"

list
/nobanner
/domain="arsbilling"
/title="Installment Charges Billed" 
/pagewidth=132

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
l_installment_amount/heading="Installment-Amount"  /total  
l_paid/heading="Amount-Paid"

sorted by arsmastera:state/newlines/total/heading="@"
          year(arsbilling:trans_eff)/total/newlines/heading="@"
          month(arsbilling:trans_eff)/total/newlines/heading="@" 
          arsbilling:status/total/newlines/heading="Status @"
          arsbilling:trans_eff
          arsbilling:policy_no 

include "reporttop.inc"
arsmastera:state/heading="State:"/column=1/newline 

end of report

"TOTALS"/column=1/newline
total[l_total_current2]/column=1/mask="(ZZ,ZZZ,ZZZ.ZZ)"/heading="TOTAL Billed"/newline 
total[l_total_future2]/column=1/mask="(ZZ,ZZZ,ZZZ.ZZ)"/heading="TOTAL Future"/newline
