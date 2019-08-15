/* arspr022.eq

   September 6, 2002

   scips.com, inc.

   check logging audit report - outstanding quotes with cash
*/                                                          

description 
Enter a Starting and Ending Date - prints only quotes with Cash applied - Outputs in a Spreadsheet;

define file arsbilling_a = access arsbilling, 
                         set arsbilling:company_id = arschksu:company_id,
                             arsbilling:policy_no  = arschksu:policy_no, generic 
           
include "startend.inc"

define string l_trans_date_str = "Checks Entered On " + str(
arschksu:trans_date)

where arschksu:trans_date >= l_starting_date   and
      arschksu:trans_date <= l_ending_date and 
      policy_no = 0
list
/nobanner
/domain="arschksu"
/pagewidth=255
/nototals 
/duplicates 
/title="Outstanding Quotes with Cash Received"
/wks 
                       
arschksu:check_reference/heading="Check-Reference"
arschksu:quote_no       /heading="Quote-Number"
arschksu:payor_type     /heading="P-T"
arschksu:trans_date     /heading="Trans-Date"
arschksu:trans_eff      /heading="Eff-Date"
arschksu:check_amount   /heading="Check-Amount"/total 
arschksu:balance        /heading="Check-Balance"/total
arschksu:check_no       /heading="Check-No"
arschksu:bank_no        /heading="Bank-No"    
arschksu:disposition    /heading="Check-Status"
sfqname:eff_date        /heading="Quote-Eff Date"/duplicates 
arschksu:trans_eff      /heading="Trans-Eff Date"
arschksu:deposit_date   /heading="Deposit-Date"
--arschksu:expansion 
sorted by --arschksu:user/newpage/total
         -- arschksu:application/newlines=2/total
          arschksu:check_reference

top of page
arschksu:user/heading="Cash Processed by"/newline
                                                 
/* top of arschksu:application
switch(arschksu:application)
case 0 : "Policy Cash Processed "
case 1 : "Applications Cash Processed "
default : "Unknown Cash Processed "/newlines
*/

end of report                                                    
""/newline=2
"Dispositions:  CLEAR - Check is cleared for Deposit"/newline
"               OPEN  - Check is Open, not yet Deposited"/newline
