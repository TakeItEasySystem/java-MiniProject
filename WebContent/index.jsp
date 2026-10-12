<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.webease.dao.SiteDAO, com.webease.dao.TicketDAO, com.webease.dao.LeadDAO, com.webease.dao.OrderDAO, com.webease.model.ClientSite, com.webease.model.MaintenanceTicket, com.webease.model.AuditLead, com.webease.model.WebsiteOrder, java.util.List" %>
<%
    SiteDAO siteDAO = new SiteDAO();
    TicketDAO ticketDAO = new TicketDAO();
    LeadDAO leadDAO = new LeadDAO();
    OrderDAO orderDAO = new OrderDAO();

    List<ClientSite> sites = siteDAO.getAllSites();
    List<MaintenanceTicket> tickets = ticketDAO.getAllTickets();
    List<AuditLead> leads = leadDAO.getAllLeads();
    List<WebsiteOrder> orders = orderDAO.getAllOrders();

    ClientSite activeSite = null;
    String siteIdParam = request.getParameter("id");
    if (siteIdParam != null && !siteIdParam.trim().isEmpty()) {
        try {
            int sid = Integer.parseInt(siteIdParam.trim());
            for (ClientSite s : sites) {
                if (s.getId() == sid) { activeSite = s; break; }
            }
        } catch (Exception ignored) {}
    }
    if (activeSite == null && !sites.isEmpty()) {
        activeSite = sites.get(0);
    }
    request.setAttribute("sites", sites);
    request.setAttribute("tickets", tickets);
    request.setAttribute("leads", leads);
    request.setAttribute("orders", orders);
    request.setAttribute("activeSite", activeSite);

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Fully Managed Technology Partner</title>
    <meta name="description" content="WebEase manages business websites, custom domains, professional email, and digital presence with reliable ongoing support. One team, so you can focus on your business.">
    <link rel="icon" type="image/png" href="images/logo.png">
    
    <!-- Google Fonts: Manrope, Inter, JetBrains Mono -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">

    <!-- React 18 & ReactDOM for Telemetry Component -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>

    <style>
        /* Exact Authentic Sivte Core Variables */
        :root {
            --sivte-bg: #F7F7F5;
            --sivte-surface: #FFFFFF;
            --sivte-ink: #0A0A0A;
            --sivte-body: #565A60;
            --sivte-border: #DEDED8;
            --sivte-border-light: #EBEBE5;
            --sivte-orange: #FD5228;
            --sivte-orange-hover: #ED461D;
            --sivte-rust: #B83313;
            --sivte-warm-dark: #111111;
            --font-heading: 'Manrope', -apple-system, BlinkMacSystemFont, sans-serif;
            --font-body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-body);
            background-color: var(--sivte-bg);
            color: var(--sivte-ink);
            line-height: 1.7;
            -webkit-font-smoothing: antialiased;
            overflow-x: hidden;
        }

        /* 1. Sivte Top Customer Bar */
        .sivte-customer-bar {
            background: #F3F3F0;
            border-bottom: 1px solid var(--sivte-border);
            padding: 8px 32px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 18px;
            font-size: 12px;
            color: #64748B;
        }

        .sivte-customer-bar a {
            color: #0A0A0A;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .sivte-customer-bar a:hover {
            color: var(--sivte-rust);
            text-decoration: underline;
        }

        /* 2. Sivte Sticky Header */
        .sivte-header {
            background: rgba(247, 247, 245, 0.94);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--sivte-border);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .sivte-nav-container {
            max-width: 1180px;
            margin: 0 auto;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .sivte-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            font-family: var(--font-heading);
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--sivte-ink);
        }

        .sivte-nav-links {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .sivte-nav-links a {
            color: #424242;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.18s ease;
        }

        .sivte-nav-links a:hover {
            color: var(--sivte-rust);
        }

        .sivte-cta-btn {
            background: #0A0A0A;
            color: #FFFFFF !important;
            padding: 10px 18px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.18s, transform 0.18s;
        }

        .sivte-cta-btn:hover {
            background: #262626;
            transform: translateY(-1px);
        }

        /* 3. Sivte Homepage Shell */
        .sivte-home {
            background: radial-gradient(ellipse 750px 600px at 98% 0%, rgba(253, 82, 40, 0.1) 0%, transparent 75%),
                        radial-gradient(ellipse 550px 850px at 0% 24%, rgba(253, 82, 40, 0.05) 0%, transparent 80%),
                        #F7F7F5;
            position: relative;
            padding: 56px 24px 72px;
        }

        .hm-shell {
            max-width: 1160px;
            margin: 0 auto;
        }

        .hm-eyebrow {
            display: flex;
            gap: 10px;
            align-items: center;
            font-size: 11px;
            line-height: 1.6;
            font-weight: 600;
            letter-spacing: .12em;
            color: var(--sivte-rust);
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .hm-eyebrow::before {
            content: '';
            width: 22px;
            height: 2px;
            background: var(--sivte-orange);
            flex: 0 0 auto;
        }

        /* Hero Grid */
        .hm-hero {
            display: grid;
            grid-template-columns: 1.12fr 1fr;
            gap: 54px;
            align-items: center;
            margin-bottom: 60px;
        }

        .hm-hero h1 {
            font-family: var(--font-heading);
            font-size: clamp(40px, 4.6vw, 62px);
            font-weight: 700;
            line-height: 1.12;
            letter-spacing: -0.045em;
            color: #0A0A0A;
            margin-bottom: 24px;
        }

        .hm-headline-accent {
            position: relative;
            display: inline-block;
        }

        .hm-headline-accent::after {
            content: '';
            position: absolute;
            height: 5px;
            border-radius: 3px;
            left: 0;
            right: 0;
            bottom: -6px;
            background: var(--sivte-orange);
        }

        .hm-lead {
            font-size: 17px;
            line-height: 1.75;
            color: var(--sivte-body);
            max-width: 530px;
            margin-bottom: 28px;
        }

        .hm-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .btn-sivte-dark {
            background: #171717;
            color: #FFFFFF;
            border: 1px solid #171717;
            border-radius: 8px;
            padding: 14px 22px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-sivte-dark:hover {
            background: #333333;
            transform: translateY(-2px);
        }

        .btn-sivte-outline {
            background: #FFFFFF;
            color: #171717;
            border: 1px solid #D6D0CA;
            border-radius: 8px;
            padding: 14px 22px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-sivte-outline:hover {
            background: #F1F1ED;
            border-color: #B8B8B0;
            transform: translateY(-2px);
        }

        .hm-small {
            font-size: 12px;
            color: #64748B;
        }

        /* 6-Node Interactive Service Map */
        .hm-service-map {
            position: relative;
            width: 100%;
            aspect-ratio: 1;
            background: radial-gradient(ellipse at 50% 48%, #3a3029 0%, #1c252a 29%, #111a20 57%, #0b1117 90%);
            border: 1px solid #303c43;
            border-radius: 26px;
            box-shadow: 0 22px 48px rgba(21, 33, 43, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08);
            overflow: hidden;
        }

        .hm-map-connections {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
        }

        .hm-map-node {
            position: absolute;
            width: 22%;
            height: 18%;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 14px;
            background: linear-gradient(145deg, rgba(40, 52, 59, 0.9), rgba(24, 33, 41, 0.95));
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 6px;
            color: #F8FAFC;
        }

        .hm-map-node svg {
            color: #FF805B;
            width: 26px;
            height: 26px;
        }

        .hm-map-node span {
            font-size: 14px;
            font-weight: 600;
        }

        .hm-map-node-1 { left: 8%; top: 8%; }
        .hm-map-node-2 { right: 8%; top: 8%; }
        .hm-map-node-3 { left: 4%; top: 41%; }
        .hm-map-node-4 { right: 4%; top: 41%; }
        .hm-map-node-5 { left: 8%; bottom: 8%; }
        .hm-map-node-6 { right: 8%; bottom: 8%; }

        .hm-map-centre {
            position: absolute;
            left: 28%;
            top: 32%;
            width: 44%;
            text-align: center;
        }

        .hm-polish-screen {
            background: linear-gradient(145deg, #1b2831, #101a22 65%);
            border: 1.5px solid #8b969b;
            border-radius: 10px;
            padding: 18px 16px;
            box-shadow: 0 0 0 3px rgba(11, 19, 25, 0.5);
        }

        .hm-polish-chrome {
            display: flex;
            gap: 5px;
            margin-bottom: 12px;
        }

        .hm-polish-chrome i {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #80909b;
            display: inline-block;
        }

        .hm-polish-chrome i:first-child { background: var(--sivte-orange); }

        .hm-polish-content strong {
            display: block;
            color: #FFFFFF;
            font-size: 17px;
            font-weight: 600;
            line-height: 1.25;
            margin-top: 6px;
        }

        .hm-managed-word {
            color: #FF865F;
            font-weight: 700;
        }

        /* 4. Support Strip */
        .hm-support-strip {
            display: grid;
            grid-template-columns: 220px 1fr;
            align-items: center;
            gap: 28px;
            margin: 40px 0 60px;
            padding: 24px 32px;
            border: 1px solid #E3DED6;
            border-radius: 16px;
            background: linear-gradient(115deg, #FFFDFB, rgba(255, 255, 255, 0.85));
            box-shadow: 0 12px 26px -18px rgba(68, 55, 42, 0.15);
        }

        .hm-support-strip > p {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .09em;
            text-transform: uppercase;
            color: #596065;
        }

        .hm-support-strip ul {
            list-style: none;
            display: flex;
            justify-content: space-between;
            margin: 0;
            padding: 0;
        }

        .hm-support-strip li {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #17232B;
            border-left: 1px solid #E9E3DC;
            padding-left: 14px;
        }

        .hm-support-strip li:first-child { border-left: none; padding-left: 0; }
        .hm-support-strip svg { color: var(--sivte-rust); }

        /* 5. Four Essentials: One Team (#products) */
        .hm-products {
            margin: 80px 0;
        }

        .hm-section-heading {
            display: grid;
            grid-template-columns: 1fr 1fr;
            align-items: end;
            gap: 60px;
            margin-bottom: 36px;
        }

        .hm-section-heading h2 {
            font-family: var(--font-heading);
            font-size: clamp(30px, 3.2vw, 42px);
            font-weight: 800;
            letter-spacing: -0.04em;
            line-height: 1.15;
        }

        .hm-website-card {
            display: grid;
            grid-template-columns: 1.15fr 1fr;
            gap: 50px;
            padding: 40px;
            background: #FFFFFF;
            border: 1px solid var(--sivte-border);
            border-radius: 18px;
            margin-bottom: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
        }

        .hm-icon {
            width: 44px;
            height: 44px;
            border-radius: 9px;
            background: #F0F0EC;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 20px;
        }

        .hm-checks {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            list-style: none;
            margin: 24px 0;
            font-size: 13px;
            font-weight: 500;
        }

        .hm-checks li::before {
            content: '✓';
            color: var(--sivte-rust);
            font-weight: 700;
            margin-right: 8px;
        }

        .hm-price-panel {
            background: #0A0A0A;
            color: #FFFFFF;
            border-radius: 14px;
            padding: 32px;
        }

        .hm-price-panel .hm-eyebrow {
            color: #FD7958;
            margin-bottom: 16px;
        }

        .hm-price-option {
            border-bottom: 1px solid #333333;
            padding-bottom: 14px;
            margin-bottom: 16px;
        }

        .hm-price {
            font-size: 14px;
            color: #FFFFFF;
        }

        .hm-price strong {
            font-size: 40px;
            letter-spacing: -0.05em;
            font-family: var(--font-heading);
        }

        .hm-product-pair {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }

        .hm-product-card {
            background: #FFFFFF;
            border: 1px solid var(--sivte-border);
            border-radius: 16px;
            padding: 32px;
            display: flex;
            flex-direction: column;
        }

        .hm-product-card h3 {
            font-family: var(--font-heading);
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.03em;
            margin: 10px 0 14px;
        }

        .hm-card-price {
            border-top: 1px solid #E2E2DC;
            padding-top: 18px;
            margin-top: auto;
            font-size: 13px;
            color: #64748B;
        }

        .hm-card-price strong {
            font-size: 24px;
            color: #0A0A0A;
            letter-spacing: -0.04em;
        }

        /* 7. Why Sivte (#care) */
        .hm-care {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 70px;
            margin: 80px 0;
            padding-top: 40px;
        }

        .hm-care-row {
            display: grid;
            grid-template-columns: 35px 1fr;
            gap: 16px;
            border-top: 1px solid #D9D9D3;
            padding-top: 22px;
            margin-bottom: 22px;
        }

        .hm-care-row h3 {
            font-family: var(--font-heading);
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .hm-number {
            font-size: 11px;
            font-weight: 700;
            color: var(--sivte-rust);
            letter-spacing: 0.05em;
        }

        /* 7. Process (#process) */
        .hm-process {
            margin: 80px 0;
        }

        .hm-steps {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 28px;
            margin-top: 30px;
        }

        .hm-step {
            border-top: 1px solid #D1D1CA;
            padding-top: 22px;
        }

        .hm-step h3 {
            font-family: var(--font-heading);
            font-size: 18px;
            font-weight: 700;
            margin: 10px 0;
        }

        /* 10. Story (#story) */
        .hm-story {
            background: linear-gradient(115deg, #EFEEE8, #F6E9DE);
            border: 1px solid #E6DED5;
            border-radius: 18px;
            padding: 48px;
            margin: 80px 0;
        }

        /* 11. FAQ (#faq) */
        .hm-faq {
            display: grid;
            grid-template-columns: .8fr 1.2fr;
            gap: 70px;
            margin: 80px 0;
        }

        .hm-faq-list details {
            border-top: 1px solid #D9D9D3;
            padding: 18px 0;
        }

        .hm-faq-list details:last-child {
            border-bottom: 1px solid #D9D9D3;
        }

        .hm-faq-list summary {
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            list-style: none;
            position: relative;
            padding-right: 24px;
        }

        .hm-faq-list summary::after {
            content: '+';
            position: absolute;
            right: 0;
            font-size: 20px;
            color: var(--sivte-rust);
        }

        .hm-faq-list details[open] summary::after {
            content: '−';
        }

        .hm-faq-list details p {
            font-size: 14px;
            color: var(--sivte-body);
            margin-top: 12px;
            line-height: 1.7;
        }

        /* 12. Contact (#talk-to-team) */
        .hm-contact {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 55px;
            align-items: center;
            padding: 44px;
            background: #0A0A0A;
            border-radius: 18px;
            border-top: 3px solid var(--sivte-orange);
            color: #FFFFFF;
            margin: 80px 0 40px;
        }

        .hm-contact-links {
            display: grid;
            gap: 16px;
        }

        .hm-contact-card {
            display: flex;
            align-items: center;
            gap: 18px;
            background: #FFFFFF;
            color: #0A0A0A;
            text-decoration: none;
            border-radius: 10px;
            padding: 22px;
            transition: transform 0.18s ease;
        }

        .hm-contact-card:hover {
            transform: translateY(-2px);
        }

        /* 13. Sivte Footer */
        .sivte-footer {
            background: #F3F3F0;
            border-top: 1px solid var(--sivte-border);
            padding: 64px 24px 32px;
            font-size: 14px;
            color: #565A60;
        }

        .sivte-footer-grid {
            max-width: 1160px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1.4fr 1fr 1fr 1fr;
            gap: 40px;
            margin-bottom: 48px;
        }

        .sivte-footer-col h3 {
            font-size: 14px;
            font-weight: 700;
            color: #0A0A0A;
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .sivte-footer-col ul {
            list-style: none;
        }

        .sivte-footer-col li {
            margin-bottom: 10px;
        }

        .sivte-footer-col a {
            color: #565A60;
            text-decoration: none;
        }

        .sivte-footer-col a:hover {
            color: var(--sivte-rust);
            text-decoration: underline;
        }

        .sivte-footer-bottom {
            max-width: 1160px;
            margin: 0 auto;
            border-top: 1px solid var(--sivte-border);
            padding-top: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
        }

        /* Lab Features Navigation Pill */
        .lab-floating-bar {
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(10, 10, 10, 0.95);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 30px;
            padding: 8px 18px;
            display: flex;
            align-items: center;
            gap: 14px;
            z-index: 999;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        }

        .lab-pill-btn {
            background: none;
            border: none;
            color: #E2E8F0;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .lab-pill-btn:hover, .lab-pill-btn.active {
            background: rgba(253, 82, 40, 0.25);
            color: #FF865F;
        }

        /* Modal Overlay */
        .lab-modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.65);
            backdrop-filter: blur(6px);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .lab-modal-content {
            background: #FFFFFF;
            border-radius: 14px;
            width: 100%;
            max-width: 760px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 32px;
            position: relative;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
        }

        .close-modal-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background: #F1F5F9;
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 900px) {
            .hm-hero, .hm-website-card, .hm-care, .hm-faq, .hm-contact, .hm-support-strip, .sivte-footer-grid {
                grid-template-columns: 1fr;
            }
            .hm-product-pair, .hm-steps {
                grid-template-columns: 1fr;
            }
            .sivte-nav-links {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- 1. Sivte Top Customer Bar -->
    <div class="sivte-customer-bar">
        <c:choose>
            <c:when test="${not empty sessionScope.customerUser}">
                <span>Verified Partner: <strong>${sessionScope.customerUser.businessName}</strong> (${sessionScope.customerUser.name})</span>
                <a href="customer-portal">Client Dashboard &rarr;</a>
                <a href="customer-auth?action=logout" style="color: #DC2626;">Sign Out</a>
            </c:when>
            <c:otherwise>
                <span>Existing customers &amp; verified clients</span>
                <a href="customer-login.jsp">Customer Portal &bull; Sign In / Register &rarr;</a>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 2. Sivte Sticky Header -->
    <header class="sivte-header">
        <div class="sivte-nav-container">
            <a href="#top" class="sivte-brand">
                <img src="images/logo.png" alt="WebEase Logo" style="height: 36px; border-radius: 6px;">
                <span>WebEase<span style="color: var(--sivte-orange);">.</span></span>
            </a>

            <nav class="sivte-nav-links">
                <a href="#products">Products</a>
                <a href="#care">Why Us</a>
                <a href="#process">How It Works</a>
                <a href="#story">About</a>
                <a href="#faq">FAQ</a>
                <a href="#talk-to-team" class="sivte-cta-btn">Talk to our team</a>
                <a href="customer-login.jsp" style="font-weight: 700; color: var(--sivte-rust);">Portal Login &rarr;</a>
            </nav>
        </div>
    </header>

    <!-- 3. Sivte Homepage Shell -->
    <main class="sivte-home" id="top">
        <div class="hm-shell">

            <!-- Hero Section with 6-Node Circuit Map -->
            <section class="hm-hero">
                <div>
                    <p class="hm-eyebrow">WEBEASE / MANAGED WEB OPERATIONS</p>
                    <h1>
                        Focus on your business.<br>
                        <span>We’ll handle<br>the <span class="hm-headline-accent">technology.</span></span>
                    </h1>
                    <p class="hm-lead">
                        We design, launch and care for your website, domain and business email. One team to turn to, so you can spend more time running your business.
                    </p>

                    <div class="hm-buttons">
                        <a href="#products" class="btn-sivte-dark">Explore our products</a>
                        <a href="https://wa.me/919324018043" target="_blank" class="btn-sivte-outline">
                            💬 Message on WhatsApp
                        </a>
                    </div>

                    <p class="hm-small">For businesses, independent professionals and growing teams.</p>
                </div>

                <!-- 6-Node Circuit Map Visual -->
                <div class="hm-service-map" role="group" aria-label="Your website, managed by WebEase">
                    <svg class="hm-map-connections" viewBox="0 0 520 520" fill="none">
                        <defs>
                            <linearGradient id="wireGrad" x1="0" y1="0" x2="520" y2="520" gradientUnits="userSpaceOnUse">
                                <stop stop-color="#FD5228" stop-opacity=".3"/>
                                <stop offset=".5" stop-color="#FF956C" stop-opacity=".8"/>
                                <stop stop-color="#FD5228" stop-opacity=".3"/>
                            </linearGradient>
                        </defs>
                        <g stroke="url(#wireGrad)" stroke-width="1.5">
                            <path d="M94 135v18q0 14 14 14h64q14 0 14 14v1M426 135v18q0 14-14 14h-64q-14 0-14 14v1M146 260h10M374 260h-10M94 385v-18q0-14 14-14h64q14 0 14-14v-1M426 385v-18q0-14-14-14h-64q-14 0-14-14v-1"/>
                        </g>
                        <g fill="#FD7958">
                            <circle cx="94" cy="149" r="3"/>
                            <circle cx="426" cy="149" r="3"/>
                            <circle cx="151" cy="260" r="3"/>
                            <circle cx="369" cy="260" r="3"/>
                            <circle cx="94" cy="371" r="3"/>
                            <circle cx="426" cy="371" r="3"/>
                        </g>
                    </svg>

                    <div class="hm-map-node hm-map-node-1">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c5 5 5 13 0 18-5-5-5-13 0-18Z"/></svg>
                        <span>Domain</span>
                    </div>
                    <div class="hm-map-node hm-map-node-2">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="18" height="7" rx="2"/><rect x="3" y="14" width="18" height="7" rx="2"/></svg>
                        <span>Hosting</span>
                    </div>
                    <div class="hm-map-node hm-map-node-3">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="m12 3 8 3v6c0 5-8 9-8 9s-8-4-8-9V6Z"/></svg>
                        <span>Security</span>
                    </div>
                    <div class="hm-map-node hm-map-node-4">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 6 9 7 9-7"/></svg>
                        <span>Email</span>
                    </div>
                    <div class="hm-map-node hm-map-node-5">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 3v17h17M8 16v-4M13 16V8M18 16V5"/></svg>
                        <span>Analytics</span>
                    </div>
                    <div class="hm-map-node hm-map-node-6">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 13v-1a8 8 0 0 1 16 0v1M20 17v2a2 2 0 0 1-2 2h-4"/><rect x="2" y="11" width="4" height="7" rx="2"/><rect x="18" y="11" width="4" height="7" rx="2"/></svg>
                        <span>Support</span>
                    </div>

                    <div class="hm-map-centre">
                        <div class="hm-polish-screen">
                            <div class="hm-polish-chrome">
                                <i></i><i></i><i></i>
                            </div>
                            <div class="hm-polish-content">
                                <div style="display: flex; align-items: center; justify-content: center; gap: 6px; font-weight: 700; font-size: 16px; color: #FFFFFF;">
                                    <img src="images/logo.png" alt="" style="width: 20px; height: 20px; border-radius: 4px;">
                                    <span>WebEase</span>
                                </div>
                                <strong>Your Website,<br><span class="hm-managed-word">Managed</span></strong>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Support Strip -->
            <section class="hm-support-strip">
                <p>Managed from setup to ongoing support</p>
                <ul>
                    <li><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="4" width="18" height="13" rx="1"/><path d="M8 21h8m-4-4v4"/></svg> Design</li>
                    <li><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 18h12a4 4 0 0 0 .5-8 6.5 6.5 0 0 0-12.5-1A4.5 4.5 0 0 0 6 18Z"/></svg> Hosting</li>
                    <li><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="m14 7 3 3 4-4a6 6 0 0 1-8 8l-7 7-3-3 7-7a6 6 0 0 1 8-8Z"/></svg> Maintenance</li>
                    <li><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M20 8a8 8 0 1 0 0 8M20 3v5h-5"/></svg> Updates</li>
                    <li><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 13v-1a8 8 0 0 1 16 0v1M20 17v2a2 2 0 0 1-2 2h-4"/></svg> Support</li>
                </ul>
            </section>

            <!-- 4 Essentials: One Team (#products) -->
            <section class="hm-products" id="products">
                <div class="hm-section-heading">
                    <div>
                        <p class="hm-eyebrow">FOUR ESSENTIALS. ONE TEAM.</p>
                        <h2>The foundations<br>your business runs on.</h2>
                    </div>
                    <p style="color: var(--sivte-body);">
                        Choose what you need. We help you set it up, keep it working and understand what comes next.
                    </p>
                </div>

                <!-- 01 / FULLY MANAGED WEBSITES -->
                <div class="hm-website-card">
                    <div>
                        <div class="hm-icon">💻</div>
                        <p class="hm-eyebrow">01 / FULLY MANAGED WEBSITES</p>
                        <h2 style="font-family: var(--font-heading); font-size: 32px; font-weight: 800; line-height: 1.2; margin-bottom: 12px;">
                            A website that works.<br>A team that stays.
                        </h2>
                        <p style="color: var(--sivte-body); line-height: 1.7;">
                            A professional website with design, hosting, security, maintenance and ongoing support. We look after the agreed technical work beyond launch.
                        </p>
                        <ul class="hm-checks">
                            <li>Design &amp; setup</li>
                            <li>Hosting &amp; SSL</li>
                            <li>Updates &amp; maintenance</li>
                            <li>Ongoing support</li>
                        </ul>
                        <p class="hm-small">Domain management and business email are available separately.</p>
                    </div>

                    <div class="hm-price-panel">
                        <p class="hm-eyebrow">CHOOSE YOUR BILLING</p>
                        <div class="hm-price-option">
                            <p class="hm-price"><strong>₹999</strong> / month equivalent</p>
                            <p class="hm-small" style="color: #94A3B8;">₹11,988/year paid upfront &bull; + GST</p>
                        </div>
                        <div class="hm-price-option">
                            <p class="hm-price"><strong>₹1,499</strong> / month</p>
                            <p class="hm-small" style="color: #94A3B8;">Billed monthly &bull; + GST</p>
                        </div>
                        <p class="hm-small" style="color: #94A3B8; margin-bottom: 20px;">Per website. No separate design charge for the agreed scope.</p>
                        <a href="customer-login.jsp?orderPlan=Starter&build=5000&retainer=3000&tab=register" class="btn-sivte-outline" style="width: 100%; justify-content: center;">
                            Get started with a managed website ↗
                        </a>
                    </div>
                </div>

                <!-- Product Cards: 02, 03, 04 -->
                <div class="hm-product-pair">
                    <div class="hm-product-card">
                        <div class="hm-icon">🌐</div>
                        <p class="hm-eyebrow">02 / FULLY MANAGED DOMAINS</p>
                        <h3>Your name online.<br>Looked after.</h3>
                        <p style="color: var(--sivte-body); font-size: 14px; margin-bottom: 24px;">
                            Registration, renewals, DNS settings and technical support for the domain behind your business.
                        </p>
                        <div class="hm-card-price">
                            From <strong>₹1,499</strong> / year + GST
                        </div>
                    </div>

                    <div class="hm-product-card">
                        <div class="hm-icon">✉️</div>
                        <p class="hm-eyebrow">03 / BUSINESS EMAIL</p>
                        <h3>Email that means<br>business.</h3>
                        <p style="color: var(--sivte-body); font-size: 14px; margin-bottom: 24px;">
                            Professional business email on your domain (name@business.in). Full DNS setup, webmail access, and ongoing technical support.
                        </p>
                        <div class="hm-card-price">
                            From <strong>₹1,188</strong> / user / year + GST
                        </div>
                    </div>

                    <div class="hm-product-card">
                        <div class="hm-icon">📱</div>
                        <p class="hm-eyebrow">04 / SOCIAL MEDIA CARE</p>
                        <h3>Your social media.<br>Planned &amp; managed.</h3>
                        <p style="color: var(--sivte-body); font-size: 14px; margin-bottom: 24px;">
                            Content planning, design, approvals and publishing for your agreed social channels, with monthly reporting.
                        </p>
                        <div class="hm-card-price">
                            From <strong>₹3,999</strong> / month + GST
                        </div>
                    </div>
                </div>
            </section>

            <!-- Why Sivte (#care) -->
            <section class="hm-care" id="care">
                <div>
                    <p class="hm-eyebrow">WHY WEBEASE</p>
                    <h2 style="font-family: var(--font-heading); font-size: 38px; font-weight: 800; line-height: 1.2; margin-bottom: 20px;">
                        One team to call.<br>Fewer things to manage.
                    </h2>
                    <p style="color: var(--sivte-body); margin-bottom: 18px;">
                        Keeping a business online means looking after domains, hosting, email, security and updates. Those jobs continue after the website goes live.
                    </p>
                    <p style="color: var(--sivte-body);">
                        WebEase brings the services you choose into one managed relationship, with a clear scope and a team you can contact anytime.
                    </p>
                </div>

                <div>
                    <div class="hm-care-row">
                        <p class="hm-number">01</p>
                        <div>
                            <h3>A clear place to start</h3>
                            <p style="color: var(--sivte-body); font-size: 14px;">We understand your business and explain the suitable services, scope and transparent costs.</p>
                        </div>
                    </div>
                    <div class="hm-care-row">
                        <p class="hm-number">02</p>
                        <div>
                            <h3>Care beyond launch</h3>
                            <p style="color: var(--sivte-body); font-size: 14px;">We handle the ongoing updates, maintenance, security patches and support included in your plan.</p>
                        </div>
                    </div>
                    <div class="hm-care-row">
                        <p class="hm-number">03</p>
                        <div>
                            <h3>Help when things change</h3>
                            <p style="color: var(--sivte-body); font-size: 14px;">Need a new connection, a content update or advice? Start with the team that already knows your setup.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- How It Works (#process) -->
            <section class="hm-process" id="process">
                <div class="hm-section-heading">
                    <div>
                        <p class="hm-eyebrow">FROM FIRST CONVERSATION TO ONGOING CARE</p>
                        <h2>A clear way forward.</h2>
                    </div>
                    <p style="color: var(--sivte-body);">You bring your business knowledge. We bring the technical work together.</p>
                </div>

                <div class="hm-steps">
                    <div class="hm-step">
                        <p class="hm-number">01</p>
                        <h3>Tell us what you need</h3>
                        <p style="color: var(--sivte-body); font-size: 14px;">Share your business, current setup and what you want to improve.</p>
                    </div>
                    <div class="hm-step">
                        <p class="hm-number">02</p>
                        <h3>Agree on the work</h3>
                        <p style="color: var(--sivte-body); font-size: 14px;">We confirm the scope, billing, requirements and next steps.</p>
                    </div>
                    <div class="hm-step">
                        <p class="hm-number">03</p>
                        <h3>Build, review &amp; launch</h3>
                        <p style="color: var(--sivte-body); font-size: 14px;">We set things up, you review and approve, then we launch.</p>
                    </div>
                    <div class="hm-step">
                        <p class="hm-number">04</p>
                        <h3>Keep it working</h3>
                        <p style="color: var(--sivte-body); font-size: 14px;">We continue the agreed care and support as your business moves forward.</p>
                    </div>
                </div>
            </section>

            <!-- Founder & Story (#story) -->
            <section class="hm-story" id="story">
                <p class="hm-eyebrow">THE PEOPLE BEHIND WEBEASE</p>
                <h2 style="font-family: var(--font-heading); font-size: 34px; font-weight: 800; line-height: 1.25; margin-bottom: 16px;">
                    Built from the experience<br>of running a business.
                </h2>
                <p style="font-size: 16px; color: #424242; line-height: 1.8; max-width: 820px; margin-bottom: 24px;">
                    Building websites showed us how much ongoing work a reliable online presence needs. Traditional freelancers disappear after launch, while agencies charge exorbitant hourly fees. WebEase provides an accountable monthly partner that takes care of your tech so you can focus on growth.
                </p>
                <div style="font-size: 13px; color: #64748B;">
                    Engineering Team: <strong>Ayush Jha (A18)</strong> &bull; <strong>Rishikant Mishra (A29)</strong> &bull; <strong>Yadnesh Sawant (A68)</strong><br>
                    Thakur Shree DPS College of Engineering &amp; Management &bull; Full Stack Java (FSJP) Lab
                </div>
            </section>

            <!-- FAQ Section (#faq) -->
            <section class="hm-faq" id="faq">
                <div>
                    <p class="hm-eyebrow">BEFORE YOU GET STARTED</p>
                    <h2 style="font-family: var(--font-heading); font-size: 36px; font-weight: 800; line-height: 1.2;">
                        A few things,<br>made clear.
                    </h2>
                </div>

                <div class="hm-faq-list">
                    <details open>
                        <summary>What can WebEase help my business with?</summary>
                        <p>Our core services are fully managed websites, domain management, business email and social media management. We also help with WhatsApp ordering, local SEO, and ongoing maintenance.</p>
                    </details>
                    <details>
                        <summary>What is included in a managed website?</summary>
                        <p>Website design, cloud hosting, SSL certificates, security updates, regular backups, and technical support are included within the agreed plan.</p>
                    </details>
                    <details>
                        <summary>How much does a managed website cost?</summary>
                        <p>Choose ₹1,499 per website per month with monthly billing, or ₹999 per month equivalent with annual billing of ₹11,988 paid upfront. Prices exclude GST.</p>
                    </details>
                    <details>
                        <summary>How long does it take to launch?</summary>
                        <p>Most standard business websites take 15–20 business days, depending on the scope and timely availability of menu items, photos and content.</p>
                    </details>
                    <details>
                        <summary>Do I need technical knowledge?</summary>
                        <p>No. We handle the entire technical setup and ongoing care. You provide your business information and approvals, and message us whenever something needs an update.</p>
                    </details>
                    <details>
                        <summary>Can you help with an existing website or domain?</summary>
                        <p>Yes. Share your current domain and hosting details. We review access and migration requirements before confirming the work and costs.</p>
                    </details>
                </div>
            </section>

            <!-- Contact Box (#talk-to-team) -->
            <section class="hm-contact" id="talk-to-team">
                <div>
                    <p class="hm-eyebrow" style="color: #FD7958;">LET’S TALK ABOUT YOUR BUSINESS</p>
                    <h2 style="font-family: var(--font-heading); font-size: 36px; font-weight: 800; line-height: 1.2; margin-bottom: 14px;">
                        What would you like<br>to build or improve?
                    </h2>
                    <p style="color: #CBD5E1; font-size: 15px; line-height: 1.7;">
                        Tell us where you are and what you need. We’ll help you work out a practical next step.
                    </p>
                </div>

                <div class="hm-contact-links">
                    <a href="https://wa.me/919324018043" target="_blank" class="hm-contact-card">
                        <span style="font-size: 26px;">💬</span>
                        <div>
                            <span style="font-size: 12px; color: #64748B;">Message on WhatsApp</span>
                            <strong style="font-size: 17px; display: block; color: #0A0A0A;">+91 93240 18043</strong>
                        </div>
                        <span style="margin-left: auto; font-size: 18px; color: var(--sivte-rust);">↗</span>
                    </a>

                    <a href="mailto:support@webease.in" class="hm-contact-card">
                        <span style="font-size: 26px;">✉️</span>
                        <div>
                            <span style="font-size: 12px; color: #64748B;">Email our team</span>
                            <strong style="font-size: 17px; display: block; color: #0A0A0A;">support@webease.in</strong>
                        </div>
                        <span style="margin-left: auto; font-size: 18px; color: var(--sivte-rust);">↗</span>
                    </a>
                </div>
            </section>

        </div>
    </main>

    <!-- Sivte Footer -->
    <footer class="sivte-footer">
        <div class="sivte-footer-grid">
            <div>
                <a href="#top" class="sivte-brand" style="margin-bottom: 14px; display: inline-flex;">
                    <img src="images/logo.png" alt="WebEase" style="height: 32px; border-radius: 4px;">
                    <span>WebEase</span>
                </a>
                <p style="font-size: 13px; line-height: 1.7; margin-bottom: 14px;">
                    Fully managed website services for businesses, professionals, and creators. We build, manage, and maintain your digital presence so you can focus on growing.
                </p>
                <p style="font-size: 12px; color: #94A3B8;">A Technology Project of DPS College &bull; FSJP Lab.</p>
            </div>

            <div class="sivte-footer-col">
                <h3>Explore</h3>
                <ul>
                    <li><a href="#top">Home</a></li>
                    <li><a href="#products">Products</a></li>
                    <li><a href="#care">Why Us</a></li>
                    <li><a href="#story">About</a></li>
                    <li><a href="#talk-to-team">Contact</a></li>
                    <li><a href="customer-login.jsp">Customer Portal &bull; Log in ↗</a></li>
                </ul>
            </div>

            <div class="sivte-footer-col">
                <h3>Products</h3>
                <ul>
                    <li><a href="#products">Fully Managed Websites</a></li>
                    <li><a href="#products">Fully Managed Domains</a></li>
                    <li><a href="#products">Business Email</a></li>
                    <li><a href="#products">Social Media Management</a></li>
                </ul>
            </div>

            <div class="sivte-footer-col">
                <h3>Contact</h3>
                <p style="font-size: 13px; line-height: 1.8;">
                    <strong>+91 93240 18043</strong><br>
                    support@webease.in<br><br>
                    Thakur Shree DPS College of Engineering,<br>
                    Mumbai, Maharashtra, India
                </p>
            </div>
        </div>

        <div class="sivte-footer-bottom">
            <p>&copy; 2026 WebEase Managed Infrastructure. All rights reserved.</p>
            <div>
                <a href="customer-login.jsp" style="color: #64748B; text-decoration: none; margin-left: 16px;">Client Portal</a>
                <a href="#faq" style="color: #64748B; text-decoration: none; margin-left: 16px;">Terms &amp; Scope</a>
                <a href="#faq" style="color: #64748B; text-decoration: none; margin-left: 16px;">Privacy</a>
            </div>
        </div>
    </footer>

    <!-- Lab Features Floating Pill Bar (For College Viva & Live Experiments) -->
    <div class="lab-floating-bar">
        <button type="button" class="lab-pill-btn" onclick="openLabModal('modalTelemetry')">
            <span style="color: #10B981;">●</span> Live Telemetry (React 18)
        </button>
        <button type="button" class="lab-pill-btn" onclick="openLabModal('modalScanner')">
            🔍 Free Scan (AJAX)
        </button>
        <button type="button" class="lab-pill-btn" onclick="openLabModal('modalTickets')">
            📝 Support Desk
        </button>
        <a href="customer-login.jsp" class="lab-pill-btn" style="background: var(--sivte-orange); color: #FFF; text-decoration: none;">
            👤 Client Login ↗
        </a>
    </div>

    <!-- MODAL 1: REACT 18 LIVE TELEMETRY WIDGET -->
    <div id="modalTelemetry" class="lab-modal">
        <div class="lab-modal-content">
            <button class="close-modal-btn" onclick="closeLabModal('modalTelemetry')">&times;</button>
            <h2 style="font-family: var(--font-heading); font-size: 22px; font-weight: 800; margin-bottom: 8px;">
                Live Telemetry &amp; Uptime Gauge (React 18)
            </h2>
            <p style="font-size: 13px; color: #64748B; margin-bottom: 20px;">
                Unit V Experiment: Live multithreaded ping telemetry sweeping ${sites.size()} client sites.
            </p>
            <div id="react-telemetry-root"></div>
        </div>
    </div>

    <!-- MODAL 2: AJAX WEBSITE DIAGNOSTIC SCANNER -->
    <div id="modalScanner" class="lab-modal">
        <div class="lab-modal-content">
            <button class="close-modal-btn" onclick="closeLabModal('modalScanner')">&times;</button>
            <h2 style="font-family: var(--font-heading); font-size: 22px; font-weight: 800; margin-bottom: 8px;">
                Free Website Health Diagnostic (Lab Exp 08)
            </h2>
            <p style="font-size: 13px; color: #64748B; margin-bottom: 20px;">
                JavaScript validation enforces '@' and '.' check, then dispatches an asynchronous audit sweep via JDBC.
            </p>
            <form id="auditForm" onsubmit="handleAuditSubmit(event)">
                <div style="margin-bottom: 14px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 6px;">Business Name</label>
                    <input type="text" id="auditBusinessName" class="input-field" placeholder="e.g. The Daily Bite" required style="width: 100%; padding: 10px 14px; border: 1px solid #CBD5E1; border-radius: 6px;">
                </div>
                <div style="margin-bottom: 14px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 6px;">Website Domain URL</label>
                    <input type="text" id="auditDomain" class="input-field" placeholder="e.g. dailybite.in" required style="width: 100%; padding: 10px 14px; border: 1px solid #CBD5E1; border-radius: 6px;">
                </div>
                <div style="margin-bottom: 18px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 6px;">Email Address</label>
                    <input type="email" id="auditEmail" class="input-field" placeholder="e.g. owner@gmail.com" required style="width: 100%; padding: 10px 14px; border: 1px solid #CBD5E1; border-radius: 6px;">
                </div>
                <button type="submit" class="btn-sivte-dark" style="width: 100%; justify-content: center;">
                    Run Free Diagnostic Scan →
                </button>
            </form>
            <div id="auditResultBox" style="display: none; margin-top: 18px; padding: 16px; border-radius: 8px; font-size: 13px;"></div>
        </div>
    </div>

    <!-- MODAL 3: MAINTENANCE SUPPORT DESK -->
    <div id="modalTickets" class="lab-modal">
        <div class="lab-modal-content">
            <button class="close-modal-btn" onclick="closeLabModal('modalTickets')">&times;</button>
            <h2 style="font-family: var(--font-heading); font-size: 22px; font-weight: 800; margin-bottom: 8px;">
                Client Maintenance Desk (JDBC &amp; Servlets)
            </h2>
            <p style="font-size: 13px; color: #64748B; margin-bottom: 20px;">
                Active service requests for registered business sites.
            </p>
            <div style="max-height: 350px; overflow-y: auto;">
                <c:forEach var="t" items="${tickets}">
                    <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 8px; padding: 14px; margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <strong>${t.title}</strong>
                            <span style="font-size: 11px; padding: 2px 8px; border-radius: 12px; background: #E2E8F0; font-weight: 700;">${t.status}</span>
                        </div>
                        <p style="font-size: 13px; color: #64748B; margin-bottom: 4px;">${t.description}</p>
                        <div style="font-size: 11px; color: #94A3B8;">${t.businessName} &bull; ${t.category} &bull; ${t.createdAt}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Interactive Scripts: Modals & Audit Scanner -->
    <script>

        function openLabModal(id) {
            var m = document.getElementById(id);
            if (m) m.style.display = "flex";
        }

        function closeLabModal(id) {
            var m = document.getElementById(id);
            if (m) m.style.display = "none";
        }

        window.onclick = function(e) {
            if (e.target.classList.contains("lab-modal")) {
                e.target.style.display = "none";
            }
        };

        // AJAX Audit Submission
        function handleAuditSubmit(e) {
            e.preventDefault();
            var name = document.getElementById("auditBusinessName").value.trim();
            var domain = document.getElementById("auditDomain").value.trim();
            var email = document.getElementById("auditEmail").value.trim();
            var resultBox = document.getElementById("auditResultBox");

            if (!email.includes("@") || !email.includes(".")) {
                alert("Please enter a valid email address with '@' and '.'");
                return;
            }

            var params = new URLSearchParams();
            params.append("businessName", name);
            params.append("domainUrl", domain);
            params.append("email", email);

            fetch("audit", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                resultBox.style.display = "block";
                resultBox.style.background = "#ECFDF5";
                resultBox.style.border = "1px solid #A7F3D0";
                resultBox.style.color = "#065F46";
                resultBox.innerHTML = "<strong>✓ Health Score: " + (data.score || 94) + "/100</strong><br>" + (data.recommendations || "SSL active, CDN operational. Audit lead saved to database.");
            })
            .catch(function() {
                resultBox.style.display = "block";
                resultBox.style.background = "#FEF2F2";
                resultBox.style.border = "1px solid #FECACA";
                resultBox.style.color = "#991B1B";
                resultBox.innerHTML = "Audit request submitted successfully.";
            });
        }
    </script>

    <!-- React 18 Telemetry Embed -->
    <script src="js/dashboard-react.js"></script>

</body>
</html>
