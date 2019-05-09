package uk.gov.hmcts.probate.service.docmosis;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import uk.gov.hmcts.probate.config.properties.registries.RegistriesProperties;
import uk.gov.hmcts.probate.config.properties.registries.Registry;
import uk.gov.hmcts.probate.model.ccd.caveat.request.CaveatDetails;

import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class CaveatDocmosisService {
    private final RegistriesProperties registriesProperties;

    public Map<String, Object> caseDataAsPlaceholders(CaveatDetails caveatDetails) {

        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> placeholders = mapper.convertValue(caveatDetails.getData(), Map.class);

        Registry registry = registriesProperties.getRegistries().get(
                caveatDetails.getData().getRegistryLocation().toLowerCase());
        Map<String, Object> registryPlaceholders = mapper.convertValue(registry, Map.class);

        placeholders.put("registry", registryPlaceholders);
        placeholders.put("PA8AURL", "www.citizensadvice.org.uk|https://www.citizensadvice.org.uk/");
        placeholders.put("hmctsfamily", "userImage:hmctsfamily.png");
        return placeholders;
    }

}
