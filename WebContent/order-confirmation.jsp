<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    com.webease.model.Customer customer = (com.webease.model.Customer) session.getAttribute("customerUser");
    if (customer == null) {
        response.sendRedirect("customer-login.jsp");
        return;
    }

    String orderId = request.getParameter("orderId");
    String planName = request.getParameter("plan");
    if (planName == null || planName.trim().isEmpty()) {
        planName = "Starter Managed Website";
    }

    com.webease.dao.OrderDAO orderDAO = new com.webease.dao.OrderDAO();
    com.webease.model.WebsiteOrder order = null;
    if (orderId != null && !orderId.trim().isEmpty()) {
        order = orderDAO.getOrderByNumber(orderId.trim());
    }

    if (order == null) {
        java.util.List<com.webease.model.WebsiteOrder> customerOrders = orderDAO.getOrdersByEmail(customer.getEmail());
        if (!customerOrders.isEmpty()) {
            order = customerOrders.get(0);
            orderId = order.getOrderNumber();
            planName = order.getPlanName();
        } else {
            orderId = (orderId != null) ? orderId : "WEB-ORD-" + (1000 + new java.util.Random().nextInt(9000));
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | Our Experts Will Reach You | WebEase</title>
    <link rel="icon" type="image/png" href="images/logo.png">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">

    <style>
        :root {
            --sivte-bg: #F7F7F5;
            --sivte-surface: #FFFFFF;
            --sivte-ink: #0A0A0A;
            --sivte-body: #565A60;
            --sivte-border: #DEDED8;
            --sivte-orange: #FD5228;
            --sivte-orange-hover: #ED461D;
            --sivte-rust: #B83313;
            --sivte-green: #10B981;
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Brand Navigation */
        .confirm-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--sivte-border);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--sivte-ink);
            font-family: var(--font-heading);
            font-size: 20px;
            font-weight: 800;
        }

        .brand-link img {
            height: 36px;
            border-radius: 6px;
        }

        .user-tag {
            font-size: 13px;
            color: var(--sivte-body);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Main Shell */
        .confirm-container {
            max-width: 820px;
            width: 100%;
            margin: 48px auto;
            padding: 0 20px;
            flex: 1;
        }

        .main-card {
            background: #FFFFFF;
            border: 1px solid var(--sivte-border);
            border-radius: 20px;
            padding: 44px 40px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #ECFDF5;
            color: #065F46;
            border: 1px solid #A7F3D0;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 20px;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            background: #10B981;
            border-radius: 50%;
            box-shadow: 0 0 8px #10B981;
        }

        /* Hero Headline */
        .hero-title {
            font-family: var(--font-heading);
            font-size: 34px;
            font-weight: 800;
            line-height: 1.2;
            letter-spacing: -0.03em;
            color: #0A0A0A;
            margin-bottom: 12px;
        }

        .hero-desc {
            font-size: 15px;
            color: var(--sivte-body);
            line-height: 1.65;
            max-width: 680px;
            margin-bottom: 36px;
        }

        /* Medium Selection Section */
        .section-label {
            font-family: var(--font-heading);
            font-size: 16px;
            font-weight: 700;
            color: #0A0A0A;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-hint {
            font-size: 13px;
            color: var(--sivte-body);
            margin-bottom: 20px;
        }

        .medium-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 32px;
        }

        .medium-card {
            border: 2px solid var(--sivte-border);
            border-radius: 14px;
            padding: 24px 20px;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            background: #FFFFFF;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .medium-card:hover {
            border-color: #FD5228;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(253, 82, 40, 0.08);
        }

        .medium-card.selected {
            border-color: #FD5228;
            background: #FFF9F7;
        }

        .medium-card-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .medium-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .medium-icon.whatsapp {
            background: #DCFCE7;
            color: #16A34A;
        }

        .medium-icon.call {
            background: #EFF6FF;
            color: #2563EB;
        }

        .radio-circle {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid #CBD5E1;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .medium-card.selected .radio-circle {
            border-color: #FD5228;
            background: #FD5228;
        }

        .medium-card.selected .radio-circle::after {
            content: '';
            width: 6px;
            height: 6px;
            background: #FFFFFF;
            border-radius: 50%;
        }

        .medium-title {
            font-family: var(--font-heading);
            font-size: 17px;
            font-weight: 700;
            color: #0A0A0A;
            margin-bottom: 6px;
        }

        .medium-desc {
            font-size: 13px;
            color: var(--sivte-body);
            line-height: 1.5;
            margin-bottom: 16px;
        }

        .medium-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            margin-top: auto;
        }

        .medium-badge.fast {
            background: #DCFCE7;
            color: #15803D;
        }

        .medium-badge.standard {
            background: #EFF6FF;
            color: #1D4ED8;
        }

        /* Action Drawer for Selected Medium */
        .action-box {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 32px;
            transition: all 0.2s ease;
        }

        .btn-whatsapp-cta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #25D366;
            color: #FFFFFF;
            text-decoration: none;
            font-weight: 700;
            font-size: 15px;
            padding: 14px 26px;
            border-radius: 10px;
            transition: background 0.2s;
            box-shadow: 0 2px 8px rgba(37, 211, 102, 0.25);
        }

        .btn-whatsapp-cta:hover {
            background: #1EBE5D;
            color: #FFFFFF;
        }

        .btn-call-confirm {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #0A0A0A;
            color: #FFFFFF;
            border: none;
            font-weight: 700;
            font-size: 14px;
            padding: 13px 24px;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-call-confirm:hover {
            background: #262626;
        }

        .phone-confirm-row {
            display: flex;
            gap: 12px;
            align-items: center;
            max-width: 480px;
            margin-top: 12px;
        }

        .phone-input {
            flex: 1;
            padding: 12px 14px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
        }

        /* Order Details Card */
        .order-summary-box {
            background: #0A0A0A;
            color: #FFFFFF;
            border-radius: 14px;
            padding: 24px 28px;
            margin-bottom: 32px;
        }

        .order-summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #262626;
            padding-bottom: 14px;
            margin-bottom: 16px;
        }

        .order-id-tag {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            color: #FD7958;
            font-weight: 700;
        }

        .order-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .order-col-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #94A3B8;
            margin-bottom: 4px;
        }

        .order-col-val {
            font-size: 14px;
            font-weight: 600;
            color: #FFFFFF;
        }

        /* Bottom Buttons */
        .bottom-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--sivte-border);
            padding-top: 24px;
        }

        .btn-portal-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #FD5228;
            color: #FFFFFF;
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
            padding: 13px 26px;
            border-radius: 10px;
            transition: background 0.2s;
        }

        .btn-portal-primary:hover {
            background: #E44219;
            color: #FFFFFF;
        }

        @media (max-width: 768px) {
            .medium-grid {
                grid-template-columns: 1fr;
            }
            .order-grid {
                grid-template-columns: 1fr;
            }
            .bottom-actions {
                flex-direction: column;
                gap: 16px;
            }
            .main-card {
                padding: 28px 20px;
            }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="confirm-header">
        <a href="index.jsp" class="brand-link">
            <img src="images/logo.png" alt="WebEase Logo">
            <span>WebEase<span style="color: var(--sivte-orange);">.</span></span>
        </a>

        <div class="user-tag">
            <span>Verified Customer: <strong>${sessionScope.customerUser.name}</strong></span>
            &bull;
            <a href="customer-auth?action=logout" style="color: #64748B; text-decoration: none;">Sign Out</a>
        </div>
    </header>

    <!-- Main Content -->
    <div class="confirm-container">
        <div class="main-card">

            <!-- Green Status Badge -->
            <div class="status-badge">
                <span class="status-dot"></span>
                <span>Order Verified &bull; Reference #<%= orderId %></span>
            </div>

            <!-- Hero Headline -->
            <h1 class="hero-title">Our WebEase Experts Will Reach You Shortly.</h1>
            <p class="hero-desc">
                Your managed website order for <strong><%= (order != null && order.getBusinessName() != null) ? order.getBusinessName() : customer.getBusinessName() %></strong> has been received by our Mumbai technical desk. 
                Before our engineers start domain and hosting setup, please select how you would prefer our experts to connect with you:
            </p>

            <!-- Medium Selector Cards -->
            <div class="section-label">
                <span>Select Your Preferred Communication Medium</span>
            </div>
            <p class="section-hint">Choose how you would like our engineering leads (Ayush, Rishi, or Yadnesh) to connect with you:</p>

            <div class="medium-grid">
                
                <!-- Option 1: WhatsApp Priority Chat -->
                <div class="medium-card selected" id="cardChat" onclick="selectMedium('chat')">
                    <div class="medium-card-header">
                        <div class="medium-icon whatsapp">ðŸ’¬</div>
                        <div class="radio-circle"></div>
                    </div>
                    <div>
                        <div class="medium-title">WhatsApp Live Chat</div>
                        <div class="medium-desc">
                            Direct message with our engineering team on WhatsApp. Share requirements, logos, or ask questions instantly.
                        </div>
                    </div>
                    <span class="medium-badge fast">âš¡ Fastest (Under 15 mins)</span>
                </div>

                <!-- Option 2: Direct Phone Call -->
                <div class="medium-card" id="cardCall" onclick="selectMedium('call')">
                    <div class="medium-card-header">
                        <div class="medium-icon call">ðŸ“ž</div>
                        <div class="radio-circle"></div>
                    </div>
                    <div>
                        <div class="medium-title">Direct Phone Call</div>
                        <div class="medium-desc">
                            Receive a direct phone call from our lead infrastructure engineer to discuss your website scope over voice.
                        </div>
                    </div>
                    <span class="medium-badge standard">Within 30â€“60 mins</span>
                </div>

            </div>

            <!-- Dynamic Action Box based on selection -->
            <div class="action-box" id="actionChat">
                <div style="font-weight: 700; font-size: 15px; margin-bottom: 6px; color: #0A0A0A;">
                    ðŸ’¬ Instant Connection via WhatsApp Desk
                </div>
                <p style="font-size: 13px; color: var(--sivte-body); margin-bottom: 16px;">
                    Click below to open a pre-filled chat with our support team at <strong>+91 93240 18043</strong>. You will be connected directly with an engineer.
                </p>
                
                <%
                    String waText = "Hi WebEase Team! I just ordered the " + planName + " plan for " 
                                  + ((order != null && order.getBusinessName() != null) ? order.getBusinessName() : customer.getBusinessName()) 
                                  + " (Order #" + orderId + "). Let's connect for website setup!";
                    String waUrl = "https://api.whatsapp.com/send?phone=919324018043&text=" + java.net.URLEncoder.encode(waText, "UTF-8");
                %>
                
                <a href="<%= waUrl %>" target="_blank" class="btn-whatsapp-cta">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M.057 24l1.687-6.163c-1.041-1.804-1.588-3.849-1.587-5.946.003-6.556 5.338-11.891 11.893-11.891 3.181.001 6.167 1.24 8.413 3.488 2.245 2.248 3.481 5.236 3.48 8.414-.003 6.557-5.338 11.892-11.893 11.892-1.99-.001-3.951-.5-5.688-1.448l-6.305 1.654zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884-.001 2.225.651 3.891 1.746 5.634l-.999 3.648 3.742-.981zm11.387-5.464c-.074-.124-.272-.198-.57-.347-.297-.149-1.758-.868-2.031-.967-.272-.099-.47-.149-.669.149-.198.297-.768.967-.941 1.165-.173.198-.347.223-.644.074-.297-.149-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.297-.347.446-.521.151-.172.2-.296.3-.495.099-.198.05-.372-.025-.521-.075-.148-.669-1.611-.916-2.206-.242-.579-.487-.501-.669-.51l-.57-.01c-.198 0-.52.074-.792.372s-1.04 1.016-1.04 2.479 1.065 2.876 1.213 3.074c.149.198 2.095 3.2 5.076 4.487.709.306 1.263.489 1.694.626.712.226 1.36.194 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.695.248-1.29.173-1.414z"/>
                    </svg>
                    <span>Start WhatsApp Chat Now (+91 93240 18043) &rarr;</span>
                </a>
            </div>

            <div class="action-box" id="actionCall" style="display: none;">
                <div style="font-weight: 700; font-size: 15px; margin-bottom: 6px; color: #0A0A0A;">
                    ðŸ“ž Direct Voice Call Request
                </div>
                <p style="font-size: 13px; color: var(--sivte-body);">
                    Please confirm the phone number our engineer should call. We will connect with you within 30 to 60 minutes.
                </p>
                <div class="phone-confirm-row">
                    <input type="tel" id="callPhoneInput" class="phone-input" value="<%= (order != null && order.getPhone() != null && !order.getPhone().isEmpty()) ? order.getPhone() : (customer.getPhone() != null ? customer.getPhone() : "") %>" placeholder="Enter 10-digit mobile number">
                    <button type="button" class="btn-call-confirm" onclick="confirmCallRequest()">
                        <span>Confirm Call</span>
                    </button>
                </div>
                <div id="callFeedback" style="display: none; margin-top: 12px; font-size: 13px; font-weight: 600; color: #059669;">
                    âœ“ Call request confirmed! Our engineer will call you shortly.
                </div>
            </div>

            <!-- Order Details Box -->
            <div class="order-summary-box">
                <div class="order-summary-header">
                    <div>
                        <span style="font-size: 11px; text-transform: uppercase; color: #94A3B8; display: block; margin-bottom: 2px;">Order Summary</span>
                        <strong style="font-size: 16px; color: #FFFFFF;"><%= planName %></strong>
                    </div>
                    <span class="order-id-tag">#<%= orderId %></span>
                </div>

                <div class="order-grid">
                    <div>
                        <div class="order-col-label">Business Name</div>
                        <div class="order-col-val"><%= (order != null && order.getBusinessName() != null) ? order.getBusinessName() : customer.getBusinessName() %></div>
                    </div>
                    <div>
                        <div class="order-col-label">Build / Setup</div>
                        <div class="order-col-val">â‚¹<%= (order != null) ? (int)order.getEstimatedBuildPrice() : 5000 %> (One-time)</div>
                    </div>
                    <div>
                        <div class="order-col-label">Monthly Retainer</div>
                        <div class="order-col-val">â‚¹<%= (order != null) ? (int)order.getEstimatedRetainerPrice() : 3000 %>/mo</div>
                    </div>
                </div>
            </div>

            <!-- Bottom Navigation -->
            <div class="bottom-actions">
                <div>
                    <span style="font-size: 13px; color: var(--sivte-body);">Need immediate help?</span>
                    <a href="tel:+919324018043" style="color: #0A0A0A; font-weight: 700; margin-left: 4px; text-decoration: none;">+91 93240 18043</a>
                </div>

                <a href="customer-portal" class="btn-portal-primary">
                    <span>Go to Client Portal &amp; Dashboard</span>
                    <span>&rarr;</span>
                </a>
            </div>

        </div>
    </div>

    <script>
        function selectMedium(medium) {
            var cardChat = document.getElementById('cardChat');
            var cardCall = document.getElementById('cardCall');
            var actionChat = document.getElementById('actionChat');
            var actionCall = document.getElementById('actionCall');

            if (medium === 'chat') {
                cardChat.classList.add('selected');
                cardCall.classList.remove('selected');
                actionChat.style.display = 'block';
                actionCall.style.display = 'none';
            } else {
                cardCall.classList.add('selected');
                cardChat.classList.remove('selected');
                actionChat.style.display = 'none';
                actionCall.style.display = 'block';
            }
        }

        function confirmCallRequest() {
            var phone = document.getElementById('callPhoneInput').value;
            if (!phone || phone.trim().length < 10) {
                alert('Please enter a valid 10-digit mobile number for our engineer to call.');
                return;
            }
            var feedback = document.getElementById('callFeedback');
            feedback.innerHTML = 'âœ“ Call scheduled: An engineer will call you on +91 ' + phone.trim() + ' within 30â€“60 minutes.';
            feedback.style.display = 'block';
        }
    </script>

</body>
</html>