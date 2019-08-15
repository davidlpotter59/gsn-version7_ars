/*  arsdeposit1

    August 19, 2001

    SCIPS.com

    Report program to generate the deposit ticket for applications.   
    the naming convention is not the same as all other SCIPS programs.  
    this is to allow each user to have their own formatting of the deposit
    slip in Visual SCIPS
*/

include "startend.inc"

where arschksu:trans_date => l_starting_date and
      arschksu:trans_date <= l_ending_date and
      arschksu:policy_no = 0  -- application status only

list
/nobanner
/domain="arschksu"
/notitle
/nopageheadings 
/pagewidth=80
/pagetotals 
/noreporttotals 

count[units] /column=1/mask="ZZZZ"/heading="Item"
arschksu:check_reference/heading="Reference" /column=10
arschksu:bank_no/heading="Bank Number"/column=26
arschksu:check_no/heading="Check Number"/column=40
arschksu:check_amount/heading="Amount"/column=56/mask="$$$,$$$,$$$.99-"/total
    

sorted by arschksu:check_reference 

top of page
"Deposit Slip"/column=21/noheading 
pagenumber/heading="Page "/column=45/newlines=2/mask="ZZ"
sfscompany:name[1]/center/newline/noheading 
trun(sfscompany:city) + ", " + trun(sfscompany:str_state) + " " + trun(str(
sfscompany:zipcode,"99999-9999"))/column=20/noheading/newline=2                        
todaysdate/mask="MM/DD/YYYY"/noheading/column=20/newline=2
arscontrol:bank_account_no/heading="Account Number "/column=15/newline=2       
"Applications"/center/newline=2

end of report                                                                         
""/newline=2
total[arschksu:check_amount]/heading="Total Deposit "/column=24/mask="$$$,$$$,$$$.99-"
