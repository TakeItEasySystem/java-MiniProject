<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    com.webease.model.Customer logged = (com.webease.model.Customer) session.getAttribute("customerUser");
    if (logged != null && request.getParameter("loggedOut") == null && request.getParameter("accountDeleted") == null) {
        if (!logged.isProfileComplete()) {
            response.sendRedirect("complete-profile.jsp");
        } else {
            response.sendRedirect("customer-portal");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome back! | WebEase</title>
    <link rel="icon" type="image/png" href="images/logo.png">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Firebase SDK (v10 Compat) -->
    <script src="https://www.gstatic.com/firebasejs/10.9.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/10.9.0/firebase-auth-compat.js"></script>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #FFFFFF;
            color: #0F172A;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 24px;
            -webkit-font-smoothing: antialiased;
        }

        .auth-container {
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
            text-align: center;
        }

        /* Top Brand Logo */
        .brand-logo-wrap {
            margin-bottom: 28px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .brand-logo-wrap img {
            height: 38px;
            width: auto;
            border-radius: 8px;
        }

        .brand-logo-wrap span {
            font-size: 20px;
            font-weight: 800;
            color: #0F172A;
            letter-spacing: -0.03em;
        }

        .brand-logo-wrap span .dot {
            color: #FD5228;
        }

        /* Headline matching reference screenshot */
        .page-title {
            font-size: 38px;
            font-weight: 800;
            color: #000000;
            letter-spacing: -0.03em;
            line-height: 1.15;
            margin-bottom: 8px;
        }

        .page-subtitle {
            font-size: 14px;
            color: #64748B;
            margin-bottom: 36px;
            line-height: 1.5;
        }

        /* Alerts */
        .alert-box {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 24px;
            text-align: left;
            line-height: 1.5;
        }

        .alert-info {
            background: #EFF6FF;
            border: 1px solid #BFDBFE;
            color: #1E40AF;
        }

        .alert-success {
            background: #ECFDF5;
            border: 1px solid #A7F3D0;
            color: #065F46;
        }

        .alert-error {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: #991B1B;
        }

        /* Dedicated "Continue with Google" Button (Matching user reference) */
        .btn-google-action {
            width: 100%;
            height: 52px;
            background: #FFFFFF;
            border: 1.5px solid #E2E8F0;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            font-size: 15px;
            font-weight: 600;
            color: #1E293B;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
            user-select: none;
            outline: none;
        }

        .btn-google-action:hover {
            background: #F8FAFC;
            border-color: #CBD5E1;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            transform: translateY(-1px);
        }

        .btn-google-action:active {
            background: #F1F5F9;
            transform: translateY(0);
        }

        .google-icon-svg {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
        }

        /* Realtime status banner */
        #authStatus {
            display: none;
            margin-top: 20px;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            text-align: center;
        }

        .spinner-dot {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid #FD5228;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            vertical-align: middle;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .auth-footer {
            margin-top: 36px;
            font-size: 12px;
            color: #94A3B8;
            line-height: 1.6;
        }

        .auth-footer a {
            color: #64748B;
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            color: #0F172A;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="auth-container">

        <!-- WebEase Logo -->
        <a href="index.jsp" class="brand-logo-wrap">
            <img src="images/logo.png" alt="WebEase Logo">
            <span>WebEase<span class="dot">.</span></span>
        </a>

        <!-- Big Bold Title matching reference screenshot -->
        <h1 class="page-title">Welcome back!</h1>
        <p class="page-subtitle">Sign in or register with your Google account</p>

        <!-- Context Alerts -->
        <c:if test="${not empty param.orderPlan}">
            <div class="alert-box alert-info">
                <strong>Setting up ${param.orderPlan} Plan</strong><br>
                Authenticate with Google to finalize your client portal.
            </div>
        </c:if>

        <c:if test="${not empty param.loggedOut}">
            <div class="alert-box alert-success">
                âœ“ You have been signed out successfully.
            </div>
        </c:if>

        <c:if test="${not empty param.accountDeleted}">
            <div class="alert-box alert-success">
                âœ“ Your account has been removed.
            </div>
        </c:if>

        <!-- Single Google Button (Styled exactly like reference screenshot) -->
        <button type="button" id="btnContinueGoogle" class="btn-google-action" onclick="handleFirebaseGoogleSignIn()">
            <svg class="google-icon-svg" viewBox="0 0 18 18">
                <path fill="#4285F4" d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844c-.209 1.125-.843 2.078-1.796 2.717v2.258h2.908c1.702-1.567 2.684-3.874 2.684-6.616z"/>
                <path fill="#34A853" d="M9 18c2.43 0 4.467-.806 5.956-2.184l-2.908-2.258c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 0 0 9 18z"/>
                <path fill="#FBBC05" d="M3.964 10.707c-.18-.54-.282-1.117-.282-1.707s.102-1.167.282-1.707V4.961H.957A8.996 8.996 0 0 0 0 9c0 1.452.348 2.827.957 4.039l3.007-2.332z"/>
                <path fill="#EA4335" d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 0 0 .957 4.961L3.964 7.293C4.672 5.166 6.656 3.58 9 3.58z"/>
            </svg>
            <span>Continue with Google</span>
        </button>

        <!-- Status Notification -->
        <div id="authStatus"></div>

        <!-- Subtle Footer -->
        <div class="auth-footer">
            <div>WebEase Managed Infrastructure &bull; Firebase Google Authentication</div>
            <div style="margin-top: 6px;">
                <a href="index.jsp">&larr; Back to Home</a> &bull; <a href="admin-login.jsp">Operations Portal</a>
            </div>
        </div>

    </div>

    <!-- Firebase Authentication Client Script -->
    <script>
        // Official WebEase Firebase Configuration
        var firebaseConfig = {
            apiKey: "AIzaSyBqRQwuzonwbdxqfxxn2e8iA8YlkOGMPT8",
            authDomain: "webease-b2307.firebaseapp.com",
            projectId: "webease-b2307",
            storageBucket: "webease-b2307.firebasestorage.app",
            messagingSenderId: "730328556134",
            appId: "1:730328556134:web:4c0cddb6515b25b44943a7"
        };

        // Initialize Firebase
        if (!firebase.apps.length) {
            firebase.initializeApp(firebaseConfig);
        }

        function showStatus(html, type) {
            var el = document.getElementById("authStatus");
            if (!el) return;
            el.className = "alert-box alert-" + (type === "error" ? "error" : (type === "success" ? "success" : "info"));
            el.innerHTML = html;
            el.style.display = "block";
        }

        // Trigger Google Popup using Firebase Authentication
        function handleFirebaseGoogleSignIn() {
            showStatus("<span class='spinner-dot'></span> Opening Google Account Chooser...", "info");

            var provider = new firebase.auth.GoogleAuthProvider();
            
            // Force Google Account Chooser to show ALL accounts on browser
            provider.setCustomParameters({
                prompt: 'select_account'
            });

            firebase.auth().signInWithPopup(provider)
                .then(function(result) {
                    var user = result.user;
                    showStatus("<span class='spinner-dot'></span> Google account selected: " + user.email + ". Verifying with WebEase...", "info");

                    // Extract JWT ID token from Firebase user
                    return user.getIdToken().then(function(idToken) {
                        sendFirebaseTokenToBackend(idToken, user.email, user.displayName);
                    });
                })
                .catch(function(error) {
                    console.error("Firebase Auth Error:", error);
                    if (error.code === "auth/popup-closed-by-user") {
                        showStatus("Sign in was closed before finishing. Please click 'Continue with Google' to try again.", "info");
                    } else if (error.code === "auth/unauthorized-domain") {
                        var currentHost = window.location.hostname || "localhost";
                        showStatus("Firebase Domain Error: Please add <code>" + currentHost + "</code> to <strong>Authorized Domains</strong> in Firebase Console &gt; Authentication &gt; Settings &gt; Authorized domains.", "error");
                    } else {
                        showStatus(error.message || "Google sign in failed.", "error");
                    }
                });
        }

        // Send token to WebEase Tomcat backend servlet
        function sendFirebaseTokenToBackend(credential, email, name) {
            showStatus("<span class='spinner-dot'></span> Authenticating session...", "info");

            var params = new URLSearchParams();
            params.append("action", "googleAuth");
            params.append("credential", credential);
            params.append("email", email || "");
            params.append("name", name || "");
            params.append("orderPlan", "${param.orderPlan}");
            params.append("build", "${param.build}");
            params.append("retainer", "${param.retainer}");

            fetch("customer-auth", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    showStatus("<strong>âœ“ Verified!</strong> " + data.message, "success");
                    setTimeout(function() {
                        window.location.href = data.redirectUrl || "complete-profile.jsp";
                    }, 500);
                } else {
                    showStatus(data.message || "Authentication verification failed.", "error");
                }
            })
            .catch(function(err) {
                showStatus("Network error connecting to Tomcat authentication servlet.", "error");
            });
        }
    </script>

</body>
</html>