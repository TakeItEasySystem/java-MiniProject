<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("tickets") == null) {
        request.setAttribute("tickets", new com.webease.dao.TicketDAO().getAllTickets());
    }
    if (request.getAttribute("sites") == null) {
        request.setAttribute("sites", new com.webease.dao.SiteDAO().getAllSites());
    }
    if (request.getAttribute("pendingCount") == null) {
        request.setAttribute("pendingCount", new com.webease.dao.TicketDAO().getCountByStatus("Pending"));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Ongoing Maintenance & Support Desk</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body style="background: #F1F5F9;">

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="brand-logo">
                <div class="logo-icon">W</div>
                <div>
                    WebEase
                    <span class="brand-tagline">Client Support Desk</span>
                </div>
            </a>
            <ul class="nav-links">
                <li><a href="dashboard">Health Monitor</a></li>
                <li><a href="tickets" style="color: #00A88F; font-weight:700;">Maintenance Desk</a></li>
                <li><a href="admin">Admin Console</a></li>
                <li><a href="index.jsp" class="nav-cta-btn" style="background:#64748B;">Public Site</a></li>
            </ul>
        </div>
    </nav>

    <div class="section" style="max-width: 1140px; padding-top: 2rem;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="color: #0A2540; font-size: 1.85rem; font-weight: 800;">
                    Website Maintenance & Support Desk
                </h1>
                <p style="color: #64748B; font-size: 0.9rem;">
                    Submit updates, menu modifications, or design tweaks. Handled directly by your dedicated WebEase team.
                </p>
            </div>
            <button onclick="openModal('newTicketModal')" class="btn-primary">
                + New Update Request
            </button>
        </div>

        <!-- Tickets Table -->
        <div class="table-container" style="background: #FFFFFF;">
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>Ticket ID</th>
                        <th>Business</th>
                        <th>Request Title</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted At</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty tickets}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 3rem 1.5rem; color: #64748B;">
                                    <strong style="color: #0A2540; font-size: 1.1rem; display: block; margin-bottom: 0.5rem;">No Maintenance Tickets in Database</strong>
                                    <p style="font-size: 0.85rem; max-width: 480px; margin: 0 auto 1.25rem; line-height: 1.5;">
                                        Maintenance tickets submitted by clients are stored in SQLite (<code>webease.db</code>) via JDBC <code>PreparedStatement</code>. Click below to submit an update request.
                                    </p>
                                    <button onclick="openModal('newTicketModal')" class="btn-primary" style="font-size: 0.85rem;">
                                        + New Update Request
                                    </button>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="ticket" items="${tickets}">
                                <tr>
                                    <td><strong>#WB-${ticket.id}</strong></td>
                                    <td style="color: #0A2540; font-weight: 600;">${ticket.businessName}</td>
                                    <td>
                                        <strong style="color: #1E293B;">${ticket.title}</strong>
                                        <div style="font-size: 0.8rem; color: #64748B; margin-top: 2px;">${ticket.description}</div>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.78rem; background: #EEF2F6; padding: 3px 8px; border-radius: 6px; color: #334155; font-weight: 600;">
                                            ${ticket.category}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ticket.priority == 'Urgent'}">
                                                <span style="color: #DC2626; font-weight: 700; font-size: 0.82rem;">⚡ Urgent</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #475569; font-size: 0.82rem;">Normal</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ticket.status == 'Resolved'}">
                                                <span class="badge badge-resolved">✓ Resolved</span>
                                            </c:when>
                                            <c:when test="${ticket.status == 'In Progress'}">
                                                <span class="badge badge-in-progress">⏳ In Progress</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pending">● Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 0.82rem; color: #64748B;">${ticket.createdAt}</td>
                                    <td>
                                        <!-- Quick Status Toggle Form for Demo/Admin -->
                                        <form action="tickets" method="POST" style="margin: 0;">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="ticketId" value="${ticket.id}">
                                            <c:choose>
                                                <c:when test="${ticket.status == 'Pending'}">
                                                    <input type="hidden" name="status" value="In Progress">
                                                    <button type="submit" class="btn-secondary" style="padding: 0.3rem 0.6rem; font-size: 0.75rem;">Start Work</button>
                                                </c:when>
                                                <c:when test="${ticket.status == 'In Progress'}">
                                                    <input type="hidden" name="status" value="Resolved">
                                                    <button type="submit" class="btn-primary" style="padding: 0.3rem 0.6rem; font-size: 0.75rem;">Mark Done</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #10B981; font-size: 0.8rem; font-weight: 600;">Completed</span>
                                                </c:otherwise>
                                            </c:choose>
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

    <!-- Modal for New Ticket Submission -->
    <div id="newTicketModal" style="display: none; position: fixed; inset: 0; background: rgba(10,37,64,0.6); backdrop-filter: blur(4px); z-index: 1000; align-items: center; justify-content: center; padding: 1.5rem;">
        <div style="background: #FFFFFF; border-radius: 12px; max-width: 540px; width: 100%; padding: 2rem; box-shadow: var(--shadow-lg); position: relative;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <h3 style="color: #0A2540; font-size: 1.3rem; font-weight: 700;">Submit Website Update Request</h3>
                <button onclick="closeModal('newTicketModal')" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #64748B;">&times;</button>
            </div>

            <form action="tickets" method="POST" onsubmit="return validateTicketForm()">
                <div class="form-group">
                    <label class="form-label">Client Business Account:</label>
                    <c:choose>
                        <c:when test="${not empty sites}">
                            <select name="siteId" class="form-select" required>
                                <c:forEach var="site" items="${sites}">
                                    <option value="${site.id}">
                                        ${site.businessName} (${site.domainUrl})
                                    </option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <input type="text" name="businessName" class="form-input" placeholder="e.g. Your Business Name or Domain" required>
                            <input type="hidden" name="siteId" value="0">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="form-group">
                    <label class="form-label">Update Title / Summary *</label>
                    <input type="text" id="ticketTitle" name="title" class="form-input" placeholder="e.g. Update cappuccino price on coffee menu" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Category:</label>
                        <select name="category" class="form-select">
                            <option value="Menu/Price Update">Menu / Price Update</option>
                            <option value="Content Update">Text / Content Update</option>
                            <option value="Timing / Hours Change">Timing / Hours Change</option>
                            <option value="Image Swap">Image / Photo Swap</option>
                            <option value="Bug Fix">Form / Bug Fix</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Priority:</label>
                        <select name="priority" class="form-select">
                            <option value="Normal">Normal (24-48h turnaround)</option>
                            <option value="Urgent">⚡ Urgent (Under 6h)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Detailed Description of Changes *</label>
                    <textarea id="ticketDescription" name="description" class="form-textarea" rows="4" placeholder="Describe exactly what needs to be changed and on which page..." required></textarea>
                </div>

                <div style="display: flex; gap: 1rem; justify-content: flex-end; margin-top: 1.5rem;">
                    <button type="button" onclick="closeModal('newTicketModal')" class="btn-secondary">Cancel</button>
                    <button type="submit" class="btn-primary">Submit To WebEase Team</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/validation.js"></script>
    <script src="js/main.js"></script>
    <script>
        // Update hidden businessName when site select changes
        document.querySelector("select[name='siteId']").addEventListener("change", function () {
            var selectedOption = this.options[this.selectedIndex];
            document.getElementById("modalBusinessName").value = selectedOption.getAttribute("data-name") || "Client Business";
        });
    </script>
</body>
</html>
