
include "startend.inc"    
signed ascii number l_amount_due = arsbilling:installment_amount - total_amount_paid - write_off_amount 

define file arscancela = access arscancel, set arscancel:company_id= arsbilling:company_id,
arscancel:policy_no= arsbilling:policy_no, generic, one to many  

define file sfscancela = access sfscancel, set sfscancel:company_id= arsbilling:company_id,
sfscancel:policy_no= arsbilling:policy_no, generic, one to many 

--where arsbilling:policy_no = 810100817
/* where arsbilling:due_date >= l_starting_date and
      arsbilling:due_date <= l_ending_date and
      arsbilling:status  one of "O" and
      arsbilling:bill_plan = "DB" 
*/
--where arsbilling:policy_no one of 810101028
list
/nobanner
/domain="arsbilling"
/title="arsbilling Audit Report"
/pagewidth=132
/duplicates                       
/nopageheadings 
--/nodetail 

arsbilling:company_id 
arsbilling:policy_no/heading="Policy-No"
--sfpname:name[1]/width=10/heading="Insured's-Name"
arsbilling:trans_date/heading="Trans-Date"
trans_eff
/* trans_code 
arsbilling:billed_date/heading="Billed-Date" 
arsbilling:due_date 
arsbilling:trans_code/heading="Trans-Code"    
arsbilling:status /heading="Billing-Status"
arsbilling:line_of_business/heading="Line"/duplicates 
*/
--arsbilling:lob_subline 
--arsbilling:comm_rate/nototal/heading="Comm-Rate"
--arsbilling:installment_amount/mask="ZZ,ZZZ,ZZZ.99-"/heading="Premium"   
arsbilling:installment_amount 
arsbilling:total_amount_paid 
--arspayplan:description 
--arsbilling:expansion 

sorted by --arsbilling:trans_date  
          --arsbilling:policy_no/newlines 
company_id policy_no 

top of page 
todaysdate/mask="MM/DD/YYYY"/newline=2

--end of policy_no 
--box
--/noblanklines /noheadings 
--arsbilling:policy_no 
--total[arsbilling:installment_amount,policy_no]
--total[l_amount_due,policy_no]/column=20  
--arscancela:policy_no  arscancela:cx_status 
--sfscancela:policy_no 
--xob
