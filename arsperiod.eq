include "startend.inc"

define l_premium = if arsbilling:trans_code one of 10,11,12,13,14,15,16,17
then
    arsbilling:installment_amount 
else
0.00

define l_surcharge = if arsbilling:trans_code one of 19,29,22,23
then
    arsbilling:installment_amount 
else
0.00

define l_installment_fee = if arsbilling:trans_code one of 18,28
then
    arsbilling:installment_amount 
else
0.00

define l_return_check_fee = if arsbilling:trans_code one of 25
then
    arsbilling:installment_amount 
else
0.00

define l_return_check = if arsbilling:trans_code one of 50
then
    arsbilling:installment_amount 
else
0.00

define l_rebill = if arsbilling:trans_code one of 21 
then
    arsbilling:installment_amount 
else
0.00

define l_void = if arsbilling:trans_code one of 55 
then
    arsbilling:installment_amount 
else
0.00

where (arsbilling:trans_date >= l_starting_date and
       arsbilling:trans_date <= l_ending_date and
       arsbilling:trans_eff  <= l_ending_date)
or
      (arsbilling:trans_date <  l_starting_date and
       arsbilling:trans_eff  >= l_starting_date and
       arsbilling:trans_eff  <= l_ending_date)
list
/nobanner 
/domain="arsbilling"
/title="Written Premium - Per ARSBILLING"

arsbilling:policy_no 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:trans_exp
arsbilling:trans_code 
l_premium 
l_surcharge 
l_installment_fee 
l_return_check_fee 
l_return_check
l_rebill
l_void 

sorted by policy_no /newlines /total 
