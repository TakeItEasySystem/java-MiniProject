package com.webease.service;

import com.webease.model.EnterprisePlan;
import com.webease.model.GrowthPlan;
import com.webease.model.PricingQuote;
import com.webease.model.ServicePlan;
import com.webease.model.StarterPlan;

import java.util.HashMap;
import java.util.Map;

/**
 * Pricing Service:
 * One-time website building fee starting from ₹5,000
 * Ongoing management starting from ₹3,000 / month (or yearly with 2 months free)
 * Scaled dynamically based on client service requirements
 */
public class PricingService {
    private static PricingService instance;
    private final Map<String, ServicePlan> planRegistry = new HashMap<>();

    private PricingService() {
        planRegistry.put("starter", new StarterPlan());
        planRegistry.put("growth", new GrowthPlan());
        planRegistry.put("enterprise", new EnterprisePlan());
    }

    public static synchronized PricingService getInstance() {
        if (instance == null) {
            instance = new PricingService();
        }
        return instance;
    }

    public ServicePlan getPlan(String planKey) {
        if (planKey == null) return planRegistry.get("starter");
        return planRegistry.getOrDefault(planKey.toLowerCase().trim(), planRegistry.get("starter"));
    }

    public PricingQuote generateQuote(String planKey, int months, boolean isAnnual) {
        return generateQuote(planKey, months, isAnnual, false, false, false);
    }

    public PricingQuote generateQuote(String planKey, int months, boolean isAnnual,
                                       boolean addWhatsApp, boolean addRazorpay, boolean addSeo) {
        ServicePlan plan = getPlan(planKey);

        if (months <= 0) months = isAnnual ? 12 : 1;

        double setupFee = plan.getSetupFee();
        double monthlyFee = plan.getMonthlyFee();

        double planCost;
        double discount = 0.0;
        String billingCycle = isAnnual ? "Yearly Plan (2 Months Free)" : "Monthly Retainer";

        if (isAnnual) {
            // Pay for 10 months, get 12 months coverage
            planCost = plan.calculateAnnualCost();
            discount = monthlyFee * 2.0;
        } else {
            planCost = plan.calculateTotalCost(months);
        }

        // Add-ons based on customer need
        double addOnsSetup = 0.0;
        double addOnsMonthly = 0.0;

        if (addWhatsApp) {
            addOnsSetup += 1500.0;
            addOnsMonthly += 500.0;
        }
        if (addRazorpay) {
            addOnsSetup += 2500.0;
            addOnsMonthly += 500.0;
        }
        if (addSeo) {
            addOnsSetup += 2000.0;
            addOnsMonthly += 500.0;
        }

        int activeMonths = isAnnual ? 10 : months;
        double totalAddOns = addOnsSetup + (addOnsMonthly * activeMonths);
        double subtotal = planCost + totalAddOns;

        // 18% GST
        double gst = Math.round((subtotal * 0.18) * 100.0) / 100.0;
        double grandTotal = Math.round((subtotal + gst) * 100.0) / 100.0;

        return new PricingQuote(
                plan.getPlanName(),
                setupFee + addOnsSetup,
                monthlyFee + addOnsMonthly,
                months,
                subtotal,
                discount,
                totalAddOns,
                gst,
                grandTotal,
                billingCycle
        );
    }

    public Map<String, ServicePlan> getAllPlans() {
        return new HashMap<>(planRegistry);
    }
}
