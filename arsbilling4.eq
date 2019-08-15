include "startend.inc"
where arsbilling:billed_date => l_starting_date  and 
      arsbilling:billed_date <= l_ending_date and
billing_ctr > 1 and 
status = "B"

list
/nobanner
/domain="arsbilling"

arsbilling:policy_no 
arsbilling:line_of_business 
arsbilling:trans_date 
arsbilling:trans_code 
arsbilling:bill_plan 
billing_ctr 
status 
arsbilling:installment_amount /total

sorted by arsbilling:line_of_business/total/heading="Line of Business @"
          arsbilling:billed_date/newpage/total
          arsbilling:policy_no/total/newlines=2

top of report
l_starting_date/heading="Starting Date "/newline/mask="MM/DD/YYYY"
l_ending_date  /heading="Ending Date   "/newline=2/mask="MM/DD/YYYY"
