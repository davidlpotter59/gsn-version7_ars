/*  arspr008w

    december 18, 2007

    scips.com

    program to print the A/R billing balance register - written basis

June 4, 2002  -  added transaction code 29 to report

august 22, 2006
added l_nsf_reverse this gets added to l_installment_amount so that the report
looks like customer server in ver 7

*/

Description Print the Daily A/R Billing Balance Register - REcords selected on a Written basis (processed); 

include "startend.inc"

define signed ascii number l_nsf_reverse = if
arsbilling:status one of "R" then 
arsbilling:total_amount_paid 
else
0.00

define signed ascii number l_premium = if
arsbilling:trans_code one of 10,11,12,13,14,15,16 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_nsf_premium = if
arsbilling:trans_code one of 60,62,63,64,66,68,69 then 
arsbilling:installment_amount 
else
0.00
 
define signed ascii number l_installment_amount = if  
arsbilling:trans_code not one of 60,62,63,64,66,68,69 then 
arsbilling:installment_amount + l_nsf_reverse 
else
0.00

define signed ascii number l_sur_charge = if
arsbilling:trans_code one of 19,22,23,27,29 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_installment_charge = if
arsbilling:trans_code one of 18,28 then
arsbilling:installment_amount 
else
0.00                                                                                                 

define signed ascii number l_nsf_charge = if
arsbilling:trans_code one of 50 then 
arsbilling:installment_amount 
else
0.00
                                  
-- 06/01/2004  -- removed 61 from the following one of statement - reapply check trans code
define signed ascii number l_other_charges = if
arsbilling:trans_code not one of 10,11,12,13,14,15,16,18,19,22,23,25,29,27,28,29,30,35,38,39,40,48,49,50,55,60,62,63,64,66,68,69,50 then
arsbilling:installment_amount 
else
0.00  

define signed ascii number l_dave = arsbilling:installment_amount - l_other_charges 

define signed ascii number l_disbursement_charges =
arsbilling:disbursement_amount 

define signed ascii number l_cx_balance_due = if
arsbilling:trans_code one of 25 then
arsbilling:installment_amount 
else
0.00
                                    
define signed ascii number l_net_amount_paid = if arsbilling:status not one of "R" then 
arsbilling:total_amount_paid - arsbilling:disbursement_amount 
else
0.00

define signed ascii number l_nsf_offset_paid = if arsbilling:status one of "R" then
arsbilling:total_amount_paid - arsbilling:disbursement_amount 
else
0.00

define file arschecka = access arscheck, set arscheck:company_id= 
arsbilling:company_id,
arscheck:policy_no= arsbilling:policy_no,approximate 

define signed ascii number l_disbursement = if arschecka:eff_date >= arsbilling:trans_eff and 
                                               arschecka:eff_date <= arsbilling:trans_exp and 
                                               val(arschecka:check_no) <> 0 and
                                               arschecka:policy_no = arsbilling:policy_no then 
                                               arschecka:check_amount
                                             else
                                                  0.00

define signed ascii number l_pending_disbursement = if arschecka:eff_date >= arsbilling:trans_eff and 
                                                       arschecka:eff_date <= arsbilling:trans_exp and 
                                                       arschecka:check_no = "" and 
                                                       arschecka:policy_no = arsbilling:policy_no then 
                                                       arschecka:check_amount
                                                     else
                                                          0.00

define signed ascii number l_net_disbursement = l_disbursement + l_Pending_disbursement 

define signed ascii number l_amount_due = l_installment_amount 
                                          + l_nsf_premium
                                          - arsbilling:write_off_amount 
                                          - l_net_amount_paid - l_nsf_reverse 
                                         
where ((arsbilling:trans_date => l_starting_date and 
        arsbilling:trans_date <= l_ending_date and 
        arsbilling:trans_eff  <= l_ending_date) or 
       (arsbilling:trans_date < l_starting_date and 
        arsbilling:trans_eff  => l_starting_date and 
        arsbilling:trans_eff  <= l_ending_date))

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Written Basis"
/pagewidth=255

arsbilling:company_id 
arsbilling:policy_no 
arsbilling:due_date 
arsbilling:trans_code/heading="TC" 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:trans_exp 
arsbilling:line_of_business/heading="LOB"
arsbilling:lob_subline
arsbilling:comm_rate/duplicates 
arsbilling:agent_no 
arsbilling:bill_plan
arsbilling:payment_plan 
arsbilling:status  
reinstated/heading="RS"
--arsbilling:installment_amount/total 
l_installment_amount/heading="Install-Amt"  
l_nsf_premium/heading="NSF-Rebilled"/total 
arsbilling:total_amount_paid/total
arsbilling:disbursement_amount /total /heading="Disb-Amt"
l_net_amount_paid/total/heading="Net-Paid"
arsbilling:write_off_amount /total 
--arsbilling:net_amount_due/total 
--l_disbursement/heading="Over-Pays"/total/mask="ZZ,ZZZ.ZZ-" 
l_amount_due/heading="Net-Balance"/total/mask="ZZ,ZZZ.99-"

sorted by arsbilling:company_id/newpage/total 
          arsbilling:bill_plan/newpage/total/heading="Total for @"
          arsbilling:policy_no/total 

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
