/* arsbilling_dump

   October 27, 2001

   SCIPS.com, LLC

   Program to list the contents of the arsbilling file for a given
   policy number 
*/

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

where arsbilling:policy_no = l_policy_no 

list
/nobanner
/domain="arsbilling"  
/pagewidth=132
/nopageheadings 



trans_date
arsbilling:trans_eff 
trans_exp
trans_code 
line_of_business 
comm_rate 
billing_ctr

--return_check_ctr   
installment_amount
status 
due_date 

sorted by arsbilling:policy_no
          arsbilling:due_date/newlines  

top of page
             
TODAYSDATE/COLUMN=1/MASK="MM/DD/YYYY"/heading="Date Printed"
trun(sfscompany:name[1])/noheading/CENTER 
pagenumber/column=125/heading="Page"/mask="ZZ"/newline=2
username/column=1/heading="Printed By"
arsbilling:policy_no/heading="Status For"/column=61/newline=2

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

end of report
""/newline=2
"                      TOTALS FOR POLICY          "/newline
total[l_annual_premium,arsbilling:policy_no]             /heading="Total Annual Premiums       "/newline
total[l_renewal_premium,arsbilling:policy_no]            /heading="Total Renewal Premiums      "/newline 
total[l_cancal_premium,arsbilling:policy_no]             /heading="Total Cancellation Premiums "/newline
total[l_endorsement_premium,arsbilling:policy_no]        /heading="Total Endorsement Premiums  "/newline 
total[l_reinstament_premium,arsbilling:policy_no]        /heading="Total Reinstatement Premiums"/newline
total[l_installment_charge,arsbilling:policy_no]         /heading="Total Installment Charges   "/newline
total[l_sur_charge,arsbilling:policy_no]                 /heading="Total Surchanges            "/newline=2
total[arsbilling:installment_amount,arsbilling:policy_no]/heading="Net Total All Transactions  "/newline=2

"   STATUS DEFINITIONS"/NEWLINE
" O - PERIOD HAS NOT BEEN BILLED 'OPEN'"/NEWLINE
" B - PERIOD HAS BEEN BILLED 'BILLED'"/NEWLINE 
" P - PERIOD HAS BEEN PAID, ONLY FULL PAYMENTS 'PAID'"/NEWLINE
" C - PERIDO HAS BEEN CANCELLED 'CANCEL'"/NEWLINE 
