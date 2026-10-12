/**
 * Unit V: Web Programming using React
 * - Components and Elements of React
 * - Rendering Components
 * - React State and Props
 * - React Hooks (useState, useEffect) - Lab Experiment 10
 * Real-time Telemetry & Live Ping Widget for Client Health Dashboard
 */

(function () {
    const e = React.createElement;
    const { useState, useEffect } = React;

    function TelemetryWidget(props) {
        // State variables using React Hooks (useState)
        const [telemetry, setTelemetry] = useState({
            responseTimeMs: 248,
            uptimePercentage: 99.98,
            pageSpeedScore: 92,
            status: "Healthy",
            lastChecked: "Just now"
        });
        const [isPinging, setIsPinging] = useState(false);
        const [history, setHistory] = useState([240, 255, 238, 260, 248]);

        // Function to perform live ping via AJAX fetch to HealthPingServlet
        const performPing = () => {
            setIsPinging(true);
            const siteId = props.siteId || 1;

            fetch("ping?id=" + siteId)
                .then(res => res.json())
                .then(data => {
                    setTelemetry(data);
                    setIsPinging(false);
                    setHistory(prev => [...prev.slice(1), data.responseTimeMs]);
                })
                .catch(err => {
                    console.error("Ping error:", err);
                    setIsPinging(false);
                });
        };

        // React Hook: useEffect for automatic initial telemetry load and periodic polling
        useEffect(() => {
            performPing();
            const interval = setInterval(performPing, 20000); // 20s heartbeat
            return () => clearInterval(interval);
        }, [props.siteId]);

        // Component Elements & Rendering
        return e("div", { className: "react-telemetry-card", style: {
            background: "#FFFFFF",
            borderRadius: "12px",
            padding: "1.75rem",
            boxShadow: "0 4px 6px -1px rgba(0,0,0,0.07)",
            border: "1px solid #E2E8F0"
        }},
            // Card Header
            e("div", { style: { display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1.25rem", borderBottom: "1px solid #F1F5F9", paddingBottom: "0.75rem" }},
                e("div", null,
                    e("h3", { style: { color: "#0A2540", fontSize: "1.15rem", fontWeight: "700", margin: 0 }}, "Live Health Monitor & Synthetic Ping"),
                    e("span", { style: { fontSize: "0.78rem", color: "#64748B" }}, "Real-time 24/7 uptime and latency monitoring")
                ),
                e("button", {
                    onClick: performPing,
                    disabled: isPinging,
                    style: {
                        background: isPinging ? "#94A3B8" : "#0A2540",
                        color: "#FFFFFF",
                        border: "none",
                        padding: "0.5rem 1rem",
                        borderRadius: "8px",
                        fontSize: "0.85rem",
                        fontWeight: "600",
                        cursor: isPinging ? "not-allowed" : "pointer",
                        display: "flex",
                        alignItems: "center",
                        gap: "6px"
                    }
                }, isPinging ? "Testing Ping..." : "⚡ Run Live Ping")
            ),

            // Metrics Row
            e("div", { style: { display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: "1rem", marginBottom: "1.25rem" }},
                // Metric 1: Uptime
                e("div", { style: { background: "#F8FAFC", padding: "1rem", borderRadius: "8px", textAlign: "center", border: "1px solid #E2E8F0" }},
                    e("div", { style: { fontSize: "1.6rem", fontWeight: "800", color: "#10B981" }}, telemetry.uptimePercentage + "%"),
                    e("div", { style: { fontSize: "0.75rem", color: "#64748B", fontWeight: "600", textTransform: "uppercase" }}, "Uptime (Last 30 Days)")
                ),
                // Metric 2: Response Latency
                e("div", { style: { background: "#F8FAFC", padding: "1rem", borderRadius: "8px", textAlign: "center", border: "1px solid #E2E8F0" }},
                    e("div", { style: { fontSize: "1.6rem", fontWeight: "800", color: "#0A2540" }}, telemetry.responseTimeMs + " ms"),
                    e("div", { style: { fontSize: "0.75rem", color: "#64748B", fontWeight: "600", textTransform: "uppercase" }}, "Server Latency")
                ),
                // Metric 3: PageSpeed
                e("div", { style: { background: "#F8FAFC", padding: "1rem", borderRadius: "8px", textAlign: "center", border: "1px solid #E2E8F0" }},
                    e("div", { style: { fontSize: "1.6rem", fontWeight: "800", color: "#00A88F" }}, telemetry.pageSpeedScore + "/100"),
                    e("div", { style: { fontSize: "0.75rem", color: "#64748B", fontWeight: "600", textTransform: "uppercase" }}, "Performance Score")
                )
            ),

            // Live Latency Trend Sparkline (SVG)
            e("div", { style: { background: "#F8FAFC", padding: "0.75rem 1rem", borderRadius: "8px", border: "1px solid #E2E8F0" }},
                e("div", { style: { display: "flex", justifyContent: "space-between", fontSize: "0.78rem", color: "#64748B", marginBottom: "6px" }},
                    e("span", { style: { fontWeight: "600" }}, "Recent Ping Pulse:"),
                    e("span", null, "Updated: " + telemetry.lastChecked)
                ),
                e("div", { style: { display: "flex", alignItems: "flex-end", gap: "6px", height: "40px" }},
                    history.map((val, idx) => 
                        e("div", {
                            key: idx,
                            title: val + " ms",
                            style: {
                                flex: 1,
                                height: Math.min(100, Math.max(20, (val / 400) * 100)) + "%",
                                background: idx === history.length - 1 ? "#00D4B2" : "#94A3B8",
                                borderRadius: "3px 3px 0 0",
                                transition: "all 0.3s ease"
                            }
                        })
                    )
                )
            )
        );
    }

    // Mount React Component to DOM
    document.addEventListener("DOMContentLoaded", function () {
        const rootElement = document.getElementById("react-telemetry-root");
        if (rootElement) {
            const siteId = rootElement.getAttribute("data-site-id") || 1;
            ReactDOM.render(e(TelemetryWidget, { siteId: siteId }), rootElement);
        }
    });
})();
