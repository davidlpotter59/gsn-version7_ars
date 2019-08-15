/*  arspr005

    September 4, 2000

    scips.com, Inc.

    a/r detailed status report by line of business
*/

description = A/R Detailed Printed Status Report ;

/* define unsigned ascii number l_policy_no[9] = parameter/prompt=
"<NL>Enter Policy Number: "                 */                     

define signed ascii number l_total_billed = if arsbilling:status <> "O" then
arsbilling:installment_amount 
else
0.00   

define signed ascii number l_total_applied = arsbilling:total_amount_paid
define string l_past_due = if todaysdate - arsbilling:due_date > 30 and 
      arsbilling:total_amount_paid <> arsbilling:installment_amount then
"*" 
else ""

define string l_payor_type=switch(arschksu:payor_type)
case "I" : "Insured"
default  : "Other"

where arsmaster:policy_no = 20071008

list        
/nobanner
/nodefaults 
/pagewidth=132
/domain="arsmaster"

box/noblanklines
l_past_due/column=1/width=1/noheading 
arsbilling:trans_date/heading="Transaction-Date"
arsbilling:trans_code/heading="Transaction-Code"
arsbilling:trans_eff/heading="Transaction-Effective"
arsbilling:trans_exp/heading="Transaction-Expiration"
arsbilling:billed_date/heading="Billed-Date"
arsbilling:comm_rate/heading="Comm-Rate"
arsbilling:due_date/heading="Due-Date"
arsbilling:status/heading="Status"
switch(arsbilling:status)
case "B" : "Billed"
case "P" : "Paid"
case "O" : "Open"
default  : "    "
l_total_billed/heading="Amount-Due"
--arsbilling:installment_amount/heading="Amount-Due" 
arsbilling:total_amount_paid/heading="Amount-Applied"
end box

followed by
box
""/newline
"Payment History"/center/newline=2
box/noblanklines
"Paid Date"/column=1
"Check Ref"/column=12
"Trans Code"/column=23
"Amount Paid"/column=38
"How Paid"/column=51    
"Check No."/column=63/newline
arspayment:trans_date/noheading
arspayment:check_reference/noheading/column=9
arspayment:payment_trans_code/noheading/column=26
arspayment:amount/noheading/column=36
l_payor_type/noheading/column=51
arspayment:check_number/column=63
end box         
end box 

sorted by arsmaster:policy_no 

top of page
"Accounts Receivable Policy Status Report"/center/newline=2
"D E T A I L E D"/center/newline=2
arsmaster:policy_no/heading="Policy No."/column=1            
" - "/column=22
switch(sfpname:status)
case "0" : "Active"
default : "Not Active - See Underwriting"/noheading/column=25
arsmaster:agent_no/heading="Agent No."/column=65/newline

sfpname:name[1]/noheading/column=11                           
sfsagent:name[1]/noheading/column=75/newline

sfpname:name[1]/noheading/column=11
sfsagent:name[1]/noheading/column=75/newline

polname:street/noheading/column=11
agent:street/noheading/column=75/newline

polname:city_state/noheading/column=11
polname:zip_code/noheading
agent:city_state/noheading/column=75
agent:zip_code/noheading/newline     
agent:telephone/noheading/column=75/newline 

polname:eff_date/mask="MM/DD/YYYY"/heading="Policy Effective"/column=1
" - "/column=29
polname:exp_date/mask="MM/DD/YYYY"/noheading/column=32

polname:line_of_business/heading="Line of Business"/column=75
tableli:description/noheading/newline

arsmaster:pay_plan/heading="Payment Plan"/column=1
arspayplan:description/noheading
arspayplan:number_of_payments/heading="Number of Payments"/column=65/newline 

end of report                                            
Box/noblanklines/line=50                          
"Totals"/noheading/column=20
total[l_total_billed]/align=l_total_billed 
total[l_total_applied]/align=arsbilling:total_amount_paid 
""/newlines=2
"* = Transaction is 30 days or greater past due"
end box
