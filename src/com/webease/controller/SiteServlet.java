package com.webease.controller;

import com.webease.dao.LeadDAO;
import com.webease.dao.OrderDAO;
import com.webease.dao.SiteDAO;
import com.webease.model.ClientSite;
import com.webease.service.MonitorService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Unit III & V: MVC Controller (HttpServlet)
 * - Servlet lifecycle (init, service, doGet, doPost)
 * - Handles client switching, fleet administrative management & CRUD operations
 * - Forwards model data to JSP views or returns JSON responses
 */
public class SiteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SiteDAO siteDAO;
    private LeadDAO leadDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.siteDAO = new SiteDAO();
        this.leadDAO = new LeadDAO();
        this.orderDAO = new OrderDAO();
        // Start background health monitoring daemon thread (Unit II Multithreading)
        MonitorService.getInstance().startBackgroundMonitoring();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String view = req.getParameter("view");
        String format = req.getParameter("format");

        List<ClientSite> sites = siteDAO.getAllSites();

        // Support JSON API query
        if ("json".equalsIgnoreCase(format)) {
            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print(serializeSitesToJson(sites));
            out.flush();
            return;
        }

        req.setAttribute("sites", sites);

        ClientSite activeSite = null;
        String siteIdParam = req.getParameter("id");
        if (siteIdParam != null && !siteIdParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(siteIdParam.trim());
                activeSite = siteDAO.getSiteById(id);
            } catch (Exception ignored) {}
        }
        if (activeSite == null && !sites.isEmpty()) {
            activeSite = sites.get(0); // Default to first site (The Daily Bite Café)
        }
        req.setAttribute("activeSite", activeSite);

        // Routing logic based on URL pattern or view parameter
        if ("/admin".equals(servletPath) || "admin".equalsIgnoreCase(view)) {
            req.setAttribute("leads", leadDAO.getAllLeads());
            req.setAttribute("orders", orderDAO.getAllOrders());
            req.setAttribute("avgFleetUptime", siteDAO.getAverageFleetUptime());
            req.setAttribute("avgFleetLatency", siteDAO.getAverageFleetLatency());
            req.getRequestDispatcher("/admin.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("addSite".equalsIgnoreCase(action)) {
                String businessName = req.getParameter("businessName");
                String category = req.getParameter("category");
                String domainUrl = req.getParameter("domainUrl");
                String ownerEmail = req.getParameter("ownerEmail");

                if (businessName != null && !businessName.trim().isEmpty() &&
                    domainUrl != null && !domainUrl.trim().isEmpty()) {

                    ClientSite newSite = new ClientSite(
                            0,
                            businessName.trim(),
                            category != null ? category.trim() : "Local Business",
                            domainUrl.trim(),
                            "Healthy",
                            99.9,
                            220,
                            90,
                            ownerEmail != null ? ownerEmail.trim() : "",
                            "Just onboarded"
                    );

                    siteDAO.addSite(newSite);
                }
            } else if ("deleteSite".equalsIgnoreCase(action)) {
                String idParam = req.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int id = Integer.parseInt(idParam.trim());
                    siteDAO.deleteSite(id);
                }
            } else if ("checkFleet".equalsIgnoreCase(action)) {
                // Trigger manual fleet diagnostic sweep
                MonitorService.getInstance().checkAllSitesNow();
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Operation failed: " + e.getMessage());
        }

        // Redirect back to referring page or admin console
        String referer = req.getHeader("Referer");
        if (referer != null && referer.contains("admin")) {
            resp.sendRedirect(req.getContextPath() + "/admin");
        } else {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private String serializeSitesToJson(List<ClientSite> sites) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < sites.size(); i++) {
            ClientSite s = sites.get(i);
            sb.append("{")
              .append("\"id\":").append(s.getId()).append(",")
              .append("\"businessName\":\"").append(escapeJson(s.getBusinessName())).append("\",")
              .append("\"category\":\"").append(escapeJson(s.getCategory())).append("\",")
              .append("\"domainUrl\":\"").append(escapeJson(s.getDomainUrl())).append("\",")
              .append("\"status\":\"").append(escapeJson(s.getStatus())).append("\",")
              .append("\"uptimePercentage\":").append(s.getUptimePercentage()).append(",")
              .append("\"responseTimeMs\":").append(s.getResponseTimeMs()).append(",")
              .append("\"pageSpeedScore\":").append(s.getPageSpeedScore()).append(",")
              .append("\"ownerEmail\":\"").append(escapeJson(s.getOwnerEmail())).append("\",")
              .append("\"lastChecked\":\"").append(escapeJson(s.getLastChecked())).append("\"")
              .append("}");
            if (i < sites.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
