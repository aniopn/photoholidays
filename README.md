# photoholidays
 photo holidays bash script aims to help photographers to show the photos to the customers, hosted in a resort for example.
 This script aims to solve the problem that is preventing the customers from finding and buying their photos once the photographer takes the photos during the journey spent at the resort.
 Often the time the photographers offer to the customers to select the photos is very short compared to the number of customers, so the amount of time for each customer is highly reduced as the chance to sell photos.
 To augment the time for the customers to select their photos a website is used, a web page in a local-only (allow local IP addresses only) web server (nginx).
 the web server should be available via the local wifi area only.
 customers can search their photos looking by room number, the script can prepare the folder tree (all room numbers) anyway, it should be manually filled with the photos.
 each customer-room-number can access only their room-numbered folder in the linux filesystem, which is also exposed via URL for example HTTP://local-nginx-web-server/room-number.
 a username is required, for example, the room number; a password is required, for example, it can be a composition of room number + check-in date + surname.
 this password should always be configured for each check-in of the customer, even via a check-in list of dates to accomplish the procedure in bulk.
 for each room number (i.e a customer) a subfolder exists named with the check-in, date which is only accessible for that specific customer at that specific time for privacy reasons of course.
 even an automatic deletion of folders & files can be configured by changing the time frame.


 still in wip...

 #bash #script #photos #holidays #url #free #solution #nginx #webpage
