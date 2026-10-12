package com.webease.model;

/**
 * Unit II: Inheritance (extends keyword, method overriding, super keyword)
 */
public class StarterPlan extends ServicePlan {
    public StarterPlan() {
        super("WebEase Starter", 6999.0, 899.0, 2, true);
    }

    @Override
    public String getPlanSummary() {
        return "Best for small local shops & tutors. Includes custom single-page website, domain setup, hosting & up to 2 monthly updates.";
    }
}
