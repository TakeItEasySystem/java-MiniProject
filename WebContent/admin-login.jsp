<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebEase | Operations Sign In</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" type="image/png" href="images/logo.png">
    <style>
        .admin-login-body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #FAFAFA;
            padding: 24px;
            font-family: var(--font-main);
        }
        .admin-login-card {
            width: 100%;
            max-width: 420px;
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 36px 32px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
        }
        .admin-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--accent-rust);
            background: #FFF5F2;
            padding: 4px 10px;
            border-radius: 4px;
            margin-bottom: 16px;
        }
        .login-input {
            width: 100%;
            padding: 12px 14px;
            font-size: 14px;
            border: 1px solid var(--border);
            border-radius: 6px;
            margin-top: 6px;
            margin-bottom: 16px;
            outline: none;
            transition: border-color 0.15s ease;
            box-sizing: border-box;
            background: #FFF;
        }
        .login-input:focus {
            border-color: #0A0A0A;
        }
        .error-alert {
            background: #FEF2F2;
            border: 1px solid #FCA5A5;
            color: #B91C1C;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="admin-login-body">

    <div class="admin-login-card">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 20px;">
            <a href="index.jsp" style="display: inline-flex; align-items: center;">
                <img src="images/logo.png" alt="WebEase Logo" class="brand-logo-img" style="height: 36px;">
            </a>
            <span style="font-weight: 700; font-size: 14px; color: #475569; border-left: 2px solid #CBD5E1; padding-left: 10px;">Operations</span>
        </div>

        <div class="admin-badge">Restricted Internal Portal</div>

        <h1 style="font-size: 24px; font-weight: 800; margin-bottom: 6px; color: #0A0A0A;">
            Founder Sign In
        </h1>
        <p style="font-size: 13px; color: var(--muted); margin-bottom: 24px; line-height: 1.5;">
            Authorized access only for WebEase team to monitor client fleet uptime, manage leads, and review website build orders.
        </p>

        <c:if test="${not empty errorMessage}">
            <div class="error-alert">
                <strong>Access Denied:</strong> ${errorMessage}
            </div>
        </c:if>

        <form action="admin-auth" method="POST">
            <div>
                <label for="username" style="font-size: 12px; font-weight: 700; text-transform: uppercase; color: #4B5563;">
                    Username
                </label>
                <input type="text" id="username" name="username" class="login-input" placeholder="admin" required autofocus>
            </div>

            <div>
                <label for="password" style="font-size: 12px; font-weight: 700; text-transform: uppercase; color: #4B5563;">
                    Password
                </label>
                <input type="password" id="password" name="password" class="login-input" placeholder="••••••••••••" required>
            </div>

            <button type="submit" class="btn-sivte-orange" style="width: 100%; justify-content: center; padding: 12px; font-size: 14px; margin-top: 8px;">
                Sign In to Operations Console →
            </button>
        </form>

        <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
            <a href="index.jsp" style="font-size: 12px; color: var(--muted); text-decoration: none;">
                ← Public Website
            </a>
            <span style="font-size: 11px; color: #9CA3AF;">WebEase v1.0</span>
        </div>
    </div>

</body>
</html>
