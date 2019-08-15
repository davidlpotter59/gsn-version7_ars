/*  arspr903.eq

    SCIPS.com, Inc.

    March 19, 2003

    Report to list an eagents expected commission statement - report will
    prompt for a date range was well as the agent number "  */

description List policies by Agent for the Selected Date range - formatted simular to the D/B commission statements ;

include "startend.inc"
                   
define unsigned ascii number l_agent_no[4]=parameter/prompt="Enter Agent Number :"

where ((arsmaster:trans_date >= l_starting_date and 
        arsmaster:trans_date <= l_ending_date and 
        arsmaster:trans_eff  <= l_ending_date) or
       (arsmaster:trans_date < l_starting_date and
        arsmaster:trans_eff >= l_starting_date and 
        arsmaster:trans_eff <= l_ending_date))
and arsmaster:agent_no = l_agent_no 
and trans_code one of 10,11,12,13,14,15,16,17

list
/nobanner
/domain="arsmaster"
/TITLE="Agent Commission Listing"

arsmaster:trans_eff  
sfpname:name[1,1,20]    
arsmaster:policy_no 
arscode:description[1,10]/duplicates  
arsmaster:premium 
arsmaster:comm_rate  
((arsmaster:premium * arsmaster:comm_rate) * 0.01)/heading="Commission"

sorted by policy_no    
