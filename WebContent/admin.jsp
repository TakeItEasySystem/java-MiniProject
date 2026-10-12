<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session == null || session.getAttribute("adminUser") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    if (request.getAttribute("leads") == null) {
        request.setAttribute("leads", new com.webease.dao.LeadDAO().getAllLeads());
    }
    if (request.getAttribute("sites") == null) {
        request.setAttribute("sites", new com.webease.dao.SiteDAO().getAllSites());
    }
    if (request.getAttribute("orders") == null) {
        request.setAttribute("orders", new com.webease.dao.OrderDAO().getAllOrders());
    }
    if (request.getAttribute("customers") == null) {
        request.setAttribute("customers", new com.webease.dao.CustomerDAO().getAllCustomers());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Operations & Fleet Command</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" type="image/png" href="images/logo.png">
    <script src="js/main.js"></script>
</head>
<body>

    <!-- Sivte Top Customer Bar -->
    <div class="sivte-customer-bar">
        <span>WebEase Internal Operations Console &bull; Logged in as: <strong>${sessionScope.adminUser}</strong></span>
        <div style="display: flex; gap: 14px; align-items: center;">
            <a href="index.jsp">Public Website -></a>
            <a href="admin-auth?action=logout" style="color: #EF4444; font-weight: 700; text-decoration: underline;">Log Out</a>
        </div>
    </div>

    <!-- Sivte Header -->
    <header class="sivte-header">
        <div class="sivte-nav-container">
            <a href="index.jsp" class="sivte-brand" style="display: inline-flex; align-items: center; gap: 12px;">
                <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img" style="height: 36px;">
                <span style="font-size: 14px; color: #475569; font-weight: 600; border-left: 2px solid #CBD5E1; padding-left: 10px;">Operations</span>
            </a>

            <nav class="sivte-nav-links">
                <a href="index.jsp" class="sivte-nav-link">Home</a>
                <a href="index.jsp#portal" class="sivte-nav-link">Client Portal</a>
                <a href="index.jsp#tickets" class="sivte-nav-link">Support Desk</a>
                <a href="admin" class="sivte-nav-link active">Fleet Operations</a>
                <a href="admin-auth?action=logout" class="btn-sivte-outline" style="font-size: 12px; padding: 6px 12px; color: #EF4444; border-color: #FECACA;">Log Out</a>
            </nav>
        </div>
    </header>

    <div class="sivte-shell" style="padding: 40px 24px 60px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <p class="hm-eyebrow">FLEET TELEMETRY &amp; DATABASE OPERATIONS</p>
                <h1 style="font-size: 32px;">Operations & Fleet Command</h1>
                <p style="font-size: 15px;">
                    Centralized client site uptime telemetry, registered business pipeline, and inbound leads.
                </p>
            </div>
            <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                <form action="sites" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="checkFleet">
                    <button type="submit" class="btn-sivte-outline" style="font-size: 13px; padding: 10px 16px;">
                        Trigger Health Sweep
                    </button>
                </form>
                <button onclick="openModal('newSiteModal')" class="btn-sivte-orange" style="font-size: 13px; padding: 10px 16px;">
                    + Onboard Client Site
                </button>
            </div>
        </div>

        <!-- Fleet Overview Metric Cards -->
        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 32px;">
            <div style="background: #FFF; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; text-align: center;">
                <div style="font-size: 28px; font-weight: 800; color: #0A0A0A;">${sites.size()}</div>
                <div style="font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600;">Monitored Sites</div>
            </div>
            <div style="background: #FFF; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; text-align: center;">
                <div style="font-size: 28px; font-weight: 800; color: #0A0A0A;">${orders.size()}</div>
                <div style="font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600;">Client Orders</div>
            </div>
            <div style="background: #FFF; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; text-align: center;">
                <div style="font-size: 28px; font-weight: 800; color: #10B981;">99.96%</div>
                <div style="font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600;">Avg Fleet Uptime</div>
            </div>
            <div style="background: #FFF; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; text-align: center;">
                <div style="font-size: 28px; font-weight: 800; color: #F59E0B;">${leads.size()}</div>
                <div style="font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600;">Inbound Leads</div>
            </div>
        </div>

        <!-- Client Websites Fleet Table -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                <h3 style="font-size: 20px; margin: 0;">Managed Client Fleet (${sites.size()})</h3>
                <span style="font-size: 13px; color: var(--muted);">Table: <code>sites</code> in SQLite</span>
            </div>
            <div class="hm-matrix-wrapper">
                <table class="hm-matrix-table">
                    <thead>
                        <tr>
                            <th>Business Name</th>
                            <th>Category</th>
                            <th>Domain URL</th>
                            <th>Status</th>
                            <th>Uptime</th>
                            <th>Latency</th>
                            <th>Page Speed</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty sites}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 36px 20px; color: var(--muted);">
                                        <div style="font-size: 15px; font-weight: 700; color: #0A0A0A; margin-bottom: 4px;">No Monitored Client Websites in Database</div>
                                        <div style="font-size: 13px; margin-bottom: 14px;">The database is connected and active. When you onboard a client or a customer places an order, their business will appear here with live telemetry.</div>
                                        <button type="button" onclick="openModal('newSiteModal')" class="btn-sivte-orange" style="font-size: 12px; padding: 7px 16px;">
                                            + Onboard Client Site
                                        </button>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="site" items="${sites}">
                                    <tr>
                                        <td><strong>${site.businessName}</strong></td>
                                        <td>${site.category}</td>
                                        <td><code>${site.domainUrl}</code></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${site.status == 'Healthy'}">
                                                    <span style="background: #ECFDF5; color: #059669; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 700;">✓ Healthy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="background: #FFFBEB; color: #D97706; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 700;">⚠ Warning</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong style="color: #10B981;">${site.uptimePercentage}%</strong></td>
                                        <td>${site.responseTimeMs} ms</td>
                                        <td>${site.pageSpeedScore} / 100</td>
                                        <td>
                                            <div style="display: flex; gap: 6px; align-items: center;">
                                                <a href="index.jsp?id=${site.id}#portal" class="btn-sivte-outline" style="padding: 4px 10px; font-size: 12px;">
                                                    Monitor →
                                                </a>
                                                <form action="sites" method="POST" style="margin: 0;" onsubmit="return confirm('Remove this client site?');">
                                                    <input type="hidden" name="action" value="deleteSite">
                                                    <input type="hidden" name="id" value="${site.id}">
                                                    <button type="submit" style="background: none; border: 1px solid #CBD5E1; color: #EF4444; padding: 4px 8px; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                                        ✕
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Client Website Orders & Registrations Table -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                <h3 style="font-size: 20px; margin: 0;">Registered Client Orders (${orders.size()})</h3>
                <span style="font-size: 13px; color: var(--muted);">Table: <code>website_orders</code> in SQLite</span>
            </div>
            <div class="hm-matrix-wrapper">
                <table class="hm-matrix-table">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Business Name</th>
                            <th>Owner Contact</th>
                            <th>Category</th>
                            <th>Plan & Billing</th>
                            <th>Pricing (Build / Retainer)</th>
                            <th>Status</th>
                            <th>Submitted On</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr>
                                    <td colspan="9" style="text-align: center; color: var(--muted); padding: 24px;">
                                        No customer website orders placed yet. Submissions from the "Build My Website" form appear here.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="ord" items="${orders}">
                                    <tr>
                                        <td><strong><code>${ord.orderNumber}</code></strong></td>
                                        <td><strong>${ord.businessName}</strong></td>
                                        <td>
                                            <div><strong>${ord.customerName}</strong></div>
                                            <div style="font-size: 12px; color: var(--muted);">${ord.phone} &bull; ${ord.email}</div>
                                            <div style="font-size: 11px; color: var(--muted);">${ord.city}</div>
                                        </td>
                                        <td>${ord.category}</td>
                                        <td>
                                            <span style="font-weight: 700;">${ord.planName}</span>
                                            <div style="font-size: 12px; color: var(--muted);">${ord.billingCycle}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: #0A0A0A;">₹${ord.estimatedBuildPrice}</div>
                                            <div style="font-size: 12px; color: var(--muted);">+ ₹${ord.estimatedRetainerPrice}/mo</div>
                                        </td>
                                        <td>
                                            <span style="background: #EFF6FF; color: #1D4ED8; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 700;">
                                                ${ord.status}
                                            </span>
                                        </td>
                                        <td style="font-size: 12px; color: var(--muted);">${ord.createdAt}</td>
                                        <td>
                                            <form action="order" method="POST" style="margin: 0;" onsubmit="return confirm('Delete this order?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="orderId" value="${ord.id}">
                                                <button type="submit" style="background: none; border: 1px solid #CBD5E1; color: #EF4444; padding: 4px 8px; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                                    ✕
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Verified Business Customers Table (Anti-Joke Identity Management) -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                <h3 style="font-size: 20px;">Verified Business Client Accounts (${customers.size()})</h3>
                <span style="font-size: 12px; color: var(--muted);">Validated with legal identity / commercial proof</span>
            </div>
            <div class="hm-matrix-wrapper">
                <table class="hm-matrix-table">
                    <thead>
                        <tr>
                            <th>Business Name</th>
                            <th>Owner / Contact</th>
                            <th>Industry &amp; City</th>
                            <th>Identity Verification Proof</th>
                            <th>Registration Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty customers}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--muted); padding: 32px;">
                                        No registered customer accounts yet. Authenticated clients will appear here.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="cust" items="${customers}">
                                    <tr>
                                        <td>
                                            <strong>${cust.businessName}</strong>
                                            <div style="font-size: 11px; color: var(--muted);">Account ID: #${cust.id}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600;">${cust.name}</div>
                                            <div style="font-size: 12px; color: var(--muted);">${cust.phone} &bull; ${cust.email}</div>
                                        </td>
                                        <td>
                                            <div>${cust.category}</div>
                                            <div style="font-size: 12px; color: var(--muted);">${cust.city}</div>
                                        </td>
                                        <td>
                                            <span style="background: #F1F5F9; border: 1px solid #CBD5E1; color: #1E293B; padding: 3px 8px; border-radius: 4px; font-size: 11px; font-family: monospace;">
                                                ${cust.businessProof}
                                            </span>
                                        </td>
                                        <td style="font-size: 12px; color: var(--muted);">${cust.createdAt}</td>
                                        <td>
                                            <a href="customer-auth?action=deleteCustomer&id=${cust.id}" onclick="return confirm('Permanently delete customer account #${cust.id} (${cust.name} - ${cust.businessName}) from the database?');" class="btn-sivte-outline" style="color: #EF4444; border-color: #FECACA; padding: 4px 10px; font-size: 11px; text-decoration: none;">
                                                🗑️ Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Inbound Audit Leads Table -->
        <div>
            <h3 style="font-size: 20px; margin-bottom: 14px;">Inbound Audit Leads (${leads.size()})</h3>
            <div class="hm-matrix-wrapper">
                <table class="hm-matrix-table">
                    <thead>
                        <tr>
                            <th>Business Name</th>
                            <th>Website URL</th>
                            <th>Owner Contact</th>
                            <th>Category</th>
                            <th>Score</th>
                            <th>Captured On</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty leads}">
                                <tr>
                                    <td colspan="7" style="text-align: center; color: #94A3B8; padding: 24px;">
                                        No inbound audit leads yet. Run a scan from the Free Health Scanner.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="lead" items="${leads}">
                                    <tr>
                                        <td><strong>${lead.businessName}</strong></td>
                                        <td><a href="https://${lead.websiteUrl}" target="_blank" style="color: var(--accent-rust); text-decoration: underline;">${lead.websiteUrl}</a></td>
                                        <td>
                                            <div><strong>${lead.ownerEmail}</strong></div>
                                            <div style="font-size: 12px; color: var(--muted);">${lead.ownerPhone}</div>
                                        </td>
                                        <td>${lead.businessType}</td>
                                        <td>
                                            <span style="font-weight: 800; color: ${lead.healthScore > 80 ? '#10B981' : '#F59E0B'};">
                                                ${lead.healthScore} / 100
                                            </span>
                                        </td>
                                        <td style="font-size: 12px; color: var(--muted);">${lead.createdAt}</td>
                                        <td>
                                            <a href="audit?action=delete&id=${lead.id}" onclick="return confirm('Delete this lead?');" style="color: #94A3B8; font-size: 12px; text-decoration: none;">
                                                ✕ Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Onboard New Client Site Modal -->
    <div id="newSiteModal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <h3 style="font-size: 22px; margin-bottom: 6px;">Onboard New Client Website</h3>
            <p style="font-size: 14px; margin-bottom: 20px;">
                Add a new client website to WebEase 24/7 background telemetry monitoring.
            </p>

            <form action="sites" method="POST">
                <input type="hidden" name="action" value="addSite">
                
                <div class="calc-group">
                    <label class="calc-label" for="addBizName">Business Name *</label>
                    <input type="text" id="addBizName" name="businessName" class="calc-input" placeholder="e.g. Shalimar Biryani House" required>
                </div>

                <div class="calc-group">
                    <label class="calc-label" for="addCategory">Industry Vertical *</label>
                    <select id="addCategory" name="category" class="calc-select">
                        <option value="Restaurants & Cafés">Restaurants & Cafés</option>
                        <option value="Salons & Beauty">Salons & Beauty</option>
                        <option value="Clinics & Healthcare">Clinics & Healthcare</option>
                        <option value="Gyms & Fitness">Gyms & Fitness</option>
                        <option value="Tutors & Coaching">Tutors & Coaching</option>
                        <option value="Local Service Providers">Local Service Providers</option>
                    </select>
                </div>

                <div class="calc-group">
                    <label class="calc-label" for="addDomain">Domain URL *</label>
                    <input type="text" id="addDomain" name="domainUrl" class="calc-input" placeholder="e.g. shalimarbiryani.in" required>
                </div>

                <div class="calc-group">
                    <label class="calc-label" for="addEmail">Client Email</label>
                    <input type="email" id="addEmail" name="ownerEmail" class="calc-input" placeholder="e.g. owner@shalimar.in">
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px;">
                    <button type="button" onclick="closeModal('newSiteModal')" class="btn-sivte-outline">Cancel</button>
                    <button type="submit" class="btn-sivte-orange">Onboard & Start Monitoring</button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
