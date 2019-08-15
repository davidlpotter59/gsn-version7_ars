
/*  arspr033

    SCIPS.com, Inc.

    October 17, 2011

    Report to list AP checks clear bank dates
*/

description List, AP checks with clear bank date ;

include "startend.inc"
define string l_prog_number = "ARSPR033 - Version 7.20"


where arscheck:check_cleared = 1 and
      arscheck:check_cleared_date => l_starting_date and
      arscheck:check_cleared_date <= l_ending_date 


list
/domain="arscheck"
/title="AP CHECKS with Clear banks dates"

check_no 
policy_no 
check_amount 
payee_name[1]
check_cleared_date


--enter_date of report 
include "reporttop.inc"
