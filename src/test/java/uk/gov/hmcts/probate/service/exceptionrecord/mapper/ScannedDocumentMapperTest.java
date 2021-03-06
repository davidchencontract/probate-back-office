package uk.gov.hmcts.probate.service.exceptionrecord.mapper;

import org.junit.Test;
import uk.gov.hmcts.probate.model.exceptionrecord.InputScannedDoc;
import uk.gov.hmcts.reform.probate.model.ScannedDocument;
import uk.gov.hmcts.reform.probate.model.cases.CollectionMember;
import uk.gov.hmcts.reform.probate.model.cases.DocumentLink;

import static java.time.LocalDateTime.now;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class ScannedDocumentMapperTest {

    private ScannedDocumentMapper scannedDocumentMapper = new ScannedDocumentMapper();

    private static final String DOC_NAME_PREFIX1 = "Test1";

    @Test
    public void testScannedDocument() {
        InputScannedDoc inputDoc = getSampleInputDocument(DOC_NAME_PREFIX1);
        CollectionMember<ScannedDocument> scannedDocumentCollectionMember
                = scannedDocumentMapper.toCaseDoc(inputDoc,null);
        assertEquals("type" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getType());
        assertEquals("subtype" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getSubtype());
        assertEquals("url" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getUrl().getDocumentUrl());
        assertEquals("binary" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getUrl().getDocumentBinaryUrl());
        assertEquals("filename" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getUrl().getDocumentFilename());
        assertEquals("dcn" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getControlNumber());
        assertEquals("filename" + DOC_NAME_PREFIX1, scannedDocumentCollectionMember.getValue().getFileName());
    }

    @Test
    public void testNoScannedDocument() {
        CollectionMember<ScannedDocument> scannedDocumentCollectionMember
                = scannedDocumentMapper.toCaseDoc(null,null);
        assertNull(scannedDocumentCollectionMember);
    }

    public static InputScannedDoc getSampleInputDocument(String suffix) {
        DocumentLink documentLink = DocumentLink.builder()
                .documentUrl("url" + suffix)
                .documentBinaryUrl("binary" + suffix)
                .documentFilename("filename" + suffix).build();
        return new InputScannedDoc(
                "type" + suffix,
                "subtype" + suffix,
                documentLink,
                "dcn" + suffix,
                "filename" + suffix,
                now(),
                now()
        );
    }
}
