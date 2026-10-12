package com.webease.exception;

/**
 * Unit II: User-defined Exception class for validation failures
 */
public class InvalidTicketException extends Exception {
    private static final long serialVersionUID = 1L;

    public InvalidTicketException(String message) {
        super(message);
    }
}
