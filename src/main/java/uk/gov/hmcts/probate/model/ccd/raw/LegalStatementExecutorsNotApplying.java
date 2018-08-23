package uk.gov.hmcts.probate.model.ccd.raw;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LegalStatementExecutorsNotApplying {

    private final LegalStatementExecutorNotApplying value;

    private final String id;

}
