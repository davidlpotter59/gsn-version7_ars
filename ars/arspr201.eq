/*  scips.com

    apspr201.eq

    january 11, 2002

    print the agents commission statements cash requirements report
*/

description Agents Commission Statements Cash Requirements Report ;

define wdate l_as_of = parameter/prompt="Enter The Accounting Date"

where apsagtck:process_month = month(l_as_of) and
      apsagtck:process_year  = year(l_as_of)

list
/nobanner
/domain="apsagtck"
/title="Agents Commission Check Cash Requirements Report"

apsagtck:agent_no
apsagtck:payee_name[1]
str(apsagtck:process_month) +"/" + str(apsagtck:process_year)/heading="Processing-Month/Year"
apsagtck:Check_date
apsagtck:Check_no 
apsagtck:check_amount 
apsagtck:release

sorted by apsagtck:agent_no

top of page
l_as_of/column=40/heading="As of"/newline=2/mask="MM/DD/YYYY"
