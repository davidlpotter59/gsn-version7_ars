/*   arspr580

     September 28, 2004

     SCIPS.com

     List Cancellation Notice Register with Policy Number;
*/

description List Cancellation Notice Register with Policy Number;

include "startend.inc" 

string l_prog_number = "ARSPR580 - Version 4.50"

where arscancel:cx_eff_date => l_starting_date and 
      arscancel:cx_eff_date <= l_ending_date 

list
/nobanner 
/domain="arscancel" 
/title="Cancellation Notice Register"
/pagewidth=132
/duplicates 

arscancel:policy_no
arscancel:agent_no 
--arscancel:line_of_business 
--sfsline_heading:description
arscancel:due_date 
arscancel:cx_eff_date 
arscancel:amount_past_due/mask="(ZZZ,ZZZ,ZZZ.99)"/total 
trun (sfpname:name[1])/heading="Insured's-Name"

sorted by arscancel:line_of_business/newpage/total 
          arscancel:due_date/total/newlines/heading="Total for Due Date @"/count/mask=
"MM/DD/YYYY"  
          arscancel:policy_no 


include "reporttop.inc"
arscancel:line_of_business /heading="Line "
sfsline_heading:description/noheading/newline
