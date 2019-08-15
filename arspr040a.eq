include "startend.inc"

where arschksu:posted_date => l_starting_date and
      arschksu:posted_date <= l_ending_date 
list
/nobanner 
/domain="arsbilling"

arschksu:policy_no trans_date posted_date check_no    arsbilling:trans_code
