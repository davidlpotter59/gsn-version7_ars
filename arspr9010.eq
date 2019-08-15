/*  arspr9010.eq

    April 29, 2002

    SCIPS.com


    report to show cash activity - excel output */

description Spreadsheet Output of the A/R Cash Activity Report, processed by Transaction Date ;


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
        arschksu:trans_date <= l_ending_date and
        arschksu:trans_eff <= l_ending_date) or
       (arschksu:trans_date < l_starting_date and
        arschksu:trans_eff >= l_starting_date and
        arschksu:trans_eff <= l_ending_date))

list
/nobanner
/domain="arschksu"
/pagewidth=210
/nodetail 
/nototals
/noheadings 
/nodefaults       
/nopageheadings 
/wks  

sorted by l_type
          arschksu:policy_no 

end of arschksu:policy_no
arschksu:policy_no /noheading /column=1
arschksu:check_reference /column=12
arschksu:trans_date/column=21
arschksu:trans_eff /column=32
arschksu:posted_date/column=43                         
arschksu:check_amount/column=54
total[l_current_period,arschksu:policy_no]/column=69
total[l_prior_advanced,arschksu:policy_no]/column=84
total[l_advanced,arschksu:policy_no]/column=99
total[arschksu:balance,arschksu:policy_no]/column=114
total[l_sur_charge_billed,arschksu:policy_no]/column=129
total[l_sur_charge_paid,arschksu:policy_no]/column=144
total[l_installment_charge_billed,arschksu:policy_no]/column=159
total[l_installment_charge_paid,arschksu:policy_no]/column=174
total[l_nsf,arschksu:policy_no]/column=189
