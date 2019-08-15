/*  arspr052

    scips.com

    September 3, 2001

    report to print the monthly audit premiums current period and
    year to date. 

*/

include "startend.inc"
   
define string l_report_title[50]="Monthly Audit - Premiums Processed"   
define string l_report_number[15]="ARSPR052" 

define string l_policy_no = trun(trun(sfsline:alpha)+str(arsmaster:policy_no))

/* do not include transaction codes 18 (installment fees) and 19 (Premium fees) in the
   commission calculation.  Agents do not get paid on these items) */

define signed ascii number l_comm = if arsmaster:trans_code <> 18 and 
arsmaster:trans_code <> 19 then
(arsmaster:premium * (arsmaster:comm_rate * 0.01)) * 1.00 -- * 1.00 for rounding
else
0.00

define date l_start_date =dateadd(01.01.0000,0,year(l_starting_date)) 

define date l_end_date = dateadd(l_ending_date,-1)            

define signed ascii number l_current_comm = if arsmaster:trans_eff <= l_ending_date and
arsmaster:trans_date => l_starting_date and
arsmaster:trans_date <= l_ending_date then 
l_comm 
else
if arsmaster:trans_eff <= l_ending_date and
arsmaster:trans_date < l_starting_date then
l_comm 
else
0.00

define signed ascii number l_current_advanced = if arsmaster:trans_eff > l_ending_date and
arsmaster:trans_date => l_starting_date and
arsmaster:trans_date <= l_ending_date then
l_comm 
else
0.00
      
define signed ascii number l_prior_comm = if arsmaster:trans_date => l_start_date and
arsmaster:trans_date <= l_end_date and
arsmaster:trans_eff <= l_end_date then
l_comm 
else
0.00                               

define signed ascii number l_prior_advanced = if arsmaster:trans_date => l_start_date and
arsmaster:trans_date <= l_end_date and
arsmaster:trans_eff > l_end_date then
l_comm
else
0.00

define signed ascii number l_ytd_comm = l_prior_comm + l_current_comm + l_current_advanced + l_prior_advanced 
define signed ascii number l_net_ytd_comm = l_prior_comm + l_current_comm + l_prior_advanced 

define signed ascii number l_installment_charge = if arsmaster:trans_code 
one of 18, 28 then  arsmaster:premium
else
0.00
                
define signed ascii number l_cancel    = if arsmaster:trans_code one of
11 then prsmaster:premium 
else
0.00

define signed ascii number l_surcharge = if arsmaster:trans_code one of
19, 29 then arsmaster:premium 
else
0.00

define signed ascii number l_annual = if arsmaster:trans_code one of
10 then arsmaster:premium
else 
0.00

define signed ascii number l_endorsement = if arsmaster:trans_code one of
12, 13 then arsmaster:premium
else
0.00

define signed ascii number l_renewal = if arsmaster:trans_code one of 14 then
arsmaster:premium 
else
0.00

define signed ascii number l_reinstate = if arsmaster:trans_code one of 16 
then arsmaster:premium 
else
0.00
 
where arsmaster:trans_code < 30 -- direct business only
list      
/nobanner
/domain="arsmaster"
/pagewidth=255         
/nopageheadings 

arsmaster:policy_no
--l_policy_no /heading="Policy-Number"/duplicates 
sfpname:name[1]/heading="Insured's-Name"/width=10/duplicates   
sfsagent:name[1]/heading="Agent"/width=20/duplicates 
arsmaster:trans_date
arsmaster:trans_code /nototal/heading="Transaction-Code " 
arsmaster:trans_eff
arsmaster:comm_rate/nototal 
arsmaster:premium/total
l_current_comm/heading="Current-Period-Commission"  
l_current_advanced/heading="Current-Advanced-Commission"                   
l_prior_comm/heading="Prior-Period-Commission" 
l_prior_advanced/heading="Prior-Advanced-Commission"
l_ytd_comm/heading="Year to Date-Commission " 
l_net_ytd_comm /heading="Year to Date-Net Commission "   
                                    
sorted by arsmaster:company_id   
          arsmaster:trans_code/total/newlines 
                
top of page
include "report.pro"                
"For the Period:"/column=95
l_starting_date/noheading/column=120/mask="MM/DD/YYYY"
" - "/column=132
l_ending_date/noheading/column=135/newline=2/mask="MM/DD/YYYY"

end of report
""/newpage 
l_report_number /column=30/heading="Report Number"/newline=2
"TOTALS for Current Period"/newline=2/column=30
trun(str(l_start_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY")
)/column=30/newline=2
total[l_annual]     /column=25/heading="Annual Premium    "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[l_endorsement]/column=25/heading="Endorsements      "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[l_cancel]     /column=25/heading="Cancellations     "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[l_renewal]    /column=25/heading="Renewals          "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2                                              
total[l_reinstate]         /column=25/heading="Reinstatements    "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[l_installment_charge]/column=25/heading="Installment Charge"/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[l_surcharge]         /column=25/heading="Surcharges        "/mask=
"($ZZ,ZZZ,ZZZ.99)"/newline=2
total[arsmaster:premium ]  /column=25/heading="     GRAND TOTAL  "/mask=
"($ZZ,ZZZ,ZZZ.99)"         
