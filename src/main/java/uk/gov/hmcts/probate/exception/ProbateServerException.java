package uk.gov.hmcts.probate.exception;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.gov.hmcts.probate.exception.model.FieldErrorResponse;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Data
@EqualsAndHashCode(callSuper = true)
public class ProbateServerException extends RuntimeException {

    public ProbateServerException(final String message) {
        super(message);
    }
}
