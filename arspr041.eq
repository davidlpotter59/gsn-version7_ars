/*   arspr041

     SCIPS.com, Inc

     October 4, 2007

     Lists payments received by check reference
*/

description 
List payments received by Check Reference Number Sorting;

include "startend.inc"        
define string l_prog_number = "ARSPR041 - Version 7.20"

define string l_type = arscode:description 

where arspayment:payment_trans_date >= l_starting_date and
      arspayment:payment_trans_date <= l_ending_date  and
      arspayment:amount <> 0

list
/nobanner
/domain="arspayment" 
/title="Payments Received by Check Reference"
/pagewidth=150
/pagelength=50
/nototals 

arspayment:policy_no/column=1 
arspayment:trans_date /column=15
arspayment:trans_eff /column=30
arspayment:trans_code /column=45/heading="Trans-Code"
arspayment:amount/total  /column=50 
arspayment:check_number/width=10 /column=70
arspayment:check_reference /column=85
arspayment:payment_trans_date/column=105   
arschksu:balance/total /column=120
arschksu:posted_date/column=135

sorted by arschksu:check_reference                                

include "reporttop.inc"
