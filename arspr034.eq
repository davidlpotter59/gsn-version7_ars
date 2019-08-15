
/*  arspr034

    SCIPS.com, Inc.

    October 17, 2011

    Report to list NSF checks clear bank dates
*/

description List, NSF checks with clear bank date ;

include "startend.inc"
define string l_prog_number = "ARSPR034 - Version 7.22"


where arsnsfcleared:check_cleared = 1 and
      arsnsfcleared:cleared_date => l_starting_date and
      arsnsfcleared:cleared_date <= l_ending_date 


list
/domain="arsnsfcleared"
/title="NSF CHECKS with Clear banks dates"

check_reference
policy_no
cleared_date
check_amount



--enter_date of report 
include "reporttop.inc"
