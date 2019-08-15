define wdate l_starting_date = parameter 
define wdate l_ending_date = parameter
         
define signed ascii number l_billed[9] = if arsbilling:status[1] = "B" then
arsbilling:installment_amount 
else
0.00/decimalplaces=2    

define signed ascii number l_unbilled[9] = if arsbilling:status[1] = "O" then
arsbilling:installment_amount 
else
0.00/decimalplaces=2                              

define signed ascii number l_billed_comm = l_billed * (arsbilling:comm_rate 
* 0.01)

define signed ascii number l_unbilled_comm = l_unbilled * (
arsbilling:comm_rate * 0.01)

where arsbilling:trans_date => l_starting_date and
      arsbilling:trans_date <= l_ending_date

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING Audit Report"
/pagewidth=200
--/nodetail 
/duplicates 
--/maxpages=30

{
    box/noblanklines 
        arsbilling:policy_no/heading="Policy-Number"/column=1
        arsbilling:trans_date/column=11/heading="Trans-Date"
        arsbilling:trans_eff/column=22/heading="Trans-Eff"
        arsbilling:trans_exp/column=33/heading="Trans-Exp"
        arsbilling:trans_code/column=44/heading="Trans-Code"
        arsbilling:line_of_business/column=50/heading="Line"
        arsbilling:billing_ctr/column=53/noheading
        --arsbilling:comm_rate/column=60/heading="Comm-Rate"/nototal                   
        arsbilling:billed_date/column=60/heading="Billed-Date"
        arsbilling:due_date/column=75/heading="Due-Date"
--        arsbilling:status/column=85/heading="Status"
--        arsbilling:pay_plan/column=95/heading="Pay-Plan"
        arsbilling:installment_amount/total/column=105/heading="Bill-Amount"
        arsbilling:installment_charge/column=125/heading="Install-Charge"
/*        l_billed/column=140/heading="Billed-Amount"
        l_unbilled/column=155/heading="Unbilled-Amount"
        l_billed_comm/column=170/heading="Billed-Commission"
        l_unbilled_comm/column=185/heading="Unbilled-Commission"
*/
         arsbilling:installment_amount/column=140/heading="Billing-Buckets"
    end box
}   

sorted by arsbilling:policy_no

/* end of arsbilling:policy_no 
arsbilling:policy_no/noheading/column=1
arsbilling:trans_date/noheading/column=11
arsbilling:trans_eff/noheading/column=22
arsbilling:trans_exp/noheading/column=33
arsbilling:trans_code/noheading/column=44
arsbilling:line_of_business/noheading/column=50
arsbilling:comm_rate/noheading/column=60
total[arsbilling:installment_amount,arsbilling:policy_no]/noheading/column=75
total[arsbilling:installment_charge,arsbilling:policy_no]/noheading/column=95
total[l_totla,arsbilling:policy_no]/noheading/column=140

end of page
""/newline
"Total For Page "/column=50
total[arsbilling:installment_amount,page]/column=75/noheading
*/
              
top of page
l_starting_date/mask="MM/DD/YYYY"/column=88/noheading
" - "
l_ending_date/mask="MM/DD/YYYY"/noheading/newline 
