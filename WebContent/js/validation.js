/**
 * Unit IV: Fundamentals of JavaScript & Form Validation
 * Directly implements Lab Experiment 08:
 * "Program using JavaScript to validate the email address entered by the user
 * (check the presence of '@' & '.' character. If this character is missing,
 * the script should display an alert box reporting the error and ask the user to re-enter it again)."
 */

function validateEmail(email) {
    if (!email || email.trim() === "") {
        alert("Please enter an email address.");
        return false;
    }

    var trimmed = email.trim().toLowerCase();
    // Lab Experiment 08 specification: check presence of '@' and '.'
    var atIndex = trimmed.indexOf("@");
    var dotIndex = trimmed.lastIndexOf(".");

    if (atIndex === -1 || dotIndex === -1 || atIndex === 0 || dotIndex < atIndex + 2 || dotIndex + 2 >= trimmed.length) {
        alert("Invalid Email Address!\nYour email must contain '@' and a valid domain extension (e.g. name@gmail.com or name@company.in).\nPlease re-enter it again.");
        return false;
    }

    var emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    if (!emailRegex.test(trimmed)) {
        alert("Invalid Email Format!\nPlease enter a valid email address (e.g. yourbusiness@gmail.com). Random text strings are rejected.");
        return false;
    }

    if (trimmed === "test@test.com" || trimmed === "asdf@asdf.com" || trimmed === "abc@abc.com") {
        alert("Invalid Email Address!\nPlaceholder or test emails are blocked. Please provide your authentic business or Gmail address.");
        return false;
    }

    return true;
}

function validatePhoneNumber(phone) {
    if (!phone || phone.trim() === "") {
        alert("Please enter your 10-digit mobile number.");
        return false;
    }
    var cleanPhone = phone.replace(/[^0-9]/g, "");
    if (!/^[6-9]\d{9}$/.test(cleanPhone)) {
        alert("Invalid Mobile Number!\nPlease enter a valid 10-digit Indian WhatsApp/mobile number starting with 6, 7, 8, or 9 (e.g. 98201 12345).");
        return false;
    }

    // Reject repetitive digits like 9999999999, 8888888888
    var first = cleanPhone.charAt(0);
    var allSame = true;
    for (var i = 1; i < cleanPhone.length; i++) {
        if (cleanPhone.charAt(i) !== first) {
            allSame = false;
            break;
        }
    }
    if (allSame) {
        alert("Invalid Mobile Number!\nRepetitive numbers (e.g. 9999999999) are blocked to prevent fake orders. Please enter your authentic WhatsApp number.");
        return false;
    }

    // Reject sequential runs
    if (cleanPhone === "1234567890" || cleanPhone === "9876543210" || cleanPhone === "0123456789") {
        alert("Invalid Mobile Number!\nSequential dummy numbers (e.g. 1234567890) are blocked. Please provide your real WhatsApp number.");
        return false;
    }

    return true;
}

function validateAuditForm() {
    var urlInput = document.getElementById("websiteUrl");
    var emailInput = document.getElementById("ownerEmail");
    var phoneInput = document.getElementById("ownerPhone");

    if (urlInput && urlInput.value.trim() === "") {
        alert("Please enter your website URL or business domain name.");
        urlInput.focus();
        return false;
    }

    if (emailInput && !validateEmail(emailInput.value)) {
        emailInput.focus();
        return false;
    }

    if (phoneInput && !validatePhoneNumber(phoneInput.value)) {
        phoneInput.focus();
        return false;
    }

    return true;
}

function validateTicketForm() {
    var title = document.getElementById("ticketTitle");
    var desc = document.getElementById("ticketDescription");

    if (!title || title.value.trim() === "") {
        alert("Please enter a brief title for your maintenance request.");
        if (title) title.focus();
        return false;
    }

    if (!desc || desc.value.trim() === "") {
        alert("Please describe what update you need (e.g., menu price change, hours update).");
        if (desc) desc.focus();
        return false;
    }

    return true;
}

function validateOrderForm() {
    var biz = document.getElementById("orderBusinessName");
    var name = document.getElementById("orderCustomerName") || document.getElementById("orderOwnerName");
    var phone = document.getElementById("orderPhone") || document.getElementById("orderWhatsapp");
    var email = document.getElementById("orderEmail");
    var city = document.getElementById("orderCity");
    var proof = document.getElementById("orderProof");
    var declaration = document.getElementById("orderConfirmAuthenticity");

    if (!biz || biz.value.trim().length < 2) {
        alert("Please enter a valid business or brand name (at least 2 characters).");
        if (biz) biz.focus();
        return false;
    }

    if (!name || name.value.trim().length < 2) {
        alert("Please enter the owner or manager's full legal name.");
        if (name) name.focus();
        return false;
    }

    if (!phone) {
        alert("Please enter a WhatsApp or mobile number.");
        return false;
    }

    if (!validatePhoneNumber(phone.value)) {
        phone.focus();
        return false;
    }

    if (!email || !validateEmail(email.value)) {
        if (email) email.focus();
        return false;
    }

    if (city && city.value.trim().length < 2) {
        alert("Please enter your business location (city / area).");
        city.focus();
        return false;
    }

    if (proof && proof.value.trim().length < 3) {
        alert("Business Verification Required: Please enter your GSTIN, Udyam MSME ID, Google Maps link, or registered Business UPI to prevent joke/fraudulent applications.");
        proof.focus();
        return false;
    }

    if (declaration && !declaration.checked) {
        alert("Please confirm the authenticity declaration to submit your website build order.");
        declaration.focus();
        return false;
    }

    return true;
}

