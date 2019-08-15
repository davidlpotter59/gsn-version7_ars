/*  arsmenu7p.inc

    February 14, 2006 

    SCIPS.com, Inc.

   A/R period end routines menu 
*/

    Menu Tagged Utilities_mm Properties { Text="A/R Period End" }
    {    
	    Menu tagged payment_plan_mm Properties { Text="Commission Statements" }
	    {
	    Menuitem Properties {
					    text     = "Direct Bill Commission Statements"
					    }
                  Events     {
					    Action   = db_commissions_fn
					    }
         Menuitem Properties {
					    Text     = "Account Current Commission Statements"
					    }
                  Events     {
					    Action   = ac_commissions_fn
					    }
	    } -- end of payment plan menu
	    Separator
	    Menu tagged check_processing_mm Properties { Text="Cancellation Processing" }
	    {
         Menuitem Properties {
					    Text     = "D/B Non-Pay Notices"
					    }
                  Events     {
					    Action   = db_non_pay_fn
					    }
         Menuitem Properties {
					    Text     = "D/B Reinstatement/Rescind Notices"
					    }
                  Events     {
					    Action   = db_reinstatements_fn
					    }
	    Menuitem Properties {
					    Text     = "D/B Balance Due Processing"
					    }
                  Events     {
					    Action   = balance_due_fn
					    } 
         } -- end of check processing menu
	    Separator
	    Menu tagged check_processing_mm Properties { Text="D/B Invoices" }
	    {
         Menuitem Properties {
					    Text     = "Select and Print D/B Installments "
					    }
                  Events     {
					    Action   = db_invoices_fn
					    }
         }  -- end of db invoices
    }
