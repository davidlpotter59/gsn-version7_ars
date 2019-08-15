/*  arspr008P

    may 29, 2001

    scips.com

    program to print the A/R billing balance register - Selected Policy

June 4, 2002  -  added transaction code 29 to report

*/

define unsigned ascii number l_policy_no = parameter/prompt=
"Enter Policy No.: "


define signed ascii number l_premium = if
arsbilling:trans_code one of 10,11,12,13,14,15,16,26 then
arsbilling:installment_amount 
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
                                  
define signed ascii number l_other_charges = if
arsbilling:trans_code not one of 10,11,12,13,14,15,16,18,19,22,23,25,26,29,27
,28,30,60,61,62,63,64,66,68,69 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_nsf_rebill = if
arsbilling:trans_code one of 60,61,62,63,64,66,68,69 then
arsbilling:installment_amount 
else
0.00


define signed ascii number l_disbursement_charges = if
arsbilling:trans_code one of 30 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_cx_balance_due = if
arsbilling:trans_code one of 25 then
arsbilling:installment_amount 
else
0.00                           

define signed ascii number l_cx_rein_balance_due = if
arsbilling:trans_code one of 26 then
arsbilling:installment_amount 
else
0.00

define file arschecka = access arscheck, set arscheck:company_id= 
arsbilling:company_id,
arscheck:policy_no= arsbilling:policy_no,generic 

define signed ascii number l_disbursement = if arschecka:aps_trans_code = "OVER" then 
                                            arschecka:check_amount * -1

where  arsbilling:policy_no = l_policy_no

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Selected Policy"
/pagewidth=255

arsbilling:company_id 
arsbilling:policy_no 
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
arsbilling:status 
arsbilling:installment_amount/total 
arsbilling:total_amount_paid/total
arsbilling:write_off_amount /total 
arsbilling:net_amount_due/total 
l_disbursement/heading="Over-Pays"/total/mask="ZZ,ZZZ.ZZ-" 

sorted by arsbilling:policy_no/total 
          arsbilling:trans_date/total

top of page
"Report Number: arspr008p - Ver. 4.00"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline

end of report
""/newline
total[l_premium]/align=arsbilling:installment_amount/heading=
"Premium"/newline=2
total[l_sur_charge]/align=arsbilling:installment_amount/heading=
"Surcharge"/newline=2
total[l_installment_charge]/align=arsbilling:installment_amount/heading=
"Installment Charges"/newline=2                                    
total[l_disbursement_charges]/align=arsbilling:installment_amount/heading=
"Disbursements"/newline=2
total[l_disbursement]/align=arsbilling:installment_amount/heading="Over Pays"/newline=2
(total[l_disbursement_charges]+total[l_disbursement])/align=arsbilling:installment_amount/heading="Total A/P"
/newline=2
total[l_cx_balance_due]/align=arsbilling:installment_amount/heading=
"C/X Balance Due"/newline=2
total[l_cx_rein_balance_due]/align=arsbilling:installment_amount/heading=
"C/X Rein Balance Due"/newline=2
total[l_nsf_rebill]/align=arsbilling:installment_amount/heading=
"NSF Rebilling"/newline=2
total[l_other_charges]/align=arsbilling:installment_amount/heading=
"Other Charges"/newline=2
