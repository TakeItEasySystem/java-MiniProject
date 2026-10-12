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
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Unit III & V: Controller handling Maintenance Tickets, Form Submissions, and JSON APIs
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
        String statusFilter = req.getParameter("status");
        String siteIdParam = req.getParameter("siteId");
        String format = req.getParameter("format");

        List<MaintenanceTicket> tickets;
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"All".equalsIgnoreCase(statusFilter)) {
            tickets = ticketDAO.getTicketsByStatus(statusFilter.trim());
        } else if (siteIdParam != null && !siteIdParam.trim().isEmpty()) {
            try {
                int sid = Integer.parseInt(siteIdParam.trim());
                tickets = ticketDAO.getTicketsBySiteId(sid);
            } catch (Exception e) {
                tickets = ticketDAO.getAllTickets();
            }
        } else {
            tickets = ticketDAO.getAllTickets();
        }

        if ("json".equalsIgnoreCase(format)) {
            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print(serializeTicketsToJson(tickets));
            out.flush();
            return;
        }

        List<ClientSite> sites = siteDAO.getAllSites();
        req.setAttribute("tickets", tickets);
        req.setAttribute("sites", sites);
        req.setAttribute("pendingCount", ticketDAO.getCountByStatus("Pending"));
        req.setAttribute("inProgressCount", ticketDAO.getCountByStatus("In Progress"));
        req.setAttribute("resolvedCount", ticketDAO.getCountByStatus("Resolved"));

        req.getRequestDispatcher("/tickets.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String format = req.getParameter("format");
        boolean isAjax = "json".equalsIgnoreCase(format) || "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        boolean success = false;
        String message = "";

        try {
            if ("updateStatus".equalsIgnoreCase(action)) {
                String ticketIdParam = req.getParameter("ticketId");
                String newStatus = req.getParameter("status");

                if (ticketIdParam != null && newStatus != null) {
                    int ticketId = Integer.parseInt(ticketIdParam.trim());
                    success = ticketDAO.updateStatus(ticketId, newStatus.trim());
                    message = success ? "Ticket status updated to " + newStatus : "Failed to update ticket";
                }
            } else if ("deleteTicket".equalsIgnoreCase(action)) {
                String ticketIdParam = req.getParameter("ticketId");
                if (ticketIdParam != null) {
                    int ticketId = Integer.parseInt(ticketIdParam.trim());
                    success = ticketDAO.deleteTicket(ticketId);
                    message = success ? "Ticket deleted successfully" : "Failed to delete ticket";
                }
            } else {
                // New Ticket Submission
                int siteId = 1;
                String siteIdParam = req.getParameter("siteId");
                if (siteIdParam != null && !siteIdParam.trim().isEmpty()) {
                    try {
                        siteId = Integer.parseInt(siteIdParam.trim());
                    } catch (Exception ignored) {}
                }

                String businessName = req.getParameter("businessName");
                if (businessName == null || businessName.trim().isEmpty()) {
                    try {
                        ClientSite site = siteDAO.getSiteById(siteId);
                        businessName = site.getBusinessName();
                    } catch (Exception e) {
                        businessName = "WebEase Client Site";
                    }
                }

                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String category = req.getParameter("category");
                String priority = req.getParameter("priority");

                if (category == null || category.trim().isEmpty()) {
                    category = "Content Update";
                }
                if (priority == null || priority.trim().isEmpty()) {
                    priority = "Normal";
                }

                String now = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
                MaintenanceTicket ticket = new MaintenanceTicket(0, siteId, businessName.trim(), title, description, category, priority, "Pending", now);

                success = ticketDAO.createTicket(ticket);
                message = success ? "Ticket submitted successfully (ID #" + ticket.getId() + ")" : "Failed to submit ticket";
            }
        } catch (InvalidTicketException e) {
            success = false;
            message = e.getMessage();
            req.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            success = false;
            message = "Server error: " + e.getMessage();
            req.setAttribute("errorMessage", message);
        }

        if (isAjax) {
            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
            out.flush();
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/tickets");
    }

    private String serializeTicketsToJson(List<MaintenanceTicket> tickets) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < tickets.size(); i++) {
            MaintenanceTicket t = tickets.get(i);
            sb.append("{")
              .append("\"id\":").append(t.getId()).append(",")
              .append("\"siteId\":").append(t.getSiteId()).append(",")
              .append("\"businessName\":\"").append(escapeJson(t.getBusinessName())).append("\",")
              .append("\"title\":\"").append(escapeJson(t.getTitle())).append("\",")
              .append("\"description\":\"").append(escapeJson(t.getDescription())).append("\",")
              .append("\"category\":\"").append(escapeJson(t.getCategory())).append("\",")
              .append("\"priority\":\"").append(escapeJson(t.getPriority())).append("\",")
              .append("\"status\":\"").append(escapeJson(t.getStatus())).append("\",")
              .append("\"createdAt\":\"").append(escapeJson(t.getCreatedAt())).append("\"")
              .append("}");
            if (i < tickets.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
