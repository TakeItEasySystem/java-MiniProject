<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    com.webease.model.Customer loggedCustomer = (com.webease.model.Customer) session.getAttribute("customerUser");
    if (loggedCustomer == null) {
        response.sendRedirect("customer-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Complete Your Business Profile</title>
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <link rel="icon" type="image/png" href="images/logo.png">
    <style>
        .profile-container {
            min-height: 100vh;
            background: #F8FAFC;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            font-family: var(--font-main);
        }
        .profile-card {
            width: 100%;
            max-width: 620px;
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 40px 36px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }
        .step-stepper {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            padding-bottom: 20px;
            border-bottom: 1px solid #E2E8F0;
            gap: 12px;
        }
        .step-bubble {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 700;
        }
        .step-dot {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 800;
        }
        .step-done .step-dot {
            background: #ECFDF5;
            color: #059669;
            border: 1px solid #A7F3D0;
        }
        .step-done {
            color: #059669;
        }
        .step-active .step-dot {
            background: var(--accent-rust);
            color: #FFFFFF;
        }
        .step-active {
            color: #0A0A0A;
        }
        .step-pending .step-dot {
            background: #F1F5F9;
            color: #94A3B8;
        }
        .step-pending {
            color: #94A3B8;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #334155;
            margin-bottom: 6px;
        }
        .form-control {
            width: 100%;
            padding: 12px 14px;
            font-size: 14px;
            border: 1px solid var(--border);
            border-radius: 6px;
            outline: none;
            box-sizing: border-box;
            background: #FFFFFF;
            transition: border-color 0.15s ease;
        }
        .form-control:focus {
            border-color: #0A0A0A;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media (max-width: 560px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        .hint-text {
            font-size: 11px;
            color: #64748B;
            margin-top: 4px;
            display: block;
            line-height: 1.4;
        }
        .alert-error {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: #991B1B;
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            line-height: 1.5;
        }
    </style>
</head>
<body>

    <div class="profile-container">
        <!-- Brand Header -->
        <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 24px;">
            <a href="index.jsp" style="display: inline-flex; align-items: center;">
                <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img" style="height: 44px;">
            </a>
            <span style="font-weight: 700; font-size: 16px; color: #475569; border-left: 2px solid #CBD5E1; padding-left: 12px;">Business Setup Hub</span>
        </div>

        <div class="profile-card">
            <!-- Multi-Step Stepper -->
            <div class="step-stepper">
                <div class="step-bubble step-done">
                    <div class="step-dot">✓</div>
                    <span>1. Sign In</span>
                </div>
                <div style="flex: 1; height: 2px; background: #E2E8F0; margin: 0 4px;"></div>
                <div class="step-bubble step-active">
                    <div class="step-dot">2</div>
                    <span>2. Business Profile</span>
                </div>
                <div style="flex: 1; height: 2px; background: #E2E8F0; margin: 0 4px;"></div>
                <div class="step-bubble step-pending">
                    <div class="step-dot">3</div>
                    <span>3. Order &amp; Launch</span>
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; flex-wrap: wrap; gap: 10px;">
                <div>
                    <h1 style="font-size: 22px; font-weight: 800; color: #0A0A0A; margin: 0 0 6px 0;">
                        Complete Your Business Profile
                    </h1>
                    <p style="font-size: 13px; color: #64748B; margin: 0; line-height: 1.5;">
                        Logged in as: <strong>+91 ${sessionScope.customerUser.phone}</strong> &bull; <strong>${sessionScope.customerUser.email}</strong>
                    </p>
                </div>
                <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; background: #FFF5F2; color: var(--accent-rust); padding: 4px 10px; border-radius: 4px;">
                    Required to Order
                </span>
            </div>

            <c:if test="${not empty param.orderPlan}">
                <div style="background: #FFF7ED; border: 1px solid #FED7AA; border-radius: 6px; padding: 12px 14px; margin-bottom: 20px; font-size: 13px; color: #9A3412; line-height: 1.5;">
                    <strong>Pending Order:</strong> Complete your profile below to immediately start your <strong>${param.orderPlan}</strong> website onboarding.
                </div>
            </c:if>

            <c:if test="${not empty profileError}">
                <div class="alert-error">
                    <strong>Error:</strong> ${profileError}
                </div>
            </c:if>

            <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 6px; padding: 12px 14px; margin-bottom: 22px; font-size: 12px; color: #475569; line-height: 1.5;">
                ℹ️ <strong>Why is this required?</strong> To prevent joke and fraudulent inquiries from overloading our developer queue, genuine business details are mandatory before websites can be ordered and deployed.
            </div>

            <form action="customer-auth" method="POST" onsubmit="return validateProfileForm(this)">
                <input type="hidden" name="action" value="updateProfile">
                <input type="hidden" name="orderPlan" value="${param.orderPlan}">
                <input type="hidden" name="build" value="${param.build}">
                <input type="hidden" name="retainer" value="${param.retainer}">

                <div class="form-row">
                    <div class="form-group">
                        <label for="profBusinessName">Registered Business / Brand Name *</label>
                        <input type="text" id="profBusinessName" name="businessName" class="form-control" placeholder="e.g. Spice Route Bistro" value="${sessionScope.customerUser.businessName ne 'Pending Business Setup' ? sessionScope.customerUser.businessName : ''}" required autofocus>
                    </div>
                    <div class="form-group">
                        <label for="profOwnerName">Owner / Manager Full Legal Name *</label>
                        <input type="text" id="profOwnerName" name="name" class="form-control" placeholder="e.g. Rahul Sharma" value="${not sessionScope.customerUser.name.startsWith('Partner') ? sessionScope.customerUser.name : ''}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="profCategory">Business Vertical / Category *</label>
                        <select id="profCategory" name="category" class="form-control" required>
                            <option value="">Select Business Category</option>
                            <option value="Restaurants & Cafes" ${sessionScope.customerUser.category eq 'Restaurants & Cafes' ? 'selected' : ''}>Restaurants &amp; Cafes</option>
                            <option value="Salons & Beauty Care" ${sessionScope.customerUser.category eq 'Salons & Beauty Care' ? 'selected' : ''}>Salons &amp; Beauty Care</option>
                            <option value="Clinics & Healthcare" ${sessionScope.customerUser.category eq 'Clinics & Healthcare' ? 'selected' : ''}>Clinics &amp; Healthcare</option>
                            <option value="Gyms & Fitness Centers" ${sessionScope.customerUser.category eq 'Gyms & Fitness Centers' ? 'selected' : ''}>Gyms &amp; Fitness Centers</option>
                            <option value="Coaching Classes & Tutors" ${sessionScope.customerUser.category eq 'Coaching Classes & Tutors' ? 'selected' : ''}>Coaching Classes &amp; Tutors</option>
                            <option value="Local Services & Contractors" ${sessionScope.customerUser.category eq 'Local Services & Contractors' ? 'selected' : ''}>Local Services &amp; Contractors</option>
                            <option value="Retail & Showrooms" ${sessionScope.customerUser.category eq 'Retail & Showrooms' ? 'selected' : ''}>Retail &amp; Showrooms</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="profCity">Business Operating City / Area *</label>
                        <input type="text" id="profCity" name="city" class="form-control" placeholder="e.g. Kandivali East, Mumbai" value="${sessionScope.customerUser.city}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="profProof">Business Verification / Identity Proof *</label>
                    <input type="text" id="profProof" name="businessProof" class="form-control" placeholder="GSTIN / MSME Udyam ID / Google Maps Link / Business UPI ID" value="${sessionScope.customerUser.businessProof}" required>
                    <span class="hint-text">Enter your GSTIN, Udyam registration ID, Google Business Profile URL, or registered merchant UPI ID.</span>
                </div>

                <div style="background: #F1F5F9; border: 1px solid #CBD5E1; border-radius: 6px; padding: 14px; margin-bottom: 24px;">
                    <label style="display: flex; gap: 10px; align-items: flex-start; cursor: pointer; text-transform: none; font-size: 13px; color: #1E293B; font-weight: normal; margin: 0;">
                        <input type="checkbox" id="confirmAuthenticity" name="confirmAuthenticity" value="true" required style="margin-top: 3px;">
                        <span>
                            <strong>Authenticity Declaration:</strong> I confirm that I am the authorized owner or manager of this business and this profile is submitted for genuine managed website services.
                        </span>
                    </label>
                </div>

                <button type="submit" class="btn-sivte-orange" style="width: 100%; justify-content: center; padding: 12px; font-size: 14px;">
                    Save Profile &amp; Unlock Website Ordering →
                </button>
            </form>

            <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                <a href="customer-auth?action=logout" style="font-size: 12px; color: #EF4444; text-decoration: underline;">
                    Sign Out &bull; Log into different account
                </a>
                <a href="index.jsp" style="font-size: 12px; color: var(--muted); text-decoration: none;">
                    ← Return to Home
                </a>
            </div>
        </div>
    </div>

    <script>
        function validateProfileForm(form) {
            var biz = form.businessName.value.trim();
            if (biz.length < 2) {
                alert("Please enter a valid registered business or brand name.");
                form.businessName.focus();
                return false;
            }

            var name = form.name.value.trim();
            if (name.length < 2) {
                alert("Please enter the owner or manager's full legal name.");
                form.name.focus();
                return false;
            }

            if (!form.category.value) {
                alert("Please select your business vertical / category.");
                form.category.focus();
                return false;
            }

            if (form.city.value.trim().length < 2) {
                alert("Please enter your business city / operating location.");
                form.city.focus();
                return false;
            }

            if (form.businessProof.value.trim().length < 3) {
                alert("Please provide genuine business verification details (GSTIN, MSME Udyam, Google Profile, or UPI).");
                form.businessProof.focus();
                return false;
            }

            if (!form.confirmAuthenticity.checked) {
                alert("Please check the authenticity declaration box before proceeding.");
                return false;
            }

            return true;
        }
    </script>

</body>
</html>
