/* arsfunc7p.inc

   February 14, 2006

   scips.com, inc.

   functions for A/R Period End Processes
*/

"db_commissions"  sequence "db_commissions_seq"  tagged db_commissions_fn ;
"db_commissions_seq" continue begin
			    display modal screen "arsmt200"
               end ;
			
"ac_commissions"  sequence "ac_commissions_seq"  tagged ac_commissions_fn ;
"ac_commissions_seq" continue begin
			    display modal screen "arsmt210"
               end ;

"db_non_pay"  sequence "db_non_pay_seq"  tagged db_non_pay_fn ;
"db_non_pay_seq" continue begin
			    display modal screen "arsmt900"
               end ;

"db_reinstatements"  sequence 
		"db_reinstatements_seq" tagged db_reinstatements_fn ;
"db_reinstatements_seq" continue begin
			    display modal screen "arsmt910"
               end ;
			
"balance_due"  sequence "balance_due_seq" tagged balance_due_fn ;
"balance_due_seq" continue begin
			    display modal screen "arsmt920"
               end ;
			
"db_invoices"  sequence "db_invoices_seq" tagged db_invoices_fn ;
"db_invoices_seq" continue begin
			    display modal screen "arsmt300"
               end ;
