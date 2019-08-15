where arspayor:policy_no = 810100571
list
/nobanner
/domain="arspayor"
/title="ARSPAYOR Listing"
/noheadings 

box/noblanklines 
arspayor:policy_no
name[1]/column=15
address[1]/column=70/newline
name[2]/column=15
address[2]/column=70/newline
name[3]/column=15
address[3]/column=70/newline
trun(trun(city) +", " + str_state)/column=15
zipcode
xob/newlines=1 

sorted by policy_no 
