/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package utils.thejasonengine.com;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.io.*;
import java.nio.file.*;
import java.util.zip.*;
import java.util.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class OSDetectorAndTaskControl {
    private static final Logger LOGGER = LogManager.getLogger(OSDetectorAndTaskControl.class);

    public static String detectOS(String filePath, String schedule, String taskName, String action) {
        String osName = System.getProperty("os.name").toLowerCase();
        String osType;
        if (osName.contains("win")) {
            osType = "Windows";
        } else if (osName.contains("mac")) {
            osType = "MacOS";
        } else if (osName.contains("nix") || osName.contains("nux") || osName.contains("aix")) {
            osType = "Unix";
        } else {
            LOGGER.error("Unknown OS");
            return "Unknown OS";
        }

        try {
            if ("Add".equalsIgnoreCase(action)) {
                scheduleTask(filePath, schedule, taskName, osType);
                return "Add task " + osType;
            } else if ("Delete".equalsIgnoreCase(action)) {
                deleteScheduleTask(taskName, osType);
                return "Delete task " + osType;
            } else if ("Deploy".equalsIgnoreCase(action)) {
                // Use the unified deployment method
                return deployContentPack(taskName, filePath);
            } else {
                LOGGER.error("Unknown action: " + action);
                return "Unknown action";
            }
        } catch (Exception e) {
            LOGGER.error("Error during task processing: " + e.getMessage());
            return "Error processing task";
        }
    }

 // Unified deployment method that auto-detects OS
    public static String deployContentPack(String zipFilePath, String outputDir) {
        String osName = System.getProperty("os.name").toLowerCase();
        try {
            if (osName.contains("win")) {
                unzipAndRunMainScriptWindows(zipFilePath, outputDir);
                return "Deployed pack successfully on Windows";
            } else if (osName.contains("nix") || osName.contains("nux") || osName.contains("aix")) {
                unzipAndRunMainScriptLinux(zipFilePath, outputDir);
                return "Deployed pack successfully on Linux/Unix";
            } else if (osName.contains("mac")) {
                unzipAndRunMainScriptLinux(zipFilePath, outputDir);
                return "Deployed pack successfully on macOS";
            } else {
                return "Unsupported OS: " + osName;
            }
        } catch (Exception e) {
            LOGGER.error("Deployment failed: " + e.getMessage(), e);
            return "Deployment failed: " + e.getMessage();
        }
    }
    // Existing scheduling methods remain unchanged
    private static void scheduleTask(String filePath, String schedule, String taskName, String osType) throws Exception {
        if ("Windows".equals(osType)) {
            scheduleWindowsTask(filePath, schedule, taskName);
        } else {
            scheduleUnixTask(filePath, schedule, taskName, osType);
        }
    }

    private static void scheduleWindowsTask(String filePath, String schedule, String taskName) throws Exception {
        String taskNameTS = "ScheduledScript_" + taskName;
        List<String> command = new ArrayList<>();
        command.addAll(Arrays.asList("schtasks", "/create", "/tn", taskNameTS, "/tr", "cmd /c \"" + filePath + "\"", "/sc", schedule, "/f"));
        executeCommand(command);
        LOGGER.info("Windows task scheduled: " + taskNameTS);
    }

    private static void scheduleUnixTask(String filePath, String schedule, String taskName, String osType) throws Exception {
        String cronEntry = schedule + " /bin/sh " + filePath + " # TaskName: " + taskName;
        List<String> currentCron = getCurrentCron();
        currentCron.add(cronEntry);
        updateCron(currentCron);
        if ("MacOS".equals(osType)) {
            LOGGER.warn("Scheduled using cron on macOS. Consider using launchd for better compatibility.");
        }
    }

    private static void deleteScheduleTask(String taskName, String osType) throws Exception {
        if ("Windows".equals(osType)) {
            deleteWindowsTask(taskName);
        } else {
            deleteUnixTask(taskName);
        }
    }

    private static void deleteWindowsTask(String taskName) throws Exception {
        String taskNameTS = "ScheduledScript_" + taskName;
        List<String> command = Arrays.asList("schtasks", "/delete", "/tn", taskNameTS, "/f");
        executeCommand(command);
        LOGGER.info("Windows task deleted: " + taskNameTS);
    }

    private static void deleteUnixTask(String taskName) throws Exception {
        List<String> currentCron = getCurrentCron();
        List<String> newCron = new ArrayList<>();
        String taskMarker = "# TaskName: " + taskName;
        for (String line : currentCron) {
            if (!line.contains(taskMarker)) {
                newCron.add(line);
            }
        }
        updateCron(newCron);
    }

    private static List<String> getCurrentCron() throws Exception {
        ProcessBuilder pb = new ProcessBuilder("crontab", "-l");
        Process p = pb.start();
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        int exitCode = p.waitFor();
        if (exitCode != 0 && exitCode != 1) { // Exit code 1 means no crontab
            throw new Exception("Failed to read crontab. Exit code: " + exitCode);
        }
        return lines;
    }

    private static void updateCron(List<String> lines) throws Exception {
        String tempFile = "tempCron.txt";
        // Ensure the content ends with a newline to prevent premature EOF
        String content = String.join("\n", lines) + "\n";
        Files.write(Paths.get(tempFile), content.getBytes());
        try (BufferedReader br = new BufferedReader(new FileReader(tempFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                LOGGER.debug("Lines of file" + line);
            }
        }
        executeCommand(Arrays.asList("crontab", tempFile));
        Files.deleteIfExists(Paths.get(tempFile));
    }

    private static void executeCommand(List<String> command) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            Process process = processBuilder.start();
            consumeStream(process.getInputStream(), false);
            consumeStream(process.getErrorStream(), true);
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                LOGGER.error("Command failed: " + command + " (exit code " + exitCode + ")");
            }
        } catch (Exception e) {
            LOGGER.error("Error executing command: " + e.getMessage(), e);
        }
    }

    private static void consumeStream(java.io.InputStream inputStream, boolean isError) {
        new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (isError) {
                        LOGGER.error("Command error: " + line);
                    } else {
                        LOGGER.info("Command output: " + line);
                    }
                }
            } catch (Exception e) {
                LOGGER.error("Error reading stream: " + e.getMessage(), e);
            }
        }).start();
    }

    // Deployment methods
    public static void unzipAndRunMainScriptLinux(String zipFilePath, String outputDir) throws IOException {
        LOGGER.info("Starting Linux unzip operation for: " + zipFilePath);
        
        // Create output directory with proper permissions
        Path outputPath = Paths.get(outputDir);
        if (!Files.exists(outputPath)) {
            Files.createDirectories(outputPath);
            setLinuxPermissions(outputPath, "755");
        }

        // Unzip the file
        try (ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath))) {
            ZipEntry entry;
            while ((entry = zipIn.getNextEntry()) != null) {
                Path filePath = outputPath.resolve(entry.getName()).normalize();
                
                // Security check: prevent zip slip vulnerability
                if (!filePath.startsWith(outputPath)) {
                    throw new IOException("Malicious zip entry: " + entry.getName());
                }
                
                if (entry.isDirectory()) {
                    Files.createDirectories(filePath);
                } else {
                    Files.createDirectories(filePath.getParent());
                    try (FileOutputStream fos = new FileOutputStream(filePath.toFile())) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = zipIn.read(buffer)) != -1) {
                            fos.write(buffer, 0, bytesRead);
                        }
                    }
                    
                    // Set executable permission for script files
                    if (filePath.toString().endsWith(".sh")) {
                        setLinuxPermissions(filePath, "755");
                    }
                }
                zipIn.closeEntry();
            }
        }
        LOGGER.info("Unzip completed to: " + outputDir);

        // Find the main script
        Path mainScript = findMainScript(outputPath);
        if (mainScript == null) {
            throw new FileNotFoundException("No main script found in extracted files");
        }

        LOGGER.info("Found main script: " + mainScript);
        executeLinuxScript(mainScript.toString(), outputDir);
    }

    public static void unzipAndRunMainScriptWindows(String zipFilePath, String outputDir) throws IOException {
        LOGGER.info("Starting Windows unzip operation for: " + zipFilePath);
        
        // Create output directory if it doesn't exist
        Path outputPath = Paths.get(outputDir);
        if (!Files.exists(outputPath)) {
            Files.createDirectories(outputPath);
        }

        // Unzip the file
        try (ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath))) {
            ZipEntry entry;
            while ((entry = zipIn.getNextEntry()) != null) {
                Path filePath = outputPath.resolve(entry.getName()).normalize();
                
                // Security check: prevent zip slip vulnerability
                if (!filePath.startsWith(outputPath)) {
                    throw new IOException("Malicious zip entry: " + entry.getName());
                }
                
                if (entry.isDirectory()) {
                    Files.createDirectories(filePath);
                } else {
                    Files.createDirectories(filePath.getParent());
                    try (FileOutputStream fos = new FileOutputStream(filePath.toFile())) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = zipIn.read(buffer)) != -1) {
                            fos.write(buffer, 0, bytesRead);
                        }
                    }
                }
                zipIn.closeEntry();
            }
        }
        LOGGER.info("Unzip completed to: " + outputDir);

        // Find the main batch file
        Path mainBatch = findMainBatch(outputPath);
        if (mainBatch == null) {
            throw new FileNotFoundException("No main batch file found in extracted files");
        }

        LOGGER.info("Found main batch file: " + mainBatch);
        executeWindowsBatch(mainBatch.toString(), outputDir);
    }

    private static Path findMainScript(Path directory) throws IOException {
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(directory)) {
            for (Path file : stream) {
                if (Files.isRegularFile(file)) {
                    String filename = file.getFileName().toString().toLowerCase();
                    if (filename.endsWith(".sh") && filename.contains("main")) {
                        return file;
                    }
                }
            }
        }
        
        // If not found in root, search recursively
        return Files.walk(directory)
            .filter(Files::isRegularFile)
            .filter(file -> {
                String filename = file.getFileName().toString().toLowerCase();
                return filename.endsWith(".sh") && filename.contains("main");
            })
            .findFirst()
            .orElse(null);
    }

    private static Path findMainBatch(Path directory) throws IOException {
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(directory)) {
            for (Path file : stream) {
                if (Files.isRegularFile(file)) {
                    String filename = file.getFileName().toString().toLowerCase();
                    if (filename.endsWith(".bat") && filename.contains("main")) {
                        return file;
                    }
                }
            }
        }
        
        // If not found in root, search recursively
        return Files.walk(directory)
            .filter(Files::isRegularFile)
            .filter(file -> {
                String filename = file.getFileName().toString().toLowerCase();
                return filename.endsWith(".bat") && filename.contains("main");
            })
            .findFirst()
            .orElse(null);
    }

    private static void setLinuxPermissions(Path path, String permissions) throws IOException {
        List<String> command = Arrays.asList("chmod", permissions, path.toString());
        executeCommand(command);
        LOGGER.info("Set permissions " + permissions + " for: " + path);
    }

    private static void executeLinuxScript(String scriptPath, String workingDir) {
        List<String> command = new ArrayList<>();
        command.add("/bin/bash");
        command.add(scriptPath);

        executeCommandWithWorkingDir(command, workingDir);
    }

    private static void executeWindowsBatch(String batchPath, String workingDir) {
        List<String> command = new ArrayList<>();
        command.add("cmd.exe");
        command.add("/c");
        command.add(batchPath);

        executeCommandWithWorkingDir(command, workingDir);
    }

    private static void executeCommandWithWorkingDir(List<String> command, String workingDir) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            if (workingDir != null) {
                processBuilder.directory(new File(workingDir));
            }
            
            // Merge stdout and stderr
            processBuilder.redirectErrorStream(true);
            
            Process process = processBuilder.start();
            StringBuilder output = new StringBuilder();
            
            // Capture output
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append("\n");
                    LOGGER.info("Script output: " + line);
                }
            }
            
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                LOGGER.error("Script execution failed. Exit code: " + exitCode);
                LOGGER.error("Output: " + output);
                throw new RuntimeException("Script execution failed with code " + exitCode);
            } else {
                LOGGER.info("Main script executed successfully");
            }
        } catch (Exception e) {
            LOGGER.error("Error executing script: " + e.getMessage(), e);
            throw new RuntimeException("Script execution error", e);
        }
    }
}