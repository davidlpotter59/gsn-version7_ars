/*  lrsutilmenu7.inc

    March 16, 2005

    SCIPS.com, Inc.

    Standard menu items for SCIPS Version 7
*/

    Menu Tagged Utilities_mm Properties { Text="Reporting" }
    {    
	    Menuitem Properties {
					    Iconname = "printer.bmp"
					    Text     = "A/R Reports"
					    }
                  Events     {
					    Action   = reports_fn
					    }
         Menuitem Properties {
					    Iconname = "change.bmp"
					    Text     = "Transaction Code Maintenance"
					    }
                  Events     {
--					    Action   = transaction_code_fn
					    }
         Menuitem Properties {
					    Iconname = "delete.bmp"
					    Text     = "Vendor Maintenance"
					    }
                  Events     {
--					    Action   = vendor_fn
					    }
         Menuitem Properties {
					    Iconname = "printer.bmp"
					    Text     = "Reserve Defaults"
					    }
                  Events     {
--					    Action   = reserve_default_fn
					    }
         Menuitem Properties {
					    Iconname = "exit.bmp"
					    Text     = "Cause of Loss"
					    }
                  Events     {
--					    Action   = cause_of_loss_fn
					    }
	    Menuitem Properties {
					    Iconname = "search.bmp"
					    Text     = "Summary Trans Codes"
					    }
                  Events     {
--					    Action   = Summary_trans_codes_fn
					    }
	    Menuitem Properties {
					    Iconname = "next.bmp"
					    Text     = "View / Print DEC Page"
					    }
                  Events     {
--					    Action   = View_print_dec_fn
					    }
	    Menuitem Properties {
					    Iconname = "printer.bmp"
					    Text     = "Form Letters"
					    }
                  Events     {
--					    Action   = form_letter_fn
					    }
    }
