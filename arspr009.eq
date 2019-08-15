/*  arspr009

    may 29, 2001

    scips.com

    program to print the A/R billing balance register - returned checks only
*/

include "startend.inc"

where arsbilling:trans_date => l_starting_date and
      arsbilling:trans_date <= l_ending_date and
      arsbilling:return_check_ctr <> 0 -- do process return checks in this
                                       -- report

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Returned Checks"

arsbilling:company_id 
arsbilling:policy_no 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:trans_exp 
arsbilling:line_of_business 
arsbilling:lob_subline
arsbilling:comm_rate/duplicates 
arsbilling:agent_no 
arsbilling:bill_plan
arsbilling:payment_plan 
arsbilling:installment_amount/total 

sorted by arsbilling:company_id/newpage/total 
          arsbilling:policy_no 
