/*  arspr401

    June 11, 2003

    SCIPS.com, Inc.

    Report to list the transactions by selected policy number 
*/

description List transactions by transaction date - enter policy number ;

define unsigned ascii number l_policy_no = parameter /prompt= "Enter Policy Number <NL> "

where arsbilling:policy_no = l_policy_no 

list
/nobanner
/domain="arsbilling"
                 
arsbilling:policy_no 
arsbilling:trans_date
arsbilling:trans_eff  
arsbilling:status 
arsbilling:trans_code
arsbilling:premium   /total   
arsbilling:total_amount_paid/total  
arsbilling:write_off_amount/total
arsbilling:disbursement_amount   /total  
arsbilling:net_amount_due 


sorted by arsbilling:trans_date /newlines 
