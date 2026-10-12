package com.webease.model;

/**
 * Pro / Custom Plan:
 * One-time website building fee ₹12,000
 * Ongoing management ₹6,000 / month
 */
public class EnterprisePlan extends ServicePlan {
    private boolean dedicatedAccountManager;
    private boolean customIntegrations;

    public EnterprisePlan() {
        super("Pro / Custom Plan", 12000.0, 6000.0, 15, true);
        this.dedicatedAccountManager = true;
        this.customIntegrations = true;
    }

    public boolean isDedicatedAccountManager() {
        return dedicatedAccountManager;
    }

    public void setDedicatedAccountManager(boolean dedicatedAccountManager) {
        this.dedicatedAccountManager = dedicatedAccountManager;
    }

    public boolean isCustomIntegrations() {
        return customIntegrations;
    }

    public void setCustomIntegrations(boolean customIntegrations) {
        this.customIntegrations = customIntegrations;
    }

    @Override
    public String getPlanSummary() {
        return "Complete custom web application with online payment gateways, WhatsApp business API, unlimited monitoring, and 1-hour priority turnaround.";
    }
}
