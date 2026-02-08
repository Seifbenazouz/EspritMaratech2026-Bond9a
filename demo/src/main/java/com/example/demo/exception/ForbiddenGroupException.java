package com.example.demo.exception;

/**
 * Lancée lorsqu'un ADMIN_GROUPE tente d'effectuer une action sur un groupe dont il n'est pas le responsable.
 */
public class ForbiddenGroupException extends RuntimeException {

    public ForbiddenGroupException(String message) {
        super(message);
    }
}
