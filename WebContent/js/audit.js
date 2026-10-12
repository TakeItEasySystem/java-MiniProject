/**
 * Unit IV: AJAX, Fetch API, and Working with JSON data
 * Asynchronously sends audit diagnostic requests to AuditServlet
 * and updates the DOM without reloading the webpage.
 */

document.addEventListener("DOMContentLoaded", function () {
    var auditForm = document.getElementById("websiteAuditForm");
    if (!auditForm) return;

    auditForm.addEventListener("submit", function (e) {
        e.preventDefault();

        // 1. Client-Side Validation (Experiment 08)
        if (!validateAuditForm()) {
            return;
        }

        var btn = document.getElementById("auditSubmitBtn");
        var scanStatus = document.getElementById("scanStatus");
        var resultsBox = document.getElementById("auditResults");

        var websiteUrl = document.getElementById("websiteUrl").value;
        var businessName = document.getElementById("businessName").value;
        var email = document.getElementById("ownerEmail").value;
        var phone = document.getElementById("ownerPhone").value;
        var businessType = document.getElementById("businessType").value;

        // UI State: Scanning
        btn.disabled = true;
        btn.innerText = "Analyzing Website...";
        scanStatus.style.display = "block";
        resultsBox.style.display = "none";
        scanStatus.innerHTML = "<div class='pulse-dot' style='display:inline-block; margin-right:8px;'></div> Scanning domain headers, SSL certificate, and response latency...";

        // Form-encoded body for Servlet doPost
        var params = new URLSearchParams();
        params.append("websiteUrl", websiteUrl);
        params.append("businessName", businessName);
        params.append("email", email);
        params.append("phone", phone);
        params.append("businessType", businessType);

        // Unit IV: Fetch API & JSON Handling
        fetch("audit", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: params.toString()
        })
        .then(function (response) {
            if (!response.ok) {
                throw new Error("HTTP error " + response.status);
            }
            return response.json();
        })
        .then(function (data) {
            scanStatus.style.display = "none";
            btn.disabled = false;
            btn.innerText = "Run Free Health Scan";

            if (data.success) {
                resultsBox.style.display = "block";

                document.getElementById("resScore").innerText = data.healthScore + "/100";
                document.getElementById("resSpeed").innerText = data.speedMs + " ms";
                document.getElementById("resSsl").innerHTML = data.sslValid ? 
                    "<span style='color: #10B981; font-weight:700;'>✓ Active</span>" : 
                    "<span style='color: #EF4444; font-weight:700;'>✗ Missing / Insecure</span>";
                document.getElementById("resMobile").innerHTML = data.mobileOptimized ? 
                    "<span style='color: #10B981; font-weight:700;'>✓ Optimized</span>" : 
                    "<span style='color: #F59E0B; font-weight:700;'>⚠ Needs Viewport Fixes</span>";
                document.getElementById("resIssues").innerText = data.issues;
            }
        })
        .catch(function (error) {
            scanStatus.style.display = "none";
            btn.disabled = false;
            btn.innerText = "Run Free Health Scan";
            alert("Error running diagnostic check: " + error.message);
        });
    });
});
