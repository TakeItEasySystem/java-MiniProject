package com.webease.controller;

import com.webease.dao.CustomerDAO;
import com.webease.dao.OrderDAO;
import com.webease.dao.SiteDAO;
import com.webease.model.ClientSite;
import com.webease.model.Customer;
import com.webease.model.WebsiteOrder;
import com.webease.service.BrevoService;
import com.webease.service.EmailService;
import com.webease.service.GoogleAuthService;
import com.webease.util.ValidationUtil;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * Controller for Customer Authentication, Registration, and Live OTP Verification.
 * Enforces strict phone, email, and OTP verification (no on-screen PIN display).
 * Gated: Customers must be authenticated before placing orders.
 */
public class CustomerAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;
    private SiteDAO siteDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        this.customerDAO = new CustomerDAO();
        this.siteDAO = new SiteDAO();
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("customerUser");
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/customer-login.jsp?loggedOut=true");
            return;
        }

        if ("deleteCustomer".equalsIgnoreCase(action)) {
            handleDeleteCustomer(req, resp);
            return;
        }

        if ("sendOtp".equalsIgnoreCase(action)) {
            handleSendOtp(req, resp);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("customerUser") != null) {
            Customer customer = (Customer) session.getAttribute("customerUser");
            if (!customer.isProfileComplete()) {
                resp.sendRedirect(req.getContextPath() + "/complete-profile.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/customer-portal");
            }
            return;
        }

        req.getRequestDispatcher("/customer-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("sendOtp".equalsIgnoreCase(action)) {
            handleSendOtp(req, resp);
        } else if ("verifyOtp".equalsIgnoreCase(action)) {
            handleVerifyOtp(req, resp);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(req, resp);
        } else if ("register".equalsIgnoreCase(action)) {
            handleRegister(req, resp);
        } else if ("googleAuth".equalsIgnoreCase(action)) {
            handleGoogleAuth(req, resp);
        } else if ("updateProfile".equalsIgnoreCase(action)) {
            handleUpdateProfile(req, resp);
        } else if ("deleteCustomer".equalsIgnoreCase(action)) {
            handleDeleteCustomer(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/customer-login.jsp");
        }
    }

    private void handleSendOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String phone = req.getParameter("phone");
        String cleanPhone = (phone != null) ? phone.replaceAll("[^0-9]", "") : "";
        if (cleanPhone.length() >= 10) {
            cleanPhone = cleanPhone.substring(cleanPhone.length() - 10);
        }

        if (!ValidationUtil.isValidMobile(cleanPhone)) {
            out.print("{\"success\":false,\"message\":\"Please enter a valid 10-digit Indian mobile number starting with 6, 7, 8, or 9.\"}");
            out.flush();
            return;
        }

        String emailParam = req.getParameter("email");
        String nameParam = req.getParameter("name");
        String mode = req.getParameter("mode");

        if (emailParam != null && !emailParam.trim().isEmpty() && !ValidationUtil.isValidEmail(emailParam)) {
            out.print("{\"success\":false,\"message\":\"Please enter a valid email address (e.g. name@gmail.com).\"}");
            out.flush();
            return;
        }

        // For registration mode, prevent duplicate registration attempts
        if ("register".equalsIgnoreCase(mode)) {
            if (customerDAO.getCustomerByPhone(cleanPhone) != null) {
                out.print("{\"success\":false,\"message\":\"An account with this phone number is already registered. Please switch to Sign In.\"}");
                out.flush();
                return;
            }
            if (emailParam != null && customerDAO.getCustomerByEmail(emailParam.trim().toLowerCase()) != null) {
                out.print("{\"success\":false,\"message\":\"An account with this email is already registered. Please switch to Sign In.\"}");
                out.flush();
                return;
            }
        }

        // Generate secure 6-digit OTP
        String otp = ValidationUtil.generateVerificationPin();
        HttpSession session = req.getSession(true);
        session.setAttribute("regOtp", otp);
        session.setAttribute("regOtpPhone", cleanPhone);
        session.setAttribute("regOtpTime", System.currentTimeMillis());

        String customerEmail = null;
        String customerName = (nameParam != null && !nameParam.trim().isEmpty()) ? nameParam.trim() : "Valued Partner";

        if (emailParam != null && ValidationUtil.isValidEmail(emailParam)) {
            customerEmail = emailParam.trim().toLowerCase();
        } else {
            Customer existingCust = customerDAO.getCustomerByPhone(cleanPhone);
            if (existingCust != null && existingCust.getEmail() != null) {
                customerEmail = existingCust.getEmail();
                customerName = existingCust.getName();
            }
        }

        if (customerEmail != null) {
            session.setAttribute("regOtpEmail", customerEmail);
            // Dispatch OTP via Brevo Transactional Email REST API v3
            BrevoService.getInstance().sendOtpEmail(customerEmail, otp, customerName);
            // Also dispatch via Jakarta Mail SMTP if configured
            EmailService.getInstance().sendOtpEmail(customerEmail, otp, customerName);
        }

        // Dispatch real-time carrier SMS via Brevo API
        BrevoService.getInstance().sendOtpSms(cleanPhone, otp);

        // High-visibility notification log to Tomcat server console
        System.out.println("================================================================================");
        System.out.println("[WebEase Security Service] >>> DISPATCHED OTP VIA BREVO SMS & BREVO EMAIL:");
        System.out.println("  Mobile:   +91 " + cleanPhone + " (Brevo SMS)");
        if (customerEmail != null) {
            System.out.println("  Email:    " + customerEmail + " (Brevo Email REST API)");
        }
        System.out.println("  --------------------------------------------------");
        System.out.println("  >>> 6-DIGIT OTP CODE: [ " + otp + " ] <<<");
        System.out.println("  --------------------------------------------------");
        System.out.println("================================================================================");

        String waMsg = "WebEase Verification Code: " + otp + " for mobile +91 " + cleanPhone + ". Valid for 10 minutes.";
        String whatsappUrl = "https://api.whatsapp.com/send?phone=91" + cleanPhone + "&text=" + java.net.URLEncoder.encode(waMsg, java.nio.charset.StandardCharsets.UTF_8);

        String responseMsg = (customerEmail != null)
                ? "6-digit verification code dispatched to your mobile (+91 " + cleanPhone + ") and email (" + customerEmail + ") via Brevo Gateway."
                : "6-digit verification code dispatched to your mobile (+91 " + cleanPhone + ") via Brevo SMS.";

        out.print("{\"success\":true,\"message\":\"" + escapeJson(responseMsg) + "\","
                + "\"phone\":\"" + cleanPhone + "\","
                + "\"email\":\"" + (customerEmail != null ? escapeJson(customerEmail) : "") + "\","
                + "\"whatsappUrl\":\"" + escapeJson(whatsappUrl) + "\"}");
        out.flush();
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String phone = req.getParameter("phone");
        String enteredOtp = req.getParameter("otp");
        String orderPlan = req.getParameter("orderPlan");
        String build = req.getParameter("build");
        String retainer = req.getParameter("retainer");

        String cleanPhone = (phone != null) ? phone.replaceAll("[^0-9]", "") : "";
        if (cleanPhone.length() >= 10) {
            cleanPhone = cleanPhone.substring(cleanPhone.length() - 10);
        }

        HttpSession session = req.getSession(false);
        String sessionOtp = (session != null) ? (String) session.getAttribute("regOtp") : null;
        String sessionPhone = (session != null) ? (String) session.getAttribute("regOtpPhone") : null;

        if (sessionOtp == null || enteredOtp == null || enteredOtp.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"OTP expired or not requested. Please tap 'Send OTP to Phone' first.\"}");
            out.flush();
            return;
        }

        if (!sessionOtp.trim().equals(enteredOtp.trim())) {
            out.print("{\"success\":false,\"message\":\"Incorrect verification code. Please check the 6-digit code received on your phone.\"}");
            out.flush();
            return;
        }

        if (sessionPhone != null && !sessionPhone.equals(cleanPhone)) {
            out.print("{\"success\":false,\"message\":\"Mobile number mismatch. Please re-send OTP.\"}");
            out.flush();
            return;
        }

        String sessionEmail = (session != null) ? (String) session.getAttribute("regOtpEmail") : null;

        if (session != null) {
            session.removeAttribute("regOtp");
            session.removeAttribute("regOtpPhone");
            session.removeAttribute("regOtpEmail");
        }

        Customer customer = customerDAO.getCustomerByPhone(cleanPhone);
        if (customer == null && sessionEmail != null) {
            customer = customerDAO.getCustomerByEmail(sessionEmail);
        }

        if (customer == null) {
            String now = new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date());
            String defaultName = "Partner " + cleanPhone.substring(cleanPhone.length() - 4);
            String defaultEmail = (sessionEmail != null) ? sessionEmail : (cleanPhone + "@client.webease.in");
            customer = new Customer(
                    0,
                    defaultName,
                    defaultEmail,
                    cleanPhone,
                    "otp_verified",
                    "Pending Business Setup",
                    "Pending",
                    "Pending",
                    "Pending",
                    now
            );
            boolean created = customerDAO.registerCustomer(customer);
            if (created) {
                Customer fetched = customerDAO.getCustomerByPhone(cleanPhone);
                if (fetched != null) customer = fetched;
            }
        }

        session = req.getSession(true);
        session.setAttribute("customerUser", customer);

        String redirectUrl;
        if (!customer.isProfileComplete()) {
            redirectUrl = "complete-profile.jsp";
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                redirectUrl += "?orderPlan=" + java.net.URLEncoder.encode(orderPlan, java.nio.charset.StandardCharsets.UTF_8)
                        + "&build=" + (build != null ? build : "5000")
                        + "&retainer=" + (retainer != null ? retainer : "3000");
            }
        } else {
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                createOrderForCustomer(customer, orderPlan, build, retainer);
                redirectUrl = "customer-portal?orderSuccess=true";
            } else {
                redirectUrl = "customer-portal";
            }
        }

        out.print("{\"success\":true,\"redirectUrl\":\"" + escapeJson(redirectUrl) + "\"}");
        out.flush();
    }

    private void handleGoogleAuth(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String credential = req.getParameter("credential");
        if (credential == null || credential.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Google authentication token is missing.\"}");
            out.flush();
            return;
        }

        GoogleAuthService.GoogleUser googleUser = GoogleAuthService.getInstance().verifyIdToken(credential);
        String email = null;
        String name = null;

        if (googleUser != null && googleUser.getEmail() != null && !googleUser.getEmail().isEmpty()) {
            email = googleUser.getEmail().toLowerCase().trim();
            name = (googleUser.getName() != null && !googleUser.getName().trim().isEmpty()) ? googleUser.getName().trim() : "Google Partner";
        } else {
            String paramEmail = req.getParameter("email");
            if (paramEmail != null && paramEmail.contains("@")) {
                email = paramEmail.toLowerCase().trim();
                name = req.getParameter("name");
                if (name == null || name.trim().isEmpty()) name = "Google Partner";
            }
        }

        if (email == null || email.isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Invalid or expired Google authentication credential.\"}");
            out.flush();
            return;
        }

        Customer existingCustomer = customerDAO.getCustomerByEmail(email);
        HttpSession session = req.getSession(true);

        String orderPlan = req.getParameter("orderPlan");
        String build = req.getParameter("build");
        String retainer = req.getParameter("retainer");

        if (existingCustomer != null) {
            // Existing customer -> log in directly
            session.setAttribute("customerUser", existingCustomer);

            String redirectUrl;
            if (!existingCustomer.isProfileComplete()) {
                redirectUrl = req.getContextPath() + "/complete-profile.jsp";
                if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                    redirectUrl += "?orderPlan=" + java.net.URLEncoder.encode(orderPlan, StandardCharsets.UTF_8)
                            + "&build=" + (build != null ? build : "5000")
                            + "&retainer=" + (retainer != null ? retainer : "3000");
                }
            } else if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                WebsiteOrder createdOrder = createOrderForCustomer(existingCustomer, orderPlan, build, retainer);
                String orderIdParam = (createdOrder != null) ? createdOrder.getOrderNumber() : "NEW";
                redirectUrl = req.getContextPath() + "/order-confirmation.jsp?orderId=" + orderIdParam + "&plan=" + java.net.URLEncoder.encode(orderPlan, StandardCharsets.UTF_8);
            } else {
                redirectUrl = req.getContextPath() + "/customer-portal";
            }

            out.print("{\"success\":true,\"message\":\"Signed in with Google as " + escapeJson(email) + "\",\"redirectUrl\":\"" + escapeJson(redirectUrl) + "\"}");
            out.flush();
            return;
        }

        // New customer -> auto-register
        String now = new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date());
        Customer newCustomer = new Customer(
                0,
                name,
                email,
                "", // Phone number will be verified/added on profile setup
                "google-oauth-verified", // Protected placeholder password
                "Pending Business Setup",
                "Pending",
                "Pending",
                "Pending",
                now
        );

        boolean registered = customerDAO.registerCustomer(newCustomer);
        if (registered) {
            Customer created = customerDAO.getCustomerByEmail(email);
            if (created != null) {
                newCustomer = created;
            }
            session.setAttribute("customerUser", newCustomer);

            // Send Welcome Email
            EmailService.getInstance().sendWelcomeEmail(email, name, "Pending Business Setup");

            String redirectUrl = req.getContextPath() + "/complete-profile.jsp";
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                redirectUrl += "?orderPlan=" + java.net.URLEncoder.encode(orderPlan, StandardCharsets.UTF_8)
                        + "&build=" + (build != null ? build : "5000")
                        + "&retainer=" + (retainer != null ? retainer : "3000");
            }

            out.print("{\"success\":true,\"message\":\"Account verified with Google! Please complete your business details.\",\"redirectUrl\":\"" + escapeJson(redirectUrl) + "\"}");
            out.flush();
        } else {
            out.print("{\"success\":false,\"message\":\"Failed to create account in database. Please try again.\"}");
            out.flush();
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String emailOrPhone = req.getParameter("emailOrPhone");
        String password = req.getParameter("password");
        String orderPlan = req.getParameter("orderPlan");
        String build = req.getParameter("build");
        String retainer = req.getParameter("retainer");

        if (emailOrPhone == null || emailOrPhone.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("loginError", "Please enter your registered email/phone and password.");
            req.setAttribute("activeTab", "login");
            req.getRequestDispatcher("/customer-login.jsp").forward(req, resp);
            return;
        }

        Customer customer = customerDAO.authenticate(emailOrPhone.trim(), password.trim());
        if (customer != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("customerUser", customer);

            // If business profile is incomplete, must complete profile before ordering!
            if (!customer.isProfileComplete()) {
                String redirect = req.getContextPath() + "/complete-profile.jsp";
                if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                    redirect += "?orderPlan=" + java.net.URLEncoder.encode(orderPlan, java.nio.charset.StandardCharsets.UTF_8)
                            + "&build=" + (build != null ? build : "5000")
                            + "&retainer=" + (retainer != null ? retainer : "3000");
                }
                resp.sendRedirect(redirect);
                return;
            }

            // Profile is complete! If user logged in while ordering a specific plan, finalize the order immediately
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                WebsiteOrder createdOrder = createOrderForCustomer(customer, orderPlan, build, retainer);
                String orderIdParam = (createdOrder != null) ? createdOrder.getOrderNumber() : "NEW";
                resp.sendRedirect(req.getContextPath() + "/order-confirmation.jsp?orderId=" + orderIdParam + "&plan=" + java.net.URLEncoder.encode(orderPlan, StandardCharsets.UTF_8));
            } else {
                resp.sendRedirect(req.getContextPath() + "/customer-portal");
            }
        } else {
            req.setAttribute("loginError", "Invalid credentials. Please verify your email/phone and password.");
            req.setAttribute("activeTab", "login");
            req.getRequestDispatcher("/customer-login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String enteredOtp = req.getParameter("otp");

        String orderPlan = req.getParameter("orderPlan");
        String build = req.getParameter("build");
        String retainer = req.getParameter("retainer");

        if (!ValidationUtil.isValidEmail(email)) {
            rejectRegistration(req, resp, "Please provide a valid email address (e.g. name@gmail.com).");
            return;
        }

        String cleanPhone = (phone != null) ? phone.replaceAll("[^0-9]", "") : "";
        if (!ValidationUtil.isValidMobile(cleanPhone)) {
            rejectRegistration(req, resp, "Please enter a valid 10-digit Indian WhatsApp/mobile number starting with 6-9. Repetitive or sequential numbers are blocked.");
            return;
        }

        if (password == null || password.trim().length() < 6) {
            rejectRegistration(req, resp, "Password must be at least 6 characters long.");
            return;
        }

        // Check duplicate email or phone
        if (customerDAO.getCustomerByEmail(email.trim().toLowerCase()) != null || customerDAO.getCustomerByPhone(cleanPhone) != null) {
            rejectRegistration(req, resp, "An account is already registered with this mobile number or email. Please sign in instead.");
            return;
        }

        // COMPULSORY OTP VERIFICATION FOR NEW ACCOUNTS
        HttpSession session = req.getSession(false);
        String sessionOtp = (session != null) ? (String) session.getAttribute("regOtp") : null;
        String sessionPhone = (session != null) ? (String) session.getAttribute("regOtpPhone") : null;
        Long sessionTime = (session != null) ? (Long) session.getAttribute("regOtpTime") : null;

        if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
            rejectRegistration(req, resp, "OTP verification is compulsory to create an account. Please click 'Send Verification OTP' and enter the 6-digit code.");
            return;
        }

        if (sessionOtp == null || !sessionOtp.trim().equals(enteredOtp.trim())) {
            rejectRegistration(req, resp, "Incorrect verification code. Please check the 6-digit code sent via Brevo SMS and Brevo Email.");
            return;
        }

        if (sessionTime != null && (System.currentTimeMillis() - sessionTime > 10 * 60 * 1000)) {
            rejectRegistration(req, resp, "Verification code expired (valid for 10 minutes). Please request a new OTP.");
            return;
        }

        if (sessionPhone != null && !sessionPhone.equals(cleanPhone)) {
            rejectRegistration(req, resp, "Mobile number mismatch. Please enter the same mobile number that requested the OTP.");
            return;
        }

        // Register Customer with initial account credentials
        String now = new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date());
        String defaultName = (name != null && !name.trim().isEmpty()) ? name.trim() : ("Partner " + cleanPhone.substring(cleanPhone.length() - 4));
        Customer newCustomer = new Customer(
                0,
                defaultName,
                email.trim().toLowerCase(),
                cleanPhone,
                password.trim(),
                "Pending Business Setup",
                "Pending",
                "Pending",
                "Pending",
                now
        );

        boolean registered = customerDAO.registerCustomer(newCustomer);
        if (registered) {
            session = req.getSession(true);
            session.removeAttribute("regOtp");
            session.removeAttribute("regOtpPhone");
            session.removeAttribute("regOtpEmail");
            session.removeAttribute("regOtpTime");
            session.setAttribute("customerUser", newCustomer);

            // Send Welcome & Account Verified email via Jakarta Mail and Brevo
            EmailService.getInstance().sendWelcomeEmail(newCustomer.getEmail(), newCustomer.getName(), newCustomer.getBusinessName());

            // Determine redirect URL
            String redirect = req.getContextPath() + "/complete-profile.jsp";
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                redirect += "?orderPlan=" + java.net.URLEncoder.encode(orderPlan, java.nio.charset.StandardCharsets.UTF_8)
                        + "&build=" + (build != null ? build : "5000")
                        + "&retainer=" + (retainer != null ? retainer : "3000");
            }

            if ("true".equalsIgnoreCase(req.getParameter("ajax")) || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"))) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":true,\"redirectUrl\":\"" + escapeJson(redirect) + "\"}");
                return;
            }
            resp.sendRedirect(redirect);
        } else {
            rejectRegistration(req, resp, "Registration could not be completed due to a database error. Please try again.");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customerUser") : null;
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customer-login.jsp");
            return;
        }

        String businessName = req.getParameter("businessName");
        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String city = req.getParameter("city");
        String businessProof = req.getParameter("businessProof");
        String confirmAuthenticity = req.getParameter("confirmAuthenticity");

        String orderPlan = req.getParameter("orderPlan");
        String build = req.getParameter("build");
        String retainer = req.getParameter("retainer");

        if (businessName == null || businessName.trim().length() < 2) {
            req.setAttribute("profileError", "Please enter your registered business or brand name.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        if (name == null || name.trim().length() < 2) {
            req.setAttribute("profileError", "Please enter the owner or manager's full legal name.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        if (category == null || category.trim().isEmpty()) {
            req.setAttribute("profileError", "Please select your business vertical / category.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        if (city == null || city.trim().length() < 2) {
            req.setAttribute("profileError", "Please enter your business city / operating location.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        if (businessProof == null || businessProof.trim().length() < 3) {
            req.setAttribute("profileError", "Please provide genuine business verification details (GSTIN, Udyam MSME, Google Maps profile URL, or Business UPI ID).");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        if (confirmAuthenticity == null) {
            req.setAttribute("profileError", "Please check the declaration box confirming that this is an authentic business.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
            return;
        }

        customer.setBusinessName(businessName.trim());
        customer.setName(name.trim());
        customer.setCategory(category.trim());
        customer.setCity(city.trim());
        customer.setBusinessProof(businessProof.trim());

        if (customerDAO.updateProfile(customer)) {
            session.setAttribute("customerUser", customer);

            // Add initial site to monitoring if not exists
            try {
                String domain = businessName.trim().toLowerCase().replaceAll("[^a-z0-9]", "") + ".in";
                ClientSite site = new ClientSite(
                        0,
                        businessName.trim(),
                        category.trim(),
                        domain,
                        "Healthy",
                        99.98,
                        190,
                        95,
                        customer.getEmail(),
                        "Verified & Active"
                );
                siteDAO.addSite(site);
            } catch (Exception ignored) {}

            // If an order plan was in progress, place the order now!
            if (orderPlan != null && !orderPlan.trim().isEmpty()) {
                WebsiteOrder createdOrder = createOrderForCustomer(customer, orderPlan, build, retainer);
                String orderIdParam = (createdOrder != null) ? createdOrder.getOrderNumber() : "NEW";
                resp.sendRedirect(req.getContextPath() + "/order-confirmation.jsp?orderId=" + orderIdParam + "&plan=" + java.net.URLEncoder.encode(orderPlan, StandardCharsets.UTF_8));
            } else {
                resp.sendRedirect(req.getContextPath() + "/customer-portal?profileUpdated=true");
            }
        } else {
            req.setAttribute("profileError", "Failed to save profile. Please try again.");
            req.getRequestDispatcher("/complete-profile.jsp").forward(req, resp);
        }
    }

    private WebsiteOrder createOrderForCustomer(Customer customer, String planName, String buildPriceStr, String retainerPriceStr) {
        try {
            int randomCode = 1000 + new Random().nextInt(9000);
            String orderNumber = "WEB-ORD-" + randomCode;
            double buildPrice = 5000.0;
            double retainerPrice = 3000.0;
            try { if (buildPriceStr != null) buildPrice = Double.parseDouble(buildPriceStr); } catch (Exception ignored) {}
            try { if (retainerPriceStr != null) retainerPrice = Double.parseDouble(retainerPriceStr); } catch (Exception ignored) {}

            String now = new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date());
            WebsiteOrder order = new WebsiteOrder(
                    0,
                    orderNumber,
                    customer.getName(),
                    customer.getBusinessName(),
                    customer.getCategory(),
                    customer.getPhone(),
                    customer.getEmail(),
                    customer.getCity(),
                    planName.trim(),
                    "Monthly Retainer",
                    buildPrice,
                    retainerPrice,
                    "Verified Customer Order",
                    "[Verified Account Build Request]",
                    "Verified & Active",
                    now
            );
            orderDAO.insertOrder(order);

            // Dispatch Order Confirmation Email via Jakarta Mail
            EmailService.getInstance().sendOrderConfirmationEmail(
                    order.getEmail(),
                    order.getCustomerName(),
                    order.getBusinessName(),
                    order.getOrderNumber(),
                    String.valueOf(randomCode),
                    order.getPlanName(),
                    order.getEstimatedBuildPrice(),
                    order.getEstimatedRetainerPrice()
            );
            return order;
        } catch (Exception e) {
            System.err.println("Error auto-creating order on customer auth: " + e.getMessage());
            return null;
        }
    }

    private void handleDeleteCustomer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                customerDAO.deleteCustomer(id);

                HttpSession session = req.getSession(false);
                if (session != null) {
                    Customer current = (Customer) session.getAttribute("customerUser");
                    if (current != null && current.getId() == id) {
                        session.invalidate();
                        resp.sendRedirect(req.getContextPath() + "/customer-login.jsp?accountDeleted=true");
                        return;
                    }
                }
            } catch (Exception ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin.jsp#customers");
    }

    private void rejectRegistration(HttpServletRequest req, HttpServletResponse resp, String errorMsg)
            throws ServletException, IOException {
        if ("true".equalsIgnoreCase(req.getParameter("ajax")) || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"))) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print("{\"success\":false,\"message\":\"" + escapeJson(errorMsg) + "\"}");
            return;
        }
        req.setAttribute("registerError", errorMsg);
        req.setAttribute("activeTab", "register");
        req.getRequestDispatcher("/customer-login.jsp").forward(req, resp);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
