/*  arspr551

    May 5, 2004

    SCIPS.com, Inc.

    program to list all arscancel records that have a cx run date < todaysdate - 20
    the purpose of this program to print all arscancel records that have been
    created and have yet to be cancelled
*/
description List all ARSCANCEL records that have a Cancellation run date < todaysdate - 20 ;

define string l_prog_number="ARSPR551 - Version 4.10"

define date l_starting_date[8]=todaysdate 
define date l_ending_date[8]=todaysdate

where arscancel:due_date < (todaysdate - 20)
and arscancel:cx_status one of "P"

list
/domain="arscancel"
/nobanner 
/title="ARSCANCEL Records Created and are in Waiting"

arscancel:policy_no 
arscancel:trans_code 
arscancel:trans_date 
arscancel:due_date 
arscancel:cx_eff_date 
arscancel:cx_status 
arscancel:cx_date 
arscancel:amount_past_due 
arscancel:reason_code 
sfpname:status /duplicates 

sorted by arscancel:cx_status/newpage 
          year(arscancel:cx_date)/newpage/count/heading="@" 
          month(arscancel:cx_date )
          arscancel:policy_no

include "reporttop.inc"

end of report
""/newline
count[arscancel:policy_no] /heading="Total Items Printed"
