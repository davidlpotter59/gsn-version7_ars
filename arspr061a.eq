/*  arspr061

    scips.com

    june 11, 2001

    agents commission work file creation
    processed not paid
    entire inforce is paid not individual installments
    creates output file arscomwrk.cq that arsup061 will use
    to update the arsagtcom data file

*/                  

include "startend.inc"                                         

define string i_name[50]=sfpname:name[1]/raw

include "renaeq1.inc"

/*  need to calculate the prior period ytd amounts and
    therefor the date range has to be calculated 
*/

define unsigned ascii number l_months = month(l_starting_date) -1
define wdate l_starting_date_1 = dateadd(l_starting_date,-l_months)
define wdate l_ending_date_1 = dateadd(l_ending_date,-1)

define string l_policy_no = trun(trun(sfsline:alpha)+str(arsmaster:policy_no))

/* do not include transaction codes 18 (installment fees) and 19 (Premium fees) in the
   commission calculation.  Agents do not get paid on these items) */
       
define signed ascii number l_current_premium = if
((arsmaster:trans_date < l_starting_date and
  arsmaster:trans_eff => l_starting_date and
  arsmaster:trans_eff <= l_ending_date) or
 (arsmaster:trans_date => l_starting_date and
  arsmaster:trans_date <= l_ending_date and
  arsmaster:trans_eff <= l_ending_date)) then
  arsmaster:premium 
else
  0.00

define signed ascii number l_prior_premium = if
((arsmaster:trans_date < l_starting_date_1 and
  arsmaster:trans_eff  => l_starting_date_1 and
  arsmaster:trans_eff <= l_ending_date_1) or
 (arsmaster:trans_date => l_starting_date_1 and
  arsmaster:trans_date <= l_ending_date_1 and
  arsmaster:trans_eff < l_starting_date_1)) then
  arsmaster:premium 
else
  0.00
          
define signed ascii number l_total_premium = l_prior_premium + 
l_current_premium

define signed ascii number l_comm = if arsmaster:trans_code <> 18 and 
arsmaster:trans_code <> 19 then
(arsmaster:premium * (arsmaster:comm_rate * 0.01)) * 1.00 -- * 1.00 for rounding
else
0.00

define date l_start_date =dateadd(01.01.0000,0,year(l_starting_date)) 

define date l_end_date = dateadd(l_ending_date,-1)            

/* define signed ascii number l_current_comm = if 
arsmaster:trans_eff <= l_ending_date and
arsmaster:trans_date => l_starting_date and
arsmaster:trans_date <= l_ending_date then 
l_comm 
else
0.00
*/

define signed ascii number l_current_comm = 
(l_current_premium * (arsmaster:comm_rate * 0.01))

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

define signed ascii number l_ytd_comm = l_prior_comm + l_current_comm 
define signed ascii number l_net_ytd_comm = l_prior_comm + l_current_comm + l_prior_advanced 

define string l_trans_type[18] = switch(arsmaster:trans_code)
case 10     : "New Policy        "
case 11     : "Cancellation      "
--case 12, 13 : "Endorsement       "                       
-- this change was made per Jim D. on May 30, 2001
case 12, 13 : "Endorsement # " + str(sfppoint:end_sequence)
case 14     : "Renewal           "    
case 15     : "Audit Premium     "
case 16     : "Reinstatement     "
case 18     : "Installment Charge"
case 19     : "NJ Prem Tax       "
default     : "Transaction       " 

define unsigned ascii number l_year = year(l_ending_date)
define unsigned ascii number l_month = month(l_ending_date)

where arsmaster:trans_code < 30 and -- direct business only
      arsmaster:trans_code not one of 18,19,28,29 and  -- installment charges
    ((arsmaster:trans_date < l_starting_date and
      arsmaster:trans_eff => l_starting_date and
      arsmaster:trans_eff <= l_ending_date) or
     (arsmaster:trans_date => l_starting_date and
      arsmaster:trans_date <= l_ending_date and
      arsmaster:trans_eff <= l_ending_date)) and
      arsmaster:bill_plan = "DB" -- added july 31, 2001 (DLP)
--and policy_no = 810100623
list      
/nobanner
/domain="arsmaster"
/pagewidth=255
/pagelength=0
/nopageheadings  
/nodefaults 
/noheadings 
/noreporttotals 
--/nodetail

--arsmaster:policy_no arsmaster:trans_date arsmaster:trans_eff 
--premium l_current_comm /total 
                        

--end of arsmaster:agent_no 
arsmaster:company_id/column=1/width=10/mask="X(10)"/noheading
arsmaster:policy_no/column=11/width=9/mask="999999999"/noheading
arsmaster:trans_date/column=20/width=8/mask="MMDDYYYY"/noheading 
arsmaster:trans_eff/column=28/width=8/mask="MMDDYYYY"/noheading
arsmaster:trans_exp/column=36/width=8/mask="MMDDYYYY"/noheading 
arsmaster:trans_code/column=44/width=4/mask="9999"/noheading 
arsmaster:line_of_business/column=48/mask="9999"/noheading 
arsmaster:comm_rate/column=52/mask="999."/noheading 
arsmaster:premium/column=56/mask="-999999.99"/noheading 
l_current_comm/column=66/mask="-999999.99"/noheading 
arsmaster:agent_no/column=76/mask="9999"/noheading 

sorted by arsmaster:agent_no
