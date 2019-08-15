/*  sfqcheck

    scips.com

    august 9, 2001

    report to print the check register for a given date range
*/

description 

Direct Bill Return and overpayment checks register, enter a starting and ending date, will not print voided checks;

include "startend.inc"

define unsigned ascii number l_check_no[15] = val(sfqcheck:check_no[10,20])
define string l_prog_number = "sfqcheck - Version 7.30"
define string l_check_type = switch(sfqcheck:aps_trans_code)
case "VOIDRP"  : "A"
default        : "X"

define string l_Page_heading = switch(l_check_type)
case "A" : "VOIDED Return Premium Checks"
default  : "Return Premium Checks"
 
where (sfqcheck:check_date => l_starting_date and
       sfqcheck:check_date <= l_ending_date and
       sfqcheck:status_after_check <> "V") 
or
      (sfqcheck:voided_date => l_starting_date and
       sfqcheck:voided_date <= l_ending_date and
       sfqcheck:status_after_check = "V" and
       sfqcheck:aps_trans_code = "VOIDRP")

list
/nobanner
/domain="sfqcheck"
/title="Declined Quote Check Register"

box/noblanklines
    sfqcheck:quote_no 
    sfqcheck:payee_name 
    sfqcheck:check_draft 
    sfqcheck:checK_cleared 
    sfqcheck:check_cleared_date
    l_check_no/heading="Check-Number"/nototal 
    sfqcheck:check_date 
    sfqcheck:check_amount 
end box

sorted by l_check_type/newpage/total/heading="Check Type"
          sfqcheck:check_no 

include "reporttop.inc"
