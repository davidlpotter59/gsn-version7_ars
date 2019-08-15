/*  arspr800_AC

    SCIPS.com, Inc.

    June 29, 2006

    Report to list in summary arsbilling records - A/C only 
*/

description 
List, in summary, AC (Account Current) arsbilling records - select a starting and ending date that have a balance as of the date range entered ;

include "ending.inc"
define string l_prog_number[20]="arspr800_ac Version 7.00"

define signed ascii number l_nsf_51 = if arsbilling_month:trans_code one of 51 then 
arsbilling_month:total_amount_paid else 0 

define signed ascii number l_billed_amount = if arsbilling_month:status not one of "O" and 
arsbilling_MONTH:trans_code not one of 25 then arsbilling_month:installment_amount 
else 0.00

define signed ascii number l_installment_amount = if arsbilling_month:trans_code one of 25 then 0 else
l_billed_amount + l_nsf_51 

define signed ascii number l_defered_amount = if arsbilling_month:trans_code not one of 25 and 
arsbilling_month:status one of "O" then arsbilling_month:installment_amount else 0.00

define signed ascii number l_total_ar = l_installment_amount + l_defered_amount 

define signed ascii number l_total_paid = arsbilling_month:total_amount_paid -- l_nsf_51 

define signed ascii number l_commission_amount = if arsbilling_month:comm_rate <> 0.00 and 
arsbilling_month:trans_code one of 13 then
arsbilling_month:installment_amount * (arsbilling_month:comm_rate * 0.01)  
else 0.00

define signed ascii number l_cx_balance_due = if arsbilling_month:trans_Code one of 25 then
arsbilling_month:installment_amount - (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount)
else 0.00

--define signed ascii number l_net = -- if trans_code not one of 25 then
--l_installment_amount - (arsbilling_month:total_amount_paid + arsbilling_month:write_off_amount) + 
--arsbilling_month:disbursement_amount 
 
-- april 10, 2007 was l_net replaced with l_installment_amount
-- april 10, 2007 was l_commission_amount -- removed from the following
define signed ascii number l_net = (l_installment_amount ) - l_total_paid  -- added l_commission_amount
- arsbilling_month:write_off_amount + arsbilling_month:disbursement_amount 

define unsigned ascii number l_days = if
l_ending_date > arsbilling_month:due_date then
l_ending_date - arsbilling_month:due_date else
0/decimalplaces=0

define signed ascii number l_90_due_date[9] =  if 
l_days => 90 
and arsbilling_month:status one of "B" 
then l_net  
else 0.00

define signed ascii number l_90_cx[9] =  if 
l_days => 90 
and arsbilling_month:status one of "B" 
then l_cx_balance_due 
else 0.00

define signed ascii number l_total_90 = l_90_due_date + l_90_cx 

define signed ascii number l_90_eff_date =  if l_ending_date - arsbilling_month:trans_eff => 90 
and arsbilling_month:status one of "B" 
then 
l_net
else 0.00

define  unsigned ascii number l_run_type[1]=parameter/prompt=
"Enter Run Type: (1 - Due Date, 2 - Effective Date) "
error "Invlaid Run Type " if l_run_type not one of 1,2

define unsigned ascii number l_over_90_only = parameter/prompt="Report on 90 Days Only (1=Yes, 2=No)"
error "Valid answers are 1 - Yes, or 2 - No only" if l_over_90_only not one of 1, 2 
define unsigned ascii number l_eff_year = year(arsbilling_month:trans_exp) - 1

/*  original selection logic */

/*
where  arsbilling_month:trans_eff <= l_ending_date
and arsbilling_month:trans_date <= l_ending_date 
and year(arsbilling_month:trans_eff) => 2000
and arsbilling_month:bill_plan one of "AC"

*/
where 

((((arsbilling_month:trans_date < l_starting_date and
 arsbilling_month:trans_eff => l_starting_date and
 arsbilling_month:trans_eff <= l_ending_date) or
(arsbilling_month:trans_date => l_starting_date and
 arsbilling_month:trans_date <= l_ending_date and
 arsbilling_month:trans_eff <= l_ending_date))

and

arsbilling_month:trans_eff <> arsbilling_month:trans_exp

and

 arsbilling_month:premium <> 0)

or

arsbilling_month:trans_date < l_starting_date and 
arsbilling_month:trans_eff <= l_ending_date and 
l_net <> 0)

and arsbilling_month:bill_plan one of "AC"


list
/nobanner
/domain="arsbilling_month"
--/pagewidth=220
/title="A/C - Accounts Receivable Outstanding Receivables - SUMMARY"
--/nodetail 
/noreporttotals 
--/pagelength=0
--/xls

box/noblanklines 
arsbilling_month:policy_no  /column=1
arsbilling_month:trans_date /column=12
arsbilling_month:trans_eff /column=30
arsbilling_month:line_of_business /column=45/heading="Line"
arsbilling_month:status /column=48
l_installment_amount /column=60 /heading="Total-Billed"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_defered_amount/column=80/heading="Deferred-Billing"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_total_ar/column=100/heading="Total-AR"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_total_paid/column=120/heading="Total-Paid"/mask="(ZZZ,ZZZ,ZZZ.99)"
arsbilling_month:write_off_amount/column=140/mask="(ZZZ,ZZZ,ZZZ.99)"
arsbilling_month:disbursement_amount/column=160/mask="(ZZZ,ZZZ,ZZZ.99)"
l_cx_balance_due/column=180/heading="CX Balance-Due"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_net/column=200  /heading="Net-Due"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_total_90 /column=220/heading="90 and Over"/mask="(ZZZ,ZZZ,ZZZ.99)"
l_eff_year /heading="Eff-Year"/column=240/mask="9999"

end box 

sorted by  arsbilling_month:agent_no/newpage 
           l_eff_year    
           arsbilling_month:policy_no                

end of arsbilling_month:agent_no 
""/newline 
    "Total for Agent "/column=1
    total[l_installment_amount]/column=60/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_defered_amount]/column=77/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_ar]/column=100/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_paid]/column=120/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[arsbilling_month:write_off_amount]/column=137/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[arsbilling_month:disbursement_amount] /column=154/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_cx_balance_due]/column=176/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_net]/column=200/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_90] /column=215/mask="(ZZZ,ZZZ,ZZZ.99)"

end of report 
""/newline 
    "Report Total "/column=1
    total[l_installment_amount]/column=60/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_defered_amount]/column=77/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_ar]/column=100/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_paid]/column=120/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[arsbilling_month:write_off_amount]/column=137/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[arsbilling_month:disbursement_amount] /column=154/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_cx_balance_due]/column=176/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_net]/column=200/mask="(ZZZ,ZZZ,ZZZ.99)"
    total[l_total_90] /column=215/mask="(ZZZ,ZZZ,ZZZ.99)"

include "reporttopasof.inc"
--"Report Period"/center/newline
--str(l_ending_date,"MM/DD/YYYY")/centre/noheading /newline
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
arsbilling_month:agent_no/heading="Agent Number"/column=1
sfsagent:name[1]/newline /noheading 

;
