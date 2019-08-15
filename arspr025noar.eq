/*  arspr025noar
 
    January 15, 2008

    scips.com

    program to print the A/P checks - Over payments with cancalled and zero balance  

*/

Description Print the A/P  checks - Over payments of polices with zero balance and cancelled;

include "startend.inc"


where (arscheck:aps_trans_code = "CANCELNOAR" and 
      ((arscheck:enter_date => l_starting_date and
      arscheck:enter_date =< l_ending_date) or
      arscheck:enter_date = 00.00.0000 ))
      
list
/nobanner
/domain="arscheck"
/title="ARSCHECK A/P checks on cancelled policies with zero balance"

policy_no 
check_no 
check_date 
enter_date
check_amount 

sorted by arscheck:company_id/newpage/total 
          arscheck:policy_no  
        
                                                  
end of report 
""/newline=2
total[arscheck:check_amount]/align=arscheck:check_amount/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="TOTAL "
