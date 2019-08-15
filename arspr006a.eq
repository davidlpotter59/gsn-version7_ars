/* arspr006a.eq

   December 26, 2000

   scips.com, inc.

   Archive Version - checks to be processed report
*/                                  
define file arsbilling_a = access arsbilling, 
set arsbilling:company_id = arschksu_month:company_id,
    arsbilling:policy_no  = arschksu_month:policy_no, generic 
           
include "startend.inc"

define string l_trans_date_str = "Checks Entered On " + str(
arschksu_month:trans_date)
                                         
-- added deposit_date check 8/27/2001 - dlp
where arschksu_month:trans_date => l_starting_date and
      arschksu_month:trans_date <= l_ending_date and
      arschksu_month:disposition = "OPEN" and
      arschksu_month:deposit_date = 00.00.0000 and
      arschksu_month:internal_check = 0 

list
/nobanner
/domain="arschksu"
/pagewidth=145
--/nodetail                   
/nototals 
--/noreporttotals 
/duplicates 

arschksu_month:policy_no /column=2/heading="Policy-Number"
if arschksu_month:policy_no = 0 or
   sfpname:name[1] = "" then
   "APPLICATION"/column=1/noheading

arschksu_month:payor_type/column=13 /heading="T-P"
arschksu_month:trans_date/column=15 /heading="Trans-Date"
arschksu_month:check_amount /total/column=25/heading="Check-Amount"
arsbilling_a:installment_amount/total /column=40/heading="Amount-Due"
arschksu_month:balance/total/column=55/heading="Check-Balance"
arschksu_month:check_no /column=80/heading="Check-No"
arschksu_month:bank_no/column=100/heading="Bank-No"    
arschksu_month:check_reference /column=130/heading="Check-Reference"
arschksu_month:disposition /heading="Check-Status"
--arsdisp:description/noheading /duplicates 

sorted by arschksu_month:policy_no

top of page
"Program No.: arspr006"/left       
sfscompany:name[1]/center/newline 
"Checks to be Processed Report"/center/newline
L_starting_date/noheading/column=60/mask="MM/DD/YYYY"
" - "
l_ending_date/noheading/mask="MM/DD/YYYY"/newline
/*
end of arschksu_month:policy_no 

if total[arsbilling_a:installment_amount,arschksu_month:policy_no] =
   arschksu_month:check_amount and 
   arschksu_month:balance = arschksu_month:check_amount then
   {                     
       arschksu_month:policy_no /column=1/noheading
       arschksu_month:payor_type/column=11/noheading 
       arschksu_month:trans_date/column=13/noheading 
       arschksu_month:check_amount/column=25/noheading 
       total[arsbilling_a:installment_amount,arschksu_month:policy_no]/noheading
/mask="ZZ,ZZZ,ZZZ.99-"/column=40
       arschksu_month:balance/column=55/noheading 
       arschksu_month:check_no/column=80/noheading 
       arschksu_month:bank_no/column=100/noheading 
       arschksu_month:check_reference/column=130/noheading /mask="ZZZZZZZ"
       
}
*/
