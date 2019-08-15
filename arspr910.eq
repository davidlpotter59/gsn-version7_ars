/*  arspr910

    scips.com

    april 11, 2001

    program to print direct bill reinstatement notices
    prints using pcl5 and cq programming
    can not be viewed in standard cq

major changes on 06/03/2001
 -- do not show amounts (transactions) billed instead reflect only
 -- transactions paid.  Using the arscancel file and arschksu the
 -- program will be able to print check #, check date (transaction date),
 -- "Payment, thank you !" for the description, due date is not 
 -- required at this point and amount due is now replaced by amount paid
*/

include "startend.inc"

define string I_name[50]=sfpname:name[1]/toggle;
define string i_Name_3[50]=arspayor:name[1]/toggle ;

define string l_agent_zipcode = str(sfsagent:zipcode,99999-9999)

include "renaeq1.inc"

define signed ascii number l_total_due = 
arscancel:amount_past_due  

define signed ascii number l_final_due = 0.00

include "fonts.var"

where arscancel:policy_no <> 0  -- just in case a 0 record was written
and   arscancel:cx_status = "R" -- if not reinstated then do not process
and  (arscancel:trans_date => l_starting_date and
      arscancel:trans_date <= l_ending_date)        
and arscancel:check_reference <> 0 -- if not paid then not reinstated

list
/nobanner
/domain="arscancel"
/nodefaults 
/nopageheadings 
/nodetail 
/notitle 
/pagelength=0
/pagewidth=255        
--/maxpages=5
      
sorted by arscancel:policy_no/newpage 
          arscancel:check_reference          
           
top of report 
l_reset  
l_simplex 

top of page    
/* print the Invoice Literal here */
""/newline
l_arial_italic_bold_16

"<033>&a1800h120V"
"REINSTATEMENT NOTICE"
""/newline 

/*  draw verticle lines */
"<033>&a360h120V<033>*c5a2952b0P" -- left verticle line, entire length
"<033>&a5460h120V<033>*c5a2952b0P" -- right verticle line, entire length
                       
/* draw horizontal lines to complete box */
"<033>&a360h120V<033>*c5100h5v0P"  -- top horizontal line
--"<033>&a360h7460V<033>*c5100h5v0P" -- bottom horizontal line
"<033>&a360h7200V<033>*c5100h5v0P" -- bottom horizontal line April 1, 2001

"<033>&a360h1260V<033>*c5100h5v0P" -- 1st line from top
"<033>&a360h1440V<033>*c5100h5v0P" -- 2nd line from top
"<033>&a360h1620V<033>*c5100h5v0P" -- 3rd line from top
"<033>&a360h5400V<033>*c5100h5v0P" -- 4th line from top

""/newline -- clear CQCS' buffer here

--"<033>&a360h5760V<033>*c180h5v0P" -- fold tick mark

/* position small verticle lines */
"<033>&a1060h1440V<033>*c5a75b0P" -- 1st verticle line on top
--"<033>&a900h1440V<033>*c5a75b0P"  -- 1st verticle line on top
"<033>&a1800h1440V<033>*c5a75b0P" -- 2nd verticle line on top
-- remove 3rd verticle line since due is not being printed 6/3/2001
-- "<033>&a3680h1440V<033>*c5a75b0P" -- 3rd verticle line on top
"<033>&a4660h1440V<033>*c5a75b0P" -- 4th verticle line on top

""/newline -- clear CQCS' buffer here

"<033>&a3132h5760V<033>*c2320h5v0P" -- bottom of pay this amount box
"<033>&a3132h5400V<033>*c5a150boP"  -- left hand line of pay this amount box

""/newline -- clear CQCS' buffer here

/* start of fixed literals */        
l_arial
--"<033>&a360h1410V"
"<033>&a3420h1110V"
"Policy Type:"
"<033>&a360h1410V"
"Run Date:"
"<033>&a2620h1410V"
"Payment Plan:"

""/newline -- clear CQCS' buffer here
"<033>&a360h1590V"
"Check No"
"<033>&a1260h+0V"
"Date"
"<033>&a2880h+0V"
"Description"
-- 6/3/2001 -- due date is not longer being printed
--"<033>&a+900h+0V"
--"Due Date"  
"<033>&a4680h+0V"
"Amount Paid"
-- "<033>&a360h1440V<033>*c2125a75b15g2P" -- shading changed 6/3/2001
"<033>&a360h1440V<033>*c2125a75b5g2P" -- shading
--++++
l_arial_bold_14
"<033>&a3200h5640V"
"Pay This Amount:" 

l_arial 
""/newline -- clear CQCS' buffer here

/* begin arscontrol literals */

"<033>&a560h5200V"
arscontrol:invoice_payto/noheading

"<033>&a2880h+0V"
arscontrol:invoice_company/noheading 

"<033>&a2880h+120V"
arscontrol:invoice_slogan/noheading 

"<033>&a360h5520V"
arscontrol:invoice_seperator/noheading 

""/newline -- clear CQCS' buffer here

"<033>&a2880h5940V"
arscontrol:invoice_payment_options/noheading 
                                      
l_arial_italic_12 
"<033>&a2880h+120V"
arscontrol:invoice_closing/noheading 
l_arial  

""/newline  -- clear CQCS' buffer here

/* this is the message lines, if any.  These were put here
   instead of in their actual order since this information
   may not be inserted. If no value is put in the field in
   arscontrol then this will not print  
*/

if arscontrol:invoice_message <> "" then
   {
--      "<033>&a720h3800V"
      "<033>&a720h4280V" -- changed 6/3/2001
      "Reinstatement Notice, Payment has been received.  Your policy is reinstated with" 
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      "no lapse in coverage unless payment by check is not honored and rejected by the"
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      "bank.  Then our cancellation notice already mailed to you continues to apply and"
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      "coverage terminates according to that notice. "
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      "Contact your agent at the address and phone number above for assistance."
      ""/newline
      "<033>&a+0h-120V"
      "<033>&a720h+120V"
      ""/newline
      
  }

/* print the company that is in the arscontrol file */

""/newline

l_arial 
"<033>&a360h5640V"
sfscompany:name[1]
"<033>&a360h+120V"
if sfscompany:name[2] <> "" then
{
  trun(sfscompany:name[2])/newline
  "<033>&a360h+0V"
}
if sfscompany:name[3] <> "" then
{
  trun(sfscompany:name[3])/newline
  "<033>&a360h+0V"
}                         
if sfscompany:address[1] <> "" then
{ 
  "<033>&a360h+0V"  
  trun(sfscompany:address[1])/newline
  "<033>&a360h+0V" 
}
if sfscompany:address[2] <> "" then 
{
 trun( sfscompany:address[2])/newline 
  "<033>&a360h+0V"
}
if sfscompany:address[3] <> "" then
{
  trun(sfscompany:address[3])/newline 
  "<033>&a360h+0V"
}          

""/newline 
"<033>&a360h-120V"
trun(sfscompany:city) + ", " + sfscompany:str_state 
sfscompany:zipcode/mask="99999-9999"/newline

""/newline -- clear CQCS' buffer now

/*  this is the end of the "NON" data portion of the invoice" */

top of arscancel:policy_no 

/* print insured's name and address */

l_arial_bold
"<033>&a460h240V"
"Insured"
l_arial 
""/newline
"<033>&a+0h-120V"
"<033>&a360h+120V"
trun(sfsline:alpha + str(arscancel:policy_no))/noheading

--l_arial_8            
""/newline
"<033>&a360h+0V"
i_rev_name/noheading 
  
""/newline
"<033>&a+0h-120V"

if sfpname:name[2] <> "" then 
{                 
    ""/newline
    "<033>&a360h+0V"
    sfpname:name[2]/noheading 
}                 

""/newline
"<033>&a+0h-120V"

if sfpname:name[3] <> "" then
{
    ""/newline
    "<033>&a360h+0V"
    sfpname:name[3]
}

""/newline
"<033>&a+0h-120V"

if sfpname:address[1] <> "" then
{
    ""/newline
    "<033>&a360h+0V"
    sfpname:address[1]
}

""/newline
"<033>&a+0h-120V"

if sfpname:address[2] <> "" then
{
    ""/newline
    "<033>&a360h+0V"
    sfpname:address[2]
}

""/newline
"<033>&a+0h-120V"

if sfpname:address[3] <> "" then
{
    ""/newline
    "<033>&a360h+0V"
    sfpname:address[3]
}

""/newline
"<033>&a360h+0V"

trun(sfpname:city + ", " + sfpname:str_state)/noheading 
--if sfpname:zipcode[1,4]=0000 then
--    sfpname:zipcode[5,9]
--else
    sfpname:str_zipcode/mask="XXXXX-XXXX"

/* end of Policy Name and Address Information */

""/newline  -- clear CQCS' buffer here

/*  Print Agents name, address and Phone Number */

l_arial_bold
"<033>&a3520h240V"
"Agent: "            
sfsagent:agent_no/mask="ZZZZ"
l_arial
""/newline
"<033>&a+0h-120V"

"<033>&a3420h+120V"


sfsagent:name[1]/noheading

"<033>&a3420h+120V"

if sfsagent:name[2] <> "" then
{
    sfsagent:name[2]/noheading 
}
else
{
    sfsagent:address[1]/noheading 
}

"<033>&a3420h+120V"
if sfsagent:name[2] <> "" then
{
    sfsagent:address[1]/noheading 
}
else
{
    trun(sfsagent:city + ", " + sfsagent:str_state)/noheading 
    sfsagent:zipcode
}

"<033>&a3420h+120V"
if sfsagent:name[2] <> "" then
{
   trun(sfsagent:city + " " + sfsagent:str_state)/noheading
/* if sfsagent:zipcode[1,4]=0000 then
sfsagent:zipcode[5,9] 
else
sfsagent:zipcode/mask="99999-9999"
*/
l_agent_zipcode

--   sfsagent:zipcode/noheading 
}
else
{   
   sfsagent:telephone[1]/noheading 
}

"<033>&a3420h+120V"
if sfsagent:name[2] <> "" then
{
    sfsagent:telephone[1]/noheading 
}
                   
/* end of Agent name and address */

""/newline  -- clear CQCS' buffer now
            
/* various other information */

""/newline
l_arial 
"<033>&a3420h1230V"
sfsline:description/noheading 

"<033>&a972h1410V"
todaysdate/mask="MM/DD/YYYY"/noheading 

"<033>&a+1900h+0V"
arspayplan:description/noheading 
             
""/newline --  clear CQCS' buffer here
"<033>&a360h1540V"

-- *******************************************
-- ***  added this end of stmt 3/14/2001   ***
-- ***  each prscode description should    ***
-- ***  print independent of eachother     ***
-- *******************************************

end of arscancel:check_reference 
--"<033>&a360h1740V"
-- courier
--"<033>(s0p12h12v0s0b3T"
-- l_courier -- changed 6/3/2001
l_letter_gothic_12

"<033>&a360h+60V"
arschksu:check_no/noheading
"<033>&a1080h+0V"
arschksu:trans_date/noheading/mask="MM/DD/YYYY"
"<033>&a2160h+0V"
"  Payment - Thank you !"
--"<033>&a3780h+0V"
--arscancel:due_date/noheading/mask="MM/DD/YYYY"
"<033>&a4636h+0V"

arschksu:check_amount/width=11/noheading/mask="$ZZ,ZZZ.99-"
/newline 
--arscancel:installment_amount/noheading/mask="ZZZ,ZZZ.99-"/newline

""/newline  -- clear CQCS' buffer here
"<033>&a360h-120V"

end of arscancel:policy_no 
--l_arial_bold_12 -- changed 6/3/2001 to letter gothic fixed font
l_letter_gothic_bold_12
  
/* remove the total line since the check line already
   has the check total printed
*/
"<033>&a2380h+120V"
--"Total Paid "
-- "<033>&a4700h+0V" changed 6/3/2001 to work with letter gothic
--"<033>&a4636h+0V"
--total[l_total_due,arscancel:policy_no]/noheading/mask="$ZZ,ZZZ.99-"
--total[arscancel:installment_amount,arscancel:policy_no]/noheading/mask=
--"$$Z,ZZZ.99-"
"<033>&a2380h+360V"

l_arial     

""/newline -- clear CQCS' buffer here

/* invoice polname name information 
   print insured's name and address */

l_arial 
""/newline

-- "<033>&a360h6530V"  -- changed 6/3/2001 to put pol # above name
"<033>&a480h6290V" 
trun(sfsline:alpha) + str(arspayor:policy_no)/noheading         
""/newline
"<033>&a480h+0V"
trun(i_name_3[(pos("=",i_name_3)+1),
    len(i_name_3)])+" "+trun(I_name_3[0,(pos("=",i_name_3) -1)])
"<033>&a480h+0V"
--trun(arspayor:name[1])
""/newline
"<033>&a480h-30V"

if arspayor:name[2] <> "" then
{
"<033>&a480h+0V"
trun(arspayor:name[2])
""/newline
"<033>&a480h-30V"
}
 
if arspayor:name[3] <> "" then
{
"<033>&a480h+0V"
trun(arspayor:name[3])
""/newline
"<033>&a480h-30V"
}

if arspayor:address[1] <> "" then
{      
"<033>&a480h+0V"
trun(arspayor:address[1])
""/newline
"<033>&a480h-30V"
}
           
""/newline
"<033>&a480h-120V"

if arspayor:address[2] <> "" then
{
"<033>&a480h+0V"
trun(arspayor:address[2])
""/newline
"<033>&a480h-30V"
}

if arspayor:address[3] <> "" then
{
"<033>&a480h+0V"
trun(arspayor:address[3])
""/newline
"<033>&a480h-30V"
}
""/newline
"<033>&a480h-120V"
trun(arspayor:city) + ", " + arspayor:str_state
trun(arspayor:str_zipcode)/mask="XXXXX-XXXX"
                                                      
/* end of Policy Name and Address Information */

"<033>&a360h6300V" -- placing this here to put the cursor back to where it
                   -- started from

""/newline  -- clear CQCS' buffer here

/* print the amount due */
            
l_arial_bold_14 
""/newline
"<033>&a4560h5640V"
/* if this notice is printing then the balance must be 0, so assume 
   that the total amount due is not 0.00 */
-- total[l_total_due,arscancel:policy_no]/mask="$ZZ,ZZZ.99-"/noheading 
total[l_final_due,arscancel:policy_no]/mask="$ZZ,ZZZ.99-"/noheading 


""/newline  --  clear CQCS' buffer here
