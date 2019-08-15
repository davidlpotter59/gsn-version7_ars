/*  arspr013a

    April 16, 2012

    scips.com

    report for Cash commissions for balancing

*/
define unsigned ascii number l_comm_rate[4] = (arscomcashwrk:comm_rate divide 100)/decimalplaces= 2

define unsigned ascii number l_comm_amount[9] = (l_comm_rate * arscomcashwrk:premium)/decimalplaces= 3


list/domain="arscomcashwrk"
company_id agent_no policy_no trans_date trans_eff trans_exp trans_code line_of_business comm_rate 
check_reference premium commission


sorted by arscomcashwrk:agent_no arscomcashwrk:check_reference 

end of arscomcashwrk:agent_no
--total[l_comm_amount ]/newline=2/column=126/mask="ZZ,ZZZ.99"/heading="TOTAL"
total[commission ]/newline=2/column=126/mask="ZZ,ZZZ.99"/heading="TOTAL"
