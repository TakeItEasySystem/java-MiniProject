package com.webease.model;

/**
 * Unit I & II Demo:
 * - Abstract class and methods
 * - Inheritance & Polymorphism
 * - Encapsulation (private members, getters/setters)
 * - Method Overloading & Overriding
 */
public abstract class ServicePlan {
    private String planName;
    private double setupFee;
    private double monthlyFee;
    private int maxMonthlyEdits;
    private boolean proactiveMonitoring;

    // Default constructor
    public ServicePlan() {
        this("Basic Plan", 5000.0, 999.0, 2, true);
    }

    // Parameterized constructor (Constructor Overloading)
    public ServicePlan(String planName, double setupFee, double monthlyFee, int maxMonthlyEdits, boolean proactiveMonitoring) {
        this.planName = planName;
        this.setupFee = setupFee;
        this.monthlyFee = monthlyFee;
        this.maxMonthlyEdits = maxMonthlyEdits;
        this.proactiveMonitoring = proactiveMonitoring;
    }

    // Getters and Setters (Encapsulation)
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    public double getSetupFee() { return setupFee; }
    public void setSetupFee(double setupFee) { this.setupFee = setupFee; }

    public double getMonthlyFee() { return monthlyFee; }
    public void setMonthlyFee(double monthlyFee) { this.monthlyFee = monthlyFee; }

    public int getMaxMonthlyEdits() { return maxMonthlyEdits; }
    public void setMaxMonthlyEdits(int maxMonthlyEdits) { this.maxMonthlyEdits = maxMonthlyEdits; }

    public boolean isProactiveMonitoring() { return proactiveMonitoring; }
    public void setProactiveMonitoring(boolean proactiveMonitoring) { this.proactiveMonitoring = proactiveMonitoring; }

    // Method Overloading 1: Calculate cost for given months
    public double calculateTotalCost(int months) {
        return this.setupFee + (this.monthlyFee * months);
    }

    // Method Overloading 2: Calculate cost with discount percentage
    public double calculateTotalCost(int months, double discountPercentage) {
        double subtotal = calculateTotalCost(months);
        double discount = (subtotal * discountPercentage) / 100.0;
        return subtotal - discount;
    }

    // Annual cost with 2 months free discount
    public double calculateAnnualCost() {
        return this.setupFee + (this.monthlyFee * 10.0);
    }

    // Abstract method to be overridden by subclasses (Polymorphism)
    public abstract String getPlanSummary();
}
