/*  arspr016

    SCIPS.com, Inc.

    March 27, 2012

    Report to list in summary arsbilling records 

*/

description 
List, in summary, arsbilling records - select a starting and ending date that have a balance as of the date range entered;

include "startend.inc"

define string l_prog_number = "ARSPR016 - Version 7.30"

define signed ascii number l_nsf_51 = if arsbilling:trans_code one of 51 then 

arsbilling:total_amount_paid else 0 

define signed ascii number l_billed_amount = if arsbilling:status not one of "O" then 
(arsbilling:installment_amount  - arsbilling:write_off_amount) 
else 0.00

define signed ascii number l_cash_total_paid = if arspayment:payment_trans_date < l_starting_date then
arspayment:amount else 0.00
 
define signed ascii number l_installment_amount = l_billed_amount + l_nsf_51

define signed ascii number l_defered_amount = if arsbilling:trans_code not one of 25 and 
arsbilling:status one of "O" then arsbilling:installment_amount else 0.00

define signed ascii number l_total_paid = arsbilling:total_amount_paid -- l_nsf_51 

define signed ascii number l_commission_amount = if arsbilling:comm_rate <> 0.00 then
arsbilling:installment_amount * (arsbilling:comm_rate * 0.01)  

define signed ascii number l_cx_balance_due = if arsbilling:trans_Code one of 25 then
arsbilling:installment_amount -- (arsbilling:total_amount_paid + arsbilling:write_off_amount)
else 0.00

define signed ascii number l_write_off_amount = arsbilling:write_off_amount 

define signed ascii number l_installment_amount2 = l_installment_amount - l_cx_balance_due 

define signed ascii number l_total_ar = l_installment_amount2  + l_defered_amount  

define signed ascii number l_net = if trans_code not one of 65,26 then
(l_total_ar - l_cash_total_paid + arsbilling:disbursement_amount) 


define unsigned ascii number l_days = if
l_ending_date > arsbilling:due_date then
l_ending_date - arsbilling:due_date else
0/decimalplaces=0 

define signed ascii number l_90_due_date[9] =  if 
l_days => 90 
and arsbilling:status one of "B" 
and trans_code not one of 65
then l_net  
else 0.00

define signed ascii number l_90_cx[9] =  if 
l_days => 90 
and arsbilling:status one of "B" 
and trans_code not one of 65
then l_cx_balance_due 
else 0.00
 
define signed ascii number l_total_90 = l_90_due_date + l_90_cx 
 
define signed ascii number l_90_eff_date =  if l_ending_date - arsbilling:trans_eff => 90 
and arsbilling:status one of "B" 
and trans_code not one of 65
then 
l_net
else 0.00

define  unsigned ascii number l_run_type[1]=parameter/prompt=
"Enter Run Type: (1 - Due Date, 2 - Effective Date) "
error "Invlaid Run Type " if l_run_type not one of 1,2

define unsigned ascii number l_over_90_only = parameter/prompt="Report on 90 Days Only (1=Yes, 2=No)"
error "Valid answers are 1 - Yes, or 2 - No only" if l_over_90_only not one of 1, 2 

define unsigned ascii number l_eff_year = year(arsbilling:trans_exp) - 1


where (arsbilling:trans_eff < l_ending_date
and year(arsbilling:trans_eff) => 2000)
--and arsbilling:trans_date > 03.01.0210)
and arsbilling:bill_plan one of "DB", "  "


list

/nobanner

/domain="arsbilling"

--/pagewidth=220

/title="Accounts Receivable Outstanding Cash Receivables - SUMMARY"

/nodetail 

/noreporttotals 

/pagelength=0

--/xls

 

box/noblanklines 

arsbilling:policy_no  /column=1

arsbilling:trans_date /column=12

arsbilling:trans_eff /column=30

arsbilling:line_of_business /column=45/heading="Line"

arsbilling:status /column=50

l_installment_amount2 /column=60 /heading="Total-Billed"

l_defered_amount/column=85/heading="Deferred-Billing"

l_total_ar/column=110/heading="Total-AR"

l_cash_total_paid/column=135/heading="Total-Paid"

arsbilling:write_off_amount/column=160

arsbilling:disbursement_amount/column=185

l_cx_balance_due/column=210/heading="CX Balance-Due"

l_net/column=235  /heading="Net-Due"

l_total_90 /column=260/heading="90 and Over"

l_eff_year /heading="Eff-Year"/column=285

--l_days /column=210

end box 

 

sorted by  l_eff_year    

           arsbilling:policy_no

                 

end of arsbilling:policy_no 

 

box/noblanklines/noheadings 

if total[l_net, arsbilling:policy_no] <> 0.00 then 

{  

    arsbilling:policy_no  /column=1

    arsbilling:trans_date /column=12

    arsbilling:trans_eff /column=30

    arsbilling:line_of_business /column=45

    arsbilling:status /column=50

    total[l_installment_amount2]/column=60

    total[l_defered_amount]/column=85

    total[l_total_ar]/column=110

    total[l_cash_total_paid]/column=135

    total[arsbilling:write_off_amount]/column=160

    total[arsbilling:disbursement_amount] /column=185

    total[l_cx_balance_due]/column=210

   total[l_net]/column=235

    total[l_total_90] /column=260

    l_eff_year /column=285

}

end box 

 

end of report 

""/newline 

    total[l_installment_amount2]/column=60

    total[l_defered_amount]/column=85

    total[l_total_ar]/column=110

    total[l_cash_total_paid]/column=135

    total[arsbilling:write_off_amount]/column=160

    total[arsbilling:disbursement_amount] /column=185

    total[l_cx_balance_due]/column=210

    total[l_net]/column=235

    total[l_total_90] /column=260

 

include "reporttop.inc"
if l_run_type one of 1 
then
{ "Run on Due Date"}
else
{ "Run on Effective Date"}
""/newline
if l_over_90_only one of 1 then 
{ "Over 90+ Days Only" }
else
{ "All Net Balances > $0.00 " }
""/newline

;
