
"payplan"  sequence "pay_plan_seq"  tagged payplan_fn ;
"pay_plan_seq" continue begin
			    display modal screen "arsmt035"
               end ;
			
"basic_control"  sequence "basic_control_seq"  tagged basic_control_fn ;
"basic_control_seq" continue begin
			    display modal screen "arsmt040"
               end ;

"advanced_control"  sequence "advanced_control_seq" tagged advanced_control_fn ;
"advanced_control_seq" continue begin
			    display modal screen "arsmt044"
               end ;
			
"billing_change"  sequence "billing_change_seq" tagged billing_change_fn ;
"billing_change_seq" continue begin
			    display modal screen "arschgbll"
               end ;
			
"reapply"  sequence "reapply_seq" tagged reapply_fn ;
"reapply_seq" continue begin
			    display modal screen "arsmt011"
               end ;
			
"return_check_wording"  sequence 
		"return_check_wording_seq" tagged return_check_wording_fn ;
"return_check_wording_seq" continue begin
			    display modal screen "arsmt045"
               end ;
			
"nonpay_wording"  sequence "nonpay_wording_seq" tagged nonpay_wording_fn;
"nonpay_wording_seq" continue begin
			    display modal screen "arsmt925"
               end ;
			
"disposition"  sequence 
		"disposition_wording_seq" tagged disposition_fn ;
"disposition_wording_seq" continue begin
			    display modal screen "arsmt032"
               end ;
			
"transaction_code"  sequence 
		"transaction_code_seq" tagged transaction_code_fn ;
"transaction_code_seq" continue begin
			    display modal screen "arsmt038"
               end ;
			
"pp_time"  sequence "pp_time_seq" tagged pp_time_fn ;
"pp_time_seq" continue begin
			    display modal screen "arsmt037"
               end ;
			
"pp_type"  sequence "pp_type_seq" tagged pp_type_fn ;
"pp_type_seq" continue begin
			    display modal screen "arsmt036"
               end ;
			
"return_check"  sequence "return_check_seq" tagged return_check_fn ;
"return_check_seq" continue begin
			    display modal screen "arsmt009"
               end ;
			
"write_off"  sequence "write_off_seq" tagged write_off_fn;
"write_off_seq" continue begin
			    display modal screen "arsmt100"
               end ;
			
"apply_checks_received"  sequence 
		"apply_checks_received_seq" tagged apply_checks_received_fn ;
"apply_checks_received_seq" continue begin
               l_continue_1 = dialog("Posting Warning","warning.bmp","You are about to POST ALL checks that are valid to be posted.  Do you wish to continue","YES","NO")
			switch (l_continue_1)
			case "YES" : begin
                            proc (":cli csbatch arsup010")/noconsole
	   l_continue_1 = dialog("Posting Complete","warning.bmp","Posting WAS processed","Continue")
					   end
               default    : begin
	   l_continue_1 = dialog("Posting Not Processed","warning.bmp","Posting was not processed","Continue")
					   end
               end
					  
			function="redisplay"
               end ;
