/*   arspr054

     december 17, 2001

     scips.com

     a/r report to list write-offs (waive amounts) processed within a 
     user defined date range
*/

description Write-offs Processed within a Starting and Ending Date Range ;

include "startend.inc"

where ((arsbilling:write_off_date => l_starting_date and
        arsbilling:write_off_date <= l_ending_date and
        arsbilling:write_Off = 1) or
       (arsbilling:write_off_date => l_starting_date and
        arsbilling:write_off_date <= l_ending_date and
        arsbilling:write_off_amount <> 0)) 

-- trans date does not get changed when it is writtten off
/*
where arsbilling:trans_date => l_starting_date and 
      arsbilling:trans_date <= l_ending_date and 
      arsbilling:return_check_ctr = 0 and
      arsbilling:write_off_amount <> 0
*/

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

top of page
"Report Number: arspr054"/newline 
"For The Period"/center/newline 
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,
"MM/DD/YYYY"))/newline/centre
