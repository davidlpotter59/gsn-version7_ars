/*  arspr017

    SCIPS.com, Inc.

    December 7, 2010

    Report to show policies number that should have lapse notices for a given date
*/
description 
List the policies that should have a lapse notice on a given date ;

include "end.inc"

define string l_prog_number = "arspr017.eq"
define date l_starting_date = l_ending_date 

where arsbilling:billing_ctr =1 
--and arsbilling:due_date = todaysdate -7
and arsbilling:due_date = l_ending_date 
and arsbilling:status = "B"
and arsbilling:trans_code not one of 15, 18, 70, 68, 25, 50

list
/domain="arsbilling"
/nobanner

policy_no trans_code billing_ctr trans_eff due_date status installment_amount total_amount_paid
include "reporttop.inc"
