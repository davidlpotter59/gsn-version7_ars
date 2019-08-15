/*   arspr059

     July 27, 2006

     scips.com

     a/r report to list write-offs (waive amounts) processed within a 
     user defined date range - using write off date not trans date
*/

description Write-offs Processed (write off date) within a Starting and Ending Date Range ;

include "startend.inc"         

define string l_prog_number = "arspr059 - Version 7.00"

/* where --arsbilling:write_off_date >= l_starting_date and
      arsbilling:write_off_date <= l_ending_date and
      arsbilling:billed_date    => l_starting_date and
      arsbilling:billed_date    <= l_ending_date and  
      ( arsbilling:write_Off = 1 or
        arsbilling:write_off_amount <> 0 )
*/
where arsbilling:write_off_date => l_starting_date and 
      arsbilling:write_off_date <= l_ending_date and 
--      arsbilling:return_check_ctr = 0 and
      arsbilling:write_off_amount <> 0
list
/nobanner
/domain="arsbilling"
/title="Write-offs Processed"

arsbilling:policy_no 
arsbilling:trans_eff 
arsbilling:trans_exp
arsbilling:payment_plan 
arsbilling:billing_ctr 
arsbilling:bill_plan   
arsbilling:status  
arsbilling:write_off_date
arsbilling:due_date
arsbilling:write_off_amount/total 

sorted by arsbilling:status/total/newpage 
          arsbilling:policy_no 

include "reporttop.inc"
