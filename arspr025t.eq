/*  arspr025t
 
    December 11, 2007

    scips.com

    program to print the daily A/R balancing register - Transaction date

*/

Description Live Version -- Print the daily A/R transaction register, direct only, includes sur charges - transaction date processing;

include "startend.inc"

string l_prog_number = "ARSPR025T - Version 7.20"

define signed ascii number l_premium = if
arsbilling:trans_code one of 10,11,12,13,14,15,16 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_disbursements = if
arsbilling:trans_code one of 30,35, 55 then 
arsbilling:disbursement_amount 
else 0.00

define signed ascii number l_installment_charge = if
arsbilling:trans_code one of 18, 28 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_surcharge = if
arsbilling:trans_code one of 19, 22,23,29 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_cx_balance_due = if
arsbilling:trans_code one of 25,26 then 
arsbilling:installment_amount 
else 
0.00

define signed ascii number l_late_fee = if
arsbilling:trans_code one of 70 then 
arsbilling:installment_amount 
else
0.00

define signed ascii number l_write_off = if
arsbilling:write_off_amount <> 0 then 
arsbilling:write_off_amount 
else
0.00

where arsbilling:trans_date => l_starting_date and
      arsbilling:trans_date <= l_ending_date

list
/nobanner
/domain="arsbilling"
/title="arsbilling File Daily Balancing Register - Transaction Date Processing"

arsbilling:company_id 
arsbilling:policy_no 
arsbilling:trans_code 
arsbilling:trans_date 
arsbilling:trans_eff
arsbilling:trans_exp 
arsbilling:line_of_business 
arsbilling:lob_subline 
arsbilling:comm_rate/duplicates 
arsbilling:agent_no 
arsbilling:bill_plan 
arsbilling:payment_plan 
arsbilling:comm_rate 
l_premium /heading="Premium"
l_installment_charge /heading="Inst-Chg"
l_late_fee/heading="Late-Fee"
arsbilling:disbursement_amount /total
arsbilling:write_off_amount /total 

sorted by arsbilling:company_id/newpage/total 
          arsbilling:bill_plan/newpage/total/heading="TOTAL for @" 
          arsbilling:trans_date/total 
          arsbilling:policy_no 
          arsbilling:trans_code --/total/newpage 
                                                  
include "reporttop.inc"

end of report 
""/newline=2
"This report shows when a transaction was created (Transaction date) with no regard to it's booking date"/newline=2
"The purpose of this report is ONLY to show what was done within the date range selected.  This report has no"/newline
"other purpose then to track transactions!"/newline=2

"TOTALS Breakdown"/center/newline=2
total[l_premium]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Premium Booked   "
total[l_installment_charge]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"
/newline=2/heading="Installment Charges Booked "
total[l_late_fee]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Late Fees Booked "
total[l_surcharge]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="Sur Charges Booked"
total[l_cx_balance_due]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="CX Balance Due Booked Booked"
total[l_disbursements]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="Disbursements Booked"
total[l_write_off]/align=l_premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Write Offs Booked"
""/newline=2
"Balancing = Premium Booked + Installment Charges + Late Fees + Surcharges + CX Balance Due = REPORT TOTAL"
