define file sfpcurrent_alt = access sfpcurrent,
                                set sfpcurrent:policy_no = arsbilling_c_status:policy_no, exact

define file sfpname_alt = access sfpname,
                             set sfpname:policy_no    = sfpcurrent:policy_no,
                                 sfpname:pol_year     = sfpcurrent:pol_year,
                                 sfpname:end_sequence = sfpcurrent:end_sequence, exact     
 
where arsbilling_c_status:policy_no    = sfpcurrent_alt:policy_no and
      arsbilling_c_status:pol_year     = sfpcurrent_alt:pol_year and
      arsbilling_c_status:end_sequence = sfpcurrent_alt:end_sequence and
      sfpname_alt:status = "CURRENT"

list

/domain="arsbilling_c_status" 
/pagelength= 0
/noblanklines

policy_no pol_year end_sequence sfpcurrent_alt:policy_no sfpcurrent_alt:pol_year sfpcurrent_alt:end_sequence
