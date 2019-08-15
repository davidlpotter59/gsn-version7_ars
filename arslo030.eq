/* arslo030.eq

   march 17, 2002

   scips.com, inc.

   check logging cash report by type and user
*/                                           
description 
Print the Cash processed by Type (Policy or Application) and by User - Spreasheet Output Version ;

define file arsbilling_a = access arsbilling, 
                         set arsbilling:company_id = arschksu:company_id,
                             arsbilling:policy_no  = arschksu:policy_no, generic 
           
include "startend.inc"

define string l_trans_date_str = "Checks Entered On " + str(
arschksu:trans_date)

define string l_payor_type=switch(arschksu:payor_type)
case "A"       : "Checks Received From Agents        "
case "B"       : "Checks Received From Billing Names "
case "C"       : "Credit Cards Transactions Processed"
case "I"       : "Checks Received from Insured's     "
case "M"       : "Checks Received from Mortgagee's   "
case "O"       : "Checks Received from Other         "
default        : "Unknown Type - Notify SCIPS        "

where arschksu:trans_date >= l_starting_date   and
      arschksu:trans_date <= l_ending_date  and
      arschksu:internal_check = 0

list
/nobanner
/domain="arschksu"
/pagewidth=132
/nototals 
/duplicates 
/wks
--/title="Check Entry Cash Report By User and Type"
                       
arschksu:user           /heading="Userame"
arschksu:check_reference/heading="Check-Reference"
arschksu:policy_no      /heading="Policy-Number"
arschksu:payor_type     /heading="P-T"
arschksu:trans_date     /heading="Trans-Date"
arschksu:trans_eff      /heading="Eff-Date"
arschksu:check_amount   /heading="Check-Amount"/total 
arschksu:balance        /heading="Check-Balance"/total
arschksu:check_no       /heading="Check-No"
arschksu:bank_no        /heading="Bank-No"    
arschksu:disposition    /heading="Check-Status"

sorted by arschksu:user/newpage/total
          arschksu:application/newlines=2/total/heading="Total for Type"
          arschksu:check_reference

top of report 
"Period Selected"/center/newline
trun(str(l_starting_date,"MM/DD/YYYY")+ " - " +str(l_ending_date,"MM/DD/YYYY")
)/center/newline
arschksu:user/heading="Cash Processed by"/newline=2/column=1
                                                 
top of arschksu:application
switch(arschksu:application)
case 0 : "Type: Policy Cash Processed "
case 1 : "Type: Applications Cash Processed "
default : "Type: Unknown Cash Processed "/newlines

end of report                                                    
""/newline=2
"Dispositions:  CLEAR - Check is cleared for Deposit"/newline
"               OPEN  - Check is Open, not yet Deposited"/newline
