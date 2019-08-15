
/*  arspr550

    May 5, 2004

    SCIPS.com, Inc.

    program to list all arscancel records that have a due date > todaysdate
    the purpose of this program to print all arscancel records that have been
    created in error
*/

description 
List all ARSCANCEL records where the due date is > todaysdate, sorted by status and policy number ;

define string l_prog_number="ARSPR550 - Version 4.10"

define date l_starting_date[8]=todaysdate 
define date l_ending_date[8]=todaysdate

where arscancel:due_date > todaysdate 

list
/domain="arscancel"
/nobanner 
/title="ARSCANCEL Records Created in Error"

arscancel:policy_no 
arscancel:trans_code 
arscancel:trans_date 
arscancel:due_date 
arscancel:cx_eff_date 
arscancel:cx_status 
arscancel:cx_date 
arscancel:amount_past_due 
arscancel:reason_code 

sorted by arscancel:cx_status/newpage 
          arscancel:policy_no

include "reporttop.inc"
