/* arspr650

   scips.com, inc.

   february 1, 2005

   print commissions statements control report - by cash received
*/

include "startend.inc"

define string l_prog_number="ARSPR650 - Version 4.10"

define file sfsagenta = access sfsagent, set sfsagent:company_id = arspayment:company_id,
                                            sfsagent:agent_no   = arspayment:agent_no 

define signed ascii number l_comm_paid[9] =
arspayment:amount * (arspayment:comm_rate * 0.01)

where ((arspayment:trans_date >= l_starting_date and 
        arspayment:trans_date <= l_ending_date and 
        arspayment:trans_eff  <= l_ending_date) or
       (arspayment:trans_date <  l_starting_date and 
        arspayment:trans_eff  >= l_starting_date and 
        arspayment:trans_eff  <= l_ending_date)) and 
        arspayment:comm_rate <> 0.00

list
/nobanner 
/domain="arspayment"
/title="Agents Paid Commissions Control Report"
/pagewidth=200

arspayment:policy_no 
arspayment:trans_date 
arspayment:trans_eff 
arspayment:trans_exp 
arspayment:trans_code 
arspayment:line_of_business 
arspayment:comm_rate/nototal  
arspayment:amount/heading="Cash-Porcessed"/total 
l_comm_paid/total /heading="Commissions"
commissions_applied/heading="Commissions-Applied" 
commissions_run_date/heading="Commissions-Run Date"

sorted by arspayment:agent_no/newlines/total/heading="Agent @" 
          policy_no

top of arspayment:agent_no 

""/newline 
arspayment:agent_no/noheading/column=1

box/noheadings 
sfsagenta:name[1]/column=10/newline 
if sfsagenta:name[2] <> "" then 
{
    sfsagenta:name[2]/column=10/newline 
}

if sfsagenta:name[3] <> "" then 
{
    sfsagenta:name[3]/column=10/newline 
}
end box  

""/newline 

include "reporttop.inc"
