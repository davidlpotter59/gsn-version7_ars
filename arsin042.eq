
/*  arspr042

    SCIPS.com, Inc.

    June 17, 2003

    Report to list in summary arsbilling records - processed and run from arsin042 only 
*/

description List, in summary, arsbilling records - accessed from arsin042 only ;

define unsigned ascii number l_policy[9]=parameter/prompt="Enter Policy Number "

define signed ascii number l_cx_balance_due_paid = if
arsbilling:status one of "Z" and 
arsbilling:trans_code one of 26 then arsbilling:payment_offset 
else 0.00
                              
define signed ascii number l_nsf_rebilling = if arsbilling:status one of "R" then
arsbilling:total_amount_paid 
else 0.00

define signed ascii number l_installment_amount = if arsbilling:trans_code one of 25 then 0 else
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

define signed ascii number l_cx_paid_amount = 0
/*if 
arsbilling:trans_code one of 16 and 
arsbilling:reinstated one of "Y" and 
arsbilling:total_amount_paid <> 0 then 
arsbilling:total_amount_paid * -1
else 0.00
*/

define signed ascii number l_total_amount_paid = if
arsbilling:status one of "O","B","P" then 
arsbilling:total_amount_paid 
else 0.00

define signed ascii number l_net = -- if trans_code not one of 25 then
l_installment_amount - (arsbilling:total_amount_paid - 
arsbilling:write_off_amount) +
arsbilling:disbursement_amount - l_voided_disbursement - l_cx_paid_amount 
 
define string l_record_status = switch(arsbilling:status)
case "C","V","E"   : "     "
default : "Active"

where arsbilling:policy_no = l_policy 

list
/nobanner
/domain="arsbilling"
/pagewidth=140
/title="Policy Summary Activity and Balance"
/noreporttotals 

--arsbilling:policy_no  /column=1
arsbilling:trans_date /column=1
arsbilling:trans_eff /column=12
arsbilling:trans_code/column=23/heading="T-C"
--arsbilling:line_of_business /column=50/heading="LOB"
arsbilling:status /column=29/heading="S-T"
l_installment_amount/column=35 /heading="Installment-Amount"/mask=
"ZZ,ZZZ,ZZZ.99-"/total        
--l_cx_paid_amount/heading="CX-Amount-Paid"/column=50/total /mask="ZZZ,ZZZ.99-"
arsbilling:total_amount_paid/column=50  /mask="ZZZ,ZZZ.99-"/total/heading=
"Total-Amount-Applied"
arsbilling:write_off_amount/column=65/mask="ZZZ,ZZZ.99-"/total 
l_disbursement/column=80/mask="ZZZ,ZZZ.99-"/total/heading="Disburse-ment"
--l_voided_disbursement/column=95/mask="ZZZ,ZZZ.99-"/total/heading=
--"VOID-Disburse-ment" 
l_cx_balance_due/column=95/heading="CX-Balance-Due"/mask="ZZZ,ZZZ.99-"/total
l_net/column=110/mask="ZZZ,ZZZ.99-" /total/heading="Net-Amount-DUE" 
arsbilling:due_date /mask="MM/DD/YYYY"/column=125

sorted by policy_no
          year(arsbilling:trans_exp)/newlines 
          l_record_status/newlines /total /heading="Grouping Status"
          arsbilling:trans_date/newlines 

top of page
""/newline
arsbilling:policy_no /heading="Policy No."
sfpname:name[1]/noheading/column=30
arsbilling:line_of_business/column=70/heading="Line of Business"
sfsline:description/noheading/newline

end of arsbilling:policy_no 
""/newline

box/noblanklines /noheadings 
"POLICY TOTALS"/column=50
    total[l_installment_amount, arsbilling:policy_no]/column=35/mask
="ZZ,ZZZ,ZZZ.99-"
--    total[l_cx_paid_amount,policy_no]/column=50/mask="ZZ,ZZZ.99-"
    total[arsbilling:total_amount_paid, policy_no] /column=50/mask=
"ZZZ,ZZZ.99-"
    total[arsbilling:write_off_amount, policy_no]/column=65/mask=
"ZZZ,ZZZ.99-"
    total[l_disbursement, policy_no] /column=80/mask=
"ZZZ,ZZZ.99-"
--    total[l_voided_disbursement, policy_no] /column=110/mask=
--"ZZZ,ZZZ.99-"
    total[l_cx_balance_due, policy_no]/column=95/mask="ZZZ,ZZZ.99-"
    total[l_net, policy_no]/column=110/mask="ZZZ,ZZZ.99-"
end box
          
