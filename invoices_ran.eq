/*  Invoices Ran

    July 8, 2014

    scips.com

   report to show invoices that ran on a date, which is billed date.

*/

Description 
To show items billed on selected day - will show what was invoiced that day;

define date l_starting_date = parameter/prompt=
"Please Enter Date they were ran on, if today then todays date : (MMDDYYYY) " default
todaysdate

where arsbilling:billed_date = l_starting_date 
and arsbilling:billing_ctr > 1

list
/nobanner
/domain="arsbilling"
/title="ARSBILLING - Innvoices ran on Billed date"
/pagewidth=255

policy_no trans_code billed_date due_date status billing_ctr


sorted by due_date 

top of page
"Report Number: Invoices by billed date"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")))/center
/newline
