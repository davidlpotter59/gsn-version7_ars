/*  arspr025ba
 
    October 31, 2006

    scips.com

    program to print the daily A/R balancing register - booked  

*/

Description Archive Version -- Print the daily A/R transaction register, direct only, includes sur charges - booked;

include "startend.inc"

string l_prog_number = "ARSPR025BA - Version 7.01"

define signed ascii number l_premium = if
arsbilling_month:trans_code one of 10,11,12,13,14,15,16 then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_disbursements = if
arsbilling_month:trans_code one of 30,35, 55 then 
arsbilling_month:disbursement_amount 
else 0.00

define signed ascii number l_installment_charge = if
arsbilling_month:trans_code one of 18, 28 then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_surcharge = if
arsbilling_month:trans_code one of 19, 22,23,29 then
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_cx_balance_due = if
arsbilling_month:trans_code one of 25,26 then 
arsbilling_month:installment_amount 
else 
0.00

define signed ascii number l_late_fee = if
arsbilling_month:trans_code one of 70 then 
arsbilling_month:installment_amount 
else
0.00

define signed ascii number l_write_off = if
arsbilling_month:write_off_amount <> 0 then 
arsbilling_month:write_off_amount 
else
0.00

where ((arsbilling_month:trans_date < l_starting_date and
        arsbilling_month:trans_eff => l_starting_date and 
        arsbilling_month:trans_eff <= l_ending_date) or
       (arsbilling_month:trans_date >= l_starting_date and 
        arsbilling_month:trans_date <= l_ending_date and 
        arsbilling_month:trans_eff  <= l_ending_date)) 

--and arsbilling_month:trans_code not one of 10,11,12,13,14,15,16, 30, 18, 28, 19, 22, 23, 29, 70, 25, 26, 35, 55

list
/nobanner
/domain="arsbilling_month"
/title="arsbilling File Daily Balancing Register - Booked"

arsbilling_month:company_id 
arsbilling_month:policy_no 
arsbilling_month:trans_code 
arsbilling_month:trans_date 
arsbilling_month:trans_eff
arsbilling_month:trans_exp 
arsbilling_month:line_of_business 
arsbilling_month:lob_subline 
arsbilling_month:comm_rate/duplicates 
arsbilling_month:agent_no 
arsbilling_month:bill_plan 
arsbilling_month:payment_plan 
arsbilling_month:comm_rate 
l_premium /heading="Premium"
l_installment_charge /heading="Inst-Chg"
l_late_fee/heading="Late-Fee"
arsbilling_month:disbursement_amount /total
arsbilling_month:write_off_amount /total 

sorted by arsbilling_month:company_id/newpage/total 
          arsbilling_month:bill_plan/newpage/total/heading="TOTAL for @" 
          arsbilling_month:trans_date/total 
          arsbilling_month:policy_no 
          arsbilling_month:trans_code --/total/newpage 
                                                  
include "reporttop.inc"

end of report 
""/newline=2
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
