package uk.gov.hmcts.probate.exception.handler;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.http.ResponseEntity;
import uk.gov.hmcts.probate.exception.ProbateServerException;
import uk.gov.hmcts.probate.exception.ClientException;
import uk.gov.hmcts.probate.exception.ConnectionException;
import uk.gov.hmcts.probate.exception.InvalidPayloadException;
import uk.gov.hmcts.probate.exception.model.ErrorResponse;
import uk.gov.hmcts.probate.exception.model.FieldErrorResponse;
import uk.gov.hmcts.probate.model.ccd.raw.response.CallbackResponse;
import uk.gov.service.notify.NotificationClientException;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;
import static org.springframework.http.HttpStatus.OK;
import static org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE;

public class DefaultExceptionHandlerTest {

    private static final String EXCEPTION_MESSAGE = "Message";

    @Mock
    private ClientException clientException;

    @Mock
    private ConnectionException connectionException;

    @Mock
    private ProbateServerException probateServerException;

    @Mock
    private InvalidPayloadException invalidPayloadException;

    @Mock
    private NotificationClientException notificationClientException;

    @InjectMocks
    private DefaultExceptionHandler underTest;

    @Before
    public void setup() {
        initMocks(this);
    }

    @Test
    public void shouldPassUpstreamBadRequestBackAsIs() {
        when(clientException.getStatusCode()).thenReturn(BAD_REQUEST.value());
        when(clientException.getMessage()).thenReturn(EXCEPTION_MESSAGE);

        ResponseEntity<ErrorResponse> response = underTest.handle(clientException);

        assertEquals(BAD_REQUEST, response.getStatusCode());
        assertEquals(DefaultExceptionHandler.CLIENT_ERROR, response.getBody().getError());
        assertEquals(EXCEPTION_MESSAGE, response.getBody().getMessage());
    }

    @Test
    public void shouldReturnServiceUnavailableForConnectionException() {
        when(connectionException.getMessage()).thenReturn(EXCEPTION_MESSAGE);

        ResponseEntity<ErrorResponse> response = underTest.handle(connectionException);

        assertEquals(SERVICE_UNAVAILABLE, response.getStatusCode());
        assertEquals(DefaultExceptionHandler.CONNECTION_ERROR, response.getBody().getError());
        assertEquals(EXCEPTION_MESSAGE, response.getBody().getMessage());
    }

    @Test
    public void shouldReportMissingDataWithStatusOK() {
        final FieldErrorResponse bve1Mock = FieldErrorResponse.builder()
                .param("Object")
                .field("field1")
                .message("message1")
                .build();

        final FieldErrorResponse bve2Mock = FieldErrorResponse.builder()
                .param("Object")
                .field("field2")
                .message("message2")
                .build();

        when(invalidPayloadException.getErrors()).thenReturn(Arrays.asList(bve1Mock, bve2Mock));

        ResponseEntity<CallbackResponse> response = underTest.handle(invalidPayloadException);

        assertEquals(OK, response.getStatusCode());

        assertEquals(bve1Mock.getMessage(), response.getBody().getErrors().get(0));
        assertEquals(bve2Mock.getMessage(), response.getBody().getErrors().get(1));
    }

    @Test
    public void shouldReturnNotificationClientException() {
        when(notificationClientException.getMessage()).thenReturn(EXCEPTION_MESSAGE);

        ResponseEntity<ErrorResponse> response = underTest.handle(notificationClientException);

        assertEquals(SERVICE_UNAVAILABLE, response.getStatusCode());
        assertEquals(DefaultExceptionHandler.CLIENT_ERROR, response.getBody().getError());
        assertEquals(EXCEPTION_MESSAGE, response.getBody().getMessage());
    }

    @Test
    public void shouldReturnInternalServerError() {
        when(probateServerException.getMessage()).thenReturn(EXCEPTION_MESSAGE);

        ResponseEntity<ErrorResponse> response = underTest.handle(probateServerException);

        assertEquals(INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertEquals(DefaultExceptionHandler.INTERNAL_SERVER_ERROR, response.getBody().getError());
        assertEquals(EXCEPTION_MESSAGE, response.getBody().getMessage());
    }
}
