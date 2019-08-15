include "startend.inc"

define string l_prog_number = "ARSPR1000"

define unsigned ascii number l_agent_no = parameter/prompt="Please Enter Agent Number:<NL>"

where arsbilling:status one of "B" and 
      arsbilling:agent_no = l_agent_no and
      arsbilling:bill_plan one of "DB"

list
/nobanner
/domain="arsbilling"
/nodetail                                                 
/title="Current Billed for Selected Agent as of Report Run Date"                                            

arsbilling:policy_no/column=1
sfpname:name[1]/column=15/width=25
arsbilling:due_date/column=45
arsbilling:net_amount_due/column=60

sorted by arsbilling:agent_no/newpage 
          arsbilling:policy_no 
          arsbilling:due_date 


end of arsbilling:agent_no 
box/noblanklines/noheadings 
total[arsbilling:net_amount_due]/mask="(ZZZ,ZZZ,ZZZ.99)"/column=60
end box

end of arsbilling:due_date 
box/noblanklines/noheadings 
arsbilling:policy_no /column=1
sfpname:name[1]/column=15
arsbilling:due_date /column=45
total[arsbilling:net_amount_due]/mask="(ZZZ,ZZZ,ZZZ.99)"/column=60
end box



include "reporttop.inc"
""/newline 
arsbilling:agent_no/column=1/noheading 
sfsagent:name[1]/noheading/column=10/newline
