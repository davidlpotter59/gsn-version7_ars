

include "startend.inc"

/* define variables to be written out */
define file sfsagent_alias = access sfsagent,
                                set sfsagent:company_id = prsmaster:company_id ,
                                    sfsagent:agent_no   = prsmaster:agent_no, exact

define signed ascii number l_new_premium[9]=if
prsmaster:trans_code one of 10 then prsmaster:premium 
else
0.00

define signed ascii number l_cancel_premium[9]=if
prsmaster:trans_code one of 11 then prsmaster:premium
else
0.00

define signed ascii number l_increase_premium[9]=if
prsmaster:trans_code one of 12 then prsmaster:premium 
else
0.00

define signed ascii number l_decrease_premium[9]=if
prsmaster:trans_code one of 13 then prsmaster:premium 
else
0.00

define signed ascii number l_renewal_premium[9]=if
prsmaster:trans_code one of 14 then prsmaster:premium 
else
0.00

define signed ascii number l_audit_premium[9]=if
prsmaster:trans_code one of 15 then prsmaster:premium 
else
0.00

define signed ascii number l_reinstatement_premium[9]=if
prsmaster:trans_code one of 16 then prsmaster:premium 
else
0.00

define file sfslinea = access sfsline, set sfsline:company_id= prsmaster:company_id, 
                                           sfsline:line_OF_BUSINESS= prsmaster:line_of_business,
                                           sfsline:lob_subline= prsmaster:lob_subline 

include "prscollect.inc"
and with prsmaster:trans_code < 17
and sfslinea:stmt_lob not one of 999 -- here is the difference

list
/nodetail
/domain="prsmaster"
/hold="agent_worth"

sorted by prsmaster:policy_no pol_year end_sequence trans_code 
       
end of prsmaster:trans_code                 
prsmaster:company_id
prsmaster:policy_no/keyelement(1.1)
prsmaster:end_sequence/keyelement(2.1)
prsmaster:pol_year/keyelement(3.1)
prsmaster:trans_code
prsmaster:line_of_business
total[l_new_premium]/heading ="new_premium"
total[l_cancel_premium]/heading ="cancel_premium"
total[l_increase_premium]/heading="increase_premium"
total[l_decrease_premium]/heading="descrease_premium"
total[l_renewal_premium]/heading ="renewal_premium"
total[l_reinstatement_premium]/heading="reinstatement_premium"
total[l_audit_premium]/heading="audit_premium"
sfsagent_alias:agent_master_code  
prsmaster:lob_subline
prsmaster:eff_date
prsmaster:exp_date
