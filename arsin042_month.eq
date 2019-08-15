/*  arspr042

    SCIPS.com, Inc.

    June 17, 2003

    Report to list in summary arsbilling records - processed and run from arsin042 only 
*/

description List, in summary, arsbilling records - accessed from arsin042 only ;

define unsigned ascii number l_policy[9]=parameter/prompt="Enter Policy Number "

define signed ascii number l_cx_balance_due_paid = if
arsbilling_month:status one of "Z" and 
arsbilling_month:trans_code one of 26 then arsbilling_month:payment_offset 
else 0.00
                              
define signed ascii number l_nsf_rebilling = if arsbilling_month:status one of "R" then
arsbilling_month:total_amount_paid 
else 0.00

define signed ascii number l_installment_amount = if arsbilling_month:trans_code one of 25 then 0 else
arsbilling_month:installment_amount + l_nsf_rebilling 

define signed ascii number l_commission_amount = if arsbilling_month:comm_rate <> 0.00 then
arsbilling_month:installment_amount * (arsbilling_month:comm_rate * 0.01)  

define signed ascii number l_cx_balance_due = if arsbilling_month:trans_Code one of 25 then
arsbilling_month:installment_amount - (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount)
else 0.00
                          
define signed ascii number l_disbursement = if arsbilling_month:trans_code not one of 36 then 
arsbilling_month:disbursement_amount 
else 0.00

define signed ascii number l_voided_disbursement = if arsbilling_month:trans_code one of 36 then 
arsbilling_month:disbursement_amount 
else 0.00
                                   
define signed ascii number l_net_disbursement = l_disbursement + 
l_voided_disbursement 

define signed ascii number l_cx_paid_amount = 0
/*if 
arsbilling_month:trans_code one of 16 and 
arsbilling_month:reinstated one of "Y" and 
arsbilling_month:total_amount_paid <> 0 then 
arsbilling_month:total_amount_paid * -1
else 0.00
*/

define signed ascii number l_total_amount_paid = if
arsbilling_month:status one of "O","B","P" then 
arsbilling_month:total_amount_paid 
else 0.00

define signed ascii number l_net = -- if trans_code not one of 25 then
l_installment_amount - (arsbilling_month:total_amount_paid - 
arsbilling_month:write_off_amount) +  
l_net_disbursement - l_cx_paid_amount 
--arsbilling_month:disbursement_amount - l_voided_disbursement - l_cx_paid_amount 
 
define string l_record_status = switch(arsbilling_month:status)
case "C","V","E"   : "     "
default : "Active"

where arsbilling_month:policy_no = l_policy 

list
/nobanner
/domain="arsbilling_month"
/pagewidth=140
/title="Policy Summary Activity and Balance"
/noreporttotals 

--arsbilling_month:policy_no  /column=1
arsbilling_month:trans_date /column=1
arsbilling_month:trans_eff /column=12
arsbilling_month:trans_code/column=23/heading="T-C"
--arsbilling_month:line_of_business /column=50/heading="LOB"
arsbilling_month:status /column=29/heading="S-T"
l_installment_amount/column=35 /heading="Installment-Amount"/mask=
"ZZ,ZZZ,ZZZ.99-"/total        
--l_cx_paid_amount/heading="CX-Amount-Paid"/column=50/total /mask="ZZZ,ZZZ.99-"
arsbilling_month:total_amount_paid/column=50  /mask="ZZZ,ZZZ.99-"/total/heading=
"Total-Amount-Applied"
arsbilling_month:write_off_amount/column=65/mask="ZZZ,ZZZ.99-"/total 
--l_disbursement/column=80/mask="ZZZ,ZZZ.99-"/total/heading="Disburse-ment"
l_net_disbursement/column=80/mask="ZZZ,ZZZ.99-"/total/heading="Disburse-ment"
--l_voided_disbursement/column=95/mask="ZZZ,ZZZ.99-"/total/heading=
--"VOID-Disburse-ment" 
l_cx_balance_due/column=95/heading="CX-Balance-Due"/mask="ZZZ,ZZZ.99-"/total
l_net/column=110/mask="ZZZ,ZZZ.99-" /total/heading="Net-Amount-DUE" 
arsbilling_month:due_date /mask="MM/DD/YYYY"/column=125
arspayment:check_reference 

sorted by arsbilling_month:policy_no
          year(arsbilling_month:trans_exp)
          l_record_status/heading="Grouping Status"
          arsbilling_month:trans_date

top of page
""/newline
arsbilling_month:policy_no /heading="Policy No."
sfpname:name[1]/noheading/column=30
arsbilling_month:line_of_business/column=70/heading="Line of Business"
sfsline:description/noheading/newline

end of arsbilling_month:policy_no 
""/newline

box/noblanklines /noheadings 
"POLICY TOTALS"/column=50
    total[l_installment_amount, arsbilling_month:policy_no]/column=35/mask
="ZZ,ZZZ,ZZZ.99-"
--    total[l_cx_paid_amount,policy_no]/column=50/mask="ZZ,ZZZ.99-"
    total[arsbilling_month:total_amount_paid, policy_no] /column=50/mask=
"ZZZ,ZZZ.99-"
    total[arsbilling_month:write_off_amount, policy_no]/column=65/mask=
"ZZZ,ZZZ.99-"
    total[l_net_disbursement, policy_no] /column=80/mask=
"ZZZ,ZZZ.99-"
--    total[l_voided_disbursement, policy_no] /column=110/mask=
--"ZZZ,ZZZ.99-"
    total[l_cx_balance_due, policy_no]/column=95/mask="ZZZ,ZZZ.99-"
    total[l_net, policy_no]/column=110/mask="ZZZ,ZZZ.99-"
end box
