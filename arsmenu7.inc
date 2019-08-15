/*  Arsmenu7.inc

    March 16, 2005

    SCIPS.com, Inc.

    Standard menu items for SCIPS Version 7
*/

    Menu Tagged Utilities_mm Properties { Text="A/R Utilities" }
    {    
	    Menu tagged payment_plan_mm Properties { Text="Payment Plan Tables" }
	    {
	    Menuitem Properties {
					    Text     = "Payment Plan Time Maintenance"
					    }
                  Events     {
					    Action   = pp_time_fn
					    }
         Menuitem Properties {
					    Text     = "Payment Plan Type Maintenance"
					    }
                  Events     {
					    Action   = pp_type_fn
					    }
	    Menuitem Properties {
					    Text     = "Payment Plan Maintenance"
					    }
                  Events     {
					    Action   = payplan_fn
					    }
	    } -- end of payment plan menu
	    Menu tagged check_processing_mm Properties { Text="Check Processing" }
	    {
         Menuitem Properties {
					    Text     = "Post Daily Checks"
					    }
                  Events     {
					    Action   = apply_checks_received_fn
					    }
         Menuitem Properties {
					    Text     = "Check Disposition Maintenance"
					    }
                  Events     {
					    Action   = disposition_fn
					    }
	    Menuitem Properties {
					    Text     = "Process Returned Checks"
					    }
                  Events     {
					    Action   = return_check_fn
					    } 
	    Menuitem Properties {
					    Text     = "Re-apply Incorrect Checks"
					    }
                  Events     {
					    Action   = reapply_fn
					    } 
	    Menuitem Properties {
					    Text     = "Returned Check Wording Maintenance"
					    }
                  Events     {
					    Action   = return_check_wording_fn
					    }
         } -- end of check processing menu
         Separator
         Menuitem Properties {
					    Text     = "Transaction Code Maintenance"
					    }
                  Events     {
					    Action   = transaction_code_fn
					    }
	    Menu tagged control_mm Properties { Text="Control File Update" }
	    {
         Menuitem Properties {
					    Text     = "Control File - Basics"
					    }
                  Events     {
					    Action   = basic_control_fn
					    }
         Menuitem Properties {
					    Text     = "Control File - Advanced"
					    }
                  Events     {
					    Action   = advanced_control_fn
					    }
	    }
	    Separator
	    Menuitem Properties {
					    Text     = "Non-Pay Notice Wording Maintenance"
					    }
                  Events     {
					    Action   = nonpay_wording_fn
					    }
	    Menuitem Properties {
					    Text     = "Process Write-offs"
					    }
                  Events     {
					    Action   = write_off_fn
					    } 
	    Menuitem Properties {
					    Text     = "Correct Billing Errors"
					    }
                  Events     {
					    Action   = billing_change_fn
					    } 
    }
