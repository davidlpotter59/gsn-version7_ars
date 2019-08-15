/*  arspr049

    SCIPS.com, Inc.

    July 17, 2007

    Report to list in summary arsbilling records - processed and run from arsin049 only (rolled up)
*/

description Rolled up List, in summary, arsbilling records - accessed from arsin042 only ;

include "startend.inc"
define string l_company_id[10] = parameter /uppercase/prompt="Please Enter Company ID       "
define unsigned ascii number l_policy[9]=parameter/prompt   ="Please Enter Policy Number    "

define string l_company[10]=l_company_id + "         "/width=10/raw 

define string l_prog_number = "ARSIN049 - Version 7.22"

define signed ascii number l_cx_balance_due_paid = if
arsbilling:status one of "Z" and 
arsbilling:trans_code one of 26 then arsbilling:payment_offset 
else 0.00

-- why 0 transcode?  there was a bug where the transaction code was not being
-- updated in the a/r system when move checks from one policy to another
                              
define signed ascii number l_nsf_rebilling = if 
(arsbilling:status one of "R" and arsbilling:trans_code not one of 0, 65) then
arsbilling:total_amount_paid 
else 0.00

define signed ascii number l_installment_amount = 
if arsbilling:trans_code one of 25 then 0 else
arsbilling:installment_amount + l_nsf_rebilling 

define signed ascii number l_commission_amount = if arsbilling:comm_rate <> 0.00 then
arsbilling:installment_amount * (arsbilling:comm_rate * 0.01)  

define signed ascii number l_cx_balance_due = if arsbilling:trans_Code one of 25 then
arsbilling:installment_amount - (arsbilling:total_amount_paid + arsbilling:write_off_amount)
else 0.00
                          
define signed ascii number l_disbursement = if arsbilling:trans_code not one of 36 then 
arsbilling:disbursement_amount 
else 0.00

define signed ascii number l_voided_disbursement = if arsbilling:trans_code one of 36 then 
arsbilling:disbursement_amount 
else 0.00
                                   
define signed ascii number l_net_disbursement = l_disbursement + 
l_voided_disbursement 

define signed ascii number l_cx_paid_amount = 0
/*if 
arsbilling:trans_code one of 16 and 
arsbilling:reinstated one of "Y" and 
arsbilling:total_amount_paid <> 0 then 
arsbilling:total_amount_paid * -1
else 0.00
*/

define signed ascii number l_amount_paid = if
(arsbilling:status one of "O","B","P","C","D") or 
(arsbilling:status one of "R" and arsbilling:trans_code one of 0,51,65) then 
arsbilling:total_amount_paid 
else 
0.00

define signed ascii number l_amount_paid_offset = if
arsbilling:status one of "V" and 
arsbilling:trans_code one of 55 then arsbilling:disbursement_amount * -1
else 0.00

define signed ascii number l_total_amount_paid = l_amount_paid - l_amount_paid_offset 

define signed ascii number l_net = -- if trans_code not one of 25 then
l_installment_amount - (arsbilling:total_amount_paid +
arsbilling:write_off_amount) +  
l_net_disbursement - l_cx_paid_amount + l_amount_paid_offset 
--arsbilling:disbursement_amount - l_voided_disbursement - l_cx_paid_amount 
 
define string l_record_status = switch(arsbilling:status)
case "C","V","E"   : "     "
default : "Active"

define string l_company1_id = l_company_id + "           " 

where/directscan
      arsbilling:company_id = l_company and 
      arsbilling:policy_no  = l_policy

list
/nobanner
/domain="arsbilling"
/pagewidth=180
/title="Policy Summary Activity and Balance"
/noreporttotals 
/nodetail 

--arsbilling:trans_date /column=1
--arsbilling:trans_eff /column=12
--arsbilling:trans_code/column=23/heading="T-C"
--arsbilling:status /column=29/heading="S-T"
l_installment_amount/column=35 /heading="Installment-Amount"/mask="ZZ,ZZZ,ZZZ.99-"        
l_total_amount_paid/column=50  /mask="ZZZ,ZZZ.99-"/heading="Total-Amount-Applied"
arsbilling:write_off_amount/column=65/mask="ZZZ,ZZZ.99-" 
l_disbursement/column=80/mask="ZZZ,ZZZ.99-"/heading="Disburse-ment"
l_voided_disbursement/column=95/mask="ZZZ,ZZZ.99-"/heading="VOID-Disburse-ment" 
l_cx_balance_due/column=110/heading="CX-Balance-Due"/mask="ZZZ,ZZZ.99-"
l_net/column=125/mask="ZZZ,ZZZ.99-"/heading="Net-Amount-DUE" 
arsbilling:due_date /mask="MM/DD/YYYY"/column=140

sorted by arsbilling:policy_no/newpage 
          arsbilling:due_date

Include "reporttop.inc"

arsbilling:policy_no /heading="Policy No."
sfpname:name[1]/noheading/column=30
arsbilling:line_of_business/column=70/heading="Line of Business"
sfsline:description/noheading/newline
arspayplan:payment_plan description arsbilling:agent_no /newline 
end of arsbilling:policy_no 
""/newline

box/noblanklines /noheadings 
    "POLICY TOTALS"/column=5
    total[l_installment_amount]/column=35/mask="ZZ,ZZZ,ZZZ.99-"
    total[l_total_amount_paid] /column=50/mask="ZZZ,ZZZ.99-"
    total[arsbilling:write_off_amount]/column=65/mask="ZZZ,ZZZ.99-"
    total[l_disbursement] /column=80/mask="ZZZ,ZZZ.99-"
    total[l_voided_disbursement] /column=95/mask="ZZZ,ZZZ.99-"
    total[l_cx_balance_due]/column=110/mask="ZZZ,ZZZ.99-"
    total[l_net]/column=125/mask="ZZZ,ZZZ.99-"
end box

end of arsbilling:due_date
""/newline

box/noblanklines /noheadings
    "Due Date Total"/column=5 
    arsbilling:due_date/mask="MM/DD/YYYY"/column=20
    total[l_installment_amount]/column=35/mask="ZZ,ZZZ,ZZZ.99-"
    total[l_total_amount_paid] /column=50/mask="ZZZ,ZZZ.99-"
    total[arsbilling:write_off_amount]/column=65/mask="ZZZ,ZZZ.99-"
    total[l_disbursement] /column=80/mask="ZZZ,ZZZ.99-"
    total[l_voided_disbursement] /column=95/mask="ZZZ,ZZZ.99-"
    total[l_cx_balance_due]/column=110/mask="ZZZ,ZZZ.99-"
    total[l_net]/column=125/mask="ZZZ,ZZZ.99-"
end box
