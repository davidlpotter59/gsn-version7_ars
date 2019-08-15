where arspayment:expansion <> ""

list
/nobanner
/domain="arspayment"
/title="arspayment Audit Report"
/pagewidth=80
/duplicates                       
/nopageheadings 
--/nodetail 

arspayment:policy_no/heading="Policy-No"/column=1
--sfpname:name[1]/width=10/heading="Insured's-Name"
arspayment:trans_date/heading="Trans-Date"
--arspayment:trans_eff/heading="Trans-Eff"
arspayment:trans_code/heading="Trans-Code"
arspayment:line_of_business/heading="Line"/duplicates 
--arspayment:lob_subline 
arspayment:comm_rate/nototal/heading="Comm-Rate"
arspayment:amount/mask="ZZ,ZZZ,ZZZ.99-"/heading="Premium"
--arspayplan:description 
arspayment:expansion 

sorted by arspayment:trans_date  
          arspayment:policy_no

top of page 
todaysdate/mask="MM/DD/YYYY"/newline=2
 
