/*  arspr905.eq

    june 3, 2001

    scips.com

    report to print the "P" pending cancellations for a date range
    selected by the user
*/

include "startend.inc"
define string l_report_name[10]="arspr905"

where arscancel:trans_date => l_starting_date and
      arscancel:trans_date <= L_ending_date and
      arscancel:cx_status = "P"  -- pending only

list
/nobanner
/domain="arscancel"
/title="Pending Cancellations Audit Report"
/nodetail

arscancel:policy_no/column=1
arscancel:trans_code /column=12/heading="Trans-Code"
arscancel:trans_date /column=17/heading="Trans-Date"
arscancel:trans_eff /column=31/heading="Trans-Eff"
arscancel:cx_eff_date /column=45/heading="CX Eff-Date"
arscancel:due_date  /column=59/heading="Due-Date"
arscancel:amount_past_due /column=74/heading="Amount-Due"

sorted by arscancel:policy_no

top of report
l_report_name/left
l_starting_date/noheading/mask="MM/DD/YYYY"/column=30
" - "/column=41
l_ending_date/noheading/mask="MM/DD/YYYY"/column=44/newline=2
sfscompany:name[1]/noheading/column=31/newline=2

end of arscancel:policy_no 
    arscancel:policy_no/column=1/noheading 
    arscancel:trans_code /column=12/noheading 
    arscancel:trans_date /column=17/noheading 
    arscancel:trans_eff /column=31/noheading 
    arscancel:cx_eff_date /column=45/noheading 
    arscancel:due_date  /column=59/noheading 
    total[arscancel:amount_past_due,arscancel:policy_no]/mask=
"(ZZZ,ZZZ,ZZZ.99)" /column=74/noheading 

end of report
""/newline                                                            
    "Total For Period "/column=45
    total[arscancel:amount_past_due]/mask="(ZZZ,ZZZ,ZZZ.99)"/noheading/column=74
