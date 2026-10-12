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

/**
 * Unit III, IV & V: RESTful JSON Servlet consumed by React component
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

        int siteId = 1;
        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                siteId = Integer.parseInt(idParam);
            } catch (Exception ignored) {}
        }

        ClientSite site = null;
        try {
            site = siteDAO.getSiteById(siteId);
        } catch (Exception e) {
            site = new ClientSite(1, "The Daily Bite Café", "Restaurants & Cafés", "thedailybite.in", "Healthy", 99.98, 248, 92, "contact@thedailybite.in", "Just now");
        }

        // Measure live ping using HealthChecker
        int newPing = MonitorService.getInstance().measureResponseTime(site.getDomainUrl());
        String now = new SimpleDateFormat("HH:mm:ss").format(new Date());

        // Update database record
        siteDAO.updateHealthMetrics(site.getId(), "Healthy", newPing, site.getUptimePercentage(), "Today at " + now);

        PrintWriter out = resp.getWriter();
        out.print("{" +
                "\"siteId\":" + site.getId() + "," +
                "\"businessName\":\"" + site.getBusinessName().replace("\"", "\\\"") + "\"," +
                "\"domainUrl\":\"" + site.getDomainUrl() + "\"," +
                "\"status\":\"Healthy\"," +
                "\"responseTimeMs\":" + newPing + "," +
                "\"uptimePercentage\":" + site.getUptimePercentage() + "," +
                "\"pageSpeedScore\":" + site.getPageSpeedScore() + "," +
                "\"lastChecked\":\"" + now + "\"" +
                "}");
        out.flush();
    }
}
