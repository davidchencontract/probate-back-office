package uk.gov.hmcts.probate.service.probateman;

import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import uk.gov.hmcts.probate.model.probateman.ProbateManModel;
import uk.gov.hmcts.probate.model.probateman.ProbateManType;
import uk.gov.hmcts.probate.security.SecurityUtils;
import uk.gov.hmcts.probate.service.CoreCaseDataService;
import uk.gov.hmcts.probate.service.ProbateManService;
import uk.gov.hmcts.probate.service.probateman.mapper.ProbateManMapper;
import uk.gov.hmcts.reform.ccd.client.model.CaseDetails;

import java.util.Map;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class ProbateManServiceImpl implements ProbateManService {

    private final Map<ProbateManType, JpaRepository> repositories;

    private final Map<ProbateManType, ProbateManMapper> mappers;

    private final SecurityUtils securityUtils;

    private final CoreCaseDataService coreCaseDataService;

    public CaseDetails saveToCcd(Long id, ProbateManType probateManType) {
        JpaRepository repository = Optional.ofNullable(repositories.get(probateManType))
            .orElseThrow(() ->
                new IllegalArgumentException("Cannot find repository for: " + probateManType.name()));
        Optional<ProbateManModel> probateManModelOptional = repository.findById(id);
        ProbateManModel probateManModel = probateManModelOptional
            .orElseThrow(() -> new IllegalArgumentException("Cannot find " + probateManType.name()
                + " with id: " + id));
        ProbateManMapper probateManMapper = mappers.get(probateManType);
        return coreCaseDataService.createCase(
            probateManMapper.toCcdData(probateManModel),
            probateManType.getCcdCaseType(),
            probateManType.getCaseCreationEventId(),
            securityUtils.getSecurityDTO()
        );
    }
}