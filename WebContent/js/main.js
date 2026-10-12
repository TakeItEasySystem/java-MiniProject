/**
 * WebEase - Interactive Frontend Experience (Unit IV & Modern WaaS)
 * Features:
 * 1. Interactive Vertical Industry Previewer (Café, Salon, Clinic, Gym, Coaching, Services)
 * 2. Live WhatsApp Maintenance Simulator (Send request -> Live update)
 * 3. Dynamic Dynamic Pricing Engine connected to PricingServlet
 * 4. Single-Page App View Navigation
 */

document.addEventListener("DOMContentLoaded", function () {
    initPricingCalculator();
    initFaqAccordion();
    initOrderFormHandler();
    initProjectTracker();
    initTalkToTeamHandlers();
});

// -----------------------------------------------------------------------------
// 1. Direct Talk to Team (WhatsApp or Phone Call) Handlers
// -----------------------------------------------------------------------------
function initTalkToTeamHandlers() {
    window.openTalkToTeamModal = function () {
        openModal("talkToTeamModal");
    };

    window.closeTalkToTeamModal = function () {
        closeModal("talkToTeamModal");
    };
}

// -----------------------------------------------------------------------------
// 2. Customer Portal Live Domain Telemetry Lookup Tool
// -----------------------------------------------------------------------------
window.handlePortalDomainLookup = function (e) {
    if (e) e.preventDefault();
    const domainInput = document.getElementById("portalLookupDomain");
    const resultBox = document.getElementById("portalLookupResult");
    if (!domainInput || !resultBox) return;

    const domain = domainInput.value.trim();
    if (!domain) return;

    const clean = domain.toLowerCase().replace(/^https?:\/\//, "").replace(/^www\./, "").split("/")[0].trim();
    if (!clean.includes(".") || clean.length < 4 || clean.endsWith(".")) {
        resultBox.style.display = "block";
        resultBox.style.background = "#FEF2F2";
        resultBox.style.border = "1px solid #FECACA";
        resultBox.style.color = "#991B1B";
        resultBox.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                <strong style="font-size:13px;">Invalid Domain Name Format</strong>
                <span style="font-size:11px; padding:2px 8px; border-radius:4px; background:#FEE2E2; border:1px solid #FCA5A5; color:#991B1B; font-weight:600;">Format Error</span>
            </div>
            <div style="font-size:12px; line-height:1.5; color:#7F1D1D;">
                "<strong>` + domain + `</strong>" is not a valid website domain. A domain name must contain a domain extension (for example: <code>yourbusiness.in</code> or <code>company.com</code>).
            </div>
        `;
        return;
    }

    resultBox.style.display = "block";
    resultBox.style.background = "#EFF6FF";
    resultBox.style.border = "1px solid #BFDBFE";
    resultBox.style.color = "#1E40AF";
    resultBox.innerHTML = "Probing DNS and live server response latency for <strong>" + domain + "</strong>...";

    fetch("ping?domain=" + encodeURIComponent(domain))
        .then(res => res.json())
        .then(data => {
            if (!data.found) {
                // Domain invalid or unreachable
                resultBox.style.background = "#FEF2F2";
                resultBox.style.border = "1px solid #FECACA";
                resultBox.style.color = "#991B1B";
                resultBox.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                        <strong style="font-size:13px;">Domain Unreachable or Invalid</strong>
                        <span style="font-size:11px; padding:2px 8px; border-radius:4px; background:#FEE2E2; border:1px solid #FCA5A5; color:#991B1B; font-weight:600;">Status: Unreachable</span>
                    </div>
                    <div style="font-size:12px; line-height:1.5; color:#7F1D1D;">
                        Could not resolve DNS records or establish an HTTP connection for <strong>` + domain + `</strong>.
                        Please verify that the domain name is spelled correctly and that an active server is running.
                    </div>
                `;
                return;
            }

            if (data.enrolled) {
                // Verified client site in database
                const isHealthy = data.status === "Healthy";
                resultBox.style.background = isHealthy ? "#ECFDF5" : "#FFFBEB";
                resultBox.style.border = isHealthy ? "1px solid #A7F3D0" : "1px solid #FDE68A";
                resultBox.style.color = isHealthy ? "#065F46" : "#92400E";
                resultBox.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                        <strong>Enrolled Client: ` + (data.businessName || domain) + `</strong>
                        <span style="font-size:11px; padding:2px 8px; border-radius:4px; background:#FFF; border:1px solid #CBD5E1; font-weight:600;">Managed Fleet</span>
                    </div>
                    <div style="display:grid; grid-template-columns:repeat(3, 1fr); gap:8px; margin:8px 0; font-size:12px;">
                        <div>Domain: <strong>` + data.domainUrl + `</strong></div>
                        <div>Status: <strong>` + data.status + `</strong></div>
                        <div>Latency: <strong>` + data.responseTimeMs + ` ms</strong></div>
                    </div>
                    <div style="font-size:12px; color:#4B5563; margin-top:6px;">
                        Uptime SLA: <strong>` + data.uptimePercentage + `%</strong> • Last Checked: <strong>` + data.lastChecked + `</strong>
                    </div>
                `;
            } else {
                // Public domain reachable on web, but not registered in client database
                resultBox.style.background = "#F8FAFC";
                resultBox.style.border = "1px solid #CBD5E1";
                resultBox.style.color = "#1E293B";
                resultBox.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                        <strong>Public Web Endpoint Active</strong>
                        <span style="font-size:11px; padding:2px 8px; border-radius:4px; background:#E2E8F0; font-weight:600; color:#475569;">Not Enrolled</span>
                    </div>
                    <div style="display:grid; grid-template-columns:repeat(2, 1fr); gap:8px; margin:8px 0; font-size:12px;">
                        <div>Host: <strong>` + domain + `</strong></div>
                        <div>HTTP Response Time: <strong>` + data.responseTimeMs + ` ms</strong></div>
                    </div>
                    <div style="font-size:12px; color:#475569; margin-top:6px; line-height:1.5;">
                        This website is live on the internet, but is not currently enrolled in WebEase 24/7 background uptime monitoring and proactive SLA management.
                    </div>
                `;
            }
        })
        .catch(err => {
            resultBox.style.background = "#FEF2F2";
            resultBox.style.border = "1px solid #FECACA";
            resultBox.style.color = "#991B1B";
            resultBox.innerHTML = `
                <div style="font-size:12px; line-height:1.5;">
                    <strong>Connection Error:</strong> Unable to connect to diagnostic service. Please verify your network connection and retry.
                </div>
            `;
        });
};

// -----------------------------------------------------------------------------
// 3. Dynamic Pricing Calculator (Wired to Java PricingServlet)
// -----------------------------------------------------------------------------
function initPricingCalculator() {
    const planSelect = document.getElementById("planSelect");
    const pagesSlider = document.getElementById("pagesSlider");
    const pagesCount = document.getElementById("pagesCount");
    const addonSeo = document.getElementById("addonSeo");
    const addonBooking = document.getElementById("addonBooking");
    const addonPayments = document.getElementById("addonPayments");
    const billingToggle = document.getElementById("billingCycleToggle");

    const displaySetup = document.getElementById("calcSetupPrice");
    const displayMonthly = document.getElementById("calcMonthlyPrice");
    const displayAnnualSavings = document.getElementById("calcSavingsBadge");

    if (!planSelect || !pagesSlider) return;

    function recalculate() {
        const plan = planSelect.value;
        const pages = parseInt(pagesSlider.value, 10);
        const isAnnual = billingToggle ? billingToggle.checked : false;

        if (pagesCount) {
            pagesCount.innerText = pages + (pages === 1 ? " Page" : " Pages");
        }

        const hasSeo = addonSeo ? addonSeo.checked : false;
        const hasBooking = addonBooking ? addonBooking.checked : false;
        const hasPayments = addonPayments ? addonPayments.checked : false;

        // Base building fee: 5k (starter), 8.5k (growth), 12k (enterprise)
        let setupFee = (plan === "starter") ? 5000 : (plan === "growth") ? 8500 : 12000;
        // Base monthly retainer: 3k (starter), 4.5k (growth), 6k (enterprise)
        let monthlyFee = (plan === "starter") ? 3000 : (plan === "growth") ? 4500 : 6000;

        // Additional pages beyond 3 pages (+₹1,000 per page build fee)
        if (pages > 3) {
            setupFee += (pages - 3) * 1000;
        }

        // Add-ons based on customer requirements
        if (hasBooking) { setupFee += 1500; monthlyFee += 500; }
        if (hasPayments) { setupFee += 2500; monthlyFee += 500; }
        if (hasSeo) { setupFee += 2000; monthlyFee += 500; }

        if (displaySetup) {
            displaySetup.innerText = "₹" + setupFee.toLocaleString("en-IN");
        }

        if (displayMonthly) {
            if (isAnnual) {
                const yearlyTotal = monthlyFee * 10; // 2 months free!
                displayMonthly.innerText = "₹" + yearlyTotal.toLocaleString("en-IN") + " / year";
            } else {
                displayMonthly.innerText = "₹" + monthlyFee.toLocaleString("en-IN") + " / mo";
            }
        }

        if (displayAnnualSavings) {
            if (isAnnual) {
                const savings = monthlyFee * 2;
                displayAnnualSavings.style.display = "inline-block";
                displayAnnualSavings.innerText = "2 Months Free Applied (Save ₹" + savings.toLocaleString("en-IN") + ")";
            } else {
                displayAnnualSavings.style.display = "none";
            }
        }
    }

    window.recalculatePricing = recalculate;

    planSelect.addEventListener("change", recalculate);
    pagesSlider.addEventListener("input", recalculate);
    if (addonSeo) addonSeo.addEventListener("change", recalculate);
    if (addonBooking) addonBooking.addEventListener("change", recalculate);
    if (addonPayments) addonPayments.addEventListener("change", recalculate);
    if (billingToggle) {
        billingToggle.addEventListener("change", function () {
            window.setBillingCycle(this.checked ? "yearly" : "monthly");
        });
    }

    recalculate();
}

// Global Billing Cycle Toggle (Monthly vs Yearly)
window.setBillingCycle = function (cycle) {
    const isYearly = (cycle === "yearly");
    const toggleMonthlyBtn = document.getElementById("toggleMonthlyBtn");
    const toggleYearlyBtn = document.getElementById("toggleYearlyBtn");
    const billingToggle = document.getElementById("billingCycleToggle");

    if (toggleMonthlyBtn && toggleYearlyBtn) {
        if (isYearly) {
            toggleYearlyBtn.classList.add("active");
            toggleMonthlyBtn.classList.remove("active");
        } else {
            toggleMonthlyBtn.classList.add("active");
            toggleYearlyBtn.classList.remove("active");
        }
    }

    if (billingToggle) {
        billingToggle.checked = isYearly;
    }

    const tierRates = document.querySelectorAll(".tier-rate");
    const tierLabels = document.querySelectorAll(".tier-label");

    tierRates.forEach(rateEl => {
        const monthly = rateEl.getAttribute("data-monthly");
        const yearly = rateEl.getAttribute("data-yearly");
        if (isYearly && yearly) {
            rateEl.innerText = "₹" + parseInt(yearly, 10).toLocaleString("en-IN");
        } else if (monthly) {
            rateEl.innerText = "₹" + parseInt(monthly, 10).toLocaleString("en-IN");
        }
    });

    tierLabels.forEach(labelEl => {
        labelEl.innerText = isYearly ? "/ year" : "/ mo";
    });

    if (typeof window.recalculatePricing === "function") {
        window.recalculatePricing();
    }
};

window.selectPlanInCalc = function (planKey) {
    const planSelect = document.getElementById("planSelect");
    if (planSelect) {
        planSelect.value = planKey;
    }
    if (typeof window.recalculatePricing === "function") {
        window.recalculatePricing();
    }
    const calcEl = document.getElementById("planSelect");
    if (calcEl) {
        calcEl.scrollIntoView({ behavior: "smooth", block: "center" });
        calcEl.focus();
    }
};

// -----------------------------------------------------------------------------
// 4. Modal Helpers & View Switcher
// -----------------------------------------------------------------------------
function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = "flex";
        document.body.style.overflow = "hidden";
    }
}

function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = "none";
        document.body.style.overflow = "auto";
    }
}

// Close modals when clicking outside
window.addEventListener("click", function (event) {
    const modals = document.querySelectorAll(".modal-overlay");
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = "none";
            document.body.style.overflow = "auto";
        }
    });
});



// -----------------------------------------------------------------------------
// 6. Customer Website Order & Proposal Workflow
// -----------------------------------------------------------------------------
function initOrderFormHandler() {
    window.openOrderModalWithPlan = function (planArg) {
        const planSelect = document.getElementById("planSelect");
        let selectedPlan = planArg || (planSelect ? planSelect.value : "starter");
        const isAnnual = document.getElementById("billingCycleToggle")?.checked;
        const setupText = document.getElementById("calcSetupPrice")?.innerText || "₹5,000";
        const monthlyText = document.getElementById("calcMonthlyPrice")?.innerText || "₹3,000 / mo";

        let rawBuildPrice = 5000;
        let rawRetainerPrice = 3000;
        let planDisplayName = "Starter Plan";

        if (selectedPlan === "growth") {
            planDisplayName = "Growth Plan";
            rawBuildPrice = 10000;
            rawRetainerPrice = isAnnual ? 5000 : 6000;
        } else if (selectedPlan === "enterprise") {
            planDisplayName = "Custom / Enterprise Plan";
            rawBuildPrice = 25000;
            rawRetainerPrice = isAnnual ? 12000 : 15000;
        } else {
            planDisplayName = "Starter Plan";
            rawBuildPrice = 5000;
            rawRetainerPrice = isAnnual ? 2500 : 3000;
        }

        // 1. MANDATORY SECURITY GATING:
        // If customer is not logged in, IMMEDIATELY redirect to login!
        if (!window.isCustomerLoggedIn) {
            window.location.href = "customer-login.jsp?orderPlan=" + encodeURIComponent(planDisplayName) +
                "&build=" + rawBuildPrice + "&retainer=" + rawRetainerPrice + "&tab=login";
            return;
        }

        // If customer is logged in but profile is not completed, redirect to complete profile page!
        if (!window.isProfileComplete) {
            window.location.href = "complete-profile.jsp?orderPlan=" + encodeURIComponent(planDisplayName) +
                "&build=" + rawBuildPrice + "&retainer=" + rawRetainerPrice;
            return;
        }

        // 2. If authenticated and profile complete, populate order modal fields and open modal
        const modalPlan = document.getElementById("orderModalPlanName");
        const modalCycle = document.getElementById("orderModalBillingCycle");
        const modalBuild = document.getElementById("orderModalBuildPrice");
        const modalRetainer = document.getElementById("orderModalRetainerPrice");

        if (modalPlan) modalPlan.value = planDisplayName;
        if (modalCycle) modalCycle.value = isAnnual ? "Yearly Plan (2 Months Free)" : "Monthly Retainer";
        if (modalBuild) modalBuild.value = rawBuildPrice;
        if (modalRetainer) modalRetainer.value = rawRetainerPrice;

        const summaryEl = document.getElementById("orderSummaryPreview");
        if (summaryEl) {
            summaryEl.innerHTML = `<strong>Selected Package:</strong> ${planDisplayName}<br>` +
                                  `<strong>One-Time Build:</strong> ₹${rawBuildPrice.toLocaleString("en-IN")}<br>` +
                                  `<strong>Ongoing Management:</strong> ₹${rawRetainerPrice.toLocaleString("en-IN")} (${isAnnual ? "Yearly with 2 Months Free" : "Monthly Retainer"})`;
        }

        openModal("orderProjectModal");
    };

    const orderForm = document.getElementById("customerOrderForm");
    if (orderForm) {
        orderForm.addEventListener("submit", function (e) {
            e.preventDefault();

            if (typeof validateOrderForm === "function" && !validateOrderForm()) {
                return;
            }

            const submitBtn = document.getElementById("orderSubmitBtn");
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerText = "Submitting Your Order...";
            }

            const formData = new FormData(orderForm);
            const params = new URLSearchParams();
            for (const pair of formData.entries()) {
                params.append(pair[0], pair[1]);
            }
            params.append("ajax", "true");

            fetch("order", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.requiresLogin) {
                    alert(data.message || "Please sign in or register your verified business account before ordering.");
                    window.location.href = data.redirectUrl || "customer-login.jsp";
                } else if (data.requiresProfile) {
                    alert(data.message || "Please complete your business profile before placing an order.");
                    window.location.href = data.redirectUrl || "complete-profile.jsp";
                } else if (data.success && data.redirectUrl) {
                    closeModal("orderProjectModal");
                    alert("Order successfully confirmed for your verified account! Redirecting to your Customer Portal...");
                    window.location.href = data.redirectUrl;
                } else if (data.success) {
                    closeModal("orderProjectModal");
                    showOrderConfirmationReceipt(data);
                } else {
                    alert(data.message || "Order submission failed. Please ensure valid details are provided.");
                }
            })
            .catch(err => {
                console.error("Order error:", err);
                alert("Unable to submit order. Please check that all mandatory business verification details are provided.");
            })
            .finally(() => {
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerText = "Confirm & Start 5-Day Build";
                }
            });
        });
    }

    function showOrderConfirmationReceipt(order) {
        const orderNumEl = document.getElementById("receiptOrderNumber");
        const bizNameEl = document.getElementById("receiptBusinessName");
        const planEl = document.getElementById("receiptPlanName");
        const totalBuildEl = document.getElementById("receiptBuildFee");
        const totalRetainerEl = document.getElementById("receiptRetainerFee");
        const waLinkEl = document.getElementById("receiptWhatsAppLink");

        if (orderNumEl) orderNumEl.innerText = order.orderNumber;
        if (bizNameEl) bizNameEl.innerText = order.businessName;
        if (planEl) planEl.innerText = order.planName;
        if (totalBuildEl) totalBuildEl.innerText = "₹" + parseInt(order.buildPrice, 10).toLocaleString("en-IN");
        if (totalRetainerEl) totalRetainerEl.innerText = "₹" + parseInt(order.retainerPrice, 10).toLocaleString("en-IN");

        if (waLinkEl) {
            const waText = encodeURIComponent(`Hi WebEase team! I just placed an order (${order.orderNumber}) for my business "${order.businessName}" under the ${order.planName}. Please connect to start wireframing!`);
            waLinkEl.href = `https://wa.me/919019930386?text=${waText}`;
        }

        openModal("orderSuccessModal");
    }
}

// -----------------------------------------------------------------------------
// 7. Self-Service Project Build Pipeline Tracker
// -----------------------------------------------------------------------------
function initProjectTracker() {
    window.searchProjectBuild = function () {
        const input = document.getElementById("trackerQueryInput");
        const statusBox = document.getElementById("trackerResultBox");
        if (!input || !statusBox) return;

        const query = input.value.trim();
        if (!query) {
            alert("Please enter your Order ID (e.g. WEB-ORD-1082) or Phone Number");
            return;
        }

        statusBox.style.display = "block";
        statusBox.innerHTML = "<div style='text-align:center; padding: 2rem; color: #00A88F; font-weight:700;'>Locating your website project...</div>";

        fetch("order?action=track&query=" + encodeURIComponent(query))
        .then(res => res.json())
        .then(data => {
            if (data.found && data.order) {
                renderTrackerUI(data.order, statusBox);
            } else {
                statusBox.innerHTML = `
                    <div style="background:#FEF2F2; border:1px solid #FECACA; border-radius:12px; padding:1.5rem; text-align:center; color:#991B1B;">
                        <strong>No active build found for "${query}"</strong>
                        <p style="font-size:0.85rem; margin-top:0.35rem; color:#B91C1C;">
                            Please double-check your Order ID or phone number. Need immediate help? Text us on WhatsApp at <strong>+91 98201 12345</strong>.
                        </p>
                    </div>`;
            }
        })
        .catch(err => {
            console.error("Tracker fetch error:", err);
            statusBox.innerHTML = "<div style='color:red; text-align:center;'>Error retrieving tracker details. Please check connection.</div>";
        });
    };

    function renderTrackerUI(order, container) {
        let step = 1;
        let progressWidth = "20%";
        let statusBadge = "Requirements Locked";
        let estDelivery = "In 4 Days";

        const st = (order.status || "").toLowerCase();
        if (st === "designing" || st === "in review") {
            step = 2;
            progressWidth = "40%";
            statusBadge = "UI/UX Mobile Design";
            estDelivery = "In 3 Days";
        } else if (st === "development") {
            step = 3;
            progressWidth = "60%";
            statusBadge = "WhatsApp & Feature Integration";
            estDelivery = "In 2 Days";
        } else if (st === "testing") {
            step = 4;
            progressWidth = "80%";
            statusBadge = "SSL & Cloud Deployment";
            estDelivery = "Tomorrow";
        } else if (st === "launched" || st === "active") {
            step = 5;
            progressWidth = "100%";
            statusBadge = "Live on Google & 24/7 Monitored";
            estDelivery = "Active & Live!";
        }

        container.innerHTML = `
            <div style="background:#FFFFFF; border:1px solid #E2E8F0; border-radius:16px; padding:2rem; box-shadow:var(--shadow);">
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem; border-bottom:1px solid #F1F5F9; padding-bottom:1.25rem;">
                    <div>
                        <span class="badge badge-healthy" style="margin-bottom:0.35rem;">Status: ${statusBadge}</span>
                        <h3 style="font-size:1.4rem; font-weight:800; color:#0A2540;">${order.businessName}</h3>
                        <div style="font-size:0.85rem; color:#64748B;">
                            Order Ref: <strong style="color:#0A2540;">${order.orderNumber}</strong> • Plan: <strong>${order.planName}</strong> (${order.billingCycle})
                        </div>
                    </div>
                    <div style="text-align:right;">
                        <span style="font-size:0.75rem; text-transform:uppercase; color:#64748B; font-weight:700;">Delivery Target</span>
                        <div style="font-size:1.25rem; font-weight:800; color:#00A88F;">${estDelivery}</div>
                    </div>
                </div>

                <!-- 5-Stage Stepper -->
                <div class="tracker-stepper">
                    <div class="tracker-progress-line" style="width: ${progressWidth};"></div>
                    
                    <div class="step-item ${step >= 1 ? (step === 1 ? 'active' : 'completed') : ''}">
                        <div class="step-bubble">${step > 1 ? '✓' : '1'}</div>
                        <div class="step-title">Requirements & Domain</div>
                        <div class="step-sub">Day 1</div>
                    </div>
                    
                    <div class="step-item ${step >= 2 ? (step === 2 ? 'active' : 'completed') : ''}">
                        <div class="step-bubble">${step > 2 ? '✓' : '2'}</div>
                        <div class="step-title">Mobile UI Design</div>
                        <div class="step-sub">Day 2</div>
                    </div>
                    
                    <div class="step-item ${step >= 3 ? (step === 3 ? 'active' : 'completed') : ''}">
                        <div class="step-bubble">${step > 3 ? '✓' : '3'}</div>
                        <div class="step-title">Features & WhatsApp</div>
                        <div class="step-sub">Day 3</div>
                    </div>
                    
                    <div class="step-item ${step >= 4 ? (step === 4 ? 'active' : 'completed') : ''}">
                        <div class="step-bubble">${step > 4 ? '✓' : '4'}</div>
                        <div class="step-title">Cloud Host & SSL</div>
                        <div class="step-sub">Day 4</div>
                    </div>
                    
                    <div class="step-item ${step >= 5 ? 'completed' : ''}">
                        <div class="step-bubble">${step >= 5 ? '✓' : '5'}</div>
                        <div class="step-title">Live Launch & QA</div>
                        <div class="step-sub">Day 5</div>
                    </div>
                </div>

                <div style="background:#F8FAFC; border-radius:12px; padding:1.25rem; border:1px solid #E2E8F0; margin-top:1.5rem; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
                    <div>
                        <div style="font-size:0.85rem; font-weight:700; color:#0A2540;">Assigned Project Manager: Ayush & Team</div>
                        <div style="font-size:0.8rem; color:#64748B;">Updates, design reviews, and menu changes handled in real-time.</div>
                    </div>
                    <a href="https://wa.me/919820112345?text=Hi%20WebEase%2C%20checking%20on%20my%20website%20order%20${order.orderNumber}" target="_blank" class="btn-primary" style="font-size:0.85rem; padding:0.5rem 1rem;">
                        Chat on WhatsApp With Project Lead
                    </a>
                </div>
            </div>`;
    }
}

// -----------------------------------------------------------------------------
// 8. FAQ Accordion Handler
// -----------------------------------------------------------------------------
function initFaqAccordion() {
    const faqCards = document.querySelectorAll(".faq-card");
    faqCards.forEach(card => {
        const question = card.querySelector(".faq-question");
        if (question) {
            question.addEventListener("click", () => {
                const isOpen = card.classList.contains("open");
                faqCards.forEach(c => c.classList.remove("open"));
                if (!isOpen) {
                    card.classList.add("open");
                }
            });
        }
    });
}

