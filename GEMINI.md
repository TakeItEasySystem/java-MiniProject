# WebEase — Startup Context & Antigravity IDE Project Instructions

## 1. Executive Summary & Startup Identity
- **Startup Name**: WebEase ("Build. Launch. Grow.")
- **Founders**:
  - Ayush Jha (A18)
  - Rishikant Mishra (A29)
  - Yadnesh Sawant (A68)
- **Institution**: Thakur Shree DPS College of Engineering & Management
- **Course**: Full Stack Java Programming (FSJP)

## 2. Core Business Concept: Website-as-a-Service (WaaS)
Traditional freelancers deliver a website and disappear, leaving local business owners with broken forms, outdated menus, and technical errors. DIY builders (Wix/Squarespace) are too complex for non-tech owners.

**WebEase is the all-in-one managed website partner for local businesses:**
- We build, launch, host, monitor, and continuously manage websites for a flat monthly retainer.
- **Key Differentiator**: **Proactive Monitoring & Issue Resolution** — detecting and fixing broken links, forms, and SSL expiration *before* customers notice.

## 3. Who We Serve (Target Verticals)
1. **Restaurants & Cafés**: Dynamic menu pricing, table reservations, operating hours, direct WhatsApp ordering.
2. **Salons & Beauty**: Service catalogs, stylist portfolios, appointment booking requests.
3. **Clinics & Healthcare**: Doctor OPD schedules, appointment inquiries, high-speed mobile accessibility.
4. **Gyms & Fitness**: Membership tiers, batch timings, trainer profiles, trial pass signup.
5. **Tutors & Coaching Classes**: Course curricula, admission inquiries, testimonial showcases.
6. **Local Service Providers**: 1-tap call/WhatsApp buttons, service area maps, instant quotes.

## 4. Business & Revenue Model (India SMB Market)
1. **One-Time Setup Fee** (₹6,999 – ₹15,999): Design, domain registration, cloud hosting setup, custom development.
2. **Monthly Management Retainer** (₹899 – ₹2,099 / month): Continuous 24/7 uptime monitoring, security updates, SSL management, and up to 6 content updates/month.
3. **Expansion Add-Ons**: Local SEO (Google Business Profile), payment gateway integration (Razorpay/UPI), custom booking workflows.

## 5. Technology Stack & Syllabus Alignment
- **Runtime**: Java OpenJDK 17 on **Apache Tomcat 9.0.99**
- **Architecture**: MVC Pattern (Model-View-Controller)
- **Database**: SQLite via **JDBC** (`webease.db`) with `PreparedStatement` to prevent SQL injection.
- **Backend Layers**:
  - `com.webease.model`: JavaBean POJOs (`ClientSite`, `MaintenanceTicket`, `AuditLead`, `ServicePlan`).
  - `com.webease.dao`: Data Access Objects (`SiteDAO`, `TicketDAO`, `LeadDAO`, `DBConnection`).
  - `com.webease.controller`: `HttpServlet` controllers (`SiteServlet`, `TicketServlet`, `AuditServlet`, `HealthPingServlet`).
  - `com.webease.service`: Background multithreading monitor (`MonitorService`, `HealthChecker`), asynchronous SMTP email verification engine (`EmailService` via Jakarta Mail), and real transactional SMS gateway (`BrevoService` via Brevo API v3).
  - `com.webease.exception`: Custom exceptions (`SiteNotFoundException`, `InvalidTicketException`).
- **Email & SMS Verification Engines**:
  - Jakarta Mail (`jakarta.mail-1.6.7.jar` + `jakarta.activation-1.2.2.jar`) with asynchronous `ExecutorService` daemon thread pool.
  - Brevo Transactional SMS API v3 (`BrevoService`) using native Java 17 `HttpClient` for carrier SMS OTP delivery.
  - SMTP over TLS/SSL (Brevo/Gmail/Outlook/Custom) for 6-digit OTP verification, order PIN confirmation, and automated downtime alerts.
  - Graceful Dev Fallback: Server console simulated dispatch when SMTP/Brevo credentials are unconfigured or offline.
- **Frontend & Dynamic Features**:
  - HTML5 & CSS3 with Deep Navy (`#0A2540`) and Electric Cyan (`#00D4B2`) branding.
  - Client-side validation (`@` and `.` check per Lab Experiment 08).
  - DOM manipulation for dynamic pricing calculations.
  - Asynchronous AJAX diagnostic scanner.
  - Embedded **React 18 Component** (`dashboard-react.js`) with Hooks (`useState`, `useEffect`) for real-time live ping telemetry.

## 6. Antigravity IDE Development Guidelines
Whenever assisting with this project:
- Respect the **Full Stack Java Programming (FSJP) syllabus** (Units I through VI).
- Maintain clean separation between Model, DAO, Controller, and View.
- Keep the application unified within the single-page experience (`index.jsp`).
- Never introduce external build dependencies (Maven/Gradle) without asking, as the environment compiles natively with `javac` and runs on Tomcat 9.
