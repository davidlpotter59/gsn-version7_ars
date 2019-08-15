/* arspr902

   September 3, 2004

   SCIPS.com, Inc.

   report to print PLIGA records within an effective date range
*/

Description List PLIGA records within the selected effective date range ;

include "startend.inc"

define string l_prog_number = "ARSPR902 - Version 4.10" 

where arsbilling:trans_code one of 19, 22,23,29 and 
     (arsbilling:trans_eff => l_starting_date and 
      arsbilling:trans_eff <= l_ending_date)

list
/nobanner
/domain="arsbilling"
/title="PLIGA Listing By Effective Date"

arsbilling:policy_no 
arsbilling:trans_code 
arsbilling:trans_date
arsbilling:trans_eff 
arsbilling:due_date 
arsbilling:installment_amount /total 
arsbilling:total_amount_paid /total 
arsbilling:write_off_amount /total 
(arsbilling:installment_amount - (arsbilling:total_amount_paid - 
arsbilling:write_Off_amount - arsbilling:disbursement_amount))/heading="Net-Amount"/total 

sorted by arsbilling:policy_no

include "reporttop.inc"
