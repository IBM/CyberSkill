package com.cyberskill.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for generating PDF certificates
 */
public class PdfCertificateGenerator {
    private static final Logger logger = LoggerFactory.getLogger(PdfCertificateGenerator.class);
    
    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 36, Font.BOLD, new BaseColor(102, 126, 234));
    private static final Font SUBTITLE_FONT = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLACK);
    private static final Font BODY_FONT = new Font(Font.FontFamily.HELVETICA, 14, Font.NORMAL, BaseColor.DARK_GRAY);
    private static final Font CERT_NUMBER_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY);
    
    /**
     * Generate a certificate PDF and return as byte array
     */
    public static byte[] generateCertificate(
            String userName,
            String pathName,
            String certificateNumber,
            LocalDateTime issuedAt
    ) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4.rotate());
            PdfWriter.getInstance(document, baos);
            document.open();
            
            addCertificateContent(document, userName, pathName, certificateNumber, issuedAt);
            
            document.close();
            logger.info("Certificate PDF generated successfully for user: {}", userName);
            
            return baos.toByteArray();
        } catch (Exception e) {
            logger.error("Error generating certificate PDF", e);
            return new byte[0];
        }
    }
    
    /**
     * Generate a certificate PDF and save to file
     */
    public static void generateCertificateToFile(
            String userName,
            String pathName,
            String certificateNumber,
            LocalDateTime issuedAt,
            String outputPath
    ) {
        try {
            Document document = new Document(PageSize.A4.rotate());
            PdfWriter.getInstance(document, new FileOutputStream(outputPath));
            document.open();
            
            addCertificateContent(document, userName, pathName, certificateNumber, issuedAt);
            
            document.close();
            logger.info("Certificate PDF saved to: {}", outputPath);
        } catch (Exception e) {
            logger.error("Error generating certificate PDF to file", e);
        }
    }
    
    /**
     * Add certificate content to the document
     */
    private static void addCertificateContent(
            Document document,
            String userName,
            String pathName,
            String certificateNumber,
            LocalDateTime issuedAt
    ) throws DocumentException {
        
        // Add spacing from top
        document.add(new Paragraph("\n\n\n"));
        
        // Certificate Title
        Paragraph title = new Paragraph("CERTIFICATE OF COMPLETION", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        
        document.add(new Paragraph("\n\n"));
        
        // "This is to certify that"
        Paragraph certifyText = new Paragraph("This is to certify that", BODY_FONT);
        certifyText.setAlignment(Element.ALIGN_CENTER);
        document.add(certifyText);
        
        document.add(new Paragraph("\n"));
        
        // User Name
        Paragraph userNamePara = new Paragraph(userName, SUBTITLE_FONT);
        userNamePara.setAlignment(Element.ALIGN_CENTER);
        document.add(userNamePara);
        
        document.add(new Paragraph("\n"));
        
        // "has successfully completed"
        Paragraph completedText = new Paragraph("has successfully completed the", BODY_FONT);
        completedText.setAlignment(Element.ALIGN_CENTER);
        document.add(completedText);
        
        document.add(new Paragraph("\n"));
        
        // Path Name
        Paragraph pathNamePara = new Paragraph(pathName, SUBTITLE_FONT);
        pathNamePara.setAlignment(Element.ALIGN_CENTER);
        document.add(pathNamePara);
        
        document.add(new Paragraph("\n"));
        
        // "learning path"
        Paragraph learningPathText = new Paragraph("Learning Path", BODY_FONT);
        learningPathText.setAlignment(Element.ALIGN_CENTER);
        document.add(learningPathText);
        
        document.add(new Paragraph("\n\n"));
        
        // Issue Date
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
        String formattedDate = issuedAt.format(formatter);
        Paragraph dateText = new Paragraph("Issued on: " + formattedDate, BODY_FONT);
        dateText.setAlignment(Element.ALIGN_CENTER);
        document.add(dateText);
        
        document.add(new Paragraph("\n\n"));
        
        // Certificate Number
        Paragraph certNumber = new Paragraph("Certificate Number: " + certificateNumber, CERT_NUMBER_FONT);
        certNumber.setAlignment(Element.ALIGN_CENTER);
        document.add(certNumber);
        
        document.add(new Paragraph("\n"));
        
        // Footer
        Paragraph footer = new Paragraph("CyberSkill Platform - Cybersecurity Learning & Upskilling", CERT_NUMBER_FONT);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);
    }
}

// Made with Bob
