include "startend.inc"

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

where (arsbilling:trans_date => l_starting_date and
       arsbilling:trans_date <= l_ending_date ) 
-- and (trans_code = 12 or trans_code = 13)
-- and arsbilling:policy_no = 22002349
list
/nobanner
/domain="arsbilling"
/title="ARSBILLING Audit Report - 01/01/2001 - 01/05/2001"
/pagewidth=200
/duplicates 
/nodetail
--/pagetotals 

arsbilling:policy_no/heading="Policy-Number"/column=1
arsbilling:trans_date/column=11/heading="Trans-Date"
arsbilling:trans_eff/column=22/heading="Trans-Eff"
--arsbilling:trans_exp/column=33/heading="Trans-Exp"
/* arsbilling:trans_code/column=44/heading="Trans-Code"
arsbilling:line_of_business/column=50/heading="Line"
arsbilling:billing_ctr/column=53/heading="B-C"
arsbilling:billed_date/column=60/heading="Billed-Date"
arsbilling:due_date/column=75/heading="Due-Date"
arsbilling:installment_amount/total/column=105/heading="Bill-Amount"*/
--arsbilling:status /column=125
--arsbilling:total_amount_paid /total/column=125/heading="Amount-Paid"
--arsbilling:installment_charge/column=125/heading="Install-Charge"  
--arsbilling:company_id 
--cacompany:account_number 
--arsbilling:status_date 
--l_billed 
--l_unbilled 

sorted by -- arsbilling:trans_code/newpage/total 
--arsbilling:trans_date/newpage       
arsbilling:policy_no 
         
end of arsbilling:policy_no 
arsbilling:policy_no/noheading/column=1
arsbilling:trans_date/column=11/noheading
total[arsbilling:total_amount_paid , arsbilling:policy_no]/column=22
/noheading 
--arsbilling:trans_eff/column=22/noheading
--arsbilling:trans_exp/column=33/noheading
/* arsbilling:trans_code/column=44/noheading
arsbilling:line_of_business/column=50/noheading
arsbilling:billing_ctr/column=53/noheading
arsbilling:billed_date/column=60/noheading
arsbilling:due_date/column=75/noheading*/
--total[arsbilling:installment_amount,arsbilling:policy_no]/column=105/noheading
--arsbilling:installment_charge/column=125/noheading

     
top of page
l_starting_date/mask="MM/DD/YYYY"/column=88/noheading
" - "
l_ending_date/mask="MM/DD/YYYY"/noheading/newline=2
--arsbilling:trans_code/noheading/column=1
--tabletca:description/noheading/column=5

        
end of report
total[arsbilling:total_amount_paid]/column=22/noheading 
