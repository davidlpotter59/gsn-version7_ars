
Description This report will show all "B" and "O" buckets within the date range selected ;

define wdate l_starting_date = parameter/prompt="enter starting date"
define wdate l_ending_date   = parameter/prompt="enter ending date"

define string l_prog_number = "arsbilling_future"

where arsbilling:due_date >= l_starting_date  and
      arsbilling:due_date <= l_ending_date and
--      arsbilling:status one of "B","O" and 
      arsbilling:status one of "O" and 
      arsbilling:bill_plan one of "DB"
--and arsbilling:billing_ctr > 1

list
/nobanner
/domain="arsbilling"
/title="Future Installments to be Billed"

arsbilling:policy_no 
arsbilling:billed_date
arsbilling:billing_ctr/heading="Installment-to be-Billed"
arsbilling:due_date 
arsbilling:status
arsbilling:installment_amount /total 
arsbilling:write_off_amount /total 
arsbilling:total_amount_paid /total 
arsbilling:net_amount_due/total
arscancel:cx_status 

sorted by arsbilling:due_date
          arsbilling:policy_no/total/newlines 

include "reporttop.inc"
