include "startend.inc"

where ((arsbilling:due_date >= l_starting_date and
        arsbilling:due_date <= l_ending_date and
        arsbilling:trans_eff  <= l_ending_date) or
       (arsbilling:due_date <  l_starting_date and
        arsbilling:trans_eff  >= l_starting_date and
        arsbilling:trans_exp  <= l_ending_date))
--and arsbilling:trans_code < 18
and arsbilling:status one of "B"
and policy_no = 810101180
list
/nobanner
/domain="arsbilling"
--/nodetail                                                 

arsbilling:policy_no    
billing_ctr 
arsbilling:installment_amount/total 
arsbilling:due_date 

sorted by month(arsbilling:due_date)/newlines 
          arsbilling:policy_no/total 
