/*  scips.com, Inc.

    july 11, 2007

    arspr090

    report to show the balancing issues between prsmaster and the net amount in arsbilling for AC transactions only
*/

description 
Report to show the balancing issues between prsmaster and the net amount in arsbilling for AC transactions only;

define file prsmastera = access prsmaster, set prsmaster:company_id = arsmaster:company_id, 
                                               prsmaster:policy_no  = arsmaster:policy_no, generic, one to many 
                                               

define l_premium = 
if prsmastera:policy_no  = arsbilling:policy_no and 
   prsmastera:trans_date = arsbilling:trans_date and 
   prsmastera:trans_code = arsbilling:trans_code 
then   prsmastera:premium 
else
   0.00

define l_commission = 
if prsmastera:policy_no  = arsbilling:policy_no and 
   prsmastera:trans_date = arsbilling:trans_date and 
   prsmastera:trans_code = arsbilling:trans_code 
then   prsmastera:premium - (prsmastera:premium * (prsmastera:comm_rate * 0.01))
else
   0.00

where 
  arsbilling:bill_plan one of "AC" and 
  arsbilling:trans_code one of 13, 12, 11

list
/nobanner
/domain="arsbilling"
/nodetail
/pagelength=0
/title="A/C Balancing Issues"

  arsbilling:policy_no/column=1 
  arsbilling:trans_code /column=15/heading="T-C"
  arsbilling:premium /column=40
  l_premium /column=60/heading="PRSMASTER-Premium"
  l_commission/heading="Caclulated-Commission"/column=80

sorted by
  arsbilling:policy_no

end of arsbilling:policy_no 
if total[arsbilling:premium] <> total[l_commission] then
{
box/noblanklines/noheadings 
  arsbilling:policy_no/column=1 
  arsbilling:trans_code /column=15
  total[arsbilling:premium] /column=40
  total[l_premium]/column=60
  total[l_commission]/column=80
arsbilling:trans_date /column=100
end box
}
