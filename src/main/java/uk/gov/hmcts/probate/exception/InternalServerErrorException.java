package uk.gov.hmcts.probate.exception;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.validation.Errors;
import uk.gov.hmcts.probate.exception.model.FieldErrorResponse;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Data
@EqualsAndHashCode(callSuper = true)
public class InternalServerErrorException extends RuntimeException {

    public InternalServerErrorException(final String message) {
        super(message);
    }
}
