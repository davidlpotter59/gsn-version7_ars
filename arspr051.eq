/*  arspr051

    scips.com

    march 19, 2001

    report to print the agents commission for current period and
    year to date.  this includes advanced commissions for both
    periods.

    this report is like the arspr050 except this uses premium
    processed and not payments received.

*/

include "startend.inc"
   
define string l_report_title[50]="Agent Commissions - Premiums Processed"   
define string l_report_number[15]="ARSPR051" 

define string l_policy_no = trun(trun(sfsline:alpha)+str(prsmaster:policy_no))

/* do not include transaction codes 18 (installment fees) and 19 (Premium fees) in the
   commission calculation.  Agents do not get paid on these items) */

define signed ascii number l_comm = if prsmaster:trans_code <> 18 and prsmaster:trans_code <> 19 then
(prsmaster:premium * (prsmaster:comm_rate * 0.01)) * 1.00 -- * 1.00 for rounding
else
0.00

define date l_start_date =dateadd(01.01.0000,0,year(l_starting_date)) 

define date l_end_date = dateadd(l_ending_date,-1)            

define signed ascii number l_current_comm = if prsmaster:trans_eff <= l_ending_date and
prsmaster:trans_date => l_starting_date and
prsmaster:trans_date <= l_ending_date then 
l_comm 
else
if prsmaster:trans_eff <= l_ending_date and
prsmaster:trans_date < l_starting_date then
l_comm 
else
0.00

define signed ascii number l_current_advanced = if prsmaster:trans_eff > l_ending_date and
prsmaster:trans_date => l_starting_date and
prsmaster:trans_date <= l_ending_date then
l_comm 
else
0.00
      
define signed ascii number l_prior_comm = if prsmaster:trans_date => l_start_date and
prsmaster:trans_date <= l_end_date and
prsmaster:trans_eff <= l_end_date then
l_comm 
else
0.00                               

define signed ascii number l_prior_advanced = if prsmaster:trans_date => l_start_date and
prsmaster:trans_date <= l_end_date and
prsmaster:trans_eff > l_end_date then
l_comm
else
0.00

define signed ascii number l_ytd_comm = l_prior_comm + l_current_comm + l_current_advanced + l_prior_advanced 
define signed ascii number l_net_ytd_comm = l_prior_comm + l_current_comm + l_prior_advanced 
 
where prsmaster:trans_code < 30 -- direct business only
list      
/nobanner
/domain="prsmaster"
/pagewidth=255         
/nopageheadings 

prsmaster:policy_no
--l_policy_no /heading="Policy-Number"/duplicates 
sfpname:name[1]/heading="Insured's-Name"/width=10/duplicates   
sfsagent:name[1]/heading="Agent"/width=20/duplicates 
prsmaster:trans_date
prsmaster:trans_code /nototal/heading="Transaction-Code (1)" 
prsmaster:trans_eff
prsmaster:comm_rate/nototal 
prsmaster:premium/total
l_current_comm/heading="Current-Period-Commission"  
l_current_advanced/heading="Current-Advanced-Commission"                   
l_prior_comm/heading="Prior-Period-Commission" 
l_prior_advanced/heading="Prior-Advanced-Commission"
l_ytd_comm/heading="Year to Date-Commission (2)" 
l_net_ytd_comm /heading="Year to Date-Net Commission (3)"   
                                    
sorted by prsmaster:company_id   
                
top of page
include "report.pro"                
"For the Period:"/column=95
l_starting_date/noheading/column=120/mask="MM/DD/YYYY"
" - "/column=132
l_ending_date/noheading/column=135/newline=2/mask="MM/DD/YYYY"

end of report
""/newlines=2
"(1) Transaction Codes 18 and 19 are not subject to commission, shown for balancing purposes only"/centre/newline
"(2) All Commissions Included, including advanced"/centre   /newline
"(3) All Commissions Included, except for Current Period Advanced"/centre/newline 

         
