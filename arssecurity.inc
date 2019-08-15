/*   arssecurity.inc

	Decemver 19, 2005

	scips.com, Inc.

	A/R security icon and function setting
*/

if g_company_id = "" then 
begin
    l_sfs        = "SFS"
    access sfsdefault, set sfsdefault:sfs_code = l_sfs
    g_company_id = sfsdefault:company_id
end

l_username      = username/spacefill
l_system_id     = "ars"/spacefill 
l_abort_program = 0

access sfssecurity_ar, set sfssecurity_ar:company_id = g_company_id,
				       sfssecurity_ar:user_id    = l_username, 
					  sfssecurity_ar:system_id  = l_system_id, generic

if sfssecurity_ar:access_ars not one of 1 then 
begin 
    l_continue = Dialog("Unauthorized Access","error.bmp","You Have NO access to this Module - Exiting","EXIT")
    function = "stop" 
end 

if sfssecurity_ar:allow_add not one of 1 then
begin 
    disable (add_fn)
end 

if sfssecurity_ar:allow_change not one of 1 then
begin 
    disable (change_fn)
end 

if sfssecurity_ar:allow_delete not one of 1 then
begin 
    disable (delete_fn)
end 

if sfssecurity_ar:time_between_payments_maintenance not one of 1 then
begin 
    disable (pp_time_fn)
end 

if sfssecurity_ar:payment_plan_type_maintenance not one of 1 then
begin 
    disable (pp_type_fn)
end 

if sfssecurity_ar:payment_plan_maintenance not one of 1 then
begin 
    disable (payplan_fn)
end 

if sfssecurity_ar:post_checks not one of 1 then
begin 
    disable (apply_checks_received_fn)
end 

if sfssecurity_ar:check_disposition_maintenance not one of 1 then
begin 
    disable (disposition_fn)
end 

if sfssecurity_ar:process_returned_checks not one of 1 then
begin 
    disable (return_check_fn)
end 

if sfssecurity_ar:reapply_incorrect_check not one of 1 then
begin 
    disable (reapply_fn)
end 

if sfssecurity_ar:returned_check_wording not one of 1 then
begin 
    disable (return_check_wording_fn)
end 

if sfssecurity_ar:transaction_code_maintenance not one of 1 then
begin 
    disable (transaction_code_fn)
end 

if sfssecurity_ar:control_file_setup_basic not one of 1 then
begin 
    disable (basic_control_fn)
end 

if sfssecurity_ar:control_file_setup_advanced not one of 1 then
begin 
    disable (advanced_control_fn)
end 

if sfssecurity_ar:non_pay_notice_wording not one of 1 then
begin 
    disable (nonpay_wording_fn)
end 

if sfssecurity_ar:process_write_offs not one of 1 then
begin 
    disable (write_off_fn)
end 

if sfssecurity_ar:correct_billing_records not one of 1 then
begin 
    disable (billing_change_fn)
end 

if sfssecurity_ar:process_direct_bill_commissions not one of 1 then
begin 
    disable (db_commissions_fn)
end 

if sfssecurity_ar:process_ac_commissions not one of 1 then
begin 
    disable (ac_commissions_fn)
end 

if sfssecurity_ar:access_intent_to_cancel not one of 1 then
begin 
    disable (db_non_pay_fn)
end 

if sfssecurity_ar:process_reinstatement_notices not one of 1 then
begin 
    disable (db_reinstatements_fn)
end 

if sfssecurity_ar:process_cx_balance_due_notices not one of 1 then
begin 
    disable (balance_due_fn)
end 

if sfssecurity_ar:process_installment_invoices not one of 1 then
begin 
    disable (db_invoices_fn)
end 
