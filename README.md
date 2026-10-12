# WebEase Platform â€” Full Stack Java Mini Project

**Project Title**: WebEase ("Managed Web Operations & Hosting Infrastructure")  
**Course**: Full Stack Java Programming (FSJP) â€” Units I to VI  
**Institution**: Thakur Shree DPS College of Engineering & Management  
**Founders**:
- **Ayush Jha** (Roll No: A18) â€” Operations & Incident Response
- **Rishikant Mishra** (Roll No: A29) â€” Core Architecture & Infrastructure
- **Yadnesh Sawant** (Roll No: A68) â€” Client Support & SLAs

---

## ðŸ“ Project Directory Structure

```plaintext
C:\java mini project\
â”œâ”€â”€ src\
â”‚   â””â”€â”€ com\webease\
â”‚       â”œâ”€â”€ controller\      # Servlets (CustomerAuthServlet, SiteServlet, TicketServlet, AuditServlet)
â”‚       â”œâ”€â”€ dao\             # JDBC SQLite Data Access Objects (CustomerDAO, OrderDAO, SiteDAO, TicketDAO)
â”‚       â”œâ”€â”€ exception\       # Custom User-Defined Exceptions (SiteNotFoundException, InvalidTicketException)
â”‚       â”œâ”€â”€ filter\          # Security and Encoding Filters
â”‚       â”œâ”€â”€ model\           # Encapsulated JavaBeans (Customer, WebsiteOrder, ClientSite, MaintenanceTicket)
â”‚       â”œâ”€â”€ service\         # Business Logic (GoogleAuthService, BrevoApiService, EmailService)
â”‚       â””â”€â”€ util\            # Hash, Validation, & Helper Utilities
â”œâ”€â”€ WebContent\
â”‚   â”œâ”€â”€ index.jsp            # Sivte-styled Homepage (6-Node Interactive Circuit Map)
â”‚   â”œâ”€â”€ customer-login.jsp   # Clean "Welcome back!" Firebase Google Sign-In
â”‚   â”œâ”€â”€ complete-profile.jsp # Business profile verification (GSTIN, MSME, Maps, UPI)
â”‚   â”œâ”€â”€ order-confirmation.jsp # Expert Consultation Gateway (WhatsApp Chat vs Call)
â”‚   â”œâ”€â”€ customer-portal.jsp  # Dedicated Client Dashboard (React 18 Telemetry)
â”‚   â”œâ”€â”€ admin-login.jsp      # Operations & Founders Sign-In
â”‚   â”œâ”€â”€ css\                 # Production Stylesheets
â”‚   â”œâ”€â”€ js\                  # Client Scripts & React Telemetry Component
â”‚   â”œâ”€â”€ images\              # Logos & Branding Assets
â”‚   â””â”€â”€ WEB-INF\
â”‚       â”œâ”€â”€ web.xml          # Servlet Deployment Descriptor
â”‚       â”œâ”€â”€ mail.properties  # Brevo API, SMTP, Google & Firebase Credentials
â”‚       â”œâ”€â”€ webease.db       # Active SQLite Database File (All tables & rows)
â”‚       â”œâ”€â”€ lib\             # SQLite JDBC Driver & Jakarta Mail JARs
â”‚       â””â”€â”€ classes\         # Compiled Java Bytecode (.class files)
â””â”€â”€ README.md
```

---

## ðŸ—„ï¸ Database Location

The SQLite database file is stored at:
```plaintext
C:\java mini project\WebContent\WEB-INF\webease.db
```

### Tables Inside `webease.db`:
1. **`customers`**: Registered Google & Firebase user accounts.
2. **`website_orders`**: Inbound orders (`WEB-ORD-XXXX`) with setup and monthly retainer details.
3. **`sites`**: 24/7 monitored business websites (latency, uptime %, speed score).
4. **`tickets`**: Maintenance and support requests.
5. **`audit_leads`**: Website health check leads.

---

## ðŸš€ Live Application URLs

When Tomcat is running:
- **Homepage**: http://localhost:8080/webease/
- **Google Sign-In**: http://localhost:8080/webease/customer-login.jsp
- **Client Portal**: http://localhost:8080/webease/customer-portal
- **Operations Portal**: http://localhost:8080/webease/admin-login.jsp