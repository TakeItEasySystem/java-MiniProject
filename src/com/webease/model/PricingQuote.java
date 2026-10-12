package com.webease.model;

import java.io.Serializable;

/**
 * Unit I: JavaBean POJO encapsulating pricing calculation breakdown
 */
public class PricingQuote implements Serializable {
    private static final long serialVersionUID = 1L;

    private String planName;
    private double setupFee;
    private double monthlyRetainer;
    private int months;
    private double subtotal;
    private double discountAmount;
    private double addOnsCost;
    private double gstAmount; // 18% GST standard in India
    private double grandTotal;
    private String billingCycle; // "monthly" or "annual"

    public PricingQuote() {}

    public PricingQuote(String planName, double setupFee, double monthlyRetainer, int months,
                        double subtotal, double discountAmount, double addOnsCost,
                        double gstAmount, double grandTotal, String billingCycle) {
        this.planName = planName;
        this.setupFee = setupFee;
        this.monthlyRetainer = monthlyRetainer;
        this.months = months;
        this.subtotal = subtotal;
        this.discountAmount = discountAmount;
        this.addOnsCost = addOnsCost;
        this.gstAmount = gstAmount;
        this.grandTotal = grandTotal;
        this.billingCycle = billingCycle;
    }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    public double getSetupFee() { return setupFee; }
    public void setSetupFee(double setupFee) { this.setupFee = setupFee; }

    public double getMonthlyRetainer() { return monthlyRetainer; }
    public void setMonthlyRetainer(double monthlyRetainer) { this.monthlyRetainer = monthlyRetainer; }

    public int getMonths() { return months; }
    public void setMonths(int months) { this.months = months; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getAddOnsCost() { return addOnsCost; }
    public void setAddOnsCost(double addOnsCost) { this.addOnsCost = addOnsCost; }

    public double getGstAmount() { return gstAmount; }
    public void setGstAmount(double gstAmount) { this.gstAmount = gstAmount; }

    public double getGrandTotal() { return grandTotal; }
    public void setGrandTotal(double grandTotal) { this.grandTotal = grandTotal; }

    public String getBillingCycle() { return billingCycle; }
    public void setBillingCycle(String billingCycle) { this.billingCycle = billingCycle; }
}
