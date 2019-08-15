/* arspr505.eq

   march 27, 2000

   scips.com

   prints d/b outstanding receivables by Policy Number - Advanced
                                                         
*/  
description Direct Bill Outstanding Receivalbes by Policy Number - Advanced;                                                     

define string l_report_title[28]="Direct Bill Aged Receivables"

define date l_as_of = parameter/cls/prompt="Enter As of Date"

define unsigned ascii number l_days_past = (l_as_of - arsbilling:due_date)

define signed ascii number l_days_mod = ((l_days_past div 31)) + 1
                     
define signed ascii number l_billed = if arsbilling:status = "B" then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_unbilled = if arsbilling:status <> "B" then
arsbilling:installment_amount 
else
0.00

define signed ascii number l_installment_charge = if arsbilling:trans_code = 
18 then l_billed else
0.00

define signed ascii number l_premium_fee = if arsbilling:trans_code = 19 then
l_billed
else
0.00

define signed ascii number l_total = l_billed + l_unbilled 

define signed ascii number l_billed_comm = l_billed * (arsbilling:comm_rate 
* 0.01) * 1.00 -- 1.00 to force rounding

define signed ascii number l_unbilled_comm = l_unbilled * (
arsbilling:comm_rate * 0.01) * 1.00 -- 1.00 to force rounding

define signed ascii number l_current = if l_days_mod =< 1 then
l_billed
else
0.00

define signed ascii number l_31_60 = if l_days_mod = 2 then
l_billed 
else
0.00

define signed ascii number l_61_90 = if l_days_mod = 3 then
l_billed
else
0.00

define signed ascii number l_91_plus = if l_days_mod = 4 then
l_billed 
else
0.00

define string l_printed_by ="Printed by: " + trun(username)

define string l_report_no = "ARSPR505"  

list
/nobanner
/domain="arsbilling"
/pagewidth=250
/nopageheadings
/nodetail

arsbilling:policy_no/column=1
arsbilling:trans_date/column=12
arsbilling:trans_eff/column=24
l_installment_charge/heading="Installment-Charges"/column=36
l_premium_fee/heading="Premium-Fees"/column=56
l_unbilled/heading="Total-Unbilled"/column=76
l_unbilled_comm/heading="Unbilled-Commission"/column=96
l_billed_comm/heading="Billed-Commission"/column=116
l_current/heading="0 to 30-Days Past"/column=136
l_31_60/heading="31 to 60-Days Past"/column=156
l_61_90/heading="61 to 90-Days Past"/column=176
l_91_plus/heading="91+ Days-Past" /column=196
l_billed/heading="Total-Billed"/column=216
            
sorted by arsbilling:policy_no 

top of report
include "report1.pro"             
l_printed_by/column=1/noheading
l_as_of/heading="As of "/column=97/newline=2/mask="M(15) D(2), Y(4)"

end of arsbilling:policy_no
arsbilling:policy_no/noheading/column=1
arsbilling:trans_date/noheading/column=12
arsbilling:trans_eff/noheading/column=24
total[l_installment_charge,arsbilling:policy_no]/column=36
total[l_premium_fee,arsbilling:policy_no]/column=56
total[l_unbilled,arsbilling:policy_no]/column=76
total[l_unbilled_comm,arsbilling:policy_no]/column=96
total[l_billed_comm,arsbilling:policy_no]/column=116
total[l_current,arsbilling:policy_no]/column=136
total[l_31_60,arsbilling:policy_no]/column=156
total[l_61_90,arsbilling:policy_no]/col=176
total[l_91_plus,arsbilling:policy_no]/column=196
total[l_billed,arsbilling:policy_no]/column=216
