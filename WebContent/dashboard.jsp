<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("sites") == null) {
        request.setAttribute("sites", new com.webease.dao.SiteDAO().getAllSites());
    }
    if (request.getAttribute("activeSite") == null) {
        java.util.List<com.webease.model.ClientSite> sList = (java.util.List<com.webease.model.ClientSite>) request.getAttribute("sites");
        if (sList != null && !sList.isEmpty()) {
            request.setAttribute("activeSite", sList.get(0));
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Client Health & Monitoring Portal</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- React 18 and ReactDOM CDN for Unit V Component -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
</head>
<body style="background: #F1F5F9;">

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="brand-logo">
                <div class="logo-icon">W</div>
                <div>
                    WebEase
                    <span class="brand-tagline">Client Health & Monitoring</span>
                </div>
            </a>
            <ul class="nav-links">
                <li><a href="dashboard" style="color: #00A88F; font-weight:700;">Health Monitor</a></li>
                <li><a href="tickets">Maintenance Desk</a></li>
                <li><a href="admin">Admin Console</a></li>
                <li><a href="index.jsp" class="nav-cta-btn" style="background:#64748B;">Public Site</a></li>
            </ul>
        </div>
    </nav>

    <div class="section" style="max-width: 1140px; padding-top: 2rem;">
        <!-- Header with Client Switcher -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="color: #0A2540; font-size: 1.85rem; font-weight: 800;">
                    ${activeSite.businessName}
                </h1>
                <div style="color: #64748B; font-size: 0.9rem;">
                    Domain: <strong style="color: #0A2540;">${activeSite.domainUrl}</strong> • Category: ${activeSite.category}
                </div>
            </div>

            <!-- Switch Demo Client Account -->
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <label style="font-size: 0.85rem; font-weight: 600; color: #64748B;">Switch Client:</label>
                <form action="dashboard" method="GET" style="margin: 0;">
                    <select name="id" class="form-select" onchange="this.form.submit()" style="padding: 0.45rem 0.8rem; font-size: 0.85rem;">
                        <c:forEach var="site" items="${sites}">
                            <option value="${site.id}" ${site.id == activeSite.id ? 'selected' : ''}>
                                ${site.businessName} (${site.category})
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>
        </div>

        <!-- Real-Time React Telemetry Widget (Unit V: React Hooks & Props) -->
        <div id="react-telemetry-root" data-site-id="${activeSite.id}" style="margin-bottom: 1.75rem;">
            <!-- React mounts here -->
        </div>

        <!-- 2-Column Grid: Proactive Resolution Feed & Quick Maintenance Request -->
        <div style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 1.5rem;">
            <!-- Left Column: Proactive Resolution Timeline -->
            <div style="background: #FFFFFF; border-radius: 12px; padding: 1.75rem; border: 1px solid #E2E8F0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.07);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                    <h3 style="color: #0A2540; font-size: 1.15rem; font-weight: 700;">Proactive Issue Resolution Feed</h3>
                    <span class="badge badge-healthy">Active Protection</span>
                </div>

                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <div style="display: flex; gap: 1rem; align-items: flex-start; padding: 0.85rem; background: #F8FAFC; border-radius: 8px; border-left: 4px solid #10B981;">
                        <div style="font-size: 1.25rem;">🛡️</div>
                        <div>
                            <strong style="color: #0A2540; font-size: 0.9rem;">Contact Form Submissions Tested & Healthy</strong>
                            <p style="color: #64748B; font-size: 0.82rem; margin-top: 0.2rem;">Automated ping verified that lead forms submit directly to inbox without error.</p>
                            <span style="font-size: 0.75rem; color: #94A3B8;">Verified Today, 11:30 AM</span>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; align-items: flex-start; padding: 0.85rem; background: #F8FAFC; border-radius: 8px; border-left: 4px solid #00D4B2;">
                        <div style="font-size: 1.25rem;">🔒</div>
                        <div>
                            <strong style="color: #0A2540; font-size: 0.9rem;">SSL Certificate Verified (Zero Downtime)</strong>
                            <p style="color: #64748B; font-size: 0.82rem; margin-top: 0.2rem;">256-bit TLS security validated. HTTPS lock active for all visitor payments.</p>
                            <span style="font-size: 0.75rem; color: #94A3B8;">Checked 2 days ago</span>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; align-items: flex-start; padding: 0.85rem; background: #F8FAFC; border-radius: 8px; border-left: 4px solid #F59E0B;">
                        <div style="font-size: 1.25rem;">⚡</div>
                        <div>
                            <strong style="color: #0A2540; font-size: 0.9rem;">Image Compression & Speed Boost</strong>
                            <p style="color: #64748B; font-size: 0.82rem; margin-top: 0.2rem;">Optimized 4 hero menu images, improving mobile load latency by 210ms.</p>
                            <span style="font-size: 0.75rem; color: #94A3B8;">Completed 4 days ago</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Quick Maintenance Actions -->
            <div style="background: #FFFFFF; border-radius: 12px; padding: 1.75rem; border: 1px solid #E2E8F0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.07); display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <h3 style="color: #0A2540; font-size: 1.15rem; font-weight: 700; margin-bottom: 0.5rem;">Need an Update?</h3>
                    <p style="color: #64748B; font-size: 0.88rem; margin-bottom: 1.25rem;">
                        As part of your WebEase managed retainer, our team makes changes for you. Just submit what you need updated.
                    </p>

                    <div style="background: #F1F5F9; padding: 1rem; border-radius: 8px; margin-bottom: 1.25rem;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 0.5rem;">
                            <span style="color: #64748B;">Included Monthly Updates:</span>
                            <strong style="color: #0A2540;">6 / month</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 0.5rem;">
                            <span style="color: #64748B;">Updates Used This Month:</span>
                            <strong style="color: #10B981;">2 used</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                            <span style="color: #64748B;">Turnaround Time SLA:</span>
                            <strong style="color: #00A88F;">Under 24 Hours</strong>
                        </div>
                    </div>
                </div>

                <div>
                    <a href="tickets" class="btn-primary" style="width: 100%; justify-content: center; margin-bottom: 0.75rem;">
                        📝 Submit Maintenance Request
                    </a>
                    <a href="https://${activeSite.domainUrl}" target="_blank" class="btn-secondary" style="width: 100%; text-align: center; display: block;">
                        🌐 Visit Live Website
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- React Component Script (Unit V) -->
    <script src="js/dashboard-react.js"></script>
</body>
</html>
