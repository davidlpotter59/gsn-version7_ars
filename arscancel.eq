--where arscancel:cx_status = "R" and
--trans_date = 12.03.2001
--where arscancel:policy_no one of 60000016, 60000035, 60000036, 60000051, 60000053, 60000058
--where arscancel:policy_no = 60000580
                             
--where arscancel:item_number <> 0
list
/nobanner
/domain="arscancel"
/duplicates 
/pagewidth=255

arscancel:company_id   
arscancel:recordnumber 
arscancel:policy_no              
arscancel:item_number /total 
arscancel:cx_date 
--sfpname:policy_no /heading="SFPNAME-Policy No"
--sfpname:name[1]
                     
sorted by item_number 
arscancel:cx_date 
end of report
count [arscancel:policy_no]
