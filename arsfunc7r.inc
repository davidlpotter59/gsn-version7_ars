/* arsfunc7p.inc

   February 14, 2006

   scips.com, inc.

   functions for A/R Period End Processes
*/

"reports"  sequence "reports_seq"  tagged reports_fn ;
"reports_seq" continue begin
			    proc ("cqwr -autoconnect arspr006 -application=Lebanon Reports")
               end ;
