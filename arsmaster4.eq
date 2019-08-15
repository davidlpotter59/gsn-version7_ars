where arsmaster:trans_date => 01.01.2000 and
      arsmaster:trans_date <= 06.30.2000
--   and arsmaster:line_of_business = 00
list
/nobanner 
--/nodetail

arsmaster:policy_no 
arsmaster:trans_date 
arsmaster:line_of_business 
arsmaster:premium/mask="$ZZZ,ZZZ,ZZZ.99-"

sorted by arsmaster:line_of_business /total/heading="Line of Business @"
