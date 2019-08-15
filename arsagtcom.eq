/*  arsagtcom.eq

    SCIPS.com

    july 11, 2002

    print the Agents commissions, processed by month, including Experience Mod Bonus
*/

define wdate l_starting_date = parameter /prompt="Enter as of Date"

define unsigned ascii number l_month=month(l_starting_date)

where arsagtcom:paid_year = year(l_starting_date) 
list
/nobanner
/domain="arsagtcom"
/title="Agents Commission Detail Report"

arsagtcom:agent_no/heading="Agent" 
sfsagent:name[1]/noheading 
arsagtcom:premium[l_month]/heading="Premium-Processed" /total
arsagtcom:commission[l_month]/heading="Commission"/total
arsagtcom:experience_commission[l_month]/heading="Experience-Commission"/total
arsagtcom:commission[l_month] + arsagtcom:experience_commission[l_month]/heading="Total-Commission"/total 

sorted by arsagtcom:agent_no 

top of page 
"Arsagtcom"/column=1
"As of Date"/column=53/newline
trun(str(l_starting_date,"MM/DD/YYYY"))/center/newline 
