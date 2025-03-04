/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package authentication.thejasonengine.com;

public class AuthService {

    
    private static final String VALID_USERNAME = "used_in_testing";
    private static final String VALID_PASSWORD = "used_in_testing";

    public boolean validateLogin(String username, String password) 
    {
         return VALID_USERNAME.equals(username) && VALID_PASSWORD.equals(password);
    }
}