<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // If accessed directly without servlet forwarding and no session, redirect to login
    com.webease.model.Customer sessionCust = (com.webease.model.Customer) session.getAttribute("customerUser");
    if (sessionCust == null) {
        response.sendRedirect("customer-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Customer Portal & Profile Hub</title>
    <meta name="description" content="Verified client portal for WebEase business customers. View profile, website uptime telemetry, and ongoing build progress.">
    <link rel="icon" type="image/png" href="images/logo.png">
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <style>
        .portal-layout {
            max-width: 1180px;
            margin: 0 auto;
            padding: 36px 24px 80px;
            font-family: var(--font-main);
        }
        .portal-header {
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
        }
        .portal-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #065F46;
            background: #ECFDF5;
            border: 1px solid #A7F3D0;
            padding: 4px 10px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        .portal-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 28px;
            margin-bottom: 32px;
        }
        @media (max-width: 860px) {
            .portal-grid {
                grid-template-columns: 1fr;
            }
        }
        .portal-card {
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 28px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
        }
        .portal-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-light);
            padding-bottom: 16px;
            margin-bottom: 20px;
        }
        .portal-card-title {
            font-size: 17px;
            font-weight: 800;
            color: #0A0A0A;
            margin: 0;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 10px 0;
            border-bottom: 1px solid #F1F5F9;
            font-size: 14px;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #64748B;
            font-weight: 600;
            min-width: 140px;
        }
        .info-value {
            color: #0F172A;
            font-weight: 700;
            text-align: right;
            word-break: break-word;
        }
        .stepper {
            display: flex;
            justify-content: space-between;
            margin: 24px 0 16px;
            position: relative;
        }
        .stepper::before {
            content: '';
            position: absolute;
            top: 14px;
            left: 20px;
            right: 20px;
            height: 2px;
            background: #E2E8F0;
            z-index: 1;
        }
        .step-item {
            position: relative;
            z-index: 2;
            text-align: center;
            flex: 1;
        }
        .step-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #FFFFFF;
            border: 2px solid #CBD5E1;
            color: #64748B;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 800;
            margin: 0 auto 8px;
        }
        .step-item.completed .step-circle {
            background: #059669;
            border-color: #059669;
            color: #FFFFFF;
        }
        .step-item.active .step-circle {
            background: #002B66;
            border-color: #002B66;
            color: #FFFFFF;
        }
        .step-label {
            font-size: 11px;
            font-weight: 700;
            color: #475569;
        }
        .ticket-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-top: 12px;
        }
        .ticket-table th, .ticket-table td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid var(--border-light);
        }
        .ticket-table th {
            background: #F8FAFC;
            color: #475569;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .status-pill {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
        }
        .status-healthy { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
        .status-open { background: #FEF3C7; color: #92400E; border: 1px solid #FCD34D; }
        .status-resolved { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; }
    </style>
</head>
<body style="background: #F8FAFC;">

    <!-- Top Navigation Header -->
    <header class="sivte-header">
        <div class="sivte-nav-container">
            <a href="index.jsp" class="sivte-brand" style="display: inline-flex; align-items: center;">
                <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img">
            </a>

            <div style="display: flex; align-items: center; gap: 16px;">
                <a href="index.jsp" class="sivte-nav-link">Main Website</a>
                <a href="index.jsp#pricing-section" class="sivte-nav-link">Pricing Plans</a>
                <div style="background: #E2E8F0; width: 1px; height: 24px;"></div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span style="font-size: 13px; font-weight: 700; color: #0F172A;">
                        ${customer.name}
                    </span>
                    <a href="customer-auth?action=logout" class="btn-sivte-outline" style="padding: 6px 14px; font-size: 12px;">
                        Sign Out
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="portal-layout">
        <!-- Portal Header -->
        <div class="portal-header">
            <div>
                <span class="portal-badge">
                    ✓ Verified Client Profile
                </span>
                <h1 style="font-size: 26px; font-weight: 800; color: #0A0A0A; margin: 4px 0 8px;">
                    ${customer.businessName}
                </h1>
                <p style="font-size: 14px; color: #64748B; margin: 0;">
                    Business Category: <strong>${customer.category}</strong> &bull; Operating Location: <strong>${customer.city}</strong>
                </p>
            </div>

            <div style="display: flex; gap: 12px; align-items: center;">
                <a href="https://wa.me/919019930386?text=Hi%20WebEase%20founders,%20I%20am%20${customer.name}%20from%20${customer.businessName}." target="_blank" class="btn-sivte-orange" style="display: inline-flex; align-items: center; gap: 8px;">
                    WhatsApp Dedicated Support
                </a>
            </div>
        </div>

        <c:if test="${not empty param.ticketCreated}">
            <div style="background: #ECFDF5; border: 1px solid #A7F3D0; color: #065F46; padding: 12px 18px; border-radius: 6px; font-size: 14px; margin-bottom: 24px;">
                ✓ Maintenance ticket successfully created. Our engineering team has received your request and will deploy updates within 24 hours.
            </div>
        </c:if>

        <div class="portal-grid">
            <!-- Card 1: Verified Customer Profile Details -->
            <div class="portal-card">
                <div class="portal-card-header">
                    <h2 class="portal-card-title">Customer Information & Identity</h2>
                    <span class="status-pill status-healthy">Verified</span>
                </div>

                <div class="info-row">
                    <span class="info-label">Business Name:</span>
                    <span class="info-value">${customer.businessName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Owner / Manager:</span>
                    <span class="info-value">${customer.name}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">WhatsApp Mobile:</span>
                    <span class="info-value">+91 ${customer.phone}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Official Email:</span>
                    <span class="info-value">${customer.email}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Operating City:</span>
                    <span class="info-value">${customer.city}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Business Vertical:</span>
                    <span class="info-value">${customer.category}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Verification Proof:</span>
                    <span class="info-value" style="color: #0369A1;">${customer.businessProof}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Client Since:</span>
                    <span class="info-value">${customer.createdAt}</span>
                </div>
            </div>

            <!-- Card 2: Active Website Health & Telemetry -->
            <div class="portal-card">
                <div class="portal-card-header">
                    <h2 class="portal-card-title">Managed Website Telemetry</h2>
                    <span class="status-pill status-healthy">24/7 Monitored</span>
                </div>

                <c:choose>
                    <c:when test="${not empty sites}">
                        <c:forEach var="site" items="${sites}">
                            <div style="background: #F8FAFC; border: 1px solid var(--border-light); border-radius: 6px; padding: 16px; margin-bottom: 14px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <strong style="font-size: 15px; color: #0A0A0A;">https://${site.domainUrl}</strong>
                                    <span class="status-pill status-healthy">${site.status}</span>
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; font-size: 12px; text-align: center;">
                                    <div style="background: #FFFFFF; border: 1px solid #E2E8F0; padding: 8px; border-radius: 4px;">
                                        <div style="color: #64748B;">Uptime Score</div>
                                        <div style="font-weight: 800; color: #059669; font-size: 14px;">${site.uptimePercentage}%</div>
                                    </div>
                                    <div style="background: #FFFFFF; border: 1px solid #E2E8F0; padding: 8px; border-radius: 4px;">
                                        <div style="color: #64748B;">Response Latency</div>
                                        <div style="font-weight: 800; color: #0284C7; font-size: 14px;">${site.responseTimeMs} ms</div>
                                    </div>
                                    <div style="background: #FFFFFF; border: 1px solid #E2E8F0; padding: 8px; border-radius: 4px;">
                                        <div style="color: #64748B;">SSL TLS Status</div>
                                        <div style="font-weight: 800; color: #059669; font-size: 14px;">Active 256-bit</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 6px; padding: 20px; text-align: center; color: #64748B; font-size: 13px;">
                            Your website domain deployment is currently being provisioned under your 5-day rapid build.
                        </div>
                    </c:otherwise>
                </c:choose>

                <div style="margin-top: 14px; font-size: 12px; color: #64748B; line-height: 1.5;">
                    Uptime probes check your DNS, SSL expiration, and contact form response every 60 seconds automatically.
                </div>
            </div>
        </div>

        <!-- Section: Ongoing Website Build Orders -->
        <div class="portal-card" style="margin-bottom: 32px;">
            <div class="portal-card-header">
                <div>
                    <h2 class="portal-card-title">Website Build Orders & Progress</h2>
                    <p style="font-size: 13px; color: #64748B; margin: 4px 0 0;">
                        Track your 5-day website build workflow from verification to live cloud launch.
                    </p>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div style="border: 1px solid #E2E8F0; border-radius: 6px; padding: 20px; margin-bottom: 20px; background: #FFFFFF;">
                            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; border-bottom: 1px solid #F1F5F9; padding-bottom: 14px; margin-bottom: 16px;">
                                <div>
                                    <span style="font-size: 12px; color: #64748B;">Order Reference:</span>
                                    <strong style="font-size: 16px; color: #0A0A0A; margin-left: 6px;">${order.orderNumber}</strong>
                                </div>
                                <div>
                                    <span class="status-pill status-healthy">${order.status}</span>
                                    <span style="font-size: 13px; color: #64748B; margin-left: 10px;">${order.createdAt}</span>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 14px; margin-bottom: 20px; font-size: 13px;">
                                <div>
                                    <span style="color: #64748B; display: block;">Service Plan:</span>
                                    <strong style="color: #0A0A0A;">${order.planName}</strong>
                                </div>
                                <div>
                                    <span style="color: #64748B; display: block;">Billing Schedule:</span>
                                    <strong style="color: #0A0A0A;">${order.billingCycle}</strong>
                                </div>
                                <div>
                                    <span style="color: #64748B; display: block;">One-Time Build Setup:</span>
                                    <strong style="color: #0A0A0A;">₹<c:out value="${order.estimatedBuildPrice}" /></strong>
                                </div>
                                <div>
                                    <span style="color: #64748B; display: block;">Monthly Retainer:</span>
                                    <strong style="color: #0A0A0A;">₹<c:out value="${order.estimatedRetainerPrice}" /> / month</strong>
                                </div>
                            </div>

                            <!-- 4-Step Build Progress Tracker -->
                            <div class="stepper">
                                <div class="step-item completed">
                                    <div class="step-circle">✓</div>
                                    <div class="step-label">1. Verified Order</div>
                                </div>
                                <div class="step-item active">
                                    <div class="step-circle">2</div>
                                    <div class="step-label">2. Wireframe & Content</div>
                                </div>
                                <div class="step-item">
                                    <div class="step-circle">3</div>
                                    <div class="step-label">3. 5-Day Build</div>
                                </div>
                                <div class="step-item">
                                    <div class="step-circle">4</div>
                                    <div class="step-label">4. Cloud Launch</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 36px 20px; color: #64748B; font-size: 14px;">
                        <p style="margin-bottom: 16px;">No pending orders found. You can request a custom build directly from our pricing page.</p>
                        <a href="index.jsp#pricing-section" class="btn-sivte-orange">View Managed Website Plans</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Section: Maintenance & Support Desk -->
        <div class="portal-card">
            <div class="portal-card-header">
                <div>
                    <h2 class="portal-card-title">Maintenance & Content Update Desk</h2>
                    <p style="font-size: 13px; color: #64748B; margin: 4px 0 0;">
                        Submit content updates, price changes, or menu revisions included in your monthly management retainer.
                    </p>
                </div>
            </div>

            <!-- New Ticket Form -->
            <form action="customer-portal" method="POST" style="background: #F8FAFC; border: 1px solid var(--border-light); border-radius: 6px; padding: 20px; margin-bottom: 24px;">
                <input type="hidden" name="action" value="submitTicket">

                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; margin-bottom: 4px; color: #475569;">Request Title *</label>
                        <input type="text" name="title" class="calc-input" placeholder="e.g. Update weekend dinner menu prices" required>
                    </div>
                    <div>
                        <label style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; margin-bottom: 4px; color: #475569;">Update Category</label>
                        <select name="category" class="calc-select">
                            <option value="Content Update">Content Update</option>
                            <option value="Menu / Price Revision">Menu / Price Revision</option>
                            <option value="Operating Hours">Operating Hours</option>
                            <option value="Doctor OPD Schedule">Doctor OPD Schedule</option>
                            <option value="Photo Gallery">Photo Gallery</option>
                            <option value="Technical Error">Technical Error</option>
                        </select>
                    </div>
                    <div>
                        <label style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; margin-bottom: 4px; color: #475569;">Priority</label>
                        <select name="priority" class="calc-select">
                            <option value="Normal">Normal (24h turnaround)</option>
                            <option value="Urgent">Urgent (Same-day)</option>
                        </select>
                    </div>
                </div>

                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; margin-bottom: 4px; color: #475569;">Detailed Instructions</label>
                    <textarea name="description" class="calc-input" rows="2" placeholder="Describe the exact items, prices, or changes you want deployed..." required></textarea>
                </div>

                <button type="submit" class="btn-sivte-black" style="padding: 10px 20px; font-size: 13px;">
                    Submit Maintenance Request
                </button>
            </form>

            <!-- Tickets Table -->
            <c:choose>
                <c:when test="${not empty tickets}">
                    <table class="ticket-table">
                        <thead>
                            <tr>
                                <th>Ticket ID</th>
                                <th>Subject</th>
                                <th>Category</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Submitted On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tickets}">
                                <tr>
                                    <td><strong>#TICK-${t.id}</strong></td>
                                    <td>${t.title}</td>
                                    <td>${t.category}</td>
                                    <td>${t.priority}</td>
                                    <td><span class="status-pill status-${t.status eq 'Resolved' ? 'resolved' : 'open'}">${t.status}</span></td>
                                    <td style="color: #64748B;">${t.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 24px 14px; color: #64748B; font-size: 13px;">
                        No open maintenance requests. All systems are operating smoothly.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Sivte Clean Footer -->
    <footer class="sivte-footer">
        <div class="sivte-footer-container">
            <div>
                <a href="index.jsp" class="sivte-brand" style="margin-bottom: 12px; display: inline-flex; align-items: center;">
                    <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img" style="height: 42px;">
                </a>
                <p style="font-size: 14px; max-width: 340px; margin-top: 8px;">
                    Managed website partner for local businesses. Flat monthly retainer covering design, cloud hosting, 24/7 uptime monitoring, and WhatsApp updates.
                </p>
                <div style="margin-top: 18px; font-size: 12px; color: #888; display: flex; gap: 14px; align-items: center; flex-wrap: wrap;">
                    <span>© 2026 WebEase Platform. All rights reserved.</span>
                    <a href="privacy.jsp" style="text-decoration: underline; color: #666;">Privacy Policy</a>
                    <a href="terms.jsp" style="text-decoration: underline; color: #666;">Terms & Conditions</a>
                </div>
            </div>

            <div>
                <h4>Direct Contact</h4>
                <p style="font-size: 14px; line-height: 1.7; color: #555;">
                    Phone Call: <strong>+91 90199 30386</strong><br>
                    WhatsApp: <strong>+91 90199 30386</strong><br>
                    Email: <strong>founders@webease.in</strong><br>
                    Support Hours: Mon - Sat, 9:00 AM - 8:00 PM IST
                </p>
            </div>

            <div>
                <h4>Navigation</h4>
                <a href="index.jsp">Home</a>
                <a href="index.jsp#products-section">Managed Websites</a>
                <a href="index.jsp#pricing-section">Pricing & Plans</a>
                <a href="customer-portal">Customer Portal</a>
                <a href="customer-auth?action=logout">Sign Out</a>
            </div>
        </div>
    </footer>

</body>
</html>
