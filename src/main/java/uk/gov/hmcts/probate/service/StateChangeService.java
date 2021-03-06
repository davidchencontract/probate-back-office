package uk.gov.hmcts.probate.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import uk.gov.hmcts.probate.changerule.ApplicantSiblingsRule;
import uk.gov.hmcts.probate.changerule.DiedOrNotApplyingRule;
import uk.gov.hmcts.probate.changerule.DomicilityRule;
import uk.gov.hmcts.probate.changerule.EntitledMinorityRule;
import uk.gov.hmcts.probate.changerule.ExecutorsRule;
import uk.gov.hmcts.probate.changerule.LifeInterestRule;
import uk.gov.hmcts.probate.changerule.MinorityInterestRule;
import uk.gov.hmcts.probate.changerule.NoOriginalWillRule;
import uk.gov.hmcts.probate.changerule.RenouncingRule;
import uk.gov.hmcts.probate.changerule.ResiduaryRule;
import uk.gov.hmcts.probate.changerule.SolsExecutorRule;
import uk.gov.hmcts.probate.changerule.SpouseOrCivilRule;
import uk.gov.hmcts.probate.changerule.UpdateApplicationRule;
import uk.gov.hmcts.probate.model.ExecutorsApplyingNotification;
import uk.gov.hmcts.probate.model.ccd.raw.CollectionMember;
import uk.gov.hmcts.probate.model.ccd.raw.request.CaseData;
import uk.gov.hmcts.probate.transformer.CallbackResponseTransformer;

import java.util.Optional;

import static uk.gov.hmcts.probate.model.Constants.NO;
import static uk.gov.hmcts.probate.model.Constants.REDEC_NOTIFICATION_SENT_STATE;
import static uk.gov.hmcts.probate.model.Constants.YES;

@Component
@RequiredArgsConstructor
public class StateChangeService {
    private static final String STATE_STOPPED = "Stopped";
    private static final String STATE_GRANT_TYPE_PROBATE = "SolProbateCreated";
    private static final String STATE_GRANT_TYPE_INTESTACY = "SolIntestacyCreated";
    private static final String STATE_GRANT_TYPE_ADMON = "SolAdmonCreated";
    private static final String STATE_GRANT_TYPE_CREATED = "SolAppCreated";

    private static final String GRANT_TYPE_PROBATE = "WillLeft";
    private static final String GRANT_TYPE_INTESTACY = "NoWill";


    private final ApplicantSiblingsRule applicantSiblingsRule;
    private final DiedOrNotApplyingRule diedOrNotApplyingRule;
    private final DomicilityRule domicilityRule;
    private final EntitledMinorityRule entitledMinorityRule;
    private final ExecutorsRule executorsRule;
    private final LifeInterestRule lifeInterestRule;
    private final MinorityInterestRule minorityInterestRule;
    private final NoOriginalWillRule noOriginalWillRule;
    private final RenouncingRule renouncingRule;
    private final ResiduaryRule residuaryRule;
    private final SolsExecutorRule solsExecutorRule;
    private final SpouseOrCivilRule spouseOrCivilRule;
    private final UpdateApplicationRule updateApplicationRule;
    private final CallbackResponseTransformer callbackResponseTransformer;


    public Optional<String> getChangedStateForCaseUpdate(CaseData caseData) {
        if (domicilityRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        if (executorsRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        return Optional.empty();
    }

    public Optional<String> getChangedStateForProbateUpdate(CaseData caseData) {
        if (noOriginalWillRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        if (domicilityRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        if (executorsRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        return Optional.empty();
    }

    public Optional<String> getChangedStateForIntestacyUpdate(CaseData caseData) {
        if (domicilityRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (minorityInterestRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (applicantSiblingsRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (renouncingRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (solsExecutorRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (spouseOrCivilRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }
        return Optional.empty();
    }

    public Optional<String> getChangedStateForAdmonUpdate(CaseData caseData) {
        if (noOriginalWillRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (domicilityRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (diedOrNotApplyingRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (entitledMinorityRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (lifeInterestRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (residuaryRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        if (solsExecutorRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_STOPPED);
        }

        return Optional.empty();
    }

    public Optional<String> getChangedStateForCaseReview(CaseData caseData) {
        if (updateApplicationRule.isChangeNeeded(caseData)) {
            return Optional.of(STATE_GRANT_TYPE_CREATED);
        }
        return Optional.empty();
    }

    public Optional<String> getChangedStateForGrantType(CaseData caseData) {
        if (caseData.getSolsWillType().equals(GRANT_TYPE_PROBATE)) {
            return Optional.of(STATE_GRANT_TYPE_PROBATE);
        } else if (caseData.getSolsWillType().equals(GRANT_TYPE_INTESTACY)) {
            return Optional.of(STATE_GRANT_TYPE_INTESTACY);
        }
        return Optional.of(STATE_GRANT_TYPE_ADMON);
    }

    public Optional<String> getRedeclarationComplete(CaseData caseData) {
        Optional<String> state = Optional.empty();
        for (CollectionMember<ExecutorsApplyingNotification> executorsApplyingNotification :
                caseData.getExecutorsApplyingNotifications()) {
            if (YES.equals(executorsApplyingNotification.getValue().getNotification())) {
                if (NO.equals(executorsApplyingNotification.getValue().getResponseReceived())) {
                    return (Optional.of(REDEC_NOTIFICATION_SENT_STATE));
                }
            }
        }
        return state;
    }
}
