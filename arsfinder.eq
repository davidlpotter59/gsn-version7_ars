define signed ascii number l_total_premium = if arsmaster:trans_code <> 18 and
arsmaster:trans_code <> 29 then
arsmaster:premium 
else
0.00/decimalplaces=2

where arsfinder:policy_no one of 810100552
 list
/nobanner
/domain="arsfinder"
--/nodefaults       
/pagewidth=132      
--/duplicates 

arsfinder:company_id 
arsfinder:policy_no             
arsfinder:billed_date    
copy_ctr 
/*       
arsbilling:billing_ctr
arsfinder:installment_charge 
arsfinder:copy_ctr 
arsfinder:copy_literal 
arsfinder:previous_payment_amount    
arsfinder:annual_premium 
*/
arspayor:name/duplicates 


sorted by arsfinder:copy_ctr/newlines/total 
