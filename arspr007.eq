/*  arspr007

    October 31, 2002

    scips.com

    program to print the A/R Master file balance register

*/

include "startend.inc"

define signed ascii number l_premium = if
arsmaster:trans_code one of 10,11,12,13,14,15,16 then
arsmaster:premium 
else
0.00

define signed ascii number l_sur_charge = if
arsmaster:trans_code one of 19,22,23,27,29 then
arsmaster:premium 
else
0.00

define signed ascii number l_installment_charge = if
arsmaster:trans_code one of 18,28 then
arsmaster:premium 
else
0.00
                                  
define signed ascii number l_other_charges = if
arsmaster:trans_code not one of 10,11,12,13,14,15,16,18,19,22,23,29,27,28,30 then
arsmaster:premium 
else
0.00

define signed ascii number l_disbursement_charges = if
arsmaster:trans_code one of 30 then
arsmaster:premium 
else
0.00

define signed ascii number l_cx_balance_due = if
arsmaster:trans_code one of 25 then
arsmaster:premium 
else
0.00

define file arschecka = access arscheck, set arscheck:company_id= 
arsmaster:company_id,
arscheck:policy_no= arsmaster:policy_no,generic 

where arsmaster:trans_date => l_starting_date and
      arsmaster:trans_date <= l_ending_date

list
/nobanner
/domain="arsmaster"
/title="ARSMASTER File Daily Balancing Register"
/pagewidth=255

arsmaster:company_id 
arsmaster:policy_no 
arsmaster:trans_code 
arsmaster:trans_date 
arsmaster:trans_eff 
arsmaster:trans_exp 
arsmaster:line_of_business 
arsmaster:lob_subline
arsmaster:comm_rate/duplicates/nototal 
arsmaster:agent_no 
arsmaster:bill_plan
arsmaster:payment_plan 
arsmaster:premium/total 

sorted by arsmaster:company_id/newpage/total 
          arsmaster:policy_no/total 

top of page
"Report Number: arspr007 - Ver. 4.10"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")) + 
" - " + trun(str(l_ending_date
,"MM/DD/YYYY")))/center/newline

end of report
""/newline
total[l_premium]/align=arsmaster:premium/heading=
"Premium"/newline=2
total[l_sur_charge]/align=arsmaster:premium/heading=
"Surcharge"/newline=2
total[l_installment_charge]/align=arsmaster:premium/heading=
"Installment Charges"/newline=2                                    
total[l_disbursement_charges]/align=arsmaster:premium/heading=
"Disbursements"/newline=2
total[l_cx_balance_due]/align=arsmaster:premium/heading=
"C/X Balance Due"/newline=2
total[l_other_charges]/align=arsmaster:premium/heading=
"Other Charges"/newline=2
