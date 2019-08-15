
/*  arspr008_archive

    may 29, 2001

    scips.com

    program to print the A/R billing balance register

June 4, 2002  -  added transaction code 29 to report

*/

include "startend.inc"

define signed ascii number l_premium = if
arsbilling_month:trans_code one of 10,11,12,13,14,15,16 then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_nsf_premium = if
arsbilling_month:trans_code one of 60,62,63,64,66,68,69 then 
arsbilling_month:installment_amount 
else
0.00
 
define signed ascii number l_installment_amount = if 
arsbilling_month:trans_code not one of 60,62,63,64,66,68,69 then 
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_sur_charge = if
arsbilling_month:trans_code one of 19,22,23,27,29 then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_installment_charge = if
arsbilling_month:trans_code one of 18,28 then
arsbilling_month:installment_amount 
else
0.00                                                                                                 

define signed ascii number l_nsf_charge = if
arsbilling_month:trans_code one of 50 then 
arsbilling_month:installment_amount 
else
0.00
                                  
define signed ascii number l_other_charges = if
arsbilling_month:trans_code not one of 10,11,12,13,14,15,16,18,19,22,23,25,29,27,28,29,30,35,38,39,40,48,49,50,55,60,61,62,63,64,66,68,69,50 then
arsbilling_month:installment_amount 
else
0.00  

define signed ascii number l_dave = arsbilling_month:installment_amount - l_other_charges 

define signed ascii number l_disbursement_charges =
arsbilling_month:disbursement_amount 

define signed ascii number l_cx_balance_due = if
((arsbilling_month:trans_code one of 25) and
(arsbilling_month:total_amount_paid = arsbilling_month:installment_amount)) then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_net_amount_due = arsbilling_month:net_amount_due - l_cx_balance_due                                     

define signed ascii number l_net_amount_paid = if arsbilling_month:status not one of "R" then 
arsbilling_month:total_amount_paid - arsbilling_month:disbursement_amount 
else
0.00

define signed ascii number l_nsf_offset_paid = if arsbilling_month:status one of "R" then
arsbilling_month:total_amount_paid - arsbilling_month:disbursement_amount 
else
0.00

define file arschecka = access arscheck, set arscheck:company_id= 
arsbilling_month:company_id,
arscheck:policy_no= arsbilling_month:policy_no,approximate 

define signed ascii number l_disbursement = if arschecka:eff_date >= arsbilling_month:trans_eff and 
                                               arschecka:eff_date <= arsbilling_month:trans_exp and 
                                               val(arschecka:check_no) <> 0 and
                                               arschecka:policy_no = arsbilling_month:policy_no then 
                                               arschecka:check_amount
                                             else
                                                  0.00

define signed ascii number l_pending_disbursement = if arschecka:eff_date >= arsbilling_month:trans_eff and 
                                                       arschecka:eff_date <= arsbilling_month:trans_exp and 
                                                       arschecka:check_no = "" and 
                                                       arschecka:policy_no = arsbilling_month:policy_no then 
                                                       arschecka:check_amount
                                                     else
                                                          0.00

define signed ascii number l_net_disbursement = l_disbursement + l_Pending_disbursement 

where (arsbilling_month:trans_date => l_starting_date and
       arsbilling_month:trans_date <= l_ending_date) and
       arsbilling_month:trans_code not one of 65 
--       l_net_amount_due <> 0

list
/nobanner
/domain="arsbilling_month"
/title="arsbilling_month File Daily Balancing Register"
/pagewidth=255

arsbilling_month:company_id 
arsbilling_month:policy_no 
arsbilling_month:due_date 
arsbilling_month:trans_code 
arsbilling_month:trans_date 
arsbilling_month:trans_eff 
arsbilling_month:trans_exp 
arsbilling_month:line_of_business 
arsbilling_month:lob_subline
arsbilling_month:comm_rate/duplicates 
arsbilling_month:agent_no 
arsbilling_month:bill_plan
arsbilling_month:payment_plan 
arsbilling_month:status  
reinstated  
--arsbilling_month:installment_amount/total 
l_installment_amount/heading="Installment-Amount"  
l_nsf_premium/heading="NSF Rebilled"/total 
arsbilling_month:total_amount_paid/total
arsbilling_month:disbursement_amount /total 
l_net_amount_paid/total/heading="Net-Paid"
arsbilling_month:write_off_amount /total 
--arsbilling_month:net_amount_due/total 
l_net_amount_due/total 
l_disbursement/heading="Over-Pays"/total/mask="ZZ,ZZZ.ZZ-" 

sorted by arsbilling_month:company_id/newpage/total 
          arsbilling_month:policy_no/total 

top of page
"Report Number: arspr008 - Ver. 4.10"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")) + 
" - " + trun(str(l_ending_date
,"MM/DD/YYYY")))/center/newline

end of report
box/needs=15
""/newline  
"Total Charges"/align=l_installment_amount /newline=2
total[l_premium]/align=l_installment_amount/heading=
"Premium"/newline=1
total[l_sur_charge]/align=l_installment_amount/heading=
"Surcharge"/newline=1
total[l_installment_charge]/align=l_installment_amount/heading=
"Installment Charges"/newline=1
total[l_other_charges]/align=l_installment_amount 
/heading="Other Charges"/newline=1
total[l_cx_balance_due]/align=l_installment_amount/heading=
"C/X Balance Due"/newline=2

"Total NSF Transactions"/align=l_installment_amount/newline=2  
total[l_nsf_premium]/align=l_installment_amount/heading="NSF Rebilled Premium"/newline=1
total[l_nsf_charge]/align=l_installment_amount/heading="NSF Charges"/newline=1
total[l_nsf_offset_paid]/align=l_installment_amount/heading="NSF Payment Removal"/newline=2

"Total Credits"/align=l_installment_amount/newline=2
total[l_net_amount_paid]/align=l_installment_amount/heading="Total Paid"
/newline=1                                  
total[l_disbursement_charges]/align=l_installment_amount/heading=
"Disbursements"/newline=2  
"Accounts Payable"/align=l_installment_amount/newline=2
total[l_disbursement]/align=l_installment_amount/heading="Total Refunds"
/newline=1
total[l_pending_disbursement]/heading="Pending Refunds"
/newline=1/align=l_installment_amount 
total[l_net_disbursement]/heading="Total A/P"
/newline=1/align=l_installment_amount   
                                                              
""/newline=2
total[l_dave]/align=l_installment_amount/heading="Difference "
end box
