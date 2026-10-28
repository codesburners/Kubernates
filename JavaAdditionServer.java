import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;

public class JavaAdditionServer {
    public static void main(String[] args) throws IOException {
        int port = 8080;
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", new HttpHandler() {
            @Override
            public void handle(HttpExchange exchange) throws IOException {
                URI uri = exchange.getRequestURI();
                String query = uri.getQuery();
                int num1 = 15;
                int num2 = 25;

                if (query != null) {
                    Map<String, String> params = parseQuery(query);
                    if (params.containsKey("a")) {
                        try { num1 = Integer.parseInt(params.get("a")); } catch (Exception ignored) {}
                    }
                    if (params.containsKey("b")) {
                        try { num2 = Integer.parseInt(params.get("b")); } catch (Exception ignored) {}
                    }
                }

                int sum = num1 + num2;

                String html = "<!DOCTYPE html><html><head><title>Java Addition Microservice</title>"
                    + "<style>"
                    + "body { font-family: -apple-system, sans-serif; background: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }"
                    + ".card { background: #1e293b; padding: 36px 40px; border-radius: 16px; border: 1px solid #334155; text-align: center; max-width: 480px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }"
                    + "h1 { color: #38bdf8; font-size: 1.8rem; margin-bottom: 8px; }"
                    + ".badge { background: #10b981; color: #022c22; font-weight: bold; font-size: 0.8rem; padding: 4px 10px; border-radius: 20px; text-transform: uppercase; }"
                    + ".calc-box { margin: 24px 0; padding: 18px; background: #0f172a; border-radius: 10px; border: 1px solid #475569; }"
                    + ".equation { font-size: 1.6rem; font-weight: bold; color: #facc15; margin: 10px 0; }"
                    + "form { margin-top: 20px; display: flex; gap: 10px; justify-content: center; }"
                    + "input { padding: 10px; width: 80px; border-radius: 6px; border: 1px solid #475569; background: #1e293b; color: white; text-align: center; font-size: 1rem; }"
                    + "button { padding: 10px 18px; border-radius: 6px; border: none; background: #38bdf8; color: #0f172a; font-weight: bold; cursor: pointer; font-size: 1rem; }"
                    + "footer { margin-top: 20px; font-size: 0.8rem; color: #64748b; }"
                    + "</style></head><body>"
                    + "<div class='card'>"
                    + "<span class='badge'>Java Microservice in Kubernetes</span>"
                    + "<h1>Java Addition Service</h1>"
                    + "<p style='color: #94a3b8;'>Running in Docker Container &amp; Orchestrated by Kubernetes</p>"
                    + "<div class='calc-box'>"
                    + "<div>Calculation Result:</div>"
                    + "<div class='equation'>" + num1 + " + " + num2 + " = " + sum + "</div>"
                    + "<div style='color: #4ade80;'>Status: Success (200 OK)</div>"
                    + "</div>"
                    + "<form method='GET'>"
                    + "<input type='number' name='a' value='" + num1 + "' required />"
                    + "<span style='font-size: 1.5rem; line-height: 2;'>+</span>"
                    + "<input type='number' name='b' value='" + num2 + "' required />"
                    + "<button type='submit'>Calculate</button>"
                    + "</form>"
                    + "<footer>Deployed via Jenkins CI/CD Pipeline</footer>"
                    + "</div></body></html>";

                byte[] responseBytes = html.getBytes("UTF-8");
                exchange.getResponseHeaders().set("Content-Type", "text/html; charset=UTF-8");
                exchange.sendResponseHeaders(200, responseBytes.length);
                OutputStream os = exchange.getResponseBody();
                os.write(responseBytes);
                os.close();
            }

            private Map<String, String> parseQuery(String query) {
                Map<String, String> map = new HashMap<>();
                for (String param : query.split("&")) {
                    String[] pair = param.split("=");
                    if (pair.length > 1) {
                        map.put(pair[0], pair[1]);
                    }
                }
                return map;
            }
        });

        server.setExecutor(null);
        System.out.println("Java Addition HTTP Server running on port " + port);
        server.start();
    }
}
