/* arspr600a

   may 17, 2004

   SCIPS.com, Inc.

   Archive - report to print the advanced cash received within date ranges
*/

description  
Archive Report to print the advanced cash received within date ranges - Will not print declined Application Deposits;

include "startend.inc"

define unsigned ascii number l_month[2]=month(arschksu_month:trans_eff) 
define string l_prog_number = "ARSPR600 - Version 4.10"

where ((arschksu_month:trans_date >= l_starting_date 
and   arschksu_month:trans_date <= l_ending_date 
and   arschksu_month:trans_eff   > l_ending_date ) 
or arschksu_month:policy_no one of 0)
and arschksu_month:disposition not one of "DCLND"
and arschksu_month:check_reference > 0
and (arschksu_month:posted_date >= l_starting_date and 
     arschksu_month:posted_date <= l_ending_date)

list
/nobanner
/domain="Arschksu"
/title="Advanced Cash Received"

if arschksu_month:policy_no one of 0 then 
{
"APPLICATION"/column=1 
str(arschksu_month:check_reference)/column=15
}
else
{
arschksu_month:policy_no    /column=1/noheading 
}
arschksu_month:trans_date   /heading="Processed-Date"/column=20
arschksu_month:trans_eff    /heading="Effective-Date"/column=35
arschksu_month:check_amount /heading="Check-Amount"/column=50/total 
arschksu_month:balance      /heading="Check-Balance" /column=65/total 

sorted by year(arschksu_month:trans_eff)/newpage/total/heading="Year @"
          l_month/total/heading="Month @"
          arschksu_month:policy_no 

include "reporttop.inc"
""/newline
Year(arschksu_month:trans_eff)/heading="Cash Received For Year "/newline/centre

top of l_month 
""/newline 
trun(str(l_month)+"/"+str(year(arschksu_month:trans_eff)))/heading="Cash Received for Effective Month"
""/newline
