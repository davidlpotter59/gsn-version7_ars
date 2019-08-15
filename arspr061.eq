/*  arspr061

    scips.com

    may 22, 2001

    agents commission statements
    processed not paid
    entire inforce is paid not individual installments

*/                  

include "fonts.var"

include "startend.inc"                                         

define string i_name[50]=sfpname:name[1]/raw

include "renaeq1.inc"

/*  need to calculate the prior period ytd amounts and
    therefor the date range has to be calculated 
*/

define unsigned ascii number l_months = month(l_starting_date) -1
define wdate l_starting_date_1 = dateadd(l_starting_date,-l_months)
define wdate l_ending_date_1 = dateadd(l_ending_date,-1)

define string l_report_title[50]="DIRECT BILL COMMISSION STATEMENT"
define string l_report_number[15]="ARSPR061" 

define date l_start_date =dateadd(01.01.0000,0,year(l_starting_date)) 
define date l_end_date = dateadd(l_ending_date,-1)            


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
((arsmaster:trans_date => l_start_date and
  arsmaster:trans_date <= l_end_date and
  arsmaster:trans_eff <= l_end_date) or
 (arsmaster:trans_date < l_start_date and
  arsmaster:trans_eff => l_start_date and
  arsmaster:trans_eff <= l_end_date)) then
  arsmaster:premium 
else
  0.00
          
define signed ascii number l_total_premium = l_prior_premium + 
l_current_premium

define signed ascii number l_comm = if arsmaster:trans_code not one of
18,19,28,29 then
(l_current_premium * (arsmaster:comm_rate * 0.01)) * 1.00 -- * 1.00 for rounding
else
0.00

define signed ascii number l_current_comm = 
(l_current_premium * (arsmaster:comm_rate * 0.01))

define signed ascii number l_current_advanced = 
if arsmaster:trans_eff > l_ending_date and
arsmaster:trans_date => l_starting_date and
arsmaster:trans_date <= l_ending_date then
l_comm 
else
0.00
      
define signed ascii number l_prior_comm = 
if ((arsmaster:trans_date => l_start_date and
  arsmaster:trans_date <= l_end_date and
  arsmaster:trans_eff <= l_end_date) or
 (arsmaster:trans_date < l_start_date and
  arsmaster:trans_eff => l_start_date and
  arsmaster:trans_eff <= l_end_date)) then
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
case 12, 13 : "Endorsement # " + str(sfppoint:end_sequence)
case 14     : "Renewal           "    
case 15     : "Audit Premium     "
case 16     : "Reinstatement     "
case 18,28  : "Installment Charge"
case 19,29  : "NJ Prem Tax       "
default     : "Transaction       " 

/*  setting access to the arsagtcom file obtain the YTD information */
define unsigned ascii number l_paid_year[4] = year (l_ending_date)
define unsigned ascii number l_month[4]     = month(l_ending_date) 
-- shows where the ytd calc should stop

define file arsagtcom_alt = access arsagtcom, set 
arsagtcom:company_id = arsmaster:company_id,
arsagtcom:agent_no   = arsmaster:agent_no,
arsagtcom:paid_year  = l_paid_year, exact 

define signed ascii number l_ytd_premium    = arsagtcom_alt:premium[13]
define signed ascii number l_ytd_commission = arsagtcom_alt:commission[13]
define signed ascii number l_ytd_net        = arsagtcom_alt:net[13]

where arsmaster:trans_code < 30 and -- direct business only
     (arsmaster:trans_code not one of 18, 19, 28, 29) -- installment charges
and 
 ((arsmaster:trans_date < l_start_date and
  arsmaster:trans_eff => l_start_date and
  arsmaster:trans_eff <= l_ending_date) or
 (arsmaster:trans_date => l_start_date and
  arsmaster:trans_date <= l_ending_date and
  arsmaster:trans_eff <= l_ending_date)) and 
arsmaster:bill_plan = "DB" -- added July 31, 2001 (DLP)
and arsmaster:agent_no = 126
list      
/nobanner
/domain="arsmaster"
/pagewidth=255
/pagelength=0
/nopageheadings  
/nodefaults 
/noheadings 
/noreporttotals 
/duplicates 
                        
box/noblanklines/maxlines=50/fixedbox 
/*  these are the calculations used to position the detail line
    characters per inch = 16.67
    720 decipoints divided by 16.67 = 44 decipoints per character
*/

--    l_courier_8  -- this is actually 16.67 characters per inch
    l_letter_gothic_bold_8  -- change made June 2, 2001 (DLP)
    ""/newline
    "<033>&a+0h-160V" -- 1.33 line spacing seems to work best
    "<033>&a400h+0V"
    arsmaster:trans_eff/mask="MM/DD/YYYY"/noheading
    ""/newline
    "<033>&a+0h-120V"
    "<033>&a920h+0V"
    i_rev_name/mask="X(30)"/noheading
    ""/newline
    "<033>&a+0h-120V"
    "<033>&a2460h+0V"               
    trun((sfsline:alpha) + " " + str(arsmaster:policy_no))
    ""/newline
    "<033>&a+0h-120V"
    "<033>&a3120h+0V"                   
    l_trans_type/noheading -- added 5/26/2001
    ""/newline             -- added 5/26/2001
    "<033>&a+0h-120V"      -- added 5/26/2001
    "<033>&a4000h+0V"       -- added 5/26/2001
    arsmaster:premium/mask="(ZZZ,ZZZ.99)"/noheading
    ""/newline
    "<033>&a+0h-120V"
    "<033>&a4616h+0V"
    arsmaster:comm_rate/nototal/mask="ZZ.ZZ"/noheading
    ""/newline
    "<033>&a+0h-120V"
    "<033>&a4924h+0V"
    (arsmaster:premium * (arsmaster:comm_rate * 0.01))/mask="(ZZ,ZZZ.99)"
--    l_comm/noheading/mask="(ZZ,ZZZ.99)"
end box

sorted by arsmaster:agent_no/newpage
          arsmaster:policy_no 
          arsmaster:trans_date 
            
top of page
l_reset 

l_arial/noheading 
""/newline
"<033>&a0h0V"  -- position cursor at the very top of the page

/* draw lines */
/*  draw verticle lines */
/* old settings 5/27/2001 
"<033>&a360h120V<033>*c5a2960b0P" -- left verticle line, entire length
""/newline
"<033>&a5460h120V<033>*c5a2960b0P" -- right verticle line, entire length
""/newline 
end of old settings
*/

"<033>&a360h120V<033>*c5a2860b0P" -- left verticle line, entire length
""/newline
"<033>&a5460h120V<033>*c5a2860b0P" -- right verticle line, entire length
""/newline 
                       
/* draw horizontal lines to complete box */
"<033>&a360h120V<033>*c5100h5v0P"  -- top horizontal line
""/newline
--"<033>&a360h7460V<033>*c5100h5v0P" -- bottom horizontal line
--""/newline
"<033>&a360h6980V<033>*c5110h5v0P" -- bottom horizontal line April 1, 2001
""/newline
--"<033>&a0h-120V"
--""/newline 

-- this line will force the cursor to return to the top left of the page
--"<033>&a0h0V"  -- position cursor at the very top of the page

/* end of line drawing */

/* print agents name and address */ 

--box/noblanklines/column=1/noheadings/line=1
l_arial/noheading
   "<033>&a360h300V"
   sfsagent:agent_no
   "<033>&a720h300V"
   sfsagent:name[1]  
   if sfsagent:name[2] <> "" then
   {
     "<033>&a720h+120V"
     sfsagent:name[2]
     ""/newline
     "<033>&a+0h-120V"
   }
   if sfsagent:name[3] <> "" then
   {
       "<033>&a720h+120V"
       sfsagent:name[3]
       ""/newline
       "<033>&a+0h-120V"
   }
""/newline
"<033>&a+0h-120V"
   if sfsagent:address[1] <> "" then
   {  
      "<033>&a720h+120V"
      sfsagent:address[1]
      ""/newline
      "<033>&a+0h-120V"
   }
""/newline
"<033>&a+0h-120V"
   if sfsagent:address[2] <> "" then
   {
      "<033>&a720h+120"
      sfsagent:address[2]
      ""/newline
      "<033>&a+0h-120V"
}
""/newline
"<033>&a+0h-120V"
   if sfsagent:address[3] = "" then
   {
      "<033>&a720h+120V"
      sfsagent:address[3]
      ""/newline
      "<033>&a+0h-120V"
   }                  
   ""/newline
   "<033>&a+0h-120V"
   "<033>&a720h+0V"
   trun(sfsagent:city) + ", " + trun(sfsagent:str_state) + " " + str(
sfsagent:zipcode)
    ""/newline
    "<033>&a+0h-120"
   
-- end box

/* print company name and address */
                  
l_arial/noheading 
"<033>&a2880h300V"

l_arial 
    ""/newline
    "<033>&a2880h300V"
    sfscompany:name[1]
    ""/newline
    "<033>&a2880h+0V"
    sfscompany:name[2]
    ""/newline
--    "<033>&a+0h-120V"
    "<033>&a2880h+0V"
    sfscompany:address[1]
    ""/newline
    "<033>&a+0h-120V"
    if sfscompany:address[2] <> "" then
    { 
       "<033>&a2880h+120V"
       sfscompany:address[2]
       ""/newline
       "<033>&a+0h-120V"
    }
""/newline
"<033>&a+0h-120V"
    if sfscompany:address[3] <> "" then
    {  
       "<033>&a2880h+120V"
       sfscompany:address[3]
       ""/newline
       "<033>&a+0h-120V"
    }             
    ""/newline
    "<033>&a2880h+0V"
    trun(sfscompany:city) + ", " + trun(sfscompany:str_state)
    sfscompany:zipcode/column=55
    ""/newline
    "<033>&a+0h-120V"

""/newline                   
l_arial_bold  
"<033>&a3000h+120V"
trun(l_report_title)/noheading 
l_arial             
""/newline
"<033>&a3300h+60V"
l_ending_date/heading="As of"/mask="M(15) D(2), Y(4)"
""/newline                                                                
"<033>&a360h-60V<033>*c5100h5v0P"  -- horizontal line under agent heading
""/newline 

-- column headings printed here
l_arial_8 
"<033>&a380h+0V"
"Effective"     
""/newline
"<033>&a+0h-120V"
"<033>&a1300h+0V"
"      Insured" 
""/newline
"<033>&a+0h-120V"
"<033>&a2560h+0V"
"Policy #"
""/newline
"<033>&a+0h-120V"
"<033>&a3160h+0V"
"Description"
""/newline
"<033>&a+0h-120V"
"<033>&a4150h+0V"
"Premium"
""/newline
"<033>&a+0h-120V"
"<033>&a4650h+0V"
"Rate"           
""/newline
"<033>&a+0h-120V"
"<033>&a4950h+0V"
"Commission"
"<033>&a+0h-120V"
""/newline
"<033>&a360h+60V<033>*c5100h5v0P"  -- horizontal line under detail headings
""/newline
"<033>&a0h1320V" -- places cursor at the beginnnig of the 1st detail line

/* print agent summary */
end of page      
l_arial 
""/newline                                                                
--"<033>&a360h6800V<033>*c5100h5v0P"  -- horizontal line under agent heading
--""/newline                                                                
"<033>&a360h6300V<033>*c5100h5v0P"  -- horizontal line under agent heading
""/newline 
"<033>&a+0h-120V"

l_arial 
"<033>&a360h6420V"
"Total Premium"  
""/newline
"<033>&a+0h-120V"      
"<033>&a1440h+0V"
"Commission"
""/newline
"<033>&a+0h-120V"
"<033>&a3600h+0V"
"TOTALS THIS MONTH"
""/newline
"<033>&a+0h-120V"
"<033>&a540h+120V"
"YTD"
""/newline
"<033>&a+0h-120V"
"<033>&a1600h+0V"
"YTD"
""/newline
"<033>&a+0h-120V"
"<033>&a3240h+0V"
"Premium"
""/newline
"<033>&a+0h-120V"
"<033>&a4320h+0V"
"Commission"
""/newline
"<033>&a+0h-120V"

l_courier/noheading
"<033>&a100h6660V"
--total[l_total_premium,arsmaster:agent_no]/mask="(ZZ,ZZZ,ZZZ.99)"
total[l_ytd_premium,arsmaster:agent_no]/mask="(ZZ,ZZZ,ZZZ.99)"
""/newline
"<033>&a+0h-120V"
"<033>&a1170h+0V"
--total[l_ytd_comm,arsmaster:agent_no]/mask="(Z,ZZZ,ZZZ.99)"
total[l_ytd_commission,arsmaster:agent_no]/mask="(Z,ZZZ,ZZZ.99)" 
""/newline
"<033>&a+0h-120V"
"<033>&a2795h+0V"
total[l_current_premium,arsmaster:agent_no]/mask="(ZZ,ZZZ,ZZZ.99)"
""/newline
"<033>&a+0h-120V"
"<033>&a3960h+0V"
total[l_comm,arsmaster:agent_no]/mask="(ZZ,ZZZ,ZZZ.99)"



 
