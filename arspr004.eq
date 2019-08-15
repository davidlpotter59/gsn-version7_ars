/*  arspr004

    february 15, 2001

    scips.com

    direct bill printed status report
*/

define unsigned ascii number l_policy_no[9] = parameter/prompt="Enter Policy Number: "

where arsmaster:policy_no = l_policy_no 

list
/nobanner
/domain="arsmaster"
/title="Printed Status Report"  
/noreporttotals 

arsmaster:trans_date/mask="MM/DD/YYYY"
arsmaster:trans_eff/mask="MM/DD/YYYY"
arsmaster:trans_exp/mask="MM/DD/YYYY"
arsmaster:trans_code/mask="ZZ"
arsmaster:line_of_business/mask="ZZ"
arsmaster:premium/mask="ZZ,ZZZ,ZZZ.99-"
arsmaster:company_id 
 
followed by

""/newline
"- - - - - Billing Information - - - - -"/column=50/newline=2
arsbilling:billed_date/mask="MM/DD/YYYY"
arsbilling:due_date/mask="MM/DD/YYYY" 
switch(arsbilling:status)
case "O" : "Open     "
case "B" : "Billed   "
case "P" : "Paid     "
default  : "Open     "
arsbilling:trans_code 
arsbilling:installment_amount/mask="ZZ,ZZZ,ZZZ.99-"
arsbilling:total_amount_paid/mask="ZZ,ZZZ,ZZZ.99-"
arsbilling:installment_charge/mask="ZZ,ZZZ,ZZZ.99-"

""/newline
"- - - - - Payment Information - - - - - "/column=50/newlines=2
arspayment:payment_trans_date/mask="MM/DD/YYYY"
arspayment:payment_trans_code
arspayment:amount/mask="ZZ,ZZZ,ZZZ.99-"
arspayment:check_reference 
arspayment:check_number 
arspayment:account_number 
sorted by arsmaster:policy_no 

top of page

""/newline
arsmaster:policy_no/column=1/noheading
sfpname:name[1]/noheading/column=12
sfsagent:agent_no/column=80/noheading
sfsagent:name[1]/noheading/column=96/newline
sfpname:name[2]/noheading/column=12
sfsagent:name[2]/noheading/column=96/newline
sfpname:address[1]/noheading/column=12
sfsagent:address[1]/noheading/column=96/newline
sfpname:city/noheading/column=12
sfpname:zipcode/noheading/column=35
sfsagent:city/noheading/column=96
sfsagent:zipcode/noheading/newline
sfsagent:telephone[1]/noheading/column=96/newline=2  

sfpname:eff_date/heading="Effective Date"/column=1
sfpname:exp_date/heading="Expiration Date"/column=27
sfpname:line_of_business/heading="Line"/column=56
sfsline:description/noheading/newline
sfpname:status/heading="Status"/column=1
--switch(sfpname:status)
--    case 0 : "Active"
--    default : "Cancelled"/column=12
sfpname:bill_plan/heading="Bill Plan"/column=28
arsmaster:payment_plan/heading="Payment Plan"/column=50
arspayplan:description/noheading/column=70/newlines=2

"- - - - - Master File - - - - -"/column=50/newline=2
