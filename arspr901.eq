/*  arspr901

    september 1, 2004

    scips.com, inc.

    report to show cancellations for an as of date range
    reflects pending underwriting cancellation, 
    amounts less then notice waive if not on last installment, 
    current pending non-pay cancellations
*/

Description Non-Pay cancellation Audit Report;

include "ending.inc"

define signed ascii number l_total_due = arsbilling:installment_amount - 
arsbilling:write_off_amount - arsbilling:total_amount_paid 

define file arspayplana = access arspayplan, set arspayplan:company_id= 
arsbilling:company_id,
arspayplan:line_of_business= arsbilling:line_of_business, 
arspayplan:payment_plan= arsbilling:payment_plan 

where arsbilling:due_date <= l_ending_date and
arsbilling:status one of "B"
and arsbilling:trans_code < 20
--and arsbilling:user_console = "arsup900"

list
/nobanner
/domain="arsbilling"
/nodetail 

arsbilling:policy_no/heading="Policy-No"/column=1    
arsbilling:billed_date/heading="Billed-Date"/column=15
arsbilling:trans_date/heading="Trans-Date"/column=25
arsbilling:trans_eff/heading="Trans-Eff"/column=35
arsbilling:trans_exp/heading="Trans-Exp"/column=45
arsbilling:billing_ctr/heading="I/P"/column=55
arsbilling:due_date/heading="Due-Date"/column=60
l_total_due/heading="Total-Net Due"/column=70
""/column=85/heading="Pending-CX"
""/column=100/heading="Less Then-Amount NOT-Last Installment"
""/column=115/heading="Less Then-Amount Last-Installment"
""/column=130/heading="Pending-NONPay-CX Notice" 

sorted by arsbilling:POLICY_NO

end of policy_no 
box/noheadings 
arsbilling:policy_no/column=1   
arsbilling:billed_date/column=15
arsbilling:trans_date/column=25 
arsbilling:trans_eff/column=35
arsbilling:trans_exp/column=45
trun(str(arsbilling:billing_ctr)) + "/" + trun(str(arspayplan:number_of_payments)) /column
=55
arsbilling:due_date/column=60 
total[l_total_due]/column=70
xob 

if sfscancel:policy_no = arsbilling:policy_no then 
{
  "X"/column=90
}

if total[l_total_due] <= 25 and 
   arsbilling:billing_ctr < arspayplana:number_of_payments then 
   {
    "X"/column=108
    }

if total[l_total_due] <= 25 and 
   arsbilling:billing_ctr = arspayplana:number_of_payments then 
   {
    "X"/column=123
    }
