/*  arspr013

    March 21, 2012

    scips.com

    report for Cash commissions

*/

Description 
To show CASH commissions for a given month;

include "startend.inc"

define unsigned ascii number l_comm_rate[9] = (arspayment:comm_rate divide 100) 

define unsigned ascii number l_comm_amount = l_comm_rate * arspayment:amount 
                    
where (((arspayment:payment_trans_date => l_starting_date and 
       arspayment:payment_trans_date <= l_ending_date) and 
       sfpname:eff_date <= l_ending_date) OR
      (ARSPAYMENT:PAYMENT_TRANS_DATE < l_STARTING_DATE And
       ARSPAYMENT:TRANS_EFF  >= l_STARTING_DATE And
       ARSPAYMENT:TRANS_EFF  <= l_ENDING_DATE)) and
       arspayment:trans_code not one of 18,19,22,23,27,28,29,70 --and 
 --      ARSMASTER:BILL_PLAN = "DB" And                               -- direct bill only
   --    ARSMASTER:COMM_RATE <> 0.00 and                             -- no zero comm rates
 --      sfsline:stmt_lob <> 999) 

list
/nobanner
/domain="arspayment"
/duplicates 

arspayment:agent_no 
arspayment:policy_no
arspayment:trans_code  
arspayment:payment_trans_date 
arspayment:trans_date 
arspayment:trans_Eff  
sfpname:eff_date
arschksu:pol_year /duplicates 
arschksu:check_reference  
arspayment:comm_rate 
arspayment:amount 
l_comm_amount/mask="$$,$$9.99" 

sorted by arspayment:agent_no 
end of agent_no/newline
total[l_comm_amount ]/newline=2/column=126/heading="TOTAL"
