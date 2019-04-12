package uk.gov.hmcts.probate.exception.handler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import uk.gov.hmcts.probate.exception.InternalServerErrorException;
import uk.gov.hmcts.probate.exception.ClientException;
import uk.gov.hmcts.probate.exception.ConnectionException;
import uk.gov.hmcts.probate.exception.InvalidPayloadException;
import uk.gov.hmcts.probate.exception.model.ErrorResponse;
import uk.gov.hmcts.probate.exception.model.FieldErrorResponse;
import uk.gov.hmcts.probate.model.ccd.raw.response.CallbackResponse;
import uk.gov.service.notify.NotificationClientException;

import java.util.stream.Collectors;

import static net.logstash.logback.argument.StructuredArguments.keyValue;
import static org.springframework.http.HttpStatus.OK;
import static org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE;

@Slf4j
@ControllerAdvice
class DefaultExceptionHandler extends ResponseEntityExceptionHandler {

    public static final String INTERNAL_SERVER_ERROR = "Internal Server error";
    public static final String CLIENT_ERROR = "Client Error";
    public static final String CONNECTION_ERROR = "Connection error";

    @ExceptionHandler(InternalServerErrorException.class)
    public ResponseEntity<ErrorResponse> handle(InternalServerErrorException exception) {

        log.info("Internal server error", keyValue("serverError", exception.getMessage()));
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                INTERNAL_SERVER_ERROR, exception.getMessage());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        return new ResponseEntity<>(errorResponse, headers, HttpStatus.INTERNAL_SERVER_ERROR);
    }


    @ExceptionHandler(InvalidPayloadException.class)
    public ResponseEntity<CallbackResponse> handle(InvalidPayloadException exception) {

        log.info("Invalid Payload", keyValue("missingKeys", exception.getErrors()));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        CallbackResponse callbackResponse = CallbackResponse.builder()
                .errors(exception.getErrors().stream().map(FieldErrorResponse::getMessage).collect(Collectors.toList()))
                .build();
        return new ResponseEntity<>(callbackResponse, headers, OK);
    }

    @ExceptionHandler(ClientException.class)
    public ResponseEntity<ErrorResponse> handle(ClientException exception) {
        log.warn("Client exception, response code: {}", exception.getStatusCode(), exception);

        ErrorResponse errorResponse = new ErrorResponse(exception.getStatusCode(), CLIENT_ERROR, exception.getMessage());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        return new ResponseEntity<>(errorResponse, headers, HttpStatus.valueOf(errorResponse.getCode()));
    }

    @ExceptionHandler(ConnectionException.class)
    public ResponseEntity<ErrorResponse> handle(ConnectionException exception) {
        log.warn("Can't connect to service, response code: {}", exception.getMessage(), exception);
        ErrorResponse errorResponse = new ErrorResponse(SERVICE_UNAVAILABLE.value(), CONNECTION_ERROR, exception.getMessage());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        return new ResponseEntity<>(errorResponse, headers, SERVICE_UNAVAILABLE);
    }

    @ExceptionHandler(value = NotificationClientException.class)
    public ResponseEntity<ErrorResponse> handle(NotificationClientException exception) {
        log.warn("Notification service exception", exception);
        ErrorResponse errorResponse = new ErrorResponse(SERVICE_UNAVAILABLE.value(), CLIENT_ERROR, exception.getMessage());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        return new ResponseEntity<>(errorResponse, headers, SERVICE_UNAVAILABLE);
    }
}
