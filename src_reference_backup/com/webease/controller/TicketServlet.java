package com.webease.controller;

import com.webease.dao.SiteDAO;
import com.webease.dao.TicketDAO;
import com.webease.exception.InvalidTicketException;
import com.webease.model.ClientSite;
import com.webease.model.MaintenanceTicket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Unit III & V: Controller handling Form submissions and Session / Request data
 */
public class TicketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TicketDAO ticketDAO;
    private SiteDAO siteDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.ticketDAO = new TicketDAO();
        this.siteDAO = new SiteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<MaintenanceTicket> tickets = ticketDAO.getAllTickets();
        List<ClientSite> sites = siteDAO.getAllSites();

        req.setAttribute("tickets", tickets);
        req.setAttribute("sites", sites);
        req.getRequestDispatcher("/tickets.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                String newStatus = req.getParameter("status");
                ticketDAO.updateStatus(ticketId, newStatus);
            } else {
                // New Ticket Submission from Client
                int siteId = Integer.parseInt(req.getParameter("siteId"));
                String businessName = req.getParameter("businessName");
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String category = req.getParameter("category");
                String priority = req.getParameter("priority");

                if (priority == null || priority.isEmpty()) {
                    priority = "Normal";
                }

                String now = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
                MaintenanceTicket ticket = new MaintenanceTicket(0, siteId, businessName, title, description, category, priority, "Pending", now);

                ticketDAO.createTicket(ticket);
            }
        } catch (InvalidTicketException e) {
            req.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/tickets");
    }
}
