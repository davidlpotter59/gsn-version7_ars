/* arspr701

   February 7, 2005

   scips.com, inc.

   print a/r records with status of "P" and the total amount paid is greater than the installment
   amounts
*/

description print a/r records with status of "P" and the total amount paid is greater than the installment
amounts;

include "startend.inc"

define string l_prog_number = "ARSPR701 - Version 7.10"

where 
      (arsbilling:status one of "P" and 
       arsbilling:installment_amount < arsbilling:total_amount_paid and 
       arsbilling:installment_amount > 0.00) and

      (arsbilling:trans_date >= l_starting_date and 
       arsbilling:trans_date <= l_ending_date)

list
/domain="arsbilling"
/nobanner 
/title="Amounts Paid in Excess of Installment Amounts"
/xls="Overpayments in AR"

arsbilling:policy_no 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:status 
arsbilling:installment_amount 
arsbilling:total_amount_paid 

sorted by arsbilling:policy_no 

include "reporttop.inc"
