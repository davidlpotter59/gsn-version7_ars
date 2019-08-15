/* arspr300

   scips.com

   november 7, 2001

   program to print the agens written premium that will be used to calculate the commissions
*/

description 
Agents Commission Statements Balancing Report - No Installment Charges or Sur Charges will be printed on this report ;

include "startend.inc"
                                                           
define signed ascii number l_commission = arsmaster:premium * (arsmaster:comm_rate * 0.01)

define signed ascii number l_net = arsmaster:premium - l_commission 

include "arscollect.inc"   
and trans_code < 18
and trans_code not one of 18, 28,19,29,22,23 
and arsmaster:bill_plan = "DB"

list
/nobanner
/domain="arsmaster"
/title="Agents Commission Statement Balance Report"
/nodetail 
/noreporttotals

arsmaster:agent_no 
sfsagent:name[1]/noheading 
--arsmaster:trans_eff
--arsmaster:trans_code
arsmaster:premium
l_commission/heading="Commissions"
l_net/heading="Net-Premiums"
                
sorted by agent_no

top of page
"Program No.: arspr300"/newline
l_starting_date/mask="MM/DD/YYYY"/heading="Date Range"/column=30
" - "
l_ending_date/mask="MM/DD/YYYY" /newline=2/noheading 

end of agent_no 
arsmaster:agent_no /noheading  
sfsagent:name[1]/noheading 
--arsmaster:trans_date/noheading 
--arsmaster:trans_code/noheading 
total[arsmaster:premium,arsmaster:agent_no] /ali=premium/noheading   
total[l_commission,arsmaster:agent_no]/align=l_commission/noheading 
total[l_net,arsmaster:agent_no]/align=l_net/noheading 

end of report 
""/newline 
total[arsmaster:premium]/al=premium/heading="Totals"   
total[l_commission]/align=l_commission/noheading    
total[l_net]/align=l_net/noheading 
