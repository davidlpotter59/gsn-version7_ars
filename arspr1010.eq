include "startend.inc"

define string l_prog_number = "ARSPR1010"

where arsbilling:status one of "B" 
and arsbilling:bill_plan one of "DB"

list
/nobanner
/domain="arsbilling"
/nodetail     
/title="Current Billed for All Agents as of Report Run Date"                                            

arsbilling:policy_no/column=1
sfpname:name[1]/column=15/width=25
arsbilling:due_date/column=45
arsbilling:net_amount_due/column=60

sorted by arsbilling:agent_no/newpage 
          arsbilling:policy_no 
          arsbilling:due_date 


end of arsbilling:agent_no 
box/noblanklines/noheadings 
"TOTAL FOR AGENT"/column=25
total[arsbilling:net_amount_due]/mask="(ZZZ,ZZZ,ZZZ.99)"/column=60
end box

end of arsbilling:due_date 
box/noblanklines/noheadings 
arsbilling:policy_no /column=1
sfpname:name[1]/width=25/column=15
arsbilling:due_date /column=45
total[arsbilling:net_amount_due]/mask="(ZZZ,ZZZ,ZZZ.99)"/column=60
end box



include "reporttop.inc"
""/newline 
arsbilling:agent_no/column=1/noheading 
sfsagent:name[1]/noheading/column=10/newline
