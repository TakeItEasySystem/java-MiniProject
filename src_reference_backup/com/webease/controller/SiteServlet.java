package com.webease.controller;

import com.webease.dao.SiteDAO;
import com.webease.model.ClientSite;
import com.webease.service.MonitorService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Unit III & V: MVC Controller (HttpServlet)
 * - Servlet lifecycle (init, service, doGet)
 * - Handling request & response
 * - Forwarding model data to JSP view
 */
public class SiteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SiteDAO siteDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.siteDAO = new SiteDAO();
        // Start background health monitoring daemon thread (Unit II Multithreading)
        MonitorService.getInstance().startBackgroundMonitoring();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String view = req.getParameter("view");
        List<ClientSite> sites = siteDAO.getAllSites();
        req.setAttribute("sites", sites);

        ClientSite activeSite = null;
        String siteIdParam = req.getParameter("id");
        if (siteIdParam != null && !siteIdParam.isEmpty()) {
            try {
                int id = Integer.parseInt(siteIdParam);
                activeSite = siteDAO.getSiteById(id);
            } catch (Exception ignored) {}
        }
        if (activeSite == null && !sites.isEmpty()) {
            activeSite = sites.get(0); // Default to The Daily Bite Café
        }
        req.setAttribute("activeSite", activeSite);

        if ("admin".equalsIgnoreCase(view)) {
            req.getRequestDispatcher("/admin.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        }
    }
}
