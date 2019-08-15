/* arspr035.eq

   November 7, 2002

   scips.com, inc.

   cash processed - BOOKED
*/                                           
description 
Cash processed by Transaction Date Effective Less than or equal to the last date entered - No advanced;
           
include "startend.inc"
define string l_prog_number = "ARSPR035 - Version 7.00"

define string l_trans_date_str = "Checks Entered On " + str(
arschksu:trans_date)

define string l_payor_type=switch(arschksu:payor_type)
case "A"       : "Checks Received From Agents        "
case "B"       : "Checks Received From Billing Names "
case "C"       : "Credit Cards Transactions Processed"
case "I"       : "Checks Received from Insured's     "
case "M"       : "Checks Received from Mortgagee's   "
case "O"       : "Checks Received from Other         "
case "S"       : "Checks SCANNED                     "
default        : "Unknown Type - Notify SCIPS        "

define signed ascii number l_prior_period_cash[9]= if
(arschksu:trans_date < l_starting_date and 
 arschksu:trans_eff >= L_starting_date and 
 arschksu:trans_eff <= l_ending_date) then
  arschksu:check_amount 
else
  0.00

define signed ascii number l_current_period_cash[9]= if
(arschksu:trans_eff <  l_ending_date and 
 arschksu:trans_date >= L_starting_date and 
 arschksu:trans_date <= l_ending_date) then
  arschksu:check_amount 
else
  0.00

where ((arschksu:trans_date >= l_starting_date and
        arschksu:trans_date <= l_ending_date and
        arschksu:trans_eff  <= l_ending_date) or
       (arschksu:trans_eff  <  l_starting_date and 
        arschksu:trans_date >= l_starting_date and 
        arschksu:trans_date <= l_ending_date)) and 
        arschksu:policy_no <> 0  and -- no applications
        arschksu:internal_check = 0

list
/nobanner
/domain="arschksu"
/pagewidth=132
/nototals 
/duplicates 
/title="Cash Report By Effective Month"
--/wks
                       
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

sorted by month(arschksu:trans_eff)/total/newpage 
          arschksu:trans_eff
          arschksu:policy_no 

include "reporttop.inc"
                                                
end of report                                                    
""/newline=2
"Dispositions:  CLEAR - Check is cleared for Deposit"/newline
"               OPEN  - Check is Open, not yet Deposited"/newline
