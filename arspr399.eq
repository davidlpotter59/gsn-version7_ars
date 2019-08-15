/* arspr399.eq

   march 16, 2004

   scips.com, inc.

   
*/                                           
description 
Report to show policy level information as it appears on the direct bill commission statements. Enter the last day of the month to see that month's commission;

define unsigned ascii number l_comm_paid = arsmaster:premium * (arsmaster:comm_rate divide 100) 

define file sfpcurrenta = access sfpcurrent, set sfpcurrent:policy_no= arsmaster:policy_no, approximate                                                              

define file sfpnamea = access sfpname, set sfpname:policy_no= sfpcurrent:policy_no , 
                                           sfpname:pol_year= sfpcurrent:pol_year , 
                                           sfpname:end_sequence = sfpcurrent:end_sequence , approximate 

define string str_policy_no = sfsline:alpha + " " + str(arsmaster:policy_no ) 

define string l_desc = switch(str(arsmaster:trans_code ) ) 
                       case "12" : "Endorsement"  
                       case "13" : "Endorsement" 
                       case "10" : "New Policy" 
                       case "14" : "Renewal" 
                       case "11" : "Cancellation" 
                  
define string i_name = sfpnamea:name[1] 
include "renaeq1.inc"                                                                                                                 

include "end.inc" 

where arsmaster:commissions_applied = l_ending_date 

list
/nobanner
/domain="arsmaster"   
/duplicates      
/noheadings     
/dif
                                                    
arsmaster:trans_eff 
i_rev_name 
arsmaster:agent_no 
str_policy_no
l_desc
arsmaster:premium 
arsmaster:comm_rate 
round(l_comm_paid,2 )  

sorted by arsmaster:agent_no arsmaster:policy_no 

 
