package com.webease.controller;

import com.webease.dao.CustomerDAO;
import com.webease.dao.OrderDAO;
import com.webease.dao.SiteDAO;
import com.webease.dao.TicketDAO;
import com.webease.model.ClientSite;
import com.webease.model.Customer;
import com.webease.model.MaintenanceTicket;
import com.webease.model.WebsiteOrder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Controller for Dedicated Customer Portal & Business Profile Hub.
 * Shows verified profile credentials, ongoing website build orders,
 * real-time uptime telemetry, and maintenance support tickets.
 */
public class CustomerPortalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CustomerDAO customerDAO;
    private OrderDAO orderDAO;
    private SiteDAO siteDAO;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        this.customerDAO = new CustomerDAO();
        this.orderDAO = new OrderDAO();
        this.siteDAO = new SiteDAO();
        this.ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customerUser") : null;

        if (customer == null) {
            // Not authenticated: send to customer login/registration page
            resp.sendRedirect(req.getContextPath() + "/customer-login.jsp");
            return;
        }

        if (!customer.isProfileComplete()) {
            resp.sendRedirect(req.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Refresh customer details from database
        Customer refreshed = customerDAO.getCustomerById(customer.getId());
        if (refreshed != null) {
            customer = refreshed;
            session.setAttribute("customerUser", customer);
        }

        // Load customer-specific orders
        List<WebsiteOrder> orders = orderDAO.getOrdersByEmail(customer.getEmail());
        if (orders.isEmpty() && customer.getPhone() != null) {
            orders = orderDAO.getOrdersByPhone(customer.getPhone());
        }

        // Load customer-specific website telemetry
        List<ClientSite> sites = siteDAO.getSitesByOwnerEmail(customer.getEmail());
        if (sites.isEmpty()) {
            // Check if there is an enrolled site with matching business name
            List<ClientSite> allSites = siteDAO.getAllSites();
            for (ClientSite s : allSites) {
                if (s.getBusinessName() != null && s.getBusinessName().equalsIgnoreCase(customer.getBusinessName())) {
                    sites.add(s);
                }
            }
        }

        // Load maintenance tickets
        List<MaintenanceTicket> tickets = ticketDAO.getTicketsByBusinessName(customer.getBusinessName());

        req.setAttribute("customer", customer);
        req.setAttribute("orders", orders);
        req.setAttribute("sites", sites);
        req.setAttribute("tickets", tickets);

        req.getRequestDispatcher("/customer-portal.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customerUser") : null;

        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customer-login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("submitTicket".equalsIgnoreCase(action)) {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            String priority = req.getParameter("priority");

            if (title != null && !title.trim().isEmpty()) {
                String now = new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date());
                MaintenanceTicket ticket = new MaintenanceTicket(
                        0,
                        1,
                        customer.getBusinessName(),
                        title.trim(),
                        description != null ? description.trim() : "Standard client maintenance request",
                        category != null ? category.trim() : "Content Update",
                        priority != null ? priority.trim() : "Normal",
                        "Open",
                        now
                );
                try {
                    ticketDAO.createTicket(ticket);
                } catch (com.webease.exception.InvalidTicketException e) {
                    System.err.println("Invalid ticket submitted: " + e.getMessage());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/customer-portal?ticketCreated=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/customer-portal");
    }
}
