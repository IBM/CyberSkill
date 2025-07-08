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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class OSDetectorAndTaskControlBack {
    private static final Logger LOGGER = LogManager.getLogger(OSDetectorAndTaskControlBack.class);

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
            } else {
                LOGGER.error("Unknown action: " + action);
                return "Unknown action";
            }
        } catch (Exception e) {
            LOGGER.error("Error during task processing: " + e.getMessage());
            return "Error processing task";
        }
    }

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
}