import org.mindrot.jbcrypt.BCrypt;

public class GenerateHash {
    public static void main(String[] args) {
        // Generate hash for admin123
        String adminPassword = "admin123";
        String adminHash = BCrypt.hashpw(adminPassword, BCrypt.gensalt(10));
        System.out.println("Admin password: " + adminPassword);
        System.out.println("Admin hash: " + adminHash);
        System.out.println("Verify admin: " + BCrypt.checkpw(adminPassword, adminHash));
        System.out.println();
        
        // Generate hash for user123
        String userPassword = "user123";
        String userHash = BCrypt.hashpw(userPassword, BCrypt.gensalt(10));
        System.out.println("User password: " + userPassword);
        System.out.println("User hash: " + userHash);
        System.out.println("Verify user: " + BCrypt.checkpw(userPassword, userHash));
        System.out.println();
        
        // Test the hashes from schema.sql
        String oldAdminHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("Testing old admin hash with 'admin123': " + BCrypt.checkpw("admin123", oldAdminHash));
    }
}

// Made with Bob
