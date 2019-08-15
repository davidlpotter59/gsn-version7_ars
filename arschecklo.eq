/*  arschecklo

    scips.com

    august 9, 2001

    report to print the check register for a given date range
*/

description 

Direct Bill Return and overpayment checks register, enter a starting and ending date, will not print voided checks, output in Excel;

include "startend.inc"

define unsigned ascii number l_check_no[6] = val(arscheck:check_no)

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
/nodefaults
/wks

    policy_no/heading="Policy-Number" 
    arscheck:payee_name[1]/heading="Payee"

    check_draft/heading="Check-Draft" 
    checK_cleared/heading="Cleared" 
    check_cleared_date/heading="Check Cleared-Date"
    l_check_no/heading="Check-Number"/nototal 
    check_date/heading="Check-Date" 
    check_amount/heading="Check-Amount" 

sorted by l_check_type/newlines/total 
          arscheck:check_no 

top of l_check_type 
l_page_heading/noheading/column=1
