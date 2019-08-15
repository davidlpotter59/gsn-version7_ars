/*  arspr018

    July 24, 2001

    scips.com

    program to print the A/R billing balance register - Billed Only
*/
define string l_Status[30] = switch(arsbilling:status)
case "B" : "Transactions Billed"
case "P" : "Transactions Paid"
case "O" : "Transactions Open"
default  : "Transaction Unknown"

include "startend.inc"
define string l_report_name[15]="arspr018"

define signed ascii number l_total_due = arsbilling:installment_amount - 
total_amount_paid 

where arsbilling:billed_date => l_starting_date and
      arsbilling:billed_date <= l_ending_date and
      arsbilling:return_check_ctr = 0 and -- do not process return checks in this
      (arsbilling:status = "B" or
       arsbilling:status = "P")         -- report

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Billed Only"
/pagewidth=180

arsbilling:company_id 
arsbilling:policy_no 
arsbilling:billed_date
arsbilling:due_date 
arsbilling:trans_code 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:trans_exp 
arsbilling:line_of_business 
arsbilling:lob_subline
arsbilling:comm_rate/duplicates 
arsbilling:agent_no 
arsbilling:bill_plan
arsbilling:payment_plan 
-- 08/15/2001 - dlp
-- replaced arsbilling:installment_amount/total
l_total_due/heading="Net-Due"/total 

sorted by arsbilling:company_id/newpage/total           
          l_status/newpage/total/heading="@"
          arsbilling:billed_date/total/heading="@"/mask=
"MM/DD/YYYY"
          arsbilling:policy_no/total 

top of page
"Report Number: arspr018"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")) + 
" - " + trun(str(l_ending_date
,"MM/DD/YYYY")))/center/newline

top of l_status 
trun(l_status)/noheading/center/newline=2
