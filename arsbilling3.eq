define wdate l_starting_date = parameter/prompt="Enter Starting Date:"
define wdate l_ending_date   = parameter/prompt="<NL>Enter Ending Date:  "


define signed ascii number l_unbilled = if arsbilling:status = "O" then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_billing = if arsbilling:status <> "O" then
arsbilling:installment_amount 
else
0.00

where ((arsbilling:trans_date => l_starting_date and
        arsbilling:trans_date <= l_ending_date and
        arsbilling:trans_eff <= l_ending_date) or
      ( arsbilling:trans_date < l_starting_date and
        arsbilling:trans_eff => l_starting_date and
        arsbilling:trans_eff <= l_ending_date ))

list
/nobanner
/domain="arsbilling"
/nodetail

arsbilling:installment_amount /total
l_billing/total
l_unbilled/total
