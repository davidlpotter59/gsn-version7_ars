include "startend.inc"
define signed ascii number l_premium = if
arsbillhist:trans_code one of 10,11,12,13,14,16 then
arsbillhist:installment_amount 
else
0.00

define signed ascii number l_install_fee = if
arsbillhist:trans_code one of 18,28 then 
arsbillhist:installment_amount 
else 
0.00

define signed ascii number l_prem_fee = if
arsbillhist:trans_code one of 19,21,22,29 then
arsbillhist:installment_amount 
else 
0.00       

define signed ascii number l_other = if
arsbillhist:trans_code not one of 10,11,12,13,14,16,18,19,21,22,28,29 then
arsbillhist:installment_amount 
else
0.00

where ((arsbillhist:trans_date >= l_starting_date and
        arsbillhist:trans_date <= l_ending_date and
        arsbillhist:trans_eff  <= l_ending_date) or
       (arsbillhist:trans_date  < l_starting_date and
        arsbillhist:trans_eff  >= l_starting_date and
        arsbillhist:trans_eff  <= l_Ending_date))

list
/nobanner
/domain="arsbillhist" 
/nodetail 

arsbillhist:policy_no 
arsbillhist:trans_date 
arsbillhist:trans_code 
arsbillhist:trans_eff
arsbillhist:due_date 
arsbillhist:status
arsbillhist:installment_amount/total  
arsbillhist:total_amount_paid 
arsbillhist:write_off_amount

sorted by arsbillhist:policy_no 

end of report
total[l_premium]/column=1/heading="Premium  "/newline 
total[l_install_fee ]/column=1/heading="Installment "/newline
total[l_prem_fee]/column=1/heading="Premium Fee"/newline 
total[l_other]/column=1/heading="Other"
