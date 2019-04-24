'use strict';

const dateFns = require('date-fns');

const testConfig = require('src/test/config');
const createCaseConfig = require('src/test/end-to-end/pages/createCase/createCaseConfig');
const eventSummaryConfig = require('src/test/end-to-end/pages/eventSummary/eventSummaryConfig');

const caseMatchesConfig = require('src/test/end-to-end/pages/caseMatches/standingSearch/caseMatchesConfig');
const createStandingSearchConfig = require('src/test/end-to-end/pages/createStandingSearch/createStandingSearchConfig');
const documentRemoveConfig = require('src/test/end-to-end/pages/documentRemove/documentRemoveConfig');
const documentUploadConfig = require('src/test/end-to-end/pages/documentUpload/standingSearch/documentUploadConfig');

const applicantDetailsTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/applicantDetailsTabConfig');
const caseDetailsTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/caseDetailsTabConfig');
const caseMatchesTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/caseMatchesTabConfig');
const deceasedTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/deceasedTabConfig');
const documentUploadTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/documentUploadTabConfig');
const historyTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/historyTabConfig');

const applicantDetailsUpdateTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/applicantDetailsUpdateTabConfig');
const caseDetailsUpdateTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/caseDetailsUpdateTabConfig');
const deceasedUpdateTabConfig = require('src/test/end-to-end/pages/caseDetails/standingSearch/deceasedUpdateTabConfig');

Feature('Back Office').retry(testConfig.TestRetryFeatures);

Scenario('Standing Search Workflow - E2E test 03 - Standing Search for a Personal Applicant - Create standing search -> Probate app in progress -> Close standing search', async function (I) {

    // IdAM
    I.authenticateWithIdamIfAvailable();

    let nextStepName = 'Create a standing search';
    I.selectNewCase();
    I.selectCaseTypeOptions(createCaseConfig.list1_text, createCaseConfig.list2_text_ss, createCaseConfig.list3_text_ss);
    I.enterStandingSearchPage1('create');
    I.enterStandingSearchPage2('create');
    I.enterStandingSearchPage3('create');
    I.enterStandingSearchPage4('create');
    I.checkMyAnswers(nextStepName);
    let endState = 'Standing search created';

    const url = await I.grabCurrentUrl();
    const caseRef = url.split('/').pop()
        .match(/.{4}/g)
        .join('-');

    // When creating a standing search, Standing Search Expiry Date is automatically set to today + 6 months
    createStandingSearchConfig.standing_search_expiry_date = dateFns.format(dateFns.addMonths(new Date(), 6), 'D MMM YYYY');
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, caseDetailsTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, deceasedTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, applicantDetailsTabConfig, createStandingSearchConfig);

    nextStepName = 'Match application';
    I.chooseNextStep(nextStepName);
    I.selectCaseMatchesForStandingSearch(caseRef, caseMatchesConfig);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Standing search matching';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, caseMatchesTabConfig, caseMatchesConfig);

    nextStepName = 'Probate app in progress';
    I.chooseNextStep(nextStepName);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Awaiting probate grant';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

    nextStepName = 'Amend standing search';
    I.chooseNextStep(nextStepName);
    I.enterStandingSearchPage1('update1');
    I.enterStandingSearchPage2('update1');
    I.enterStandingSearchPage3('update1');
    I.enterStandingSearchPage4('update1');
    I.checkMyAnswers(nextStepName);

    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, caseDetailsUpdateTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, deceasedUpdateTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, applicantDetailsUpdateTabConfig, createStandingSearchConfig);

    const uploadNumber = 1;
    nextStepName = 'Upload document';
    I.chooseNextStep(nextStepName);
    I.uploadDocument(caseRef, documentUploadConfig, uploadNumber);
    I.enterEventSummary(caseRef, nextStepName);
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, documentUploadTabConfig, documentUploadConfig);

    nextStepName = 'Add comment';
    I.chooseNextStep(nextStepName);
    I.enterComment(caseRef, nextStepName);
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

    nextStepName = 'Match application';
    I.chooseNextStep(nextStepName);
    I.selectCaseMatchesForStandingSearch(caseRef, caseMatchesConfig);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Standing search matching';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, caseMatchesTabConfig, caseMatchesConfig);

    nextStepName = 'No match';
    I.chooseNextStep(nextStepName);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Standing search not matched';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

    nextStepName = 'Probate app in progress';
    I.chooseNextStep(nextStepName);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Awaiting probate grant';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

    nextStepName = 'Close standing search';
    I.chooseNextStep(nextStepName);
    I.enterEventSummary(caseRef, nextStepName);
    endState = 'Standing search closed';
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

    nextStepName = 'Amend standing search';
    I.chooseNextStep(nextStepName);
    I.enterStandingSearchPage1('update2');
    I.enterStandingSearchPage2('update2');
    I.enterStandingSearchPage3('update2');
    I.enterStandingSearchPage4('update2');
    I.checkMyAnswers(nextStepName);

    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, caseDetailsUpdateTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, deceasedUpdateTabConfig, createStandingSearchConfig);
    I.seeCaseDetails(caseRef, applicantDetailsUpdateTabConfig, createStandingSearchConfig);

    nextStepName = 'Upload document';
    I.chooseNextStep(nextStepName);
    I.removeDocuments(caseRef, documentRemoveConfig, uploadNumber);
    I.enterEventSummary(caseRef, nextStepName);
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);
    I.seeCaseDetails(caseRef, documentUploadTabConfig, documentRemoveConfig);

    nextStepName = 'Add comment';
    I.chooseNextStep(nextStepName);
    I.enterComment(caseRef, nextStepName);
    I.seeCaseDetails(caseRef, historyTabConfig, eventSummaryConfig, nextStepName, endState);

}).retry(testConfig.TestRetryScenarios);