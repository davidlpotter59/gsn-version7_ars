/*  SCIPS.com, Inc.

    February 5, 2004

    arspr8000

    Balance verification between ARSMASTER and ARSBILLING based on a date range entered.  Report will
    only show those policies that are not in balance between ARSMASTER and ARSBILLING.  Remember that
    the installment charges will not be included
*/

Description 
    Balance verification between ARSMASTER and ARSBILLING based on a date range entered.  Report will
    only show those policies that are not in balance between ARSMASTER and ARSBILLING.  Remember that
    the installment charges will not be included.  This report checks direct premium only (transaction
    codes < 17).;

include "startend.inc"
DEFINE STRING L_prog_number = "ARSPR8000 - VERSION 7.00"

define signed ascii number l_total_billing[9] =
if arsbilling:trans_code = arsmaster:trans_code then arsbilling:premium
else 0.00


where arsmaster:trans_date >= l_starting_date         
and   arsmaster:trans_date <= l_ending_date    
and   arsmaster:trans_code < 17       

list
/nobanner
/domain="arsmaster"
/nodetail 
/pagelength=0
/noreporttotals 

arsmaster:policy_no /column=1
arsmaster:trans_date /column=15
arsmaster:trans_code /column=30
arsmaster:trans_eff /column=40
arsmaster:premium /column=60
l_total_billing/heading="Billing-Amount"/column=80
l_total_billing - arsmaster:premium/heading="Total-Difference"/column=100/nototal 

sorted by arsmaster:policy_no 

end of arsmaster:policy_no 

if total[arsmaster:premium] <> total[l_total_billing] then 
{
box/noheadings 
    arsmaster:policy_no/column=1
    arsmaster:trans_date /column=15
    arsmaster:trans_CODE/COLUMN=30
    ARSMASTER:trans_eff/column=40
    total[arsmaster:premium]/column=60
    total[l_total_billing]/column=80
    total[l_total_billing] - total[arsmaster:premium]/column=100/mask="ZZ,ZZZ,ZZZ.99-"
end box
}

end of report
    "Report Total"/column=30
    total[arsmaster:premium]/mask="ZZ,ZZZ,ZZZ.99-"/column=60
    total[l_total_billing]/mask="ZZ,ZZZ,ZZZ.99-"/column=80

INCLUDE "reporttop.inc"
