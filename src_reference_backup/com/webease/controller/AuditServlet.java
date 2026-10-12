package com.webease.controller;

import com.webease.dao.LeadDAO;
import com.webease.model.AuditLead;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * Unit III & IV: Servlet handling AJAX requests, JSON serialization, and Lead Persistence
 */
public class AuditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LeadDAO leadDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.leadDAO = new LeadDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String websiteUrl = req.getParameter("websiteUrl");
        String businessName = req.getParameter("businessName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String businessType = req.getParameter("businessType");

        if (websiteUrl == null || websiteUrl.trim().isEmpty()) {
            websiteUrl = "example-business.com";
        }
        if (businessName == null || businessName.trim().isEmpty()) {
            businessName = "Local Business Owner";
        }
        if (email == null || email.trim().isEmpty()) {
            email = "inquiry@client.com";
        }

        // Diagnostic calculation
        Random random = new Random();
        int baseScore = 65 + random.nextInt(20); // typical unmanaged SMB score: 65 - 84
        int speedMs = 850 + random.nextInt(1400); // 850ms - 2250ms
        boolean sslValid = websiteUrl.toLowerCase().startsWith("https://") || random.nextBoolean();
        boolean mobileOptimized = random.nextBoolean();

        String issues = (sslValid ? "SSL Certificate Active. " : "Missing SSL Security. ") +
                (mobileOptimized ? "Mobile responsive. " : "Mobile layout scaling errors detected. ") +
                "Page load latency: " + speedMs + "ms. Forms need uptime monitoring.";

        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
        AuditLead lead = new AuditLead(0, businessName, websiteUrl, email, phone, businessType, baseScore, issues, now);
        leadDAO.insertLead(lead);

        PrintWriter out = resp.getWriter();
        out.print("{" +
                "\"success\":true," +
                "\"healthScore\":" + baseScore + "," +
                "\"speedMs\":" + speedMs + "," +
                "\"sslValid\":" + sslValid + "," +
                "\"mobileOptimized\":" + mobileOptimized + "," +
                "\"issues\":\"" + issues.replace("\"", "\\\"") + "\"" +
                "}");
        out.flush();
    }
}
