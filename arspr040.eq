/*   arspr040

     SCIPS.com, Inc

     February 13, 2003

     Lists payments received by received date and type (transaction code) 
*/

description List payments received by payment transaction date and transaction description ;

include "startend.inc"        

define string l_type = arscode:description 

where arspayment:payment_trans_date >= l_starting_date and
      arspayment:payment_trans_date <= l_ending_date  and
      arspayment:amount <> 0

list
/nobanner
/domain="arspayment" 
/title="Payments Received by Transaction Description"
/pagewidth=150
/pagelength=50
/nototals 

arspayment:policy_no/column=1 
arspayment:trans_date /column=15
arspayment:trans_eff /column=30
arspayment:trans_code /column=45
arspayment:amount/total  /column=50 
arspayment:check_number/width=10 /column=70
arspayment:check_reference /column=85
arspayment:payment_trans_date/column=105   
arschksu:balance/total /column=120
arschksu:posted_date/column=135

sorted by arschksu:posted_date/total  
          l_type/newpage 
          arspayment:trans_date/newlines
                               

top of page 
"Report No.: arspr040"/column=1/newline=2                      
"Date Range"/column=62/newline
str(l_starting_date,"MM/DD/YYYY") + " - " + str(l_ending_date,"MM/DD/YYYY")/col=55/newline=2
l_type /heading="Transaction Type"
                                    

end of l_type 
""/newline                      
l_type/heading="Total for Type"
total[arspayment:amount, l_type]/column=50
total[arschksu:balance, l_type]/column=50

end of arspayment:trans_date 
""/newline
"Transaction Date Total"                   
total[arspayment:amount, arspayment:trans_date]/column=50
--total[arschksu:balance, arspayment:trans_date]/column=50
