package com.webease.exception;

/**
 * Unit II: User-defined Exception class
 */
public class SiteNotFoundException extends Exception {
    private static final long serialVersionUID = 1L;

    public SiteNotFoundException(String message) {
        super(message);
    }

    public SiteNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
