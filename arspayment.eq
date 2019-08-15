/* arspayment

   scips.com

   july 24, 2001

   prints payments received by payment trans date
*/
include "startend.inc"

where arspayment:trans_date => l_starting_date and
      arspayment:trans_date <= l_ending_date 

list
/nobanner
/domain="arspayment"
/pagewidth=160
/title="Payments Received Report"
/nodetail 

company_id 
policy_no/width=15 
trans_date/heading="Premium-Trans Date"
arspayment:payment_trans_date/heading="Payment-Trans Date"
trans_code/heading="Premium-Trans Code"
arspayment:payment_trans_code/heading="Payment-Trans Code"
line_of_business                                          
agent_no 
comm_rate/nototal 
check_reference 
check_number 
amount/total        

--sorted by arspayment:company_id/newpage/total
--          arspayment:payment_trans_date/total/newlines
--          arspayment:policy_no/total/newlines 
--          arspayment:check_number/newlines/total  

top of page
"Report Number: arspayment"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")) + " - " + trun(str(l_ending_date
,"MM/DD/YYYY")))/center/newline
