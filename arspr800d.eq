/*  arspr800d

    SCIPS.com, Inc.

    June 17, 2003

    Report to list in detail arsbilling records - processed and run from arsin042 only 
*/

description 
List, in detail, arsbilling records - select a starting and ending date that have a balance as of the date range entered ;

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

define  unsigned ascii number l_run_type[1]=parameter/prompt=
"Enter Run Type: (1 - Due Date, 2 - Effective Date) "
error "Invlaid Run Type " if l_run_type not one of 1,2

where ((l_run_type one of 1 and 
        arsbilling:due_date >= l_starting_date and   
        arsbilling:due_date <= l_ending_date) or  
       (l_run_type one of 2 and 
        arsbilling:trans_eff >= l_starting_date and 
        arsbilling:trans_eff <= l_ending_date))
list
/nobanner
/domain="arsbilling"
/pagewidth=180
/title="Accounts Receivable Outstanding Receivables - DETAIL" 
/noreporttotals 

box/noblanklines 
arsbilling:policy_no  /column=1
arsbilling:trans_date /column=12
arsbilling:trans_eff /column=30
arsbilling:line_of_business /column=45
arsbilling:status /column=50
l_installment_amount/total /column=60 /heading="Installment-Amount"
arsbilling:total_amount_paid /total /column=75  
arsbilling:write_off_amount/column=90
arsbilling:disbursement_amount   /total /column=105
l_cx_balance_due/column=120/heading="CX Balance-Due"
l_net/column=135  /heading="Net-Due"
end box 

sorted by arsbilling:policy_no /newlines 
                            
end of arsbilling:policy_no 
box/noblanklines/noheadings 
"Policy Total "/column=25
total[l_installment_amount]/column=60
total[arsbilling:total_amount_paid]/column=75  
total[arsbilling:write_off_amount]/column=90
total[arsbilling:disbursement_amount] /column=105
total[l_cx_balance_due]/column=120
total[l_net]/column=135  
end box 

end of report
""/newline 

box/noblanklines/noheadings 
if total[l_net] <> 0 then 
{
total[l_installment_amount]/column=60
total[arsbilling:total_amount_paid]/column=75  
total[arsbilling:write_off_amount]/column=90
total[arsbilling:disbursement_amount] /column=105
total[l_cx_balance_due]/column=120
total[l_net]/column=135  
}
end box 

top of page
"Report Period"/center/newline
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY"))/centre/noheading /newline
if l_run_type one of 1 
then
{ "Run on Due Date"}
else
{ "Run on Effective Date"}
""/newline 
