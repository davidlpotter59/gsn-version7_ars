/*  arsdeposit2

    march 10, 2002

    SCIPS.com

    Report program to generate the deposit ticket for reinstatements.  
    the naming convention is not the same as all other SCIPS programs.  
    this is to allow each user to have their own formatting of the deposit
    slip in Visual SCIPS
*/

include "startend.inc"

where arschksu:trans_date => l_starting_date and
      arschksu:trans_date <= l_ending_date and
      arschksu:internal_check = 1  -- internal check created

list
/nobanner
/domain="arschksu"
/title="Automatic Reinstatement 'CHECKS' Processed"
/nopageheadings 
/pagewidth=80              
/pagetotals 
/noreporttotals 

count[units] /column=1/mask="ZZZZ"/heading="Item"
arschksu:check_reference/heading="Reference" /column=10
arschksu:bank_no/heading="Bank Number"/column=26
arschksu:check_no/heading="Check Number"/column=50
arschksu:check_amount/heading="Amount"/column=66/mask="$$$,$$$,$$$.99-"/total
    

sorted by arschksu:check_reference 

top of page
"Reinstatement Transactions"/column=25/noheading 
pagenumber/heading="Page "/column=70/newlines=2/mask="ZZ"
trun(sfscompany:name[1])/center/newline/noheading 
trun(trun(sfscompany:city) + ", " + trun(sfscompany:str_state) + " " + trun(str(
sfscompany:zipcode,"99999-9999")))/center/noheading/newline=2                        
"Run Date"/center/newline 
trun(str(todaysdate,"MM/DD/YYYY"))/noheading/center/newline=2       

end of report                                                                         
""/newline=2
total[arschksu:check_amount]/heading="Total Amount Reinstated "/column=24/mask="$$$,$$$,$$$.99-"
