/* arspr020.eq

   July 31, 2001

   scips.com

   checks to be processed report - starting and ending check reference

08/28/2002 DLP  added deposit date column as last column
08/28/2002 DLP  removed status description
08/28/2002 DLP  created a new status based on the value of deposit_date
*/                                  
define unsigned ascii number l_starting_reference[7]=parameter 
define unsigned ascii number l_ending_reference[7]=parameter 

define file arsbilling_a = access arsbilling, 
set arsbilling:company_id = arschksu:company_id,
    arsbilling:policy_no  = arschksu:policy_no, generic 

string l_disp[20]=if arschksu:deposit_date <> 00.00.0000 then
"Deposited"
else
"OPEN"

define string l_trans_date_str = "Checks Entered On " + str(
arschksu:trans_date)

where arschksu:check_reference => l_starting_reference and
      arschksu:check_reference <= l_ending_reference --and
--      arschksu:disposition = "OPEN"

list
/nobanner
/domain="arschksu"
/pagewidth=250
--/nodetail                   
/nototals 
--/noreporttotals 

arschksu:policy_no /column=2/heading="Policy-Number"
if arschksu:policy_no = 0 or
   sfpname:name[1] = "" then
   "APPLICATION"/column=2/noheading

arschksu:payor_type/column=13 /heading="T-P"
arschksu:trans_date/column=15 /heading="Trans-Date"
arschksu:check_amount /total/column=25/heading="Check-Amount"
arschksu:balance/total/column=55/heading="Check-Balance"
arschksu:check_no /column=80/heading="Check-No"
arschksu:bank_no/column=100/heading="Bank-No"    
arschksu:check_reference /column=130/heading="Check-Reference"
l_disp /heading="Check-Status"
arschksu:deposit_date /heading="Deposit-Date"
--arsdisp:description/noheading 

sorted by l_disp /total/newlines=2 
          arschksu:policy_no

top of page
"Checks to be Processed Report - by Reference Number"/center/newlines=2
L_starting_reference/noheading/column=113/mask="ZZZZZZZ"
" - "
l_ending_reference/noheading/mask="ZZZZZZZ"/newline
