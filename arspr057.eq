/*  arspr057

    SCIPS.com

    June 4, 2007

    A/R Writtem, Unearned and Commissions Processed by Line of Business 
    and LOB Subline

    Broken out by DB and AC
*/

description 
DB and AC Written, Unearned and Commissions Processed by Line of Business 
- Select Select Daily or Monthly Prorata for the unearned calculation ;

include "startend.inc"

define string l_prog_number = "ARSPR057 - Version 7.20"

include "arsunearned.inc"

define signed ascii number l_written_commission[9]=arsmaster:premium * (
arsmaster:comm_rate * 0.01)/decimalplaces=2

define signed ascii number l_net_written = arsmaster:premium - 
l_written_commission 

define signed ascii number l_unearned_commission[9]=l_unearned * (
arsmaster:comm_rate * 0.01)/decimalplaces=2

define signed ascii number l_net_unearned[9]=l_unearned - 
l_unearned_commission 

/* DB Calcs */

define signed ascii number l_written_db[9]= if arsmaster:bill_Plan one of "DB" then 
arsmaster:premium/decimalplaces=2
else
0.00

define signed ascii number l_written_commission_db[9]= if arsmaster:bill_Plan one of "DB" then 
arsmaster:premium * (arsmaster:comm_rate * 0.01)/decimalplaces=2
else
0.00

define signed ascii number l_net_written_db =  if arsmaster:bill_Plan one of "DB" then
arsmaster:premium - l_written_commission 
else 0.00

define signed ascii number l_unearned_commission_db[9] = if arsmaster:bill_Plan one of "DB" then
l_unearned * (arsmaster:comm_rate * 0.01)/decimalplaces=2
else 0.00

define signed ascii number l_net_unearned_db[9]= if arsmaster:bill_Plan one of "DB" then
l_unearned - l_unearned_commission 
else 0.00

/*  end of DB Calcs */

/* AC Calcs */


define signed ascii number l_written_ac[9]= if arsmaster:bill_Plan one of "AC" then 
arsmaster:premium/decimalplaces=2
else
0.00

define signed ascii number l_written_commission_ac[9]= if arsmaster:bill_Plan one of "AC" then 
arsmaster:premium * (arsmaster:comm_rate * 0.01)/decimalplaces=2
else
0.00

define signed ascii number l_net_written_ac =  if arsmaster:bill_Plan one of "AC" then
arsmaster:premium - l_written_commission 
else 0.00

define signed ascii number l_unearned_commission_ac[9] = if arsmaster:bill_Plan one of "AC" then
l_unearned * (arsmaster:comm_rate * 0.01)/decimalplaces=2
else 0.00

define signed ascii number l_net_unearned_ac[9]= if arsmaster:bill_Plan one of "AC" then
l_unearned - l_unearned_commission 
else 0.00

/*  end of AC Calcs */

include "arscollect.inc"
and trans_code <= 18

list
/nobanner
/domain="arsmaster"
/title="DB and AC (A/R) Written, Unearned and Commissions Processed by Line of Business - No Detail (Summary Only)"
/nodetail                            
/nototals

arsmaster:premium/heading="Written-Premium"/column=60
l_written_commission/heading="Written-Commissions"/column=80
l_net_written/heading="Net-Written-Premium"/column=100
l_unearned/heading="Unerned-Premium"/column=120
l_unearned_commission/heading="Unearned-Commissions"/column=140
l_net_unearned/heading="Net-Unearned-Premium"/column=160

/* DB */

l_written_db/heading="DB Written"/column=180
l_written_commission_db/heading="DB Written-Commissions"/column=200
l_net_written_db/heading="DB Net-Written-Premium"/column=220
l_unearned_commission_db/heading="DB Unerned-Premium"/column=240
l_unearned_commission_db/heading="DB Unearned-Commissions"/column=260
l_net_unearned_db/heading="DB Net-Unearned-Premium"/column=280

/* AC */

l_written_ac/heading="AC Written"/column=300
l_written_commission_ac/heading="AC Written-Commissions"/column=320
l_net_written_ac/heading="AC Net-Written-Premium"/column=340
l_unearned_commission_ac/heading="AC Unerned-Premium"/column=360
l_unearned_commission_ac/heading="AC Unearned-Commissions"/column=380
l_net_unearned_ac/heading="AC Net-Unearned-Premium"/column=400

sorted by sfsline:stmt_lob /newlines 
          arsmaster:line_of_business /newlines 
          arsmaster:lob_subline

top of sfsline:stmt_lob 
sfsline:stmt_lob/noheading /column=1
sfsstmt:description/noheading/column=10/newline

top of arsmaster:line_of_business
arsmaster:line_of_business/noheading /column=5
sfsline_heading:description/noheading/column=10                              

end of sfsline:stmt_lob                        
""/newline 
"Total for Statement "/column=10 
total[arsmaster:premium]/noheading/column=60
total[l_written_commission]/noheading/column=80
total[l_net_written]/noheading/column=100
total[l_unearned]/noheading/column=120
total[l_unearned_commission]/noheading/column=140
total[l_net_unearned]/noheading/column=160

/* DB */

total[l_written_db]/noheading/column=180
total[l_written_commission_db]/noheading/column=200
total[l_net_written_db]/noheading/column=220
total[l_unearned_commission_db]/noheading/column=240
total[l_unearned_commission_db]/noheading/column=260
total[l_net_unearned_db]/noheading/column=280

/* AC */

total[l_written_commission_ac]/noheading/column=300
total[l_written_commission_ac]/noheading/column=320
total[l_net_written_ac]/noheading/column=340
total[l_unearned_commission_ac]/noheading/column=360
total[l_unearned_commission_ac]/noheading/column=380
total[l_net_unearned_ac]/noheading/column=400
  
end of arsmaster:line_of_business                                    
""/newline 
"Total of Line of Business"/column=10
total[arsmaster:premium]/noheading/column=60
total[l_written_commission]/noheading/column=80
total[l_net_written]/noheading/column=100
total[l_unearned]/noheading/column=120
total[l_unearned_commission]/noheading/column=140
total[l_net_unearned]/noheading/column=160

/* DB */

total[l_written_db]/noheading/column=180
total[l_written_commission_db]/noheading/column=200
total[l_net_written_db]/noheading/column=220
total[l_unearned_commission_db]/noheading/column=240
total[l_unearned_commission_db]/noheading/column=260
total[l_net_unearned_db]/noheading/column=280

/* AC */

total[l_written_commission_ac]/noheading/column=300
total[l_written_commission_ac]/noheading/column=320
total[l_net_written_ac]/noheading/column=340
total[l_unearned_commission_ac]/noheading/column=360
total[l_unearned_commission_ac]/noheading/column=380
total[l_net_unearned_ac]/noheading/column=400

end of arsmaster:lob_subline 
arsmaster:lob_subline/noheading/column=10
sfsline:description/noheading/column=15
total[arsmaster:premium]/noheading/column=60
total[l_written_commission]/noheading/column=80
total[l_net_written]/noheading/column=100
total[l_unearned]/noheading/column=120
total[l_unearned_commission]/noheading/column=140
total[l_net_unearned]/noheading/column=160

/* DB */

total[l_written_db]/noheading/column=180
total[l_written_commission_db]/noheading/column=200
total[l_net_written_db]/noheading/column=220
total[l_unearned_commission_db]/noheading/column=240
total[l_unearned_commission_db]/noheading/column=260
total[l_net_unearned_db]/noheading/column=280

/* AC */

total[l_written_commission_ac]/noheading/column=300
total[l_written_commission_ac]/noheading/column=320
total[l_net_written_ac]/noheading/column=340
total[l_unearned_commission_ac]/noheading/column=360
total[l_unearned_commission_ac]/noheading/column=380
total[l_net_unearned_ac]/noheading/column=400

end of report                
""/newline=2
"Report Totals"/column=1
total[arsmaster:premium]/noheading/column=60
total[l_written_commission]/noheading/column=80
total[l_net_written]/noheading/column=100
total[l_unearned]/noheading/column=120
total[l_unearned_commission]/noheading/column=140
total[l_net_unearned]/noheading/column=160

/* DB */

total[l_written_db]/noheading/column=180
total[l_written_commission_db]/noheading/column=200
total[l_net_written_db]/noheading/column=220
total[l_unearned_commission_db]/noheading/column=240
total[l_unearned_commission_db]/noheading/column=260
total[l_net_unearned_db]/noheading/column=280

/* AC */

total[l_written_commission_ac]/noheading/column=300
total[l_written_commission_ac]/noheading/column=320
total[l_net_written_ac]/noheading/column=340
total[l_unearned_commission_ac]/noheading/column=360
total[l_unearned_commission_ac]/noheading/column=380
total[l_net_unearned_ac]/noheading/column=400

include "reporttop.inc"
if l_unearned_type one of 1 then 
{ "Daily Pro Rata"/heading="Run Mode       "/column=1
}
else
{ "Monthly Pro Rata"
}
""/newline = 2
