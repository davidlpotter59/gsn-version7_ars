/*  arspayplan

    november 4, 2002

    SCIPS.com, Inc.

    program to list payment plan options by line of business */

description List Payment Plan Options by Line of Business ;

list
/nobanner
/domain="arspayplan"
--/nodefaults 
--/nopageheadings 
/pagewidth=80

"D I S T R I B U T I O N"/center/newline=2  
box
distribution[1]/noheading/column=10
distribution[2]/noheading/column=20
distribution[3]/noheading/column=30
distribution[4]/noheading/column=40 
distribution[5]/noheading/column=50 
distribution[6]/noheading/column=60 /newline
distribution[7]/noheading/column=10 
distribution[8]/noheading/column=20 
distribution[9]/noheading/column=30 
distribution[10]/noheading/column=40 
distribution[11]/noheading/column=50 
distribution[12]/noheading/column=60/newline=2
xob /newlines=2

arspayplan:installment_charge_type/column=1 /heading="Type"
arspayplan:installment_charge_time/column=40/heading="Frequency"
arspayplan:installment_charge_rate/column=60/heading="Rate"/newline
arspayplan:minimum_premium/column=1/heading="Minimum Premium"
arspayplan:invoice_days_between/column=40/heading="Days Between Installments"
/newline/mask="ZZZZ"
arspayplan:installment_months_between/column=1/heading=
"Months Between Installments"/mask="ZZZZ"

sorted by arspayplan:line_of_business/newpage
          arspayplan:payment_plan /newpage                                 

end of page                                                                         
""/newline=2
"Installments can either be billed with months between or days between but not both"   

top of page
""/newline
arspayplan:line_of_business/noheading/column=1 
sfsline:description/noheading /column=10/newline=2
arspayplan:description/noheading/column=1
arspayplan:number_of_payments/heading="Number of Payments"/newline=3/column=1
  
