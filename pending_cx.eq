/* pending_cx.eq
  
   scips.com
   
   February 15, 2012

   pending cancellation report

*/

description
List all ARSCANCEL records that have a Cancellation run date < todaysdate - 0 ;

define date l_starting_date[ 8 ] = todaysdate;

define unsigned ascii number l_agent_no[4] = parameter
  
define string i_name[50] = sfpname:name[1]

include "renaeq1.inc"

where arscancel:cx_status one of "P" and
      arscancel:agent_no = l_agent_no 
list
/nobanner
/title="Pending Non-Pay Notices Sorted by Agent and Cx Effective Date - All Outstanding As of Run Date"
/domain="arscancel"
--/nopageheadings

  arscancel:policy_no/left/heading="Policy-Number"  
  include "renaeq2.inc"/heading="Insured's Name" 
  arscancel:trans_eff/heading="Policy-Effective-Date" 
  arscancel:exp_date/heading="Policy-Expiration-Date" 
  arscancel:line_of_business/heading="Line of-Business" 
  arscancel:payment_plan 
  arscancel:billing_ctr/heading="Installment-Number" 
  arscancel:due_date/heading="Original-Due-Date"
  arscancel:trans_date/heading="Non Pay-Run Date"
  arscancel:cx_eff_date/heading="Cancel-Effective-Date" 
  arscancel:amount_past_due/heading="Amount-Past-Due"

sorted by
  sfsagent:agent_no 
  arscancel:cx_eff_date
  month(arscancel:cx_date )
  arscancel:policy_no

top of page
  trun(sfscompany:name[1])/heading="Company Name"/column=1/newline
  trun(str(l_starting_date,"MM/DD/YYYY"))/heading="    Run Date"/column=1 /newline=2
  sfsagent:agent_no/heading="       Agent"
  sfsagent:name/noheading 

end of report
  ""/newline
  count[arscancel:policy_no]/heading="Total Non-Pays Outstanding"

;

