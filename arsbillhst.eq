include "startend.inc"

where ((arsbillhist:trans_date >= l_starting_date and 
        arsbillhist:trans_date <= l_ending_date and
        arsbillhist:trans_eff  <= l_ending_date) or
       (arsbillhist:trans_date  < l_starting_date and
        arsbillhist:trans_eff  >= l_starting_date and
        arsbillhist:trans_eff  <= l_ending_date ))
list
/nobanner
/domain="arsbillhist"
/title="ARSBILLING History Dump"

arsbillhist:policy_no 
arsbillhist:trans_date 
arsbillhist:trans_code 
arsbillhist:status 
arsbillhist:installment_amount 
arsbillhist:total_amount_paid 
arsbillhist:write_off_amount 

sorted by arsbillhist:policy_no
