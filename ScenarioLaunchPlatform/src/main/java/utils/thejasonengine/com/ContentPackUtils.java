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


public class ContentPackUtils {
	 private static final Logger LOGGER = LogManager.getLogger(ContentPackUtils.class);

    public static class PackParseResult {
        public final String unpackedDir;
        public final String packJsonContent;

        public PackParseResult(String unpackedDir, String packJsonContent) {
            this.unpackedDir = unpackedDir;
            this.packJsonContent = packJsonContent;
        }
    }

    public static PackParseResult unzipAndExtractPackJson(String zipFilePath, String outputBaseDir) throws IOException {
        String unpackDir = outputBaseDir + File.separator + "contentpacks" + File.separator;
        
        LOGGER.debug("This is the upacked dir: " + unpackDir);
        Files.createDirectories(Paths.get(unpackDir));

        String packJsonContent = null;

        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(zipFilePath))) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                Path outPath = Paths.get(unpackDir, entry.getName());
                if (entry.isDirectory()) {
                    Files.createDirectories(outPath);
                } else {
                    Files.createDirectories(outPath.getParent());
                    Files.copy(zis, outPath, StandardCopyOption.REPLACE_EXISTING);

                    if (entry.getName().toLowerCase().endsWith("pack.json")) {
                        packJsonContent = Files.readString(outPath);
                    }
                }
                zis.closeEntry();
            }
        }

        if (packJsonContent == null) {
            throw new FileNotFoundException("pack.json not found in the archive.");
        }

        return new PackParseResult(unpackDir, packJsonContent);
    }
}
