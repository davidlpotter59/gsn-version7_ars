/*  arscheck4

    scips.com

    November 3, 2003

    report to print the check register for a given date range for voided return premium checks only
*/

description 

Direct Bill Return and overpayment checks register, enter a starting and ending date, print voided checks for return premiums only;

include "startend.inc"

define unsigned ascii number l_check_no[9] = val(arscheck:check_no)

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
/title="Direct Bill Check Register - VOIDED Return Premium Checks"

box/noblanklines
    policy_no 
    arscheck:payee_name 
    aps_trans_code  
    l_check_no/heading="Check-Number"/nototal 
    check_date 
    check_amount 
    entering_user_name
end box

sorted by l_check_type/newpage/total/heading="Check Type"
          arscheck:check_no 

top of page
"Report No.: arscheck4"/newline/left
trun("Check Date Range")/center/newline 
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,
"MM/DD/YYYY"))/centre /newline 
trun(l_page_heading)/noheading/centre
