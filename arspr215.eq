/*   arspr215

     March 6, 2002

     SCIPS.com

     program to list the installment bills produced by billed
     date - rebills only

*/

description 
List Rebill Transactions (NSF) - Installment Bills Processed by "Billed Date" - This report will not show the First installment or Policies where the Payment Plan is 1;

define wdate l_starting_date = parameter/prompt="Enter First Billed Date"
define wdate l_ending_date   = parameter/prompt="Enter Last Billed Date"

define string l_status = switch(arsbilling:status)
case "B" : "Billed     "
case "O" : "Not Billed "
case "P" : "Paid       "
default  : "Outstanding" 
                              
where arsbilling:billed_date => l_starting_date and
      arsbilling:billed_date <= l_ending_date and
      arsbilling:billing_ctr > 1 and
      arsbilling:trans_code one of 21,50 -- c/x balance due notice    

list
/nobanner
/domain="arsbilling" 
/title="Installment Bills Processed by 'Billed Date'"
/pagewidth=80
/duplicates 

arsbilling:policy_no
arsbilling:trans_date
arsbilling:billed_date 

arsbilling:billing_ctr/heading="Which-Installment-Billed"
due_date                       
(arsbilling:installment_amount -(arsbilling:total_amount_paid +
  arsbilling:write_off_amount))/total 



sorted by arsbilling:billed_date/total/newpage 
          arsbilling:policy_no/newlines=2/total 

top of page
l_starting_date/heading="Billed Date Range"/column=20/mask="MM/DD/YYYY"
" - "
l_ending_date/noheading/mask="MM/DD/YYYY"/newline=2

end of report
"Billed Date - the date that the installment status changed from 'O'"/newline
"to 'B' (Open to Billed).  This is the day before today if you are attempting"/newline
"to run this report for the previous nights automatic processing"/newline=2
