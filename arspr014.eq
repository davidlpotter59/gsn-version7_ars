/*  arspr014

    March 26, 2012

    scips.com

    report for NSF for given dates

*/

Description 
To show NSF checks for given returned dates;

include "startend.inc"
 define file arspaymenta = access arspayment, set arspayment:check_reference= arschksu:check_reference, 
using second index

define unsigned ascii number l_comm_rate = (arspaymenta:comm_rate divide 100) 

define unsigned ascii number l_comm_amount = l_comm_rate * arspaymenta:amount 
                    
where ((arschksu:return_date => l_starting_date and 
       arschksu:return_date <= l_ending_date) and 
       arschksu:disposition = "NSF") 

list
/nobanner
/domain="arschksu"
/duplicates 


arschksu:policy_no 
arspaymenta:agent_no
arschksu:check_reference 
trans_date 
enter_date 
return_date
arschksu:disposition 
arspaymenta:amount
arspaymenta:trans_code 
l_comm_rate * 100/mask="99.99"/heading="Comm_Rate"
l_comm_amount/mask="$$,$$$.99"

sorted by agent_no, policy_no
