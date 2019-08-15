/* include "startend.inc"
where ((arsmaster:trans_date >= l_starting_date and
        arsmaster:trans_date <= l_ending_date and 
        arsmaster:trans_eff <= l_ending_date) or
       (arsmaster:trans_date < l_starting_date and
        arsmaster:trans_eff >= l_starting_date and 
         arsmaster:trans_eff <= l_ending_date)) and arschksu:trans_date <= l_ending_date 
*/
where arsmaster:commissions_applied <> 00.00.0000
list
/nobanner
/domain="arsmaster"  
/pagewidth=132

arsmaster:policy_no  
arsmaster:trans_date 
arsmaster:trans_eff 
arsmaster:premium  
arschksu:check_reference 
arschksu:check_no 
arschksu:check_amount      
arschksu:trans_date 
arsmaster:commissions_applied 

sorted by arsmaster:agent_no/newpage 
arsmaster:policy_no     

top of page

""/newline
arsmaster:agent_no/noheading 
sfsagent:name[1]/noheading/newline=2
