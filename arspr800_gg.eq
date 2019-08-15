

/*  arspr800_gg

    SCIPS.com, Inc.

    June 17, 2003

    Report to list in summary arsbilling records - processed and run from arsin042 only 
*/

description 
List, in summary, arsbilling records - select a starting and ending date that have a balance as of the date range entered ;

include "ending.inc"
--define string l_prog_number = "ARSPR800 - Version 7.20"
define string l_prog_number = "ARSPR800 - Version 7.22"
--define string l_prog_number = "ARSPR800 - Version 7.30_3a"

define signed ascii number l_nsf_51 = if arsbilling_month:trans_code one of 51 then 
arsbilling_month:total_amount_paid else 0 

define signed ascii number l_billed_amount = if arsbilling_month:status not one of "O" then 
arsbilling_month:installment_amount 
else 0.00

--define signed ascii number l_installment_amount = if arsbilling_month:trans_code one of 25 then 0 else
--l_billed_amount + l_nsf_51 
define signed ascii number l_installment_amount = l_billed_amount + l_nsf_51



define signed ascii number l_defered_amount = if arsbilling_month:trans_code not one of 25 and 
arsbilling_month:status one of "O" then arsbilling_month:installment_amount else 0.00

define signed ascii number l_total_paid = arsbilling_month:total_amount_paid -- l_nsf_51 

define signed ascii number l_commission_amount = if arsbilling_month:comm_rate <> 0.00 then
arsbilling_month:installment_amount * (arsbilling_month:comm_rate * 0.01)  

--define signed ascii number l_cx_balance_due = if arsbilling_month:trans_Code one of 25 then
--arsbilling_month:installment_amount - (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount)
--else 0.00
define signed ascii number l_cx_balance_due = if arsbilling_month:trans_Code one of 25 then
arsbilling_month:installment_amount 
-- (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount)
else 0.00

define signed ascii number l_nsf = if trans_code one of 65 then
total_amount_paid 

define signed ascii number l_write_off_amount = arsbilling_month:write_off_amount 

--define signed ascii number l_net = -- if trans_code not one of 25 then
--l_installment_amount - (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount) + 
--arsbilling_month:disbursement_amount 

define signed ascii number l_installment_amount2 = l_installment_amount - l_cx_balance_due +l_nsf

define signed ascii number l_total_ar = l_installment_amount2  + l_defered_amount

--define signed ascii number l_net = if trans_code not one of 65,26 then
define signed ascii number l_net = if trans_code not one of 26 then
(((l_total_ar - l_total_paid) 
 - arsbilling_month:write_off_amount) + arsbilling_month:disbursement_amount)


define unsigned ascii number l_days = if
l_ending_date > arsbilling_month:due_date then
l_ending_date - arsbilling_month:due_date else
0/decimalplaces=0

define signed ascii number l_90_due_date[9] =  if 
l_days => 90 
and arsbilling_month:status one of "B" 
and trans_code not one of 65
then l_net  
else 0.00

define signed ascii number l_90_cx[9] =  if 
l_days => 90 
and arsbilling_month:status one of "B" 
and trans_code not one of 65
then l_cx_balance_due 
else 0.00

define signed ascii number l_total_90 = l_90_due_date + l_90_cx 

define signed ascii number l_90_eff_date =  if l_ending_date - arsbilling_month:trans_eff => 90 
and arsbilling_month:status one of "B" 
and trans_code not one of 65
then 
l_net
else 0.00

define  unsigned ascii number l_run_type[1]=parameter/prompt=
"Enter Run Type: (1 - Due Date, 2 - Effective Date) "
error "Invlaid Run Type " if l_run_type not one of 1,2

define unsigned ascii number l_over_90_only = parameter/prompt="Report on 90 Days Only (1=Yes, 2=No)"
error "Valid answers are 1 - Yes, or 2 - No only" if l_over_90_only not one of 1, 2 
define unsigned ascii number l_eff_year = year(arsbilling_month:trans_exp) - 1

where  arsbilling_month:trans_eff <= l_ending_date
and year(arsbilling_month:trans_eff) => 2000
and arsbilling_month:bill_plan one of "DB", "  "
--and arsbilling_month:policy_no = 600000984

list
/nobanner
/domain="arsbilling_month"
--/pagewidth=220
/title="Accounts Receivable Outstanding Receivables - SUMMARY"
/nodetail 
/noreporttotals 
/pagelength=0
--/xls

box/noblanklines 
arsbilling_month:policy_no  /column=1
arsbilling_month:trans_date /column=12
arsbilling_month:trans_eff /column=30
arsbilling_month:line_of_business /column=45/heading="Line"
arsbilling_month:status /column=50
l_installment_amount2 /column=60 /heading="Total-Billed"
l_defered_amount/column=85/heading="Deferred-Billing"
l_total_ar/column=110/heading="Total-Premiums-(Including fee)"
l_total_paid/column=135/heading="Total-Paid"
arsbilling_month:write_off_amount/column=160
arsbilling_month:disbursement_amount/column=185
l_cx_balance_due/column=210/heading="CX Balance-Due"
l_net/column=235  /heading="Net-Due"
l_total_90 /column=260/heading="90 and Over"
l_eff_year /heading="Eff-Year"/column=285
--l_days /column=210
end box 

sorted by  l_eff_year    
           arsbilling_month:policy_no
                 
end of arsbilling_month:policy_no 

box/noblanklines/noheadings 
--if total[l_net, arsbilling_month:policy_no] <> 0.00 then 
--{  
    arsbilling_month:policy_no  /column=1
    arsbilling_month:trans_date /column=12
    arsbilling_month:trans_eff /column=30
    arsbilling_month:line_of_business /column=45
    arsbilling_month:status /column=50
    total[l_installment_amount2]/column=60
    total[l_defered_amount]/column=85
    total[l_total_ar]/column=110
    total[l_total_paid]/column=135
    total[arsbilling_month:write_off_amount]/column=160
    total[arsbilling_month:disbursement_amount] /column=185
    total[l_cx_balance_due]/column=210
    total[l_net]/column=235
    total[l_total_90] /column=260
    l_eff_year /column=285
--}
end box 

end of report 
""/newline 
    total[l_installment_amount2]/column=60
    total[l_defered_amount]/column=85
    total[l_total_ar]/column=110
    total[l_total_paid]/column=135
    total[arsbilling_month:write_off_amount]/column=160
    total[arsbilling_month:disbursement_amount] /column=185
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
