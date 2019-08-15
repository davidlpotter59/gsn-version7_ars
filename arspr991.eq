/*  arspr991

    april 27, 2006

    scips.com, inc.

    report to show policies out of balance between arsmaster and arsbilling - AC
*/

description The report will show the differences for Account Current Policies between ARSMASTER and ARSBILLING records.  Note:  If the records
are not on the ARSMASTER then there will be no checking on ARSBILLING so use the arspr007 report to 
verify PRSMASTER and ARSMASTER ;

include "startend.inc"

define string l_prog_number = "arspr990 - Version 7.00"

where arsmaster:trans_date => l_starting_date and 
      arsmaster:trans_date <= l_ending_date  and
      arsmaster:trans_code < 17 and
      arsmaster:bill_plan one of "AC"

list
/nobanner
/domain="arsmaster"
/title="Account Current - Balancing Errors Between ARSMASTER and ARSBILLING"
/nodetail
/noreporttotals 

arsmaster:policy_no /column=1
arsmaster:trans_date /column=15
arsmaster:trans_code /column=30/heading="Trans-Code"
arsmaster:line_of_business /column=35/heading="LOB"
arsmaster:lob_subline /column=40/heading="Sub-line"
arsmaster:premium /column=45
arsbilling:installment_amount/column=65
arsbilling:premium/column=85/heading="Difference"

sorted by arsmaster:policy_no 

end of arsmaster:policy_no 

if total[arsmaster:ac_net_amount_due] <> total[arsbilling:installment_amount] then 
{
box/noheadings 
    arsmaster:policy_no /column=1
    arsmaster:trans_date /column=15
    arsmaster:bill_plan/column=26
    arsmaster:trans_code /column=30
    arsmaster:line_of_business /column=35
    arsmaster:lob_subline /column=40
    total[arsmaster:premium] /column=45
    total[arsbilling:installment_amount]/column=65
    total[arsmaster:premium] - total[arsbilling:premium]/column=85
end box 
}
    
include "reporttop.inc"
