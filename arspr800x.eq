/*  arspr800

    SCIPS.com, Inc.

    June 17, 2003

    Report to list in summary arsbilling records - processed and run from arsin042 only  
    Special Version for Salem
*/

description 
List, in summary, arsbilling records - select a starting and ending date  ;

include "startend.inc"

define signed ascii number l_installment_amount = if arsbilling:trans_code one of 25 then 0 else
arsbilling:installment_amount 

define signed ascii number l_commission_amount = if arsbilling:comm_rate <> 0.00 then
arsbilling:installment_amount * (arsbilling:comm_rate * 0.01)  

define signed ascii number l_cx_balance_due = if arsbilling:trans_Code one of 25 then
arsbilling:installment_amount - (arsbilling:total_amount_paid + arsbilling:write_off_amount)
else 0.00

define signed ascii number l_net = -- if trans_code not one of 25 then
l_installment_amount - (arsbilling:total_amount_paid + arsbilling:write_off_amount) + 
arsbilling:disbursement_amount 

where arsbilling:due_date >= l_starting_date and 
      arsbilling:due_date <= l_ending_date  and
      arsbilling:status one of "O","B"

list
/nobanner
/domain="arsbilling"
/pagewidth=180
--/nodetail  
--/noreporttotals
--/nodefaults 
--/pagelength=0 

box/noblanklines 
arsbilling:policy_no  
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:line_of_business 
arsbilling:status 
l_installment_amount/total /column=60 /heading="Installment-Amount"
arsbilling:total_amount_paid /total /column=75  
arsbilling:write_off_amount/column=90
arsbilling:disbursement_amount   /total /column=105
l_cx_balance_due/column=120/heading="CX Balance-Due"
l_net/column=135  
end box 

sorted by arsbilling:policy_no 

top of page
"Report Period"/center/newline
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY"))/centre/noheading /newline
