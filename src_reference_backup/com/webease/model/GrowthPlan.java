package com.webease.model;

/**
 * Unit II: Inheritance (extends keyword, method overriding, super keyword)
 */
public class GrowthPlan extends ServicePlan {
    private boolean prioritySupport;

    public GrowthPlan() {
        super("WebEase Growth", 12999.0, 1699.0, 6, true);
        this.prioritySupport = true;
    }

    public boolean isPrioritySupport() {
        return prioritySupport;
    }

    public void setPrioritySupport(boolean prioritySupport) {
        this.prioritySupport = prioritySupport;
    }

    @Override
    public String getPlanSummary() {
        return "Best for cafés, salons, clinics & gyms. Includes multi-page website, online booking/menu, 6 monthly updates, and 24/7 proactive monitoring.";
    }
}
