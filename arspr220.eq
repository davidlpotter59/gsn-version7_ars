/*   arspr220

     October 31, 2002

     SCIPS.com

     program to list the installment bills expected to produce by due date
     these are records where the status must be "O" and the due date is
     within the date range selected

*/

description 
List expected invoices by Future Due Dates ;
define unsigned ascii number l_underwriting_cx[1]=if sfscancel:cx_eff_date <>
 00.00.0000 and sfscancel:status = "CANCEL"
then 1
else 0

define string l_cx_yes_no=switch(l_underwriting_cx)
case 1 : "YES"
default : "NO"

define wdate l_starting_date = parameter/prompt="Enter First Due Date"
define wdate l_ending_date   = parameter/prompt="Enter Last Due Date"

define string l_status = switch(arsbilling:status)
case "B" : "Billed     "
case "O" : "Not Billed "
case "P" : "Paid       "
default  : "Outstanding" 
                              
where arsbilling:due_date => l_starting_date and
      arsbilling:due_date <= l_ending_date and
      arsbilling:status = "O" and 
      arsbilling:billing_ctr > 1 and
      arsbilling:trans_code not one of 21,25,50 -- c/x balance due notice    

list
/nobanner
/domain="arsbilling" 
/title="Expected Installments To Be Billed By Due Date"
/pagewidth=90
/duplicates 

arsbilling:policy_no
arsbilling:trans_date 
arsbilling:trans_code 
arsbilling:billed_date 
arsbilling:billing_ctr/heading="Which-Installment-Is Due"
arsbilling:due_date                       
(arsbilling:installment_amount -(arsbilling:total_amount_paid +
  arsbilling:write_off_amount))/total /heading="Installment-Amount"
--l_cx_yes_no/heading="Pending Underwriting-Cancellaion"

sorted by arsbilling:due_date/total/newpage 
          arsbilling:policy_no/newlines=2/total 

top of page
"Program No.: arspr210"/left
username/heading="Printed By"/column=60/newline=2
l_starting_date/heading="Due Date Range"/column=20/mask="MM/DD/YYYY"
" - "
l_ending_date/noheading/mask="MM/DD/YYYY"/newline=2
