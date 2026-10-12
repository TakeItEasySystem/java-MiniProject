package com.webease.controller;

import com.webease.dao.SiteDAO;
import com.webease.model.ClientSite;
import com.webease.service.MonitorService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Unit III, IV & V: RESTful JSON Servlet consumed by React 18 telemetry component
 */
public class HealthPingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SiteDAO siteDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.siteDAO = new SiteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();

        if ("fleet".equalsIgnoreCase(action)) {
            List<ClientSite> sites = siteDAO.getAllSites();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < sites.size(); i++) {
                ClientSite s = sites.get(i);
                int ping = MonitorService.getInstance().measureResponseTime(s.getDomainUrl());
                sb.append("{")
                  .append("\"siteId\":").append(s.getId()).append(",")
                  .append("\"businessName\":\"").append(escapeJson(s.getBusinessName())).append("\",")
                  .append("\"responseTimeMs\":").append(ping).append(",")
                  .append("\"uptimePercentage\":").append(s.getUptimePercentage()).append(",")
                  .append("\"status\":\"").append(escapeJson(s.getStatus())).append("\"")
                  .append("}");
                if (i < sites.size() - 1) sb.append(",");
            }
            sb.append("]");
            out.print(sb.toString());
            out.flush();
            return;
        }

        int siteId = 1;
        String domainParam = req.getParameter("domain");
        if (domainParam != null && !domainParam.trim().isEmpty()) {
            String domain = domainParam.trim();
            // 1. Search database to see if this is an enrolled client site
            List<ClientSite> allSites = siteDAO.getAllSites();
            ClientSite matchedSite = null;
            String cleanInput = domain.toLowerCase().replaceAll("https?://", "").replaceAll("^www\\.", "").replaceAll("/.*", "").trim();

            // Validate that the input is an actual domain with a TLD extension
            if (!cleanInput.contains(".") || cleanInput.length() < 4 || cleanInput.endsWith(".")) {
                out.print("{" +
                        "\"found\":false," +
                        "\"enrolled\":false," +
                        "\"error\":\"Invalid domain name format. Please enter a valid domain address (e.g., yourbusiness.in or company.com).\"" +
                        "}");
                out.flush();
                return;
            }

            for (ClientSite s : allSites) {
                String sDomain = s.getDomainUrl() != null ? s.getDomainUrl().toLowerCase().replaceAll("https?://", "").replaceAll("^www\\.", "").replaceAll("/.*", "").trim() : "";
                String sName = s.getBusinessName() != null ? s.getBusinessName().toLowerCase().trim() : "";

                if (!cleanInput.isEmpty() && (sDomain.equals(cleanInput) || sName.equalsIgnoreCase(cleanInput))) {
                    matchedSite = s;
                    break;
                }
            }

            if (matchedSite != null) {
                int ping = MonitorService.getInstance().measureResponseTime(matchedSite.getDomainUrl());
                String status = (ping < 0) ? "Down" : ((ping > 1200) ? "Warning" : "Healthy");
                String nowTime = new SimpleDateFormat("HH:mm:ss").format(new Date());

                out.print("{" +
                        "\"found\":true," +
                        "\"enrolled\":true," +
                        "\"siteId\":" + matchedSite.getId() + "," +
                        "\"businessName\":\"" + escapeJson(matchedSite.getBusinessName()) + "\"," +
                        "\"domainUrl\":\"" + escapeJson(matchedSite.getDomainUrl()) + "\"," +
                        "\"status\":\"" + status + "\"," +
                        "\"responseTimeMs\":" + ping + "," +
                        "\"uptimePercentage\":" + matchedSite.getUptimePercentage() + "," +
                        "\"pageSpeedScore\":" + matchedSite.getPageSpeedScore() + "," +
                        "\"lastChecked\":\"" + nowTime + "\"" +
                        "}");
                out.flush();
                return;
            }

            // 2. Not enrolled in WebEase. Measure real host availability on the internet.
            int ping = MonitorService.getInstance().measureResponseTime(domain);
            if (ping < 0) {
                // Host unreachable, does not exist, or invalid domain string
                out.print("{" +
                        "\"found\":false," +
                        "\"enrolled\":false," +
                        "\"error\":\"Domain unreachable or invalid host. Could not resolve DNS or establish connection.\"" +
                        "}");
                out.flush();
                return;
            }

            // Real domain on the web, but not in our fleet database
            String nowTime = new SimpleDateFormat("HH:mm:ss").format(new Date());
            out.print("{" +
                    "\"found\":true," +
                    "\"enrolled\":false," +
                    "\"siteId\":0," +
                    "\"businessName\":\"" + escapeJson(domain) + "\"," +
                    "\"domainUrl\":\"" + escapeJson(domain) + "\"," +
                    "\"status\":\"Online (Not Enrolled)\"," +
                    "\"responseTimeMs\":" + ping + "," +
                    "\"lastChecked\":\"" + nowTime + "\"," +
                    "\"message\":\"Domain is active on the public web, but is not currently enrolled in WebEase 24/7 proactive monitoring.\"" +
                    "}");
            out.flush();
            return;
        }

        ClientSite site = null;
        try {
            site = siteDAO.getSiteById(siteId);
        } catch (Exception e) {
            List<ClientSite> all = siteDAO.getAllSites();
            if (!all.isEmpty()) {
                site = all.get(0);
            }
        }

        if (site == null) {
            out.print("{\"available\":false,\"message\":\"No active client websites enrolled yet.\"}");
            out.flush();
            return;
        }

        // Measure live ping using HealthChecker
        int newPing = MonitorService.getInstance().measureResponseTime(site.getDomainUrl());
        String status = (newPing > 1200) ? "Warning" : "Healthy";
        String nowTime = new SimpleDateFormat("HH:mm:ss").format(new Date());

        // Update database record
        siteDAO.updateHealthMetrics(site.getId(), status, newPing, site.getUptimePercentage(), "Today at " + nowTime);

        out.print("{" +
                "\"siteId\":" + site.getId() + "," +
                "\"businessName\":\"" + escapeJson(site.getBusinessName()) + "\"," +
                "\"domainUrl\":\"" + escapeJson(site.getDomainUrl()) + "\"," +
                "\"status\":\"" + status + "\"," +
                "\"responseTimeMs\":" + newPing + "," +
                "\"uptimePercentage\":" + site.getUptimePercentage() + "," +
                "\"pageSpeedScore\":" + site.getPageSpeedScore() + "," +
                "\"lastChecked\":\"" + nowTime + "\"" +
                "}");
        out.flush();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
