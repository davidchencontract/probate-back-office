package uk.gov.hmcts.probate.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import uk.gov.hmcts.probate.config.properties.registries.RegistriesProperties;
import uk.gov.hmcts.probate.config.properties.registries.Registry;
import uk.gov.hmcts.probate.model.DocumentType;
import uk.gov.hmcts.probate.model.ccd.raw.Document;
import uk.gov.hmcts.probate.model.ccd.raw.request.CallbackRequest;
import uk.gov.hmcts.probate.model.ccd.raw.request.CaseData;
import uk.gov.hmcts.probate.model.ccd.raw.request.CaseDetails;
import uk.gov.hmcts.probate.service.docmosis.GenericMapperService;
import uk.gov.hmcts.probate.service.template.pdf.PDFManagementService;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static uk.gov.hmcts.probate.model.Constants.CTSC;
import static uk.gov.hmcts.probate.model.DocumentType.ADMON_WILL_GRANT_DRAFT;
import static uk.gov.hmcts.probate.model.DocumentType.DIGITAL_GRANT_DRAFT;
import static uk.gov.hmcts.probate.model.DocumentType.DIGITAL_GRANT_DRAFT_REISSUE;
import static uk.gov.hmcts.probate.model.DocumentType.INTESTACY_GRANT_DRAFT;

@Slf4j
@Service
@RequiredArgsConstructor
public class DocumentGeneratorService {

    private final RegistriesProperties registriesProperties;
    private final PDFManagementService pdfManagementService;
    private final DocumentService documentService;
    private final GenericMapperService genericMapperService;

    private static final String GRANT_OF_PROBATE = "gop";
    private static final String ADMON_WILL = "admonWill";
    private static final String INTESTACY = "intestacy";
    private static final String EDGE_CASE = "edgeCase";
    private static final String CREST_IMAGE = "GrantOfProbateCrest";
    private static final String SEAL_IMAGE = "GrantOfProbateSeal";
    private static final String CREST_FILE_PATH = "crestImage.txt";
    private static final String SEAL_FILE_PATH = "sealImage.txt";

    public Document generateGrantReissueDraft(CallbackRequest callbackRequest) {
        CaseDetails caseDetails = callbackRequest.getCaseDetails();
        CaseData caseData = caseDetails.getData();
        Document document;
        DocumentType template;
        getRegistryDetails(caseDetails);

        switch (caseData.getCaseType()) {
            case INTESTACY:
                template = INTESTACY_GRANT_DRAFT;
                document = pdfManagementService.generateAndUpload(callbackRequest, template);
                log.info("Generated and Uploaded Intestacy grant preview document with template {} for the case id {}",
                        template.getTemplateName(), callbackRequest.getCaseDetails().getId().toString());
                break;
            case ADMON_WILL:
                template = ADMON_WILL_GRANT_DRAFT;
                document = pdfManagementService.generateAndUpload(callbackRequest, template);
                log.info("Generated and Uploaded Admon Will grant preview document with template {} for the case id {}",
                        template.getTemplateName(), callbackRequest.getCaseDetails().getId().toString());
                break;
            case EDGE_CASE:
                document = Document.builder().documentType(DocumentType.EDGE_CASE).build();
                break;
            case GRANT_OF_PROBATE:
            default:
                template = DIGITAL_GRANT_DRAFT_REISSUE;
                Map<String, Object> images = new HashMap<>();
                images.put(CREST_IMAGE, CREST_FILE_PATH);
                images.put(SEAL_IMAGE, SEAL_FILE_PATH);
                Map<String, Object> placeholders = genericMapperService.caseDataWithImages(images, caseDetails);
                document = pdfManagementService.generateDocmosisDocumentAndUpload(placeholders, template, true);
                log.info("Generated and Uploaded Grant of Probate preview document with template {} for the case id {}",
                        template.getTemplateName(), callbackRequest.getCaseDetails().getId().toString());
                break;
        }

        expireDrafts(callbackRequest);

        return document;
    }

    private void expireDrafts(CallbackRequest callbackRequest) {
        DocumentType[] documentTypes = {DIGITAL_GRANT_DRAFT, INTESTACY_GRANT_DRAFT, ADMON_WILL_GRANT_DRAFT, DIGITAL_GRANT_DRAFT_REISSUE};
        for (DocumentType documentType : documentTypes) {
            documentService.expire(callbackRequest, documentType);
        }
    }

    private CaseDetails getRegistryDetails(CaseDetails caseDetails) {
        Registry registry = registriesProperties.getRegistries().get(
                caseDetails.getData().getRegistryLocation().toLowerCase());
        caseDetails.setRegistryTelephone(registry.getPhone());
        caseDetails.setRegistryAddressLine1(registry.getAddressLine1());
        caseDetails.setRegistryAddressLine2(registry.getAddressLine2());
        caseDetails.setRegistryAddressLine3(registry.getAddressLine3());
        caseDetails.setRegistryAddressLine4(registry.getAddressLine4());
        caseDetails.setRegistryPostcode(registry.getPostcode());
        caseDetails.setRegistryTown(registry.getTown());

        Registry ctscRegistry = registriesProperties.getRegistries().get(CTSC);
        caseDetails.setCtscTelephone(ctscRegistry.getPhone());

        return caseDetails;
    }
}
