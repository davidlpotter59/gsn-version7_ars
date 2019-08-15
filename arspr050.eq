/*  arspr050

    scips.com

    march 19, 2001

    report to print the agents commission for current period and
    year to date.  this includes advanced commissions for both
    periods.

*/

include "startend.inc"
   
define string l_report_title[50]="Agent Commissions - Payments Received"   
define string l_report_number[15]="ARSPR050"

define signed ascii number l_comm = if arspayment:trans_code <> 18 and arspayment:trans_code <> 19 then
(arspayment:amount * (arspayment:comm_rate * 0.01)) * 1.00 -- * 1.00 for rounding
else
0.00

define date l_start_date =dateadd(01.01.0000,0,year(l_starting_date)) 

define date l_end_date = dateadd(l_ending_date,-1)

define signed ascii number l_current_comm = if arspayment:payment_trans_date => l_starting_date and
arspayment:payment_trans_date <= l_ending_date and
arspayment:trans_eff <= l_ending_date then
l_comm 
else
0.00

define signed ascii number l_current_advanced = if arspayment:Payment_trans_date => l_starting_date and
arspayment:payment_trans_date <= l_ending_date and
arspayment:trans_eff > l_ending_date then
l_comm 
else
0.00
      
define signed ascii number l_prior_comm = if arspayment:payment_trans_date => l_start_date and
arspayment:payment_trans_date <= l_end_date and
arspayment:trans_eff <= l_end_date then
l_comm 
else
0.00                               

define signed ascii number l_prior_advanced = if arspayment:payment_trans_date => l_start_date and
arspayment:payment_trans_date <= l_end_date and
arspayment:trans_eff > l_end_date then
l_comm
else
0.00

define signed ascii number l_ytd_comm = l_prior_comm + l_current_comm + l_current_advanced + l_prior_advanced 
define signed ascii number l_net_ytd_comm = l_prior_comm + l_current_comm + l_prior_advanced 

list      
/nobanner
/domain="arspayment"
/pagewidth=255         
/nopageheadings 

arspayment:policy_no
sfpname:name[1]/heading="Insured's-Name"/width=10
sfsagent:name/heading="Agent"/width=20
arspayment:trans_date
arspayment:trans_code/heading="Transaction-Code (1)"
arspayment:trans_eff
arspayment:payment_trans_date 
arspayment:comm_rate/nototal 
arspayment:amount/total
l_current_comm/heading="Current-Period-Commission"  
l_current_advanced/heading="Current-Advanced-Commission"                   
l_prior_comm/heading="Prior-Period-Commission" 
l_prior_advanced/heading="Prior-Advanced-Commission"
l_ytd_comm/heading="Year to Date-Commission (2)" 
l_net_ytd_comm /heading="Year to Date-Net Commission (3)"
                                    
sorted by arspayment:company_id   
               
top of page
include "report.pro" 

end of report
""/newlines=2
"(1) Transaction Codes 18 and 19 are not subject to commission, shown for balancing purposes only"/centre/newline 
"(2) All Commissions Included, including advanced"/centre   /newline
"(3) All Commissions Included, except for Current Period Advanced"/centre/newline 

         
