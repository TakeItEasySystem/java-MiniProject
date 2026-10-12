package com.webease.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Unit III & V: MVC Controller (HttpServlet) for Founder & Admin Authentication.
 * Manages admin session lifecycle, login credential verification, and secure session invalidation.
 */
public class AdminAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Default WebEase Founder Credentials
    private static final String ADMIN_USER_1 = "admin";
    private static final String ADMIN_USER_2 = "rishi";
    private static final String ADMIN_USER_3 = "ayush";
    private static final String ADMIN_USER_4 = "yadnesh";
    private static final String ADMIN_PASS = "webease2026";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("adminUser");
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin-login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        boolean isValid = false;
        String normalizedUser = (username != null) ? username.trim().toLowerCase() : "";

        if (password != null && ADMIN_PASS.equals(password.trim())) {
            if (ADMIN_USER_1.equals(normalizedUser) ||
                ADMIN_USER_2.equals(normalizedUser) ||
                ADMIN_USER_3.equals(normalizedUser) ||
                ADMIN_USER_4.equals(normalizedUser)) {
                isValid = true;
            }
        }

        if (isValid) {
            HttpSession session = req.getSession(true);
            session.setAttribute("adminUser", username.trim());
            session.setAttribute("loginTime", new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date()));
            // Session timeout: 30 minutes inactivity
            session.setMaxInactiveInterval(30 * 60);

            resp.sendRedirect(req.getContextPath() + "/admin");
        } else {
            req.setAttribute("errorMessage", "Invalid credentials. Access restricted to WebEase founders.");
            req.getRequestDispatcher("/admin-login.jsp").forward(req, resp);
        }
    }
}
