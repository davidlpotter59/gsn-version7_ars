
/*  arspr552

    May 5, 2004

    SCIPS.com, Inc.

    report to list open arsbilling buckets based on the date range entered
*/

description List open arsbilling buckets based on the date range entered;

include "startend.inc"

define string l_prog_number="ARSPR552 - Version 4.21"

where ((arsbilling:due_date >= l_starting_date and
        arsbilling:due_date <= l_ending_date)) and
        arsbilling:status one of "O"

list
/nobanner
/domain="arsbilling"
/title="List Outstanding Receivables" 
/nodetail                                                

arsbilling:policy_no /column=1   
arsbilling:billing_ctr/column=15
arsbilling:status/column=25 
arsbilling:status_date/column=30 
arsbilling:installment_amount/total/column=40
arsbilling:due_date/column=55 
sfpsupp:mortgage_type_1/heading="Mortgage-Type"/column=65
sfscancel:cancellation_code/heading="CX-Code"/column=75 
arscancel:cx_status/heading="Non Pay-CX-Status"/column=85 

sorted by arsbilling:due_date 
          arsbilling:policy_no

include "reporttop.inc"

end of arsbilling:policy_no 
box/noheadings 
arsbilling:policy_no/column=1
billing_ctr/column=15 
arsbilling:status/column=25
arsbilling:status_date/column=30 
arsbilling:installment_amount/column=40
arsbilling:due_date/column=55 
sfpsupp:mortgage_type_1/column=65
sfscancel:cancellation_code/column=75 
arscancel:cx_status/column=85 
end box
