--Hostlist 2

 

description we will only collect 1 years of cancelled policies from todays date;

 

define wdate l_starting_date = dateadd(todaysdate,-12) 

define wdate l_ending_date   = todaysdate

 

define file sfpcurrent_alias = access sfpcurrent,

                                  set sfpcurrent:policy_no= sfpname:policy_no, exact  

 

where sfpname:status one of "CANCELLED" and 

      sfpcurrent_alias:policy_no    = sfpname:policy_no and

      sfpcurrent_alias:pol_year     = sfpname:pol_year and

      sfpcurrent_alias:end_sequence = sfpname:end_sequence    

      and sfpname:trans_date >= l_starting_date 

      and sfpname:trans_date <= l_ending_date 

 

LIST               

/domain ="sfpname"                    

/noheadings

/nopageheadings 

/nobanner 

/pagelength= 0

 

sfpname:policy_no/mask="999999999"
