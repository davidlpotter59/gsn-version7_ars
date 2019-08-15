/*  arscheck

    scips.com

    august 9, 2001

    report to print the check register for a given date range
*/

description 

Direct Bill Return and overpayment checks register, enter a starting and ending date, will not print voided checks;

include "startend.inc"

define unsigned ascii number l_check_no[10] = val(arscheck:check_no[10,20])

define string l_check_type = switch(arscheck:aps_trans_code)
case "VOIDRP"  : "A"                      
default        : "X"

define string l_Page_heading = switch(l_check_type)
case "A" : "VOIDED Return Premium Checks"
default  : "Return Premium Checks"
 
where (arscheck:check_date => l_starting_date and
       arscheck:check_date <= l_ending_date and
       arscheck:status_after_check <> "V") 
or
      (arscheck:voided_date => l_starting_date and
       arscheck:voided_date <= l_ending_date and
       arscheck:status_after_check = "V" and
       arscheck:aps_trans_code = "VOIDRP")

list
/nobanner
/domain="arscheck"
/title="Direct Bill Check Register"

box/noblanklines
    policy_no 
    arscheck:payee_name 
    check_draft 
    checK_cleared 
    check_cleared_date
    l_check_no/heading="Check-Number"/nototal 
    check_date 
    check_amount 
end box

sorted by l_check_type/newpage/total/heading="Check Type"
          arscheck:check_no 

top of page
"arscheck"/newline/left
trun("Check Date Range")/center/newline 
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,
"MM/DD/YYYY"))/centre /newline 
trun(l_page_heading)/noheading/centre
