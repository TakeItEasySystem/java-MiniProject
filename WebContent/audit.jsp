<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Free Local Business Website Health Audit</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="brand-logo">
                <div class="logo-icon">W</div>
                <div>
                    WebEase
                    <span class="brand-tagline">Build. Launch. Grow.</span>
                </div>
            </a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="dashboard">Client Portal</a></li>
                <li><a href="tickets">Support Desk</a></li>
                <li><a href="index.jsp#pricing">Pricing</a></li>
            </ul>
        </div>
    </nav>

    <div class="section" style="max-width: 860px; padding-top: 3rem;">
        <div class="section-header" style="margin-bottom: 2rem;">
            <div class="section-tag">Instant Diagnostic</div>
            <h1 class="section-title">Free Website Health & Performance Scanner</h1>
            <p class="section-subtitle">
                Is your local business website losing customers due to slow load speeds, broken mobile layouts, or missing SSL? Run an instant diagnostic scan below.
            </p>
        </div>

        <div class="hero-mockup-card" style="padding: 2.25rem;">
            <!-- Audit Form -->
            <form id="websiteAuditForm">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label" for="businessName">Business Name *</label>
                        <input type="text" id="businessName" class="form-input" placeholder="e.g. Copper Chimney Café" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="businessType">Business Category *</label>
                        <select id="businessType" class="form-select">
                            <option value="Restaurant & Café">Restaurant & Café</option>
                            <option value="Salon & Beauty">Salon & Beauty</option>
                            <option value="Clinic & Healthcare">Clinic & Healthcare</option>
                            <option value="Gym & Fitness">Gym & Fitness</option>
                            <option value="Tutor & Coaching">Tutor & Coaching</option>
                            <option value="Local Service Provider">Local Service Provider</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="websiteUrl">Website URL / Domain *</label>
                    <input type="text" id="websiteUrl" class="form-input" placeholder="e.g. copperchimneycafe.com" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label" for="ownerEmail">Owner Email Address *</label>
                        <input type="email" id="ownerEmail" class="form-input" placeholder="e.g. owner@gmail.com" required>
                        <span style="font-size: 0.75rem; color: #64748B;">Validated with '@' & '.' (Lab Experiment 08)</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="ownerPhone">Contact Phone (10 digits)</label>
                        <input type="tel" id="ownerPhone" class="form-input" placeholder="e.g. 9876543210">
                    </div>
                </div>

                <button type="submit" id="auditSubmitBtn" class="btn-primary" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                    🔍 Run Free Health Scan
                </button>
            </form>

            <!-- Loading status indicator -->
            <div id="scanStatus" style="display: none; margin-top: 1.5rem; text-align: center; color: #0A2540; font-weight: 600; padding: 1rem; background: #F1F5F9; border-radius: 8px;">
            </div>

            <!-- Dynamic Results Card (Rendered via AJAX & JSON DOM) -->
            <div id="auditResults" style="display: none; margin-top: 2rem; border-top: 2px dashed #E2E8F0; padding-top: 1.5rem;">
                <h3 style="color: #0A2540; font-size: 1.3rem; margin-bottom: 1rem;">Diagnostic Scorecard:</h3>

                <div class="metric-grid">
                    <div class="metric-box">
                        <div id="resScore" class="metric-val" style="color: #F59E0B;">--</div>
                        <div class="metric-label">Health Score</div>
                    </div>
                    <div class="metric-box">
                        <div id="resSpeed" class="metric-val">--</div>
                        <div class="metric-label">Server Latency</div>
                    </div>
                    <div class="metric-box">
                        <div id="resSsl" class="metric-val" style="font-size: 1.1rem; padding-top: 0.35rem;">--</div>
                        <div class="metric-label">SSL Encryption</div>
                    </div>
                </div>

                <div style="background: #F8FAFC; padding: 1.25rem; border-radius: 8px; border-left: 4px solid #00D4B2; margin-bottom: 1.5rem;">
                    <strong style="color: #0A2540;">Detected Diagnostic Insights:</strong>
                    <p id="resIssues" style="margin-top: 0.35rem; color: #475569; font-size: 0.9rem;">--</p>
                </div>

                <div style="background: #ECFDF5; padding: 1.25rem; border-radius: 8px; border: 1px solid #A7F3D0; text-align: center;">
                    <h4 style="color: #065F46; font-size: 1.05rem; margin-bottom: 0.35rem;">How WebEase Can Solve This For You</h4>
                    <p style="color: #047857; font-size: 0.88rem; margin-bottom: 1rem;">
                        Our managed service proactively fixes mobile layout breakages, monitors SSL expiration, and handles all updates for a flat monthly fee.
                    </p>
                    <a href="dashboard" class="btn-primary" style="display: inline-block;">
                        View Managed Client Demo →
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/validation.js"></script>
    <script src="js/audit.js"></script>
</body>
</html>
