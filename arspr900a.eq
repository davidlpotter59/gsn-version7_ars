/*  arspr900a.eq

    scips.com

    may 28, 2001

    program creates the arscxwrk.txt file that will be used as
    input 
*/

include "startend.inc"

define string I_name[50]=sfpname:name[1];
define string l_agent_zipcode = str(sfsagent:zipcode,99999-9999)

include "renaeq1.inc"

define signed ascii number l_total_premium = 
arsbilling:installment_amount - 
arsbilling:total_amount_paid/decimalplaces=2

define signed ascii number l_total_past_due = 
if arsbilling:due_date < l_ending_date then 
    arsbilling:installment_amount - arsbilling:total_amount_paid  
else
    0.00

define signed ascii number l_current_total_due = 
if arsbilling:due_date > l_ending_date then 
    arsbilling:installment_amount - 
    arsbilling:total_amount_paid  
else
    0.00

define signed ascii number l_total_due =
    l_current_total_due + l_total_past_due                                 
      
--define wdate l_cx_eff_date = arsbilling:due_date + 12 
define wdate l_cx_eff_date = todaysdate + 15

define wdate l_cancellation_date = if weekday(todaysdate) = 
1 then l_cx_eff_date + 1 -- force to Monday
else if weekday(todaysdate) = 7 then l_cx_eff_date + 2
else
l_cx_eff_date

define unsigned ascii number l_sub_code[4]=0; -- used for workfile only

include "fonts.var"

where (arsbilling:due_date => l_starting_date and
       arsbilling:due_date <= l_ending_date) and
       arsbilling:bill_plan = "DB" and
       arsbilling:status <> "P" and
       arsbilling:status <> "C"

list
/nobanner
/domain="arsbilling"
/nodefaults 
/nopageheadings 
/nodetail 
/notitle 
/pagelength=0
      
sorted by arsbilling:policy_no
          arsbilling:due_date          
          arsbilling:trans_code

end of arsbilling:trans_code -- since there is a potential to have
                            -- multiple amounts past due with different
                            -- due dates then use the date sort rather
                            -- than the policy no sort - changed 6/3/2001
                            -- need to have the actual transaction code
                            -- passed to recieving program arsup900

-- if there is no past due amount then do nothing here
if l_total_past_due <> 0 then
{                                                        
box
/noheadings
/nozerosuppress
    arsbilling:company_id/column=1/width=10/mask="XXXXXXXXXX"
    arsbilling:policy_no/column=11/width=9/mask="999999999"
    l_sub_code/column=20/width=4/mask="9999"               
    arsbilling:trans_code/column=24/width=4/mask="9999"
    todaysdate/column=28/width=8/mask="MMDDYYYY"           
    arsbilling:trans_eff/column=36/width=8/mask="MMDDYYYY"
    arsbilling:line_of_business/column=44/width=4/mask="9999"
    arsbilling:payment_plan/column=48/width=4/mask="9999"
    arsbilling:due_date/column=52/width=8/mask="MMDDYYYY"
    l_cancellation_date/column=60/width=8/mask="MMDDYYYY"
    "P"/column=68/width=1/mask="X"
    arsbilling:agent_no/column=69/width=4/mask="9999"
    total[l_total_past_due, arsbilling:trans_code]/column=73/width=11/mask="9999999.99-"    
end box
}
