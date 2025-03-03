# Cyber Awareness Platform (CAP)
CAP has been built to raise awareness on Cyber Security issues and specifically on OWASP Top 10 and SANS 25

Before starting your CAP instance, ensure you have all of your settings in the [site.properties] configured correctly.  
```properties example
url = jdbc:postgresql://localhost:5432/CAP
databaseUsername = postgres
databasePassword = postgres
activefolder = C:/challenges
swapSpace = C:/challenge_swapSpace
trash = C:/challenge_trash
authentication = local
urlXSSCheckServer = http://localhost:8000
```
1. The url value should point at your postgresql instance
2. The databaseUsername should be your db user for the schema described in the URL
3. Plaintext pass for databaseUsername
4. activeFolder should be an already created folder in your system
5. swapSpace should be an already created folder in your system
6. trash should be an already created folder in your system
7. authentication can be set to ldap or local. Ldap is recommended as its the most tested
8. urlXSSCheckServer can be set to a server locally or remote.
