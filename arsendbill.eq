/*  arsendbill

    scips.inc, inc.

    march 1, 2007

    a/r report to show  credit endorsements on first bucket that need an invoice
*/

description     a/r report to show  credit endorsements on first bucket that need an invoice;

include "startend.inc"

define string l_prog_number = "ARSENDBILL - Version 7.00"

where arsbilling:billed_date => l_starting_date and 
      arsbilling:billed_date <= l_ending_date and 
      arsbilling:billing_ctr one of 1 and 
      arsbilling:installment_amount <> 0.00 and
      arsbilling:trans_code one of 13

list
/nobanner
/domain="arsbilling"
/title="Credit Endorsements First Bucket Invoice Requirements"

arsbilling:policy_no 
arsbilling:trans_date 
arsbilling:trans_code 
arsbilling:trans_eff
arsbilling:status 
arsbilling:installment_amount 
arsbilling:total_amount_paid 
arsbilling:write_off_amount 
arsbilling:net_amount_due 

sorted by arsbilling:policy_no 

include "reporttop.inc"
