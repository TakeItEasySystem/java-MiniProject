package com.webease.util;

import java.util.Random;
import java.util.regex.Pattern;

/**
 * Validation and Verification Utility for WebEase Platform.
 * Enforces strict phone, email, and business verification rules
 * to eliminate fake/random test entries and handle WhatsApp/Email verification codes.
 */
public class ValidationUtil {

    // RFC-compliant email pattern with valid TLD requirement (minimum 2 chars)
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    // Standard 10-digit Indian mobile pattern starting with 6, 7, 8, or 9
    private static final Pattern MOBILE_PATTERN = Pattern.compile("^[6-9]\\d{9}$");

    /**
     * Strictly validates a mobile number.
     * Rejects: non-10 digits, numbers not starting with 6-9, all-same repeating digits, and sequential runs.
     */
    public static boolean isValidMobile(String phone) {
        if (phone == null) return false;
        String clean = phone.replaceAll("[^0-9]", "");
        if (!MOBILE_PATTERN.matcher(clean).matches()) {
            return false;
        }

        // Reject repetitive fake numbers like 9999999999, 8888888888, 7777777777
        char firstChar = clean.charAt(0);
        boolean allSame = true;
        for (int i = 1; i < clean.length(); i++) {
            if (clean.charAt(i) != firstChar) {
                allSame = false;
                break;
            }
        }
        if (allSame) return false;

        // Reject sequential fake runs like 1234567890 or 9876543210
        if ("9876543210".equals(clean) || "1234567890".equals(clean) || "0123456789".equals(clean)) {
            return false;
        }

        // Reject 6 or more identical consecutive digits (e.g. 9800000000, 9999991234)
        if (clean.matches(".*(\\d)\\1{5,}.*")) {
            return false;
        }

        // Reject obvious pattern repetitions like 9898989898, 9090909090
        String pair = clean.substring(0, 2);
        if (clean.equals(pair + pair + pair + pair + pair)) {
            return false;
        }

        return true;
    }

    /**
     * Strictly validates an email address.
     * Allows authentic personal Gmail (@gmail.com) and business custom domains.
     * Rejects placeholder names, throwaways, and keyboard smashes.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String trimmed = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(trimmed).matches()) {
            return false;
        }

        String[] parts = trimmed.split("@");
        if (parts.length != 2) return false;
        String user = parts[0];
        String domain = parts[1];

        // Require meaningful user part and domain
        if (user.length() < 3 || domain.length() < 4) return false;

        // Block throwaway/placeholder prefixes
        if ("test".equals(user) || "testing".equals(user) || "asdf".equals(user)
                || "qwerty".equals(user) || "fake".equals(user) || "dummy".equals(user)
                || "xyz".equals(user) || "abc".equals(user) || "temp".equals(user)
                || "123".equals(user) || "1234".equals(user) || "12345".equals(user)) {
            return false;
        }

        // Block throwaway test domains
        if (domain.equals("test.com") || domain.equals("example.com") || domain.equals("fake.com")
                || domain.equals("temp.com") || domain.equals("dummy.com") || domain.equals("mailinator.com")) {
            return false;
        }

        return true;
    }

    /**
     * Generates a 6-digit confirmation PIN for WhatsApp / Email verification.
     */
    public static String generateVerificationPin() {
        int pin = 100000 + new Random().nextInt(900000);
        return String.valueOf(pin);
    }
}
