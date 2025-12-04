#!/bin/bash

# Generate Draw.io diagrams for MicroServeThat
# Usage: ./generate-diagrams.sh
# Output: Creates .drawio files that can be opened in draw.io or VS Code with Draw.io extension

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/diagrams"

mkdir -p "$OUTPUT_DIR"

echo "🎨 Generating MicroServeThat diagrams..."

# =============================================================================
# DATA FLOW DIAGRAM
# =============================================================================
cat > "$OUTPUT_DIR/data-flow-diagram.drawio" << 'EOF'
<mxfile host="app.diagrams.net" modified="2024-12-04T00:00:00.000Z" agent="MicroServeThat Generator" etag="microservethat-dataflow" version="22.1.0" type="device">
  <diagram name="Data Flow" id="data-flow-diagram">
    <mxGraphModel dx="1434" dy="780" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="900" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        
        <!-- Title -->
        <mxCell id="title" value="MicroServeThat - Data Flow Diagram" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=24;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="500" y="20" width="400" height="40" as="geometry" />
        </mxCell>
        
        <!-- User/Frontend -->
        <mxCell id="user" value="👤 User" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="80" y="200" width="40" height="80" as="geometry" />
        </mxCell>
        
        <mxCell id="frontend" value="Frontend&#xa;(Next.js)&#xa;Port 3000" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="160" y="200" width="100" height="80" as="geometry" />
        </mxCell>
        
        <!-- API Gateway -->
        <mxCell id="gateway" value="API Gateway&#xa;Port 9000&#xa;&#xa;• Routing&#xa;• Auth (JWT)&#xa;• Circuit Breaker" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontStyle=1;align=center;" vertex="1" parent="1">
          <mxGeometry x="320" y="180" width="140" height="120" as="geometry" />
        </mxCell>
        
        <!-- Keycloak -->
        <mxCell id="keycloak" value="🔐 Keycloak&#xa;Port 8181&#xa;(OAuth2/JWT)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="320" y="360" width="140" height="70" as="geometry" />
        </mxCell>
        
        <!-- Product Service -->
        <mxCell id="product-svc" value="Product Service&#xa;Port 8080&#xa;&#xa;GET /api/product&#xa;POST /api/product" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="540" y="80" width="140" height="100" as="geometry" />
        </mxCell>
        
        <mxCell id="mongodb" value="MongoDB&#xa;(Products)" style="shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="720" y="80" width="80" height="80" as="geometry" />
        </mxCell>
        
        <!-- Order Service -->
        <mxCell id="order-svc" value="Order Service&#xa;Port 8081&#xa;&#xa;POST /api/order" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="540" y="200" width="140" height="100" as="geometry" />
        </mxCell>
        
        <mxCell id="order-mysql" value="MySQL&#xa;(Orders)" style="shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
          <mxGeometry x="720" y="200" width="80" height="80" as="geometry" />
        </mxCell>
        
        <!-- Inventory Service -->
        <mxCell id="inventory-svc" value="Inventory Service&#xa;Port 8082&#xa;&#xa;GET /api/inventory" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="540" y="340" width="140" height="100" as="geometry" />
        </mxCell>
        
        <mxCell id="inventory-mysql" value="MySQL&#xa;(Inventory)" style="shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
          <mxGeometry x="720" y="340" width="80" height="80" as="geometry" />
        </mxCell>
        
        <!-- Kafka -->
        <mxCell id="kafka" value="Apache Kafka&#xa;Topic: order-placed&#xa;(Async Messaging)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="900" y="200" width="140" height="80" as="geometry" />
        </mxCell>
        
        <!-- Notification Service -->
        <mxCell id="notification-svc" value="Notification Service&#xa;Port 8083&#xa;&#xa;Kafka Consumer&#xa;Email Sender" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="1100" y="200" width="140" height="100" as="geometry" />
        </mxCell>
        
        <mxCell id="email" value="📧 Email&#xa;(SMTP)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1" parent="1">
          <mxGeometry x="1280" y="220" width="80" height="60" as="geometry" />
        </mxCell>
        
        <!-- Observability -->
        <mxCell id="observability" value="Observability Stack&#xa;&#xa;Prometheus (Metrics)&#xa;Grafana (Dashboards)&#xa;Tempo (Tracing)&#xa;Loki (Logs)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="900" y="380" width="140" height="100" as="geometry" />
        </mxCell>
        
        <!-- Arrows -->
        <!-- User to Frontend -->
        <mxCell id="arrow1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#333333;" edge="1" parent="1" source="user" target="frontend">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Frontend to Gateway -->
        <mxCell id="arrow2" value="REST" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#333333;" edge="1" parent="1" source="frontend" target="gateway">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Gateway to Keycloak -->
        <mxCell id="arrow3" value="JWT Validation" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#b85450;dashed=1;" edge="1" parent="1" source="gateway" target="keycloak">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Gateway to Services -->
        <mxCell id="arrow4" value="1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="gateway" target="product-svc">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="arrow5" value="2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="gateway" target="order-svc">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="arrow6" value="3" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="gateway" target="inventory-svc">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Services to Databases -->
        <mxCell id="arrow7" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#82b366;" edge="1" parent="1" source="product-svc" target="mongodb">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="arrow8" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#d6b656;" edge="1" parent="1" source="order-svc" target="order-mysql">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="arrow9" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#d6b656;" edge="1" parent="1" source="inventory-svc" target="inventory-mysql">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Order to Inventory (Sync) -->
        <mxCell id="arrow10" value="SYNC&#xa;Stock Check" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=3;strokeColor=#b85450;fontStyle=1" edge="1" parent="1" source="order-svc" target="inventory-svc">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Order to Kafka (Async) -->
        <mxCell id="arrow11" value="ASYNC&#xa;OrderPlacedEvent" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=3;strokeColor=#9673a6;fontStyle=1" edge="1" parent="1" source="order-svc" target="kafka">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Kafka to Notification -->
        <mxCell id="arrow12" value="Consume" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#9673a6;" edge="1" parent="1" source="kafka" target="notification-svc">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Notification to Email -->
        <mxCell id="arrow13" value="Send" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#666666;" edge="1" parent="1" source="notification-svc" target="email">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- All services to Observability -->
        <mxCell id="arrow14" value="Metrics/Traces/Logs" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=1;strokeColor=#d79b00;dashed=1;" edge="1" parent="1" source="order-svc" target="observability">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Legend -->
        <mxCell id="legend-box" value="" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1" parent="1">
          <mxGeometry x="40" y="480" width="200" height="140" as="geometry" />
        </mxCell>
        <mxCell id="legend-title" value="Legend" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontStyle=1;fontSize=14" vertex="1" parent="1">
          <mxGeometry x="100" y="485" width="80" height="20" as="geometry" />
        </mxCell>
        <mxCell id="legend1" value="→ Synchronous (REST)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="510" width="150" height="20" as="geometry" />
        </mxCell>
        <mxCell id="legend2" value="→ Asynchronous (Kafka)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="535" width="150" height="20" as="geometry" />
        </mxCell>
        <mxCell id="legend3" value="- - → Auth/Observability" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="560" width="150" height="20" as="geometry" />
        </mxCell>
        <mxCell id="legend4" value="🔵 Microservices" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="585" width="150" height="20" as="geometry" />
        </mxCell>
        
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF

echo "✅ Created: $OUTPUT_DIR/data-flow-diagram.drawio"

# =============================================================================
# ORDER PROCESS FLOW DIAGRAM
# =============================================================================
cat > "$OUTPUT_DIR/order-process-flow.drawio" << 'EOF'
<mxfile host="app.diagrams.net" modified="2024-12-04T00:00:00.000Z" agent="MicroServeThat Generator" etag="microservethat-processflow" version="22.1.0" type="device">
  <diagram name="Order Process Flow" id="order-process-flow">
    <mxGraphModel dx="1434" dy="780" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="1000" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        
        <!-- Title -->
        <mxCell id="title" value="MicroServeThat - Order Process Flow" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=24;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="450" y="20" width="400" height="40" as="geometry" />
        </mxCell>
        
        <!-- Swimlanes -->
        <mxCell id="swimlane-user" value="User / Frontend" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="80" width="1300" height="120" as="geometry" />
        </mxCell>
        
        <mxCell id="swimlane-gateway" value="API Gateway" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="200" width="1300" height="120" as="geometry" />
        </mxCell>
        
        <mxCell id="swimlane-order" value="Order Service" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="320" width="1300" height="140" as="geometry" />
        </mxCell>
        
        <mxCell id="swimlane-inventory" value="Inventory Service" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="460" width="1300" height="120" as="geometry" />
        </mxCell>
        
        <mxCell id="swimlane-kafka" value="Kafka" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="580" width="1300" height="100" as="geometry" />
        </mxCell>
        
        <mxCell id="swimlane-notification" value="Notification Service" style="swimlane;horizontal=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="40" y="680" width="1300" height="120" as="geometry" />
        </mxCell>
        
        <!-- Process Steps -->
        <!-- Start -->
        <mxCell id="start" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#000000;" vertex="1" parent="1">
          <mxGeometry x="100" y="125" width="30" height="30" as="geometry" />
        </mxCell>
        
        <!-- Step 1: User clicks Order -->
        <mxCell id="step1" value="1. Click&#xa;Order Now" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="170" y="115" width="80" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 2: Send Request -->
        <mxCell id="step2" value="2. POST /api/order&#xa;{skuCode, qty, price}" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="290" y="110" width="120" height="60" as="geometry" />
        </mxCell>
        
        <!-- Step 3: Gateway receives -->
        <mxCell id="step3" value="3. Validate JWT&#xa;Route to Order Svc" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
          <mxGeometry x="290" y="235" width="120" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 4: Order Service receives -->
        <mxCell id="step4" value="4. Receive&#xa;Order Request" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="290" y="360" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 5: Call Inventory -->
        <mxCell id="step5" value="5. Check Stock&#xa;(Sync REST Call)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="430" y="360" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 6: Inventory Check -->
        <mxCell id="step6" value="6. Query DB&#xa;skuCode + qty" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="430" y="495" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Decision: In Stock? -->
        <mxCell id="decision" value="In&#xa;Stock?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
          <mxGeometry x="570" y="350" width="80" height="70" as="geometry" />
        </mxCell>
        
        <!-- Step 7a: Not in stock -->
        <mxCell id="step7a" value="7a. Return Error&#xa;&#34;Out of Stock&#34;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
          <mxGeometry x="680" y="425" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 7b: Save Order -->
        <mxCell id="step7b" value="7b. Save Order&#xa;to MySQL" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="700" y="360" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 8: Publish to Kafka -->
        <mxCell id="step8" value="8. Publish&#xa;OrderPlacedEvent" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="840" y="360" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 9: Kafka receives -->
        <mxCell id="step9" value="9. Message in&#xa;&#34;order-placed&#34; topic" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
          <mxGeometry x="840" y="610" width="120" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 10: Return Success -->
        <mxCell id="step10" value="10. Return&#xa;&#34;Order Placed&#34;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="980" y="360" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 11: Gateway Response -->
        <mxCell id="step11" value="11. Forward&#xa;Response" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
          <mxGeometry x="980" y="235" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 12: Show Success -->
        <mxCell id="step12" value="12. Show&#xa;Success Message" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="980" y="115" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 13: Notification consumes -->
        <mxCell id="step13" value="13. Consume&#xa;Event" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="1000" y="615" width="80" height="50" as="geometry" />
        </mxCell>
        
        <!-- Step 14: Send Email -->
        <mxCell id="step14" value="14. Send&#xa;Confirmation Email" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="1000" y="720" width="100" height="50" as="geometry" />
        </mxCell>
        
        <!-- End -->
        <mxCell id="end" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#000000;strokeWidth=3;" vertex="1" parent="1">
          <mxGeometry x="1200" y="130" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="end-ring" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=none;strokeWidth=2;" vertex="1" parent="1">
          <mxGeometry x="1195" y="125" width="40" height="40" as="geometry" />
        </mxCell>
        
        <!-- Arrows -->
        <mxCell id="a1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="start" target="step1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step1" target="step2">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a3" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step2" target="step3">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a4" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step3" target="step4">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a5" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step4" target="step5">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a6" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step5" target="step6">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a7" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step6" target="decision">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="550" y="520" />
              <mxPoint x="550" y="385" />
            </Array>
          </mxGeometry>
        </mxCell>
        
        <mxCell id="a8a" value="NO" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#b85450;fontStyle=1" edge="1" parent="1" source="decision" target="step7a">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a8b" value="YES" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#82b366;fontStyle=1" edge="1" parent="1" source="decision" target="step7b">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a9" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step7b" target="step8">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a10" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#9673a6;" edge="1" parent="1" source="step8" target="step9">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a11" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step8" target="step10">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a12" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step10" target="step11">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a13" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step11" target="step12">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a14" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step12" target="end">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a15" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#9673a6;" edge="1" parent="1" source="step9" target="step13">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="a16" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;" edge="1" parent="1" source="step13" target="step14">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- Async label -->
        <mxCell id="async-label" value="⚡ ASYNC PATH (Non-blocking)" style="text;html=1;strokeColor=none;fillColor=#e1d5e7;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=1;fontStyle=1;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="1100" y="610" width="180" height="30" as="geometry" />
        </mxCell>
        
        <!-- Sync label -->
        <mxCell id="sync-label" value="🔄 SYNC PATH (Blocking)" style="text;html=1;strokeColor=none;fillColor=#fff2cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=1;fontStyle=1;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="430" y="420" width="150" height="30" as="geometry" />
        </mxCell>
        
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF

echo "✅ Created: $OUTPUT_DIR/order-process-flow.drawio"

# =============================================================================
# CIRCUIT BREAKER FLOW DIAGRAM
# =============================================================================
cat > "$OUTPUT_DIR/circuit-breaker-flow.drawio" << 'EOF'
<mxfile host="app.diagrams.net" modified="2024-12-04T00:00:00.000Z" agent="MicroServeThat Generator" etag="microservethat-circuitbreaker" version="22.1.0" type="device">
  <diagram name="Circuit Breaker Pattern" id="circuit-breaker-flow">
    <mxGraphModel dx="1200" dy="700" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1200" pageHeight="700" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        
        <!-- Title -->
        <mxCell id="title" value="Circuit Breaker Pattern - Resilience4J" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=20;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="400" y="20" width="400" height="30" as="geometry" />
        </mxCell>
        
        <!-- CLOSED State -->
        <mxCell id="closed" value="CLOSED&#xa;(Normal)" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;fontSize=14" vertex="1" parent="1">
          <mxGeometry x="200" y="150" width="120" height="80" as="geometry" />
        </mxCell>
        <mxCell id="closed-desc" value="✓ Requests pass through&#xa;✓ Failures counted&#xa;✓ Normal operation" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="160" y="240" width="150" height="60" as="geometry" />
        </mxCell>
        
        <!-- OPEN State -->
        <mxCell id="open" value="OPEN&#xa;(Failing)" style="ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;fontStyle=1;fontSize=14" vertex="1" parent="1">
          <mxGeometry x="540" y="150" width="120" height="80" as="geometry" />
        </mxCell>
        <mxCell id="open-desc" value="✗ Requests fail fast&#xa;✗ No calls to service&#xa;✗ Return fallback" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="510" y="240" width="150" height="60" as="geometry" />
        </mxCell>
        
        <!-- HALF-OPEN State -->
        <mxCell id="half-open" value="HALF-OPEN&#xa;(Testing)" style="ellipse;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontStyle=1;fontSize=14" vertex="1" parent="1">
          <mxGeometry x="880" y="150" width="120" height="80" as="geometry" />
        </mxCell>
        <mxCell id="half-open-desc" value="? Allow few test requests&#xa;? Check if service recovered&#xa;? Decide next state" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="850" y="240" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- Transitions -->
        <!-- CLOSED -> OPEN -->
        <mxCell id="t1" value="Failure threshold&#xa;exceeded (e.g., 5 fails)" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#b85450;fontStyle=1;curved=1" edge="1" parent="1" source="closed" target="open">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="400" y="120" />
            </Array>
          </mxGeometry>
        </mxCell>
        
        <!-- OPEN -> HALF-OPEN -->
        <mxCell id="t2" value="Wait timeout&#xa;(e.g., 30 seconds)" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#d6b656;fontStyle=1;curved=1" edge="1" parent="1" source="open" target="half-open">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="730" y="120" />
            </Array>
          </mxGeometry>
        </mxCell>
        
        <!-- HALF-OPEN -> CLOSED -->
        <mxCell id="t3" value="Test requests&#xa;succeed" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#82b366;fontStyle=1;curved=1" edge="1" parent="1" source="half-open" target="closed">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="600" y="350" />
              <mxPoint x="260" y="350" />
            </Array>
          </mxGeometry>
        </mxCell>
        
        <!-- HALF-OPEN -> OPEN -->
        <mxCell id="t4" value="Test requests fail" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=2;strokeColor=#b85450;fontStyle=1;curved=1;dashed=1" edge="1" parent="1" source="half-open" target="open">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="730" y="250" />
            </Array>
          </mxGeometry>
        </mxCell>
        
        <!-- Code Example Box -->
        <mxCell id="code-box" value="" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1" parent="1">
          <mxGeometry x="120" y="400" width="960" height="220" as="geometry" />
        </mxCell>
        <mxCell id="code-title" value="MicroServeThat Implementation" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontStyle=1;fontSize=14" vertex="1" parent="1">
          <mxGeometry x="140" y="410" width="300" height="20" as="geometry" />
        </mxCell>
        <mxCell id="code" value="// InventoryClient.java (Order Service)&#xa;@CircuitBreaker(name = &quot;inventory&quot;, fallbackMethod = &quot;fallbackMethod&quot;)&#xa;@Retry(name = &quot;inventory&quot;)&#xa;boolean isInStock(String skuCode, Integer quantity);&#xa;&#xa;default boolean fallbackMethod(String code, Integer qty, Throwable t) {&#xa;    log.warn(&quot;Circuit breaker fallback for {}: {}&quot;, code, t.getMessage());&#xa;    return false;  // Safe default: assume out of stock&#xa;}&#xa;&#xa;// Routes.java (API Gateway)&#xa;.filter(circuitBreaker(&quot;productServiceCircuitBreaker&quot;, &#xa;        URI.create(&quot;forward:/fallbackRoute&quot;)))" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=top;whiteSpace=wrap;rounded=0;fontFamily=Courier New;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="140" y="440" width="600" height="170" as="geometry" />
        </mxCell>
        
        <!-- Benefits Box -->
        <mxCell id="benefits-box" value="" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="760" y="440" width="300" height="160" as="geometry" />
        </mxCell>
        <mxCell id="benefits-title" value="Why Circuit Breaker?" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontStyle=1;fontSize=12" vertex="1" parent="1">
          <mxGeometry x="780" y="450" width="200" height="20" as="geometry" />
        </mxCell>
        <mxCell id="benefits" value="✓ Prevents cascading failures&#xa;✓ Fails fast (no waiting)&#xa;✓ Auto-recovery when service heals&#xa;✓ Graceful degradation&#xa;✓ Protects system resources" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=top;whiteSpace=wrap;rounded=0;fontSize=11" vertex="1" parent="1">
          <mxGeometry x="780" y="480" width="250" height="100" as="geometry" />
        </mxCell>
        
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF

echo "✅ Created: $OUTPUT_DIR/circuit-breaker-flow.drawio"

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "🎉 All diagrams generated successfully!"
echo ""
echo "📁 Output directory: $OUTPUT_DIR"
echo ""
echo "📄 Generated files:"
ls -la "$OUTPUT_DIR"/*.drawio
echo ""
echo "📌 How to use:"
echo "   1. Open in VS Code with 'Draw.io Integration' extension"
echo "   2. Open in browser at https://app.diagrams.net"
echo "   3. Export to PNG/SVG/PDF from Draw.io"
echo ""
echo "💡 To export to PNG from command line (requires draw.io desktop):"
echo "   drawio -x -f png -o diagram.png diagram.drawio"
