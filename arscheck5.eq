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
 
where (arscheck:enter_date => l_starting_date and
       arscheck:enter_date <= l_ending_date and
       arscheck:release = "S")

list
/nobanner
/domain="arscheck"
/title="Suspended Direct Bill Check Register"

box/noblanklines
    policy_no 
    arscheck:payee_name 
    aps_trans_code  
    arscheck:release 
    enter_date 
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
