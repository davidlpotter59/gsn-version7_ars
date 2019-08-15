/*  arspr551 

    July 18, 2006

    SCIPS.com, Inc.

    program to list all arscancel records that have a cx run date < todaysdate - 3

    the purpose of this program to print all arscancel records that have been

    created and have yet to be cancelled

*/

description List all ARSCANCEL records that have a Cancellation run date < todaysdate - 3 ;

where arscancel:cx_eff_date <= (todaysdate - 3) and
      arscancel:cx_status one of "P" 

list
/nobanner
/nopageheadings 
/pagelength= 0
/noheadings 
/notitle 
/domain="arscancel"

  arscancel:policy_no/mask="999999999"  
 
sorted by            
  arscancel:policy_no
