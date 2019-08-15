/*  arspr008a

    may 29, 2001

    scips.com

    program to print the A/R billing balance register

June 4, 2002  -  added transaction code 29 to report

*/

description A/R Transaction Code Dump from the ARSBILLING File ;

include "startend.inc"

where arsbilling:trans_date => l_starting_date and
      arsbilling:trans_date <= l_ending_date and
      arsbilling:return_check_ctr = 0 -- do not process return checks in this
                                      -- report
list
/nobanner
/domain="arsbilling"
/title="ARSBILLING File Daily Balancing Register - Transaction Code DUMP"
/pagewidth=255
/nodetail 

arsbilling:company_id 
arsbilling:policy_no 
arsbilling:due_date 
arsbilling:trans_code 
arsbilling:trans_date 
arsbilling:trans_eff 
arsbilling:trans_exp 
arsbilling:line_of_business 
arsbilling:lob_subline
arsbilling:comm_rate/duplicates 
arsbilling:agent_no 
arsbilling:bill_plan
arsbilling:payment_plan 
arsbilling:status 
arsbilling:installment_amount/total 
arsbilling:total_amount_paid/total
arsbilling:write_off_amount /total 
arsbilling:net_amount_due/total 

sorted by arsbilling:trans_code/newlines=2/total 
          arsbilling:company_id/newpage/total 
       --   arsbilling:policy_no/total 

top of page
"Report Number: arspr008a - Ver. 2.30"/left
trun(trun("Printed By:") + " " + trun(username))/right/newline
trun("Report Period:") + " " + (trun(str(l_starting_date,"MM/DD/YYYY")) + 
" - " + trun(str(l_ending_date
,"MM/DD/YYYY")))/center/newline
""/newline
arsbilling:trans_code/heading="Transaction Code"
