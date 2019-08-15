 /*  arspr015

    March 26, 2012

    scips.com

    report for Misapplied checks for given dates

*/

Description 
To show misapplied checks for posted dates;

include "startend.inc"
 define file arspaymenta = access arspayment, set arspayment:check_reference= arschksu:check_reference, 
using second index

define unsigned ascii number l_comm_rate = (arspaymenta:comm_rate divide 100) 

define unsigned ascii number l_comm_amount = l_comm_rate * arspaymenta:amount 
                    
where ((arschksu:posted_date  => l_starting_date and 
       arschksu:posted_date <= l_ending_date) and 
       arschksu:disposition = "ERROR")

list
/nobanner
/domain="arspayment"
/duplicates 


arschksu:policy_no 
arspaymenta:agent_no
arspaymenta:check_reference 
arschksu:trans_date 
enter_date 
posted_date
arschksu:disposition 
arspaymenta:amount
arschksu:reapplied_from_policy_no  
reapllied_to_policy_no 
return_reason
l_comm_rate * 100/mask="99.99"/heading="Comm_Rate"
l_comm_amount/mask="$$,$$$.99"
