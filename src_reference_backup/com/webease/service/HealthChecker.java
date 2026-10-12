package com.webease.service;

import com.webease.model.ClientSite;

/**
 * Unit II: Interface definition
 */
public interface HealthChecker {
    boolean checkSiteAvailability(String url);
    int measureResponseTime(String url);
    ClientSite performFullDiagnostic(ClientSite site);
}
