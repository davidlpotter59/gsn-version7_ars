/* arspr302

   scips.com

   november 7, 2001

   program to print the agens written premium that will be used to calculate the commissions - shows policy level detail by agent
*/

description 
Agents Commission Statements Balancing Report - No Installment Charges or Sur Charges will be printed on this report - Policy level detail - No headings in Spreadsheet ;

include "startend.inc"
                                                           
define signed ascii number l_commission = arsmaster:premium * (arsmaster:comm_rate * 0.01)

define signed ascii number l_net = arsmaster:premium - l_commission 

include "arscollect.inc"   
and trans_code < 18
--and trans_code not one of 18, 28,19,29,22,23 
and arsmaster:bill_plan = "DB"

list
/nobanner
/domain="arsmaster"
/noreporttotals
/nodefaults 
/nopageheadings 

arsmaster:agent_no 
arsmaster:policy_no
arsmaster:trans_date 
arsmaster:trans_eff 
arsmaster:premium
l_commission/noheading
l_net/noheading
arschksu:check_no 
arschksu:check_amount 
                
sorted by arsmaster:agent_no/newlines 

end of report 
""/newline=2
total[arsmaster:premium]/al=premium/heading="Totals"   
total[l_commission]/align=l_commission/noheading    
total[l_net]/align=l_net/noheading 
