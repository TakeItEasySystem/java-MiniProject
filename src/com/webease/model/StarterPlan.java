package com.webease.model;

/**
 * Starter Plan:
 * One-time website building fee starting at ₹5,000
 * Ongoing management starting at ₹3,000 / month
 */
public class StarterPlan extends ServicePlan {
    public StarterPlan() {
        super("Starter Plan", 5000.0, 3000.0, 4, true);
    }

    @Override
    public String getPlanSummary() {
        return "Complete custom website build, cloud hosting, domain setup, 24/7 uptime monitoring, and up to 4 monthly content/menu updates.";
    }
}
