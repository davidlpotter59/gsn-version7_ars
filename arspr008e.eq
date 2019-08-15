/*  arspr008e

    scips.com

    april 28, 2003

    print direct bill open items that expire with balances within
    a selected date range
*/

description A/R Open Item Balances as of selected Expirating Date;

define wdate l_starting_date = parameter/prompt="Enter Starting Date"
define wdate l_ending_date   = parameter/prompt="Enter Ending Date"

where arsbilling:net_amount_due > 0 and
      arsbilling:status one of "O","B" and 
     (arsbilling:trans_exp >= l_starting_date and 
      arsbilling:trans_exp <= l_ending_date)

list
/nobanner
/domain="arsbilling"
/pagewidth=75
/title="arsbilling"

arsbilling:policy_no
arsbilling:trans_exp 
arsbilling:trans_code 
arsbilling:status 
arsbilling:installment_amount /total 

sorted by arsbilling:policy_no/total

top of page         
"Run Date"/column=35/newline
str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY")
/noheading/column=27/newline=2

top of policy_no 
if arscancel:policy_no <> 0 then 
"Policy is Cancelled/Notice Sent"/newline 
