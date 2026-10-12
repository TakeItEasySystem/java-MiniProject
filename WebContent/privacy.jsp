<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Privacy Policy</title>
    <meta name="description" content="WebEase Privacy Policy - How we collect, handle, and safeguard data for local businesses and visitors.">
    <link rel="icon" type="image/png" href="images/logo.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .legal-content {
            max-width: 820px;
            margin: 0 auto;
            padding: 48px 24px 80px;
        }
        .legal-header {
            margin-bottom: 36px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 24px;
        }
        .legal-section {
            margin-bottom: 32px;
        }
        .legal-section h2 {
            font-size: 20px;
            margin-bottom: 12px;
            color: #0A0A0A;
            font-weight: 700;
        }
        .legal-section p {
            font-size: 15px;
            line-height: 1.75;
            color: #374151;
            margin-bottom: 12px;
        }
        .legal-section ul {
            margin: 12px 0 16px 20px;
            color: #374151;
            font-size: 15px;
            line-height: 1.7;
        }
        .legal-section li {
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

    <!-- Top Customer Bar -->
    <div class="sivte-customer-bar">
        <span>Existing customers</span>
        <a href="index.jsp#portal">Customer portal · Log in -></a>
    </div>

    <!-- Header Navigation -->
    <header class="sivte-header">
        <div class="sivte-nav-container">
            <a href="index.jsp" class="sivte-brand" style="display: inline-flex; align-items: center;">
                <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img">
            </a>

            <nav class="sivte-nav-links">
                <a href="index.jsp" class="sivte-nav-link">Home</a>
                <a href="index.jsp#products-section" class="sivte-nav-link">Products</a>
                <a href="index.jsp#pricing-section" class="sivte-nav-link">Pricing</a>
                <a href="terms.jsp" class="sivte-nav-link">Terms & Conditions</a>
                <a href="index.jsp" class="sivte-cta-btn">Back to Website</a>
            </nav>
        </div>
    </header>

    <main class="legal-content">
        <div class="legal-header">
            <p class="hm-eyebrow">LEGAL & DATA PROTECTION</p>
            <h1 style="font-size: 36px; margin-bottom: 8px;">Privacy Policy</h1>
            <p style="font-size: 14px; color: var(--muted); margin: 0;">
                Last Updated: October 2026 | Effective Date: October 10, 2026
            </p>
        </div>

        <div class="legal-section">
            <h2>1. Introduction</h2>
            <p>
                WebEase ("we," "our," or "us") operates as a managed Website-as-a-Service (WaaS) partner for local businesses. This Privacy Policy outlines how we collect, store, process, and protect business and personal information across our website and managed client deployments in India.
            </p>
            <p>
                By using our website, submitting an order, or engaging our website management services, you acknowledge and agree to the data practices described in this document.
            </p>
        </div>

        <div class="legal-section">
            <h2>2. Information We Collect</h2>
            <p>We collect only the information necessary to build, host, and manage your website:</p>
            <ul>
                <li><strong>Contact & Business Details:</strong> Business name, owner or manager name, contact email address, phone number, physical location, and industry vertical.</li>
                <li><strong>Domain & Account Credentials:</strong> Domain names, registrar access, DNS records, or hosting information supplied to configure client websites.</li>
                <li><strong>Diagnostic Audit Inputs:</strong> Website URLs and contact numbers submitted via our Free Website Health Scanner.</li>
                <li><strong>Technical & Telemetry Logs:</strong> Server latency, uptime timestamps, HTTP status codes, and SSL certificate validity dates captured by our 24/7 background health monitor.</li>
            </ul>
        </div>

        <div class="legal-section">
            <h2>3. How We Use Collected Data</h2>
            <p>Information collected by WebEase is used strictly for operational purposes:</p>
            <ul>
                <li>To design, configure, host, and launch your mobile-responsive business website.</li>
                <li>To conduct continuous 24/7 uptime monitoring and detect performance anomalies.</li>
                <li>To communicate website updates, invoices, and diagnostic results via WhatsApp and email.</li>
                <li>To configure WhatsApp direct ordering and appointment workflows.</li>
                <li>To prevent security threats, unauthorized access, and malicious automated traffic.</li>
            </ul>
        </div>

        <div class="legal-section">
            <h2>4. 100% Client Data Ownership</h2>
            <p>
                WebEase maintains a strict client ownership policy. All client content, brand assets, product catalogs, customer booking data, and domain assets remain 100% your property.
            </p>
            <p>
                We do not sell, rent, license, or monetize your business or customer data to third-party advertisers or data brokers under any circumstances.
            </p>
        </div>

        <div class="legal-section">
            <h2>5. Data Security Standards</h2>
            <p>
                We implement layered technical controls to protect client information:
            </p>
            <ul>
                <li><strong>Database Integrity:</strong> SQLite relational data queries utilize JDBC PreparedStatements exclusively to eliminate SQL-injection vulnerabilities.</li>
                <li><strong>Access Control:</strong> Administrative and operational consoles are protected by Java EE session authentication and restricted to verified founders.</li>
                <li><strong>Transport Security:</strong> All client websites and diagnostic endpoints operate over encrypted HTTPS protocols with TLS certificates.</li>
            </ul>
        </div>

        <div class="legal-section">
            <h2>6. Third-Party Infrastructure Services</h2>
            <p>
                To provide managed hosting and domain services, WebEase works with reputable third-party infrastructure providers:
            </p>
            <ul>
                <li><strong>Cloud Hosting & CDN:</strong> High-performance cloud server hosts that store static assets and web pages.</li>
                <li><strong>Domain Registrars:</strong> ICANN-accredited domain registrars for .in, .com, and regional domain registrations.</li>
                <li><strong>Payment Processors:</strong> Standard UPI and Razorpay payment gateways for invoice processing. Payment credentials are handled directly by PCI-DSS compliant gateways.</li>
            </ul>
        </div>

        <div class="legal-section">
            <h2>7. Data Retention & Deletion Rights</h2>
            <p>
                We retain client project files and telemetry history for the duration of the active management retainer. If a client terminates their management retainer, WebEase provides a complete ZIP archive backup of all website code and database files.
            </p>
            <p>
                Upon formal written request to <code>founders@webease.in</code>, we will permanently purge all archived copies from our secondary systems within 30 days.
            </p>
        </div>

        <div class="legal-section">
            <h2>8. Contact & Grievance Redressal</h2>
            <p>
                If you have questions, feedback, or data requests regarding this Privacy Policy, please contact our team:
            </p>
            <ul>
                <li><strong>Email:</strong> founders@webease.in</li>
                <li><strong>Phone / WhatsApp:</strong> +91 90199 30386</li>
                <li><strong>Office Hours:</strong> Monday - Saturday, 9:00 AM - 8:00 PM IST</li>
                <li><strong>Location:</strong> Mumbai, Maharashtra, India</li>
            </ul>
        </div>
    </main>

    <!-- Footer -->
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
                <a href="index.jsp#process-section">How It Works</a>
                <a href="index.jsp#pricing-section">Pricing & Plans</a>
                <a href="privacy.jsp">Privacy Policy</a>
                <a href="terms.jsp">Terms & Conditions</a>
            </div>
        </div>
    </footer>

</body>
</html>
