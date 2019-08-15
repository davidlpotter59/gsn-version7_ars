/* arsbilling_past_due

   June 7, 2007

   SCIPS.com, Inc.

   this report will show all potential past due notices with items noted that
   could potentially keep the notice from being created
*/

description Report and print all potential past due notices with items noted that 
could potentially keep the notice from being created;

define wdate l_starting_date = 01.01.2000

define wdate l_ending_date = parameter/prompt="Please Enter the As of Due Date to Verify"

define string l_prog_number = "ARSBILLING Past Due - Version 7.20"

where arsbilling:status one of "B", "O" 
and arsbilling:due_date <= l_ending_date 

list
/nobanner
/domain="arsbilling"
/title="Billed and Unbilled Buckets Past Due"

arsbilling:policy_no /column=1
arsbilling:billed_date /column=15
arsbilling:status /column=30
arsbilling:trans_date /column=40
arsbilling:due_date/column=55
arsbilling:installment_amount/column=70 
arsbilling:total_amount_paid /column=90
arsbilling:write_off_amount /column=110
arsbilling:net_amount_due /column=130/mask="(ZZ,ZZZ.99)"

sorted by arsbilling:due_date/total/heading="Policies that were due on @"/newlines /mask="MM/DD/YYYY"
          arsbilling:policy_no/total/heading="      TOTAL for Policy @"/newlines

end of arsbilling:policy_no 
box/noblanklines 
    if arscancel:cx_status one of "P" then 
    {
        "Potential Cancellations Outstanding for policy " + str(arsbilling:policy_no,"ZZZZZZZZZ")/newline/column=10
        arscancel:policy_no/column=15
        arscancel:cx_status /heading="A/R Cancellation Status "
        arscancel:due_date /heading="Past Due Date"
        "Total Amount Due "
        arscancel:amount_past_due /noheading/column=130/mask="(ZZ,ZZZ.99)"/newline
        sfpname:status/column=15/heading="Policy Status" 
        if sfscancel:status <> "" then 
        {
            sfscancel:status/heading="Cancellation Status"
        }
    }
end box/newlines

include "reporttop.inc"
