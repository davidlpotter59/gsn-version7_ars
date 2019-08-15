/*  lebins_arspr025b
 
    September 12, 2006

    scips.com

    program to print the daily A/R balancing register - booked  

*/

Description Print the daily A/R transaction register, direct only, includes sur charges - booked;

include "startend.inc"

string l_prog_number = "ARSPR025B - Version 7.00"

define file alt_sfsline  = access sfsline, set 
sfsline:company_id       = arsbilling:company_id,
sfsline:line_of_business = arsbilling:line_of_business,
sfsline:lob_subline      = arsbilling:lob_subline, generic

define signed ascii number l_premium = if
arsbilling:trans_code one of 10,11,12,13,14,15,16,60,61,62,63,64,65,66 and
alt_sfsline:stmt_lob <> 999 then 
arsbilling:installment_amount 
else
0.00

define signed ascii number l_disbursements = if
arsbilling:trans_code one of 30,35, 55 then 
arsbilling:disbursement_amount 
else 0.00

define signed ascii number l_installment_charge = if
arsbilling:trans_code one of 18, 28, 68 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_surcharge = if
arsbilling:trans_code one of 19, 22,23,29, 69 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_assessments = if
alt_sfsline:stmt_lob = 999 then
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

where ((arsbilling:trans_date < l_starting_date and
        arsbilling:trans_eff => l_starting_date and 
        arsbilling:trans_eff <= l_ending_date) or
       (arsbilling:trans_date >= l_starting_date and 
        arsbilling:trans_date <= l_ending_date and 
        arsbilling:trans_eff  <= l_ending_date)) 

--and arsbilling:trans_code not one of 10,11,12,13,14,15,16, 30, 18, 28, 19, 22, 23, 29, 70, 25, 26, 35, 55

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Booked"

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
arsbilling:premium 
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
"TOTALS Breakdown"/center/newline=2
total[l_premium]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Premium Booked   "
total[l_installment_charge]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"
/newline=2/heading="Installment Charges Booked "
total[l_late_fee]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Late Fees Booked "
total[l_surcharge]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="Sur Charges Booked"
total[l_assessments]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="Assessments Booked"
total[l_cx_balance_due]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="CX Balance Due Booked Booked"
total[l_disbursements]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2/heading="Disbursements Booked"
total[l_write_off]/align=arsbilling:premium/mask="(Z,ZZZ,ZZZ.99)"/newline=2
/heading="Write Offs Booked"
""/newline=2
"Balancing = Premium Booked + Installment Charges + Late Fees + Surcharges + CX Balance Due = REPORT TOTAL"
