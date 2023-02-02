package ru.zakazsharovekb.airdelivery.service.parser;

import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import javax.net.ssl.HttpsURLConnection;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

@Slf4j
public class YandexDiskDownload {
    private static final String DEBUG_TOKEN = "y0_AgAAAAAJdy2aAAj5XwAAAADZCGF1DakuqitSQeqJfHqISFhL1i2HKzE";
    static String filename = "Наши миллиардные заказы.xlsx";
    static String urlRequest = "https://cloud-api.yandex.net/v1/disk/resources/download?path=/";

    public static InputStream getFileFromYandexDisk() throws IOException {

        WebClient client = WebClient.create();
        Mono<String> responses = client
                .get()
                .uri(urlRequest + filename)
                .header("Authorization", "OAuth " + DEBUG_TOKEN)
                .exchangeToMono(response -> {
                    if (response.statusCode().equals(HttpStatus.OK)) {
                        return response.bodyToMono(String.class);
                    } else if (response.statusCode().is4xxClientError()) {
                        return Mono.just("Error response");
                    } else {
                        return response.createException()
                                .flatMap(Mono::error);
                    }
                });
//        String fileUrl = URLDecoder.decode(, StandardCharsets.UTF_8.name());
        URL url = new URL(new JSONObject(responses.block()).getString("href"));
        URLConnection urlConn = url.openConnection();
        HttpsURLConnection httpsConn = (HttpsURLConnection) urlConn;
        httpsConn.setRequestMethod("GET");
        httpsConn.setRequestProperty("Authorization", "OAuth " + DEBUG_TOKEN);
        httpsConn.connect();
        InputStream inputStream = httpsConn.getInputStream();
        return inputStream;
    }


}