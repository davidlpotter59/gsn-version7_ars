/*  arspayment

    march 7, 2001
   
    scips.com

    report to print the payments received within a
    selected starting and ending date range
*/

include "startend.inc"

--where arspayment:payment_trans_date => l_starting_date and
--      arspayment:payment_trans_date <= l_ending_date 
where arspayment:policy_no = 608907
list
/nobanner
/domain="arspayment"
/title="ARSPAYMENT - Payments Processed"
/pagewidth=250

arspayment:policy_no 
arspayment:payment_trans_date           
arspayment:trans_code/duplicates  
arspayment:amount /total 
arspayment:agent_no /duplicates 
arspayment:comm_rate  /nototal 
arspayment:check_number 
arspayment:check_reference
arspayment:account_number 
arspayment:company_id 
arspayment:trans_type

sorted by arspayment:policy_no 
