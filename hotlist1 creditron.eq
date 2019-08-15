--hostlist 1

 

description List all ARSCANCEL records that have a Cancellation run date < todaysdate - 2 ;

 

where arscancel:cx_eff_date <= (todaysdate - 2) and

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
