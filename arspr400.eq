/* arspr400

   October 27, 2001

   SCIPS.com, LLC

   Program to list the contents of the arsbilling file for a given
   policy number 
*/

description Accounts Receivable Billing Status Report ;

define unsigned ascii number l_policy_no=parameter/prompt="Enter Policy Number"/cls
error "Policy Number can not be zero " if l_policy_no = 0

define signed ascii number l_renewal_premium = if arsbilling:trans_code = 14 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_annual_premium = if arsbilling:trans_code = 10 then
arsbilling:installment_amount
else
0.00
        
define signed ascii number l_cancal_premium = if arsbilling:trans_code = 11 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_endorsement_premium = if arsbilling:trans_code one of 12, 13 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_reinstament_premium = if arsbilling:trans_code = 16 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_installment_charge = if arsbilling:trans_code one of 18, 28 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_sur_charge = if arsbilling:trans_code one of 19,22,23,29 then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_net_permium = l_annual_premium + l_endorsement_premium + l_cancal_premium +
l_renewal_premium + l_reinstament_premium + l_sur_charge + l_installment_charge 
                  
define signed ascii number l_amount_paid = arsbilling:total_amount_paid 

define signed ascii number l_write_off  = arsbilling:write_off_amount 

define signed ascii number l_balance_due = l_net_permium - (l_amount_paid + l_write_off)

define string l_program_no = "ARSPR400 - version 1.00.00"

where arsbilling:policy_no = l_policy_no 

list
/nobanner
/domain="arsbilling"  
/pagewidth=140
/nopageheadings 


trans_date/heading="Trans-Date"
arsbilling:trans_eff /heading="Eff-Date"
trans_exp/heading="Exp-Date"
trans_code /heading="Trans-Code"
line_of_business /heading="LOB"
comm_rate/heading="Comm-Rate" 
billing_ctr/heading="Installment-Number" 
installment_amount/heading="Invoice-Amount" 
total_amount_paid/heading="Amount-Paid"
write_off_amount/heading="Write-Off" 
status /heading="S-T"
billed_date/heading="Billed-Date" 
due_date/heading="Due-Date" 
printed 

sorted by arsbilling:policy_no
          arsbilling:due_date/newlines  

top of page
             
TODAYSDATE/COLUMN=1/MASK="MM/DD/YYYY"/heading="Date Printed"
trun(sfscompany:name[1])/noheading/Centre  
pagenumber/column=120/heading="Page"/mask="ZZ"/newline=2
username/column=1/heading="Printed By"
arsbilling:policy_no/heading="Status For"/column=55/newline=1
l_program_no/heading="Program "/newline=2/column=1

sfpname:name[1]/newline/noheading   
if sfpname:name[2]<>"" then
   sfpname:name[2]/noheading/newline
if sfpname:name[3]<>"" then
   sfpname:name[3]/noheading/newline

sfpname:address[1]/noheading/newline
if sfpname:address[2]<>"" then
   sfpname:address[2]/noheading/newline
if sfpname:address[3]<>"" then
   sfpname:address[3]/noheading/newline

trun(sfpname:city) + " ," + str_state + " " + str(zipcode)/newline=2         

/* end of arsbilling:policy_no 
""/newline 
"P A Y M E N T   I N F O R M A T I O N"/CENTER/NEWLINE=2
"Check Reference"/column=5
"Check Number"/column=30          
"Check Amount"/column=55
"Date Posted"/column=75 /newline=2
arspayment:check_reference /noheading/column=7
arspayment:check_number/noheading/column=33
arspayment:amount/noheading/column=53
arspayment:payment_trans_date/noheading/column=75
*/

end of report
""/newline=2
"                      TOTALS FOR POLICY          "/newline
total[l_annual_premium,arsbilling:policy_no]             /heading="Total Annual Premiums       "  
"   STATUS DEFINITIONS (S T)"/NEWLINE/column=65
total[l_renewal_premium,arsbilling:policy_no]            /heading="Total Renewal Premiums      "
" O - PERIOD HAS NOT BEEN BILLED 'OPEN'"/NEWLINE/column=50
total[l_cancal_premium,arsbilling:policy_no]             /heading="Total Cancellation Premiums "
" B - PERIOD HAS BEEN BILLED 'BILLED'"/NEWLINE/column=50
total[l_endorsement_premium,arsbilling:policy_no]        /heading="Total Endorsement Premiums  "
" P - PERIOD HAS BEEN PAID, ONLY FULL PAYMENTS 'PAID'"/NEWLINE/column=50
total[l_reinstament_premium,arsbilling:policy_no]        /heading="Total Reinstatement Premiums"
" C - PERIOD HAS BEEN CANCELLED 'CANCEL'"/NEWLINE/column=50
total[l_installment_charge,arsbilling:policy_no]         /heading="Total Installment Charges   "/newline
total[l_sur_charge,arsbilling:policy_no]                 /heading="Total Surchanges            "/newline=2
total[arsbilling:installment_amount,arsbilling:policy_no]/heading="Net Total All Transactions  "/newline=2
total[arsbilling:total_amount_paid, arsbilling:policy_no]/heading="Total Amount Received       "/newline=2 
total[arsbilling:write_off_amount,  arsbilling:policy_no]/heading="Total Write-offs            "/newline=2
total[l_balance_due,arsbilling:policy_no]                /heading="Net Due From Insured        "/newline=2
