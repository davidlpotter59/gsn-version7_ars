/*  arspr135.eq

    december 26, 2000

    scips.com, inc.

    A/R Payment Plans Listing
*/

list
/banner
/domain="arspayplan"
/title="A/R Payment Plans Listing"                         
/noblanklines                 

arspayplan:payment_plan/heading="Payment-Plan"
arspayplan:description/heading="Description"
arspayplan:number_of_payments/heading="Number of-Installments"
arspayplan:distribution/heading="Installment-Percentages"/mask="ZZZ.ZZ"
arspayplan:installment_charge_type/heading="Charge-Type"
arspayplan:installment_charge_time/heading="Charge-Time"
arspayplan:installment_charge_rate/heading="Charge-Rate"
arspayplan:installment_months_between/heading="Months-Between"
arspayplan:minimum_premium/heading="Minimum-Premium"

sorted by  arspayplan:company_id /newpage 
           arspayplan:line_of_business /newlines 
           arspayplan:payment_plan
