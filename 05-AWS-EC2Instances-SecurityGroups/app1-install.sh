#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y nginx

cat > /usr/share/nginx/html/index.html <<'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EC2 Instance Online</title>
  <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Orbitron:wght@400;700;900&family=Rajdhani:wght@300;400;600;700&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --neon-green: #00ff88;
      --neon-blue: #00d4ff;
      --neon-pink: #ff2d78;
      --neon-yellow: #ffe600;
      --dark: #020810;
      --panel: rgba(0,255,136,0.04);
      --border: rgba(0,255,136,0.25);
      --glow-green: 0 0 8px #00ff88, 0 0 24px #00ff8866, 0 0 60px #00ff8822;
      --glow-blue: 0 0 8px #00d4ff, 0 0 24px #00d4ff66;
      --glow-pink: 0 0 8px #ff2d78, 0 0 30px #ff2d7866;
    }

    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    html, body {
      width: 100%; height: 100%;
      background: var(--dark);
      color: var(--neon-green);
      font-family: 'Share Tech Mono', monospace;
      overflow-x: hidden;
    }

    /* ── CANVAS BACKGROUND ── */
    #matrix-canvas {
      position: fixed;
      inset: 0;
      opacity: 0.07;
      pointer-events: none;
      z-index: 0;
    }

    /* ── SCANLINES OVERLAY ── */
    .scanlines {
      position: fixed;
      inset: 0;
      background: repeating-linear-gradient(
        to bottom,
        transparent 0px,
        transparent 3px,
        rgba(0,0,0,0.18) 3px,
        rgba(0,0,0,0.18) 4px
      );
      pointer-events: none;
      z-index: 100;
      animation: scanMove 8s linear infinite;
    }
    @keyframes scanMove {
      0% { background-position: 0 0; }
      100% { background-position: 0 100px; }
    }

    /* ── VIGNETTE ── */
    .vignette {
      position: fixed;
      inset: 0;
      background: radial-gradient(ellipse at center, transparent 50%, rgba(0,0,0,0.85) 100%);
      pointer-events: none;
      z-index: 1;
    }

    /* ── GRID FLOOR ── */
    .grid-floor {
      position: fixed;
      bottom: 0; left: 0; right: 0;
      height: 45vh;
      background:
        linear-gradient(to bottom, transparent 0%, rgba(0,255,136,0.04) 100%),
        repeating-linear-gradient(90deg, rgba(0,255,136,0.06) 0px, transparent 1px, transparent 80px, rgba(0,255,136,0.06) 81px),
        repeating-linear-gradient(0deg, rgba(0,255,136,0.06) 0px, transparent 1px, transparent 50px, rgba(0,255,136,0.06) 51px);
      transform: perspective(600px) rotateX(55deg);
      transform-origin: bottom center;
      pointer-events: none;
      z-index: 0;
    }

    /* ── MAIN LAYOUT ── */
    .page {
      position: relative;
      z-index: 2;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: flex-start;
      padding: 40px 20px 120px;
    }

    /* ── TOP STATUS BAR ── */
    .status-bar {
      width: 100%;
      max-width: 980px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border);
      padding-bottom: 12px;
      margin-bottom: 48px;
      font-size: 11px;
      letter-spacing: 2px;
      color: rgba(0,255,136,0.5);
    }
    .status-bar .live {
      display: flex;
      align-items: center;
      gap: 8px;
      color: var(--neon-green);
    }
    .pulse-dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: var(--neon-green);
      box-shadow: var(--glow-green);
      animation: pulseDot 1.4s ease-in-out infinite;
    }
    @keyframes pulseDot {
      0%,100% { opacity:1; transform: scale(1); }
      50% { opacity:0.3; transform: scale(0.6); }
    }

    /* ── HERO SECTION ── */
    .hero {
      text-align: center;
      margin-bottom: 60px;
      animation: fadeUp 0.8s ease 0.2s both;
    }

    .hero-eyebrow {
      font-family: 'Orbitron', monospace;
      font-size: 11px;
      letter-spacing: 6px;
      color: var(--neon-blue);
      text-shadow: var(--glow-blue);
      margin-bottom: 20px;
      opacity: 0.8;
    }

    .hero-title {
      font-family: 'Orbitron', monospace;
      font-weight: 900;
      font-size: clamp(44px, 9vw, 110px);
      line-height: 0.95;
      letter-spacing: -1px;
      color: #fff;
      margin-bottom: 24px;
      position: relative;
    }
    .hero-title .line1 {
      display: block;
      -webkit-text-stroke: 1px var(--neon-green);
      color: transparent;
      text-shadow: none;
      filter: drop-shadow(0 0 18px var(--neon-green));
      animation: glitchTitle 6s ease-in-out infinite;
    }
    .hero-title .line2 {
      display: block;
      color: #fff;
      text-shadow: 0 0 40px rgba(0,212,255,0.4);
    }
    .hero-title .line3 {
      display: block;
      -webkit-text-stroke: 1px var(--neon-pink);
      color: transparent;
      filter: drop-shadow(0 0 14px var(--neon-pink));
    }

    @keyframes glitchTitle {
      0%,90%,100% { transform: translateX(0) skew(0deg); filter: drop-shadow(0 0 18px var(--neon-green)); }
      91% { transform: translateX(-4px) skew(-1deg); filter: drop-shadow(4px 0 0 var(--neon-pink)) drop-shadow(-4px 0 0 var(--neon-blue)); }
      93% { transform: translateX(4px) skew(1deg); }
      95% { transform: translateX(0) skew(0deg); filter: drop-shadow(0 0 18px var(--neon-green)); }
    }

    .hero-sub {
      font-family: 'Rajdhani', sans-serif;
      font-size: clamp(15px, 2.5vw, 22px);
      font-weight: 300;
      letter-spacing: 3px;
      color: rgba(255,255,255,0.45);
      text-transform: uppercase;
    }

    /* ── BIG STATUS CARD ── */
    .status-card {
      width: 100%;
      max-width: 980px;
      border: 1px solid var(--border);
      background: var(--panel);
      backdrop-filter: blur(8px);
      border-radius: 2px;
      padding: 40px;
      position: relative;
      margin-bottom: 32px;
      animation: fadeUp 0.8s ease 0.5s both;
      overflow: hidden;
    }
    .status-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 1px;
      background: linear-gradient(90deg, transparent, var(--neon-green), transparent);
      animation: scanH 3s ease-in-out infinite;
    }
    @keyframes scanH {
      0%,100% { opacity: 0.4; transform: translateX(-100%); }
      50% { opacity: 1; transform: translateX(100%); }
    }
    .status-card::after {
      content: 'SYS_STATUS';
      position: absolute;
      top: 16px; right: 24px;
      font-size: 10px;
      letter-spacing: 3px;
      color: rgba(0,255,136,0.2);
      font-family: 'Orbitron', monospace;
    }

    .card-header {
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: 36px;
    }
    .online-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(0,255,136,0.1);
      border: 1px solid var(--neon-green);
      padding: 6px 18px;
      font-family: 'Orbitron', monospace;
      font-size: 12px;
      letter-spacing: 3px;
      color: var(--neon-green);
      text-shadow: var(--glow-green);
      box-shadow: inset 0 0 20px rgba(0,255,136,0.05), 0 0 20px rgba(0,255,136,0.1);
    }
    .card-header-label {
      font-family: 'Rajdhani', sans-serif;
      font-size: 28px;
      font-weight: 700;
      letter-spacing: 4px;
      color: rgba(255,255,255,0.85);
      text-transform: uppercase;
    }

    /* ── METRICS GRID ── */
    .metrics {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1px;
      background: var(--border);
      border: 1px solid var(--border);
      margin-bottom: 32px;
    }
    @media (max-width: 700px) {
      .metrics { grid-template-columns: repeat(2, 1fr); }
    }
    .metric {
      background: var(--dark);
      padding: 24px 20px;
      position: relative;
      overflow: hidden;
      transition: background 0.2s;
    }
    .metric:hover { background: rgba(0,255,136,0.04); }
    .metric-accent {
      position: absolute;
      bottom: 0; left: 0;
      height: 2px;
      background: linear-gradient(90deg, var(--neon-green), transparent);
      width: 60%;
    }
    .metric-label {
      font-family: 'Orbitron', monospace;
      font-size: 9px;
      letter-spacing: 3px;
      color: rgba(0,255,136,0.4);
      margin-bottom: 10px;
      text-transform: uppercase;
    }
    .metric-value {
      font-family: 'Orbitron', monospace;
      font-size: clamp(15px, 2.5vw, 22px);
      font-weight: 700;
      color: #fff;
      letter-spacing: 1px;
      line-height: 1.1;
    }
    .metric-value.green { color: var(--neon-green); text-shadow: var(--glow-green); }
    .metric-value.blue  { color: var(--neon-blue);  text-shadow: var(--glow-blue); }
    .metric-value.pink  { color: var(--neon-pink);  text-shadow: var(--glow-pink); }
    .metric-value.yellow{ color: var(--neon-yellow);text-shadow: 0 0 8px #ffe600, 0 0 24px #ffe60044; }
    .metric-sub {
      font-size: 10px;
      color: rgba(255,255,255,0.25);
      letter-spacing: 1px;
      margin-top: 4px;
    }

    /* ── TERMINAL BOOT LOG ── */
    .terminal {
      width: 100%;
      max-width: 980px;
      border: 1px solid rgba(0,255,136,0.15);
      background: rgba(0,0,0,0.6);
      border-radius: 2px;
      padding: 28px 32px;
      margin-bottom: 32px;
      animation: fadeUp 0.8s ease 0.8s both;
      position: relative;
    }
    .terminal-titlebar {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 20px;
      padding-bottom: 14px;
      border-bottom: 1px solid rgba(0,255,136,0.1);
    }
    .dot { width: 11px; height: 11px; border-radius: 50%; }
    .dot-r { background: #ff5f57; }
    .dot-y { background: #febc2e; }
    .dot-g { background: #28c840; }
    .terminal-title {
      margin-left: 8px;
      font-size: 11px;
      letter-spacing: 2px;
      color: rgba(255,255,255,0.3);
    }
    .log-line {
      font-size: 12px;
      line-height: 2;
      letter-spacing: 0.5px;
      display: flex;
      gap: 12px;
      align-items: baseline;
    }
    .log-time { color: rgba(0,255,136,0.3); min-width: 80px; flex-shrink: 0; }
    .log-tag { min-width: 70px; flex-shrink: 0; }
    .tag-ok    { color: var(--neon-green); }
    .tag-info  { color: var(--neon-blue); }
    .tag-warn  { color: var(--neon-yellow); }
    .tag-boot  { color: var(--neon-pink); }
    .log-msg { color: rgba(255,255,255,0.6); }
    .log-msg strong { color: #fff; }
    .cursor-blink {
      display: inline-block;
      width: 8px; height: 14px;
      background: var(--neon-green);
      margin-left: 4px;
      vertical-align: middle;
      animation: blink 1s step-end infinite;
    }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }

    /* Log line stagger */
    .log-line { opacity: 0; animation: logReveal 0.3s ease forwards; }
    .log-line:nth-child(1)  { animation-delay: 0.1s; }
    .log-line:nth-child(2)  { animation-delay: 0.35s; }
    .log-line:nth-child(3)  { animation-delay: 0.6s; }
    .log-line:nth-child(4)  { animation-delay: 0.85s; }
    .log-line:nth-child(5)  { animation-delay: 1.1s; }
    .log-line:nth-child(6)  { animation-delay: 1.35s; }
    .log-line:nth-child(7)  { animation-delay: 1.6s; }
    .log-line:nth-child(8)  { animation-delay: 1.85s; }
    .log-line:nth-child(9)  { animation-delay: 2.1s; }
    .log-line:nth-child(10) { animation-delay: 2.35s; }
    .log-line:nth-child(11) { animation-delay: 2.6s; }
    @keyframes logReveal {
      from { opacity:0; transform: translateY(4px); }
      to   { opacity:1; transform: translateY(0); }
    }

    /* ── BOTTOM ROW: GAUGE + UPTIME ── */
    .bottom-row {
      width: 100%;
      max-width: 980px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      animation: fadeUp 0.8s ease 1s both;
    }
    @media (max-width: 600px) { .bottom-row { grid-template-columns: 1fr; } }

    .panel {
      border: 1px solid var(--border);
      background: var(--panel);
      padding: 28px 28px;
      position: relative;
      overflow: hidden;
    }
    .panel-label {
      font-family: 'Orbitron', monospace;
      font-size: 9px;
      letter-spacing: 3px;
      color: rgba(0,255,136,0.35);
      margin-bottom: 20px;
    }

    /* Arc gauge */
    .gauge-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
    }
    .gauge-svg { overflow: visible; }
    .gauge-track {
      fill: none;
      stroke: rgba(0,255,136,0.1);
      stroke-width: 10;
      stroke-linecap: round;
    }
    .gauge-fill {
      fill: none;
      stroke: url(#gaugeGrad);
      stroke-width: 10;
      stroke-linecap: round;
      stroke-dasharray: 283;
      stroke-dashoffset: 283;
      animation: gaugeAnim 2s cubic-bezier(.4,0,.2,1) 1.5s forwards;
    }
    @keyframes gaugeAnim {
      to { stroke-dashoffset: 42; } /* ~85% fill */
    }
    .gauge-center {
      font-family: 'Orbitron', monospace;
      font-size: 13px;
      fill: #fff;
      dominant-baseline: middle;
      text-anchor: middle;
    }
    .gauge-pct {
      font-family: 'Orbitron', monospace;
      font-size: 28px;
      font-weight: 700;
      fill: var(--neon-green);
      dominant-baseline: middle;
      text-anchor: middle;
      filter: drop-shadow(0 0 6px var(--neon-green));
    }

    /* Uptime bars */
    .uptime-bars { display: flex; flex-direction: column; gap: 14px; }
    .uptime-row { display: flex; flex-direction: column; gap: 6px; }
    .uptime-row-top {
      display: flex;
      justify-content: space-between;
      font-size: 11px;
      color: rgba(255,255,255,0.5);
      letter-spacing: 1px;
    }
    .uptime-row-top span:last-child { color: var(--neon-green); }
    .bar-track {
      height: 5px;
      background: rgba(0,255,136,0.08);
      border-radius: 99px;
      overflow: hidden;
    }
    .bar-fill {
      height: 100%;
      border-radius: 99px;
      width: 0;
      animation: barGrow 1.5s ease forwards;
    }
    .bar-fill.g { background: linear-gradient(90deg, var(--neon-green), #00ff88cc); animation-delay: 1.2s; --w: 100%; }
    .bar-fill.b { background: linear-gradient(90deg, var(--neon-blue), #00d4ffcc); animation-delay: 1.4s; --w: 78%; }
    .bar-fill.p { background: linear-gradient(90deg, var(--neon-pink), #ff2d78cc); animation-delay: 1.6s; --w: 92%; }
    .bar-fill.y { background: linear-gradient(90deg, var(--neon-yellow), #ffe600cc); animation-delay: 1.8s; --w: 65%; }
    @keyframes barGrow { to { width: var(--w); } }

    /* ── FOOTER ── */
    .footer {
      position: fixed;
      bottom: 0; left: 0; right: 0;
      padding: 14px 32px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(2,8,16,0.95);
      border-top: 1px solid rgba(0,255,136,0.12);
      z-index: 50;
      font-size: 10px;
      letter-spacing: 2px;
      color: rgba(0,255,136,0.3);
    }
    .footer-center {
      font-family: 'Orbitron', monospace;
      font-size: 10px;
      letter-spacing: 3px;
      color: rgba(0,255,136,0.2);
    }
    .footer-right { text-align: right; }

    /* ── CORNER DECORATIONS ── */
    .corner {
      position: absolute;
      width: 20px; height: 20px;
      pointer-events: none;
    }
    .corner-tl { top: 0; left: 0; border-top: 2px solid var(--neon-green); border-left: 2px solid var(--neon-green); }
    .corner-tr { top: 0; right: 0; border-top: 2px solid var(--neon-green); border-right: 2px solid var(--neon-green); }
    .corner-bl { bottom: 0; left: 0; border-bottom: 2px solid var(--neon-green); border-left: 2px solid var(--neon-green); }
    .corner-br { bottom: 0; right: 0; border-bottom: 2px solid var(--neon-green); border-right: 2px solid var(--neon-green); }

    /* ── BIG DECORATIVE RING ── */
    .ring-wrap {
      position: fixed;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      pointer-events: none;
      z-index: 0;
    }
    .ring {
      border-radius: 50%;
      border: 1px solid rgba(0,255,136,0.04);
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%,-50%);
      animation: ringPulse 4s ease-in-out infinite;
    }
    .ring:nth-child(1) { width: 600px; height: 600px; animation-delay: 0s; }
    .ring:nth-child(2) { width: 900px; height: 900px; animation-delay: 1s; border-color: rgba(0,212,255,0.03); }
    .ring:nth-child(3) { width: 1200px; height: 1200px; animation-delay: 2s; }
    @keyframes ringPulse {
      0%,100% { opacity: 1; }
      50% { opacity: 0.3; }
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<!-- Matrix rain -->
<canvas id="matrix-canvas"></canvas>

<!-- Overlays -->
<div class="scanlines"></div>
<div class="vignette"></div>
<div class="grid-floor"></div>

<!-- Decorative rings -->
<div class="ring-wrap">
  <div class="ring"></div>
  <div class="ring"></div>
  <div class="ring"></div>
</div>

<div class="page">

  <!-- Top Bar -->
  <div class="status-bar">
    <span>AWS // EC2 // NGINX // INSTANCE_BOOT</span>
    <span class="live">
      <span class="pulse-dot"></span>
      LIVE FEED
    </span>
    <span id="clock">--:--:-- UTC</span>
  </div>

  <!-- Hero -->
  <div class="hero">
    <div class="hero-eyebrow">▸ AMAZON EC2 INSTANCE INITIALIZED ◂</div>
    <div class="hero-title">
      <span class="line1">SYSTEM</span>
      <span class="line2">ONLINE</span>
      <span class="line3">NGINX</span>
    </div>
    <div class="hero-sub">Instance launched &nbsp;·&nbsp; Web server active &nbsp;·&nbsp; Awaiting requests</div>
  </div>

  <!-- Status Card -->
  <div class="status-card">
    <div class="corner corner-tl"></div>
    <div class="corner corner-tr"></div>
    <div class="corner corner-bl"></div>
    <div class="corner corner-br"></div>

    <div class="card-header">
      <div class="online-badge"><span class="pulse-dot"></span> ONLINE</div>
      <div class="card-header-label">Server Diagnostics</div>
    </div>

    <div class="metrics">
      <div class="metric">
        <div class="metric-accent"></div>
        <div class="metric-label">Web Server</div>
        <div class="metric-value green">NGINX</div>
        <div class="metric-sub">v1.24.x stable</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-blue),transparent)"></div>
        <div class="metric-label">Platform</div>
        <div class="metric-value blue">AMAZON<br>LINUX</div>
        <div class="metric-sub">AL2023</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-pink),transparent)"></div>
        <div class="metric-label">Listening Port</div>
        <div class="metric-value pink">:80</div>
        <div class="metric-sub">HTTP / Public</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-yellow),transparent)"></div>
        <div class="metric-label">Deploy Method</div>
        <div class="metric-value yellow">USER<br>DATA</div>
        <div class="metric-sub">Cloud-init</div>
      </div>
      <div class="metric">
        <div class="metric-accent"></div>
        <div class="metric-label">Cloud Provider</div>
        <div class="metric-value green">AWS</div>
        <div class="metric-sub">Amazon Web Services</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-blue),transparent)"></div>
        <div class="metric-label">Protocol</div>
        <div class="metric-value blue">HTTP/1.1</div>
        <div class="metric-sub">TCP/IP Stack</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-pink),transparent)"></div>
        <div class="metric-label">Init System</div>
        <div class="metric-value pink">SYSTEMD</div>
        <div class="metric-sub">Service: enabled</div>
      </div>
      <div class="metric">
        <div class="metric-accent" style="background:linear-gradient(90deg,var(--neon-yellow),transparent)"></div>
        <div class="metric-label">Uptime Status</div>
        <div class="metric-value yellow">100%</div>
        <div class="metric-sub">Since launch</div>
      </div>
    </div>
  </div>

  <!-- Terminal Log -->
  <div class="terminal">
    <div class="terminal-titlebar">
      <div class="dot dot-r"></div>
      <div class="dot dot-y"></div>
      <div class="dot dot-g"></div>
      <span class="terminal-title">root@ec2-instance — user-data.log</span>
    </div>

    <div class="log-line"><span class="log-time">[00:00.001]</span><span class="log-tag tag-boot">[BOOT]</span><span class="log-msg">EC2 instance startup sequence initiated</span></div>
    <div class="log-line"><span class="log-time">[00:00.024]</span><span class="log-tag tag-info">[INFO]</span><span class="log-msg">Cloud-init executing <strong>user-data</strong> script</span></div>
    <div class="log-line"><span class="log-time">[00:00.210]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">Running: <strong>yum update -y</strong> — package index refreshed</span></div>
    <div class="log-line"><span class="log-time">[00:02.417]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">Running: <strong>yum install -y nginx</strong> — package downloaded</span></div>
    <div class="log-line"><span class="log-time">[00:04.882]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">NGINX installed successfully → <strong>/usr/sbin/nginx</strong></span></div>
    <div class="log-line"><span class="log-time">[00:04.901]</span><span class="log-tag tag-info">[INFO]</span><span class="log-msg">Writing custom <strong>index.html</strong> → /usr/share/nginx/html/</span></div>
    <div class="log-line"><span class="log-time">[00:04.912]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">HTML file written — <strong>4.8 KB</strong></span></div>
    <div class="log-line"><span class="log-time">[00:04.930]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">systemctl <strong>enable</strong> nginx → symlink created in /etc/systemd</span></div>
    <div class="log-line"><span class="log-time">[00:05.142]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">systemctl <strong>start</strong> nginx → worker processes spawned</span></div>
    <div class="log-line"><span class="log-time">[00:05.188]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg">NGINX listening on <strong>0.0.0.0:80</strong> — accepting connections</span></div>
    <div class="log-line"><span class="log-time">[00:05.201]</span><span class="log-tag tag-ok">[ OK ]</span><span class="log-msg"><strong>Setup complete.</strong> Instance ready. <span class="cursor-blink"></span></span></div>
  </div>

  <!-- Bottom Row -->
  <div class="bottom-row">

    <!-- Gauge -->
    <div class="panel">
      <div class="corner corner-tl"></div>
      <div class="corner corner-tr"></div>
      <div class="corner corner-bl"></div>
      <div class="corner corner-br"></div>
      <div class="panel-label">SYSTEM HEALTH SCORE</div>
      <div class="gauge-wrap">
        <svg class="gauge-svg" width="180" height="130" viewBox="0 0 180 130">
          <defs>
            <linearGradient id="gaugeGrad" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" stop-color="#00d4ff"/>
              <stop offset="100%" stop-color="#00ff88"/>
            </linearGradient>
          </defs>
          <path class="gauge-track"
            d="M 25,110 A 70,70 0 1 1 155,110"
            stroke-dasharray="283" stroke-dashoffset="0"/>
          <path class="gauge-fill"
            d="M 25,110 A 70,70 0 1 1 155,110"/>
          <text class="gauge-pct" x="90" y="84">85</text>
          <text class="gauge-center" x="90" y="106" font-size="11" fill="rgba(255,255,255,0.35)">OPTIMAL</text>
        </svg>
        <div style="font-size:11px;letter-spacing:2px;color:rgba(0,255,136,0.5);margin-top:-8px;">ALL SYSTEMS NOMINAL</div>
      </div>
    </div>

    <!-- Uptime bars -->
    <div class="panel">
      <div class="corner corner-tl"></div>
      <div class="corner corner-tr"></div>
      <div class="corner corner-bl"></div>
      <div class="corner corner-br"></div>
      <div class="panel-label">SERVICE READINESS</div>
      <div class="uptime-bars">
        <div class="uptime-row">
          <div class="uptime-row-top"><span>NGINX Process</span><span>100%</span></div>
          <div class="bar-track"><div class="bar-fill g" style="--w:100%"></div></div>
        </div>
        <div class="uptime-row">
          <div class="uptime-row-top"><span>Network Stack</span><span>78%</span></div>
          <div class="bar-track"><div class="bar-fill b" style="--w:78%"></div></div>
        </div>
        <div class="uptime-row">
          <div class="uptime-row-top"><span>Disk I/O</span><span>92%</span></div>
          <div class="bar-track"><div class="bar-fill p" style="--w:92%"></div></div>
        </div>
        <div class="uptime-row">
          <div class="uptime-row-top"><span>Memory Pool</span><span>65%</span></div>
          <div class="bar-track"><div class="bar-fill y" style="--w:65%"></div></div>
        </div>
      </div>
    </div>
  </div>

</div>

<!-- Footer -->
<div class="footer">
  <span>NGINX / AMAZON LINUX / EC2</span>
  <span class="footer-center">▸ DEPLOYED VIA USER DATA ◂</span>
  <span class="footer-right" id="uptime-counter">UPTIME: CALCULATING...</span>
</div>

<script>
// ── Matrix rain canvas ──
(function() {
  const canvas = document.getElementById('matrix-canvas');
  const ctx = canvas.getContext('2d');
  let cols, drops;
  const chars = '01アイウエオカキクケコサシスセソタチツテトナニヌネノ∑≠≡∞∂∇ΔΩ';
  function init() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    cols = Math.floor(canvas.width / 18);
    drops = Array(cols).fill(1);
  }
  function draw() {
    ctx.fillStyle = 'rgba(2,8,16,0.05)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = '#00ff88';
    ctx.font = '14px Share Tech Mono';
    drops.forEach((y, i) => {
      const ch = chars[Math.floor(Math.random() * chars.length)];
      ctx.fillText(ch, i * 18, y * 18);
      if (y * 18 > canvas.height && Math.random() > 0.975) drops[i] = 0;
      drops[i]++;
    });
  }
  init();
  window.addEventListener('resize', init);
  setInterval(draw, 60);
})();

// ── Clock ──
function updateClock() {
  const now = new Date();
  const h = String(now.getUTCHours()).padStart(2,'0');
  const m = String(now.getUTCMinutes()).padStart(2,'0');
  const s = String(now.getUTCSeconds()).padStart(2,'0');
  document.getElementById('clock').textContent = `${h}:${m}:${s} UTC`;
}
setInterval(updateClock, 1000);
updateClock();

// ── Uptime counter ──
const start = Date.now();
function updateUptime() {
  const s = Math.floor((Date.now() - start) / 1000);
  const h = String(Math.floor(s / 3600)).padStart(2,'0');
  const m = String(Math.floor((s % 3600) / 60)).padStart(2,'0');
  const sec = String(s % 60).padStart(2,'0');
  document.getElementById('uptime-counter').textContent = `UPTIME: ${h}:${m}:${sec}`;
}
setInterval(updateUptime, 1000);
</script>
</body>
</html>