package com.webease.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Unit III & V: Java EE Servlet Filter API
 * Intercepts requests to administrative and fleet management resources.
 * Ensures only authenticated founders with an active HttpSession can access the internal console.
 */
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization lifecycle
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Prevent client browser caching of restricted admin screens
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("adminUser") != null);

        if (isLoggedIn) {
            // Authorized founder session active, proceed with request
            chain.doFilter(request, response);
        } else {
            // Unauthorized visitor, redirect to founder login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin-login.jsp");
        }
    }

    @Override
    public void destroy() {
        // Filter cleanup lifecycle
    }
}
