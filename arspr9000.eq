/*  arspr9000.eq

    April 29, 2002

    SCIPS.com


    report to show cash activity */

description A/R Cash Activity Report, processed by Transaction Date ;


include "startend.inc"

define string l_type=if arschksu:policy_no = 0 then "Applications Outstanding"
else
"Policy's Processed"

define signed ascii number l_prior_advanced = if arschksu:trans_date < l_starting_date and
arschksu:trans_eff >= l_starting_date and
arschksu:trans_eff <= l_ending_date 
then arschksu:check_amount 
else
0.00

define signed ascii number l_advanced = if arschksu:trans_date >= l_starting_date and
arschksu:trans_date <= l_ending_date and
arschksu:trans_eff > l_ending_date 
then arschksu:check_amount 
else
0.00

define signed ascii number l_current_period = if l_prior_advanced = 0.00 and
l_advanced = 0.00 then arschksu:check_amount 
else
0.00 

define signed ascii number l_nsf = if arschksu:disposition = "RETRN" then
arschksu:check_amount 
else
0.00
  
define file aarsbilling = access arsbilling, set arsbilling:company_id= arschksu:company_id,
                                                 arsbilling:policy_no=  arschksu:policy_no, one to many, generic 

define signed ascii number l_sur_charge_billed = if (aarsbilling:trans_code one of 19,22,23,27,29 and 
                                                    (aarsbilling:trans_date >= l_starting_date and
                                                     aarsbilling:trans_date <= l_ending_date)) then
aarsbilling:installment_amount 
else
0.00

define signed ascii number l_sur_charge_paid = if (aarsbilling:trans_code one of 19,22,23,27,29 and
                                                  (aarsbilling:trans_date >= l_starting_date and
                                                   aarsbilling:trans_date <= l_ending_date)) then
aarsbilling:total_amount_paid 
else
0.00

define signed ascii number l_installment_charge_billed = if (aarsbilling:trans_code one of 18,28 and
                                                            (aarsbilling:trans_date >= l_starting_date and
                                                             aarsbilling:trans_date <= l_ending_date)) then
aarsbilling:installment_amount 
else
0.00

define signed ascii number l_installment_charge_paid = if (aarsbilling:trans_code one of 18,28 and
                                                          (aarsbilling:trans_date >= l_starting_date and
                                                           aarsbilling:trans_date <= l_ending_date)) then
aarsbilling:total_amount_paid  
else
0.00


where ((arschksu:trans_date >= l_starting_date and
        arschksu:trans_date <= l_ending_date))/*  and
        arschksu:trans_eff <= l_ending_date) or
       (arschksu:trans_date < l_starting_date and
        arschksu:trans_eff >= l_starting_date and
        arschksu:trans_eff <= l_ending_date))    */

list
/nobanner
/domain="arschksu"
/title="Accounts Receivable Cash Activity Report"
/pagewidth=210
/nodetail 
/nototals 

if arschksu:policy_no = 0 then
{
arschksu:quote_no/noheading/column=1  
}
else
{
arschksu:policy_no /noheading /column=1
}              

arschksu:check_reference/column=12 
arschksu:trans_date/column=21
arschksu:trans_eff/column=32
arschksu:posted_date/column=43                         
arschksu:check_amount /column=54
l_current_period/heading="Current-Perid-Cash"/column=69
l_prior_advanced/heading="Prior-Period-Advanced"/column=84
l_advanced /heading="Current-Period-Advanced"/column=99
arschksu:balance /heading="Check-Balance-(Amt not Applied)"/column=114
l_sur_charge_billed/heading="Sur Charges-Billed"/column=129
l_sur_charge_paid/heading="Sur Charges-Paid"/column=144
l_installment_charge_billed/heading="Installment-Charges-Billed"/column=159
l_installment_charge_paid/heading="Installment-Charges-Paid"/column=174
l_nsf/heading="NSF-Amount" /column=189

sorted by l_type /newpage
          arschksu:policy_no 

top of page
"Program Number: ARSPR9000"/left
trun(l_type)/heading="Check Status"/center/newline=2
"Date Range"/center/newline
trun(str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY"))/newline=2/center   

end of report
""/newpage
"Totals Page"/center/newline=2

total[arschksu:check_amount]      /newline/heading="Check Amounts              "
total[l_prior_advanced]           /newline/heading="Prior Period Advanced      "
total[l_advanced]                 /newline/heading="Current Period Advanced    "
total[l_current_period]           /newline/heading="Current Period Cash        "
total[arschksu:balance]           /newline/heading="Outstanding Balance        "
total[l_sur_charge_billed]        /newline/heading="Sur Charges Billed         "
total[l_sur_charge_paid]          /newline/heading="Sur Charges Collected      " 
total[l_installment_charge_billed]/newline/heading="Installment Charges Billed "
total[l_installment_charge_paid]  /newline/heading="Installment Charges Paid   "
total[l_nsf]                      /newline/heading="NSF's Processed            "

end of arschksu:policy_no
box/noheadings/noblanklines  /duplicates 
if arschksu:policy_no = 0 then
{
arschksu:quote_no/noheading  /column=1
}
else
{
arschksu:policy_no /noheading /column=1
}              

arschksu:check_reference /column=12
arschksu:trans_date/column=21/duplicates 
arschksu:trans_eff /column=32/duplicates 
arschksu:posted_date/column=43/duplicates                           
arschksu:check_amount/column=54/duplicates 
total[l_current_period,arschksu:policy_no]/column=69
total[l_prior_advanced,arschksu:policy_no]/column=84
total[l_advanced,arschksu:policy_no]/column=99
total[arschksu:balance,arschksu:policy_no]/column=114
total[l_sur_charge_billed,arschksu:policy_no]/column=129
total[l_sur_charge_paid,arschksu:policy_no]/column=144
total[l_installment_charge_billed,arschksu:policy_no]/column=159
total[l_installment_charge_paid,arschksu:policy_no]/column=174
total[l_nsf,arschksu:policy_no]/column=189
end box
