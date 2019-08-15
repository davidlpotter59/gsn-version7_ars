/*  arspr075

    scips.com

    May 17, 2001

    arsbilling audit report, to fix balancing problems

*/

--include "startend.inc"
     
define signed ascii number l_billed[9] = if arsbilling:status <> "O" then
arsbilling:installment_amount 
else
0.00/decimalplaces=2    

define signed ascii number l_unbilled[9] = if arsbilling:status = "O" then
arsbilling:installment_amount 
else
0.00/decimalplaces=2                              

define signed ascii number l_billed_comm = l_billed * (arsbilling:comm_rate 
* 0.01)

define signed ascii number l_unbilled_comm = l_unbilled * (
arsbilling:comm_rate * 0.01)
  
define signed ascii number l_amount_due = l_billed - arsbilling:total_amount_paid 

--where (arsbilling:trans_date => l_starting_date and
--       arsbilling:trans_date <= l_ending_date ) 
-- and (trans_code = 12 or trans_code = 13)
--and arsbilling:policy_no = 22002349
--where arsbilling:trans_date = 03.21.2001

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING Audit Report"
/pagewidth=132
/duplicates 
--/nodetail
--/pagetotals 

arsbilling:policy_no/heading="Policy-Number"/column=1
arsbilling:trans_date/column=11/heading="Trans-Date"
arsbilling:trans_eff/column=22/heading="Trans-Eff"
arsbilling:trans_exp/column=33/heading="Trans-Exp"
arsbilling:trans_code/column=44/heading="Trans-Code"
arsbilling:line_of_business/column=50/heading="Line"     
arsbilling:comm_rate/column=56/heading="Comm-Rate"
arsbilling:sub_code/column=61/heading="Sub-Code"
arsbilling:billing_ctr/column=65/heading="B-C"
arsbilling:billed_date/column=71/heading="Billed-Date"
arsbilling:due_date/column=85/heading="Due-Date" 
arsbilling:status /column=96/heading="Status"
arsbilling:installment_amount/total/column=105/heading="Bill-Amount"
--arsbilling:total_amount_paid /total/column=125/heading="Amount-Paid"   
--l_amount_due /total/column=125/heading="Amount-Due"
--l_billed/heading="Amount-Billed"
--l_unbilled/heading="Amount-Unbilled"
--arsbilling:line_of_business 
--arsbilling:lob_subline 
--day(arsbilling:due_date)/nototal 
--dayname(arsbilling:due_date)

sorted by -- arsbilling:trans_code/newpage/total 
arsbilling:trans_date/newpage/total 
arsbilling:policy_no/total
         
/* end of arsbilling:policy_no 
arsbilling:policy_no/noheading/column=1
arsbilling:trans_date/column=11/noheading
arsbilling:trans_eff/column=22/noheading
arsbilling:trans_exp/column=33/noheading
arsbilling:trans_code/column=44/noheading
arsbilling:line_of_business/column=50/noheading
arsbilling:billing_ctr/column=53/noheading
arsbilling:billed_date/column=60/noheading
arsbilling:due_date/column=75/noheading
(total[arsbilling:installment_amount,arsbilling:policy_no]/column=105/noheading
arsbilling:installment_charge/column=125/noheading
*/
     
/* top of page
l_starting_date/mask="MM/DD/YYYY"/column=88/noheading
" - "
l_ending_date/mask="MM/DD/YYYY"/noheading/newline=2
--arsbilling:trans_code/noheading/column=1
--tabletca:description/noheading/column=5
*/
