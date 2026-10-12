package com.webease.model;

/**
 * Growth Plan:
 * One-time website building fee ₹8,500
 * Ongoing management ₹4,500 / month
 */
public class GrowthPlan extends ServicePlan {
    private boolean prioritySupport;

    public GrowthPlan() {
        super("Growth Plan", 8500.0, 4500.0, 8, true);
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
        return "Multi-page website build with dynamic booking/ordering, cloud hosting, priority WhatsApp support, and up to 8 monthly updates.";
    }
}
