/*  arspr202.eq
                   
    November 3, 2002
  
    SCIPS.com, Inc. 

    List Payments recieved by Agent and Policy number within 
    a starting and ending date range

11/27/2002 - added insured's name - DLP

*/

description 
List payments received by Agent and Policy number with a date range ;

include "startend.inc"

define file sfsagent1 = access sfsagent, 
                           set sfsagent:company_id = arschksu:company_id,
                               sfsagent:agent_no   = sfpname:agent_no, many to one, exact 

where arschksu:trans_date >= l_starting_date and 
      arschksu:trans_date <= l_ending_date and
      arschksu:policy_no  <> 0 -- no applications just policies
list
/nobanner
/domain="arschksu"
/title="Cash Processed by Agent"
/pagewidth=132

arschksu:policy_no /heading="Policy-Number"/column=1
sfpname:name[1]/noheading/column=15/width=30
arschksu:trans_date/heading="Date-Processed"/column=50
arschksu:check_no/heading="Check-No."/column=65
arschksu:check_amount/heading="Amount"/column=80

sorted by sfpname:agent_no /newpage
          arschksu:policy_no 

top of page
"Cash Received Dates"/column=43/newline
l_starting_date/column=40/noheading/mask="MM/DD/YYYY" 
" - "
l_ending_date/noheading/newline=2/mask="MM/DD/YYYY"

sfsagent1:agent_no/noheading /column=1
sfsagent1:name[1]/column=6/noheading /newline 
if sfsagent1:name[2] <> "" then 
{
   sfsagent1:name[2]/column=6/noheading/newline
}
if sfsagent1:name[3] <> "" then 
{
   sfsagent1:name[3]/column=6/noheading/newline
}                 
if sfsagent1:address[1] <> "" then 
{
   sfsagent1:address[1]/column=6/noheading/newline
}
if sfsagent1:address[2] <> "" then 
{
   sfsagent1:address[2]/column=6/noheading/newline
}
if sfsagent1:address[3] <> "" then 
{
   sfsagent1:address[3]/column=6/noheading/newline
}
(trun(sfsagent1:city)+", "+trun(sfsagent1:str_state))+ " " +
str(sfsagent1:zipcode,"99999-9999")/newline=2/noheading /column=6
                               
end of sfpname:agent_no                                
""/newline=2
"TOTAL FOR AGENT"/column=30
total[arschksu:check_amount,sfpname:agent_no]/column=44/mask=
"ZZ,ZZZ,ZZZ.99-"/noheading 
