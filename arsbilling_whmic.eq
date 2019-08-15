define wdate l_starting_date=parameter
define wdate l_ending_date = parameter

where arsbilling:due_date >= l_starting_date and 
      arsbilling:due_date <= l_ending_date and 
      arsbilling:billing_ctr > 1 and
      arsbilling:status = "O"

list
/nobanner
/domain="arsbilling"
/title="Outstanding and Missed Receiveables"

arsbilling:policy_no 
arsbilling:trans_date
arsbilling:trans_eff              
arsbilling:due_date
arsbilling:trans_code/heading="TC"
arsbilling:status
arsbilling:installment_amount 

sorted by arsbilling:due_date/newlines/count/heading="@"
          arsbilling:policy_no 
