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
  <title>Your Server is Live!</title>
  <link href="https://fonts.googleapis.com/css2?family=Bangers&family=Comic+Neue:wght@400;700&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --red: #e62429;
      --darkred: #a01018;
      --blue: #1a3a8c;
      --yellow: #f5d800;
      --black: #0a0a0a;
      --white: #fff;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      background-color: var(--red);
      font-family: 'Comic Neue', cursive;
      min-height: 100vh;
      overflow-x: hidden;
      background-image:
        repeating-linear-gradient(0deg, transparent, transparent 59px, rgba(0,0,0,0.08) 59px, rgba(0,0,0,0.08) 60px),
        repeating-linear-gradient(90deg, transparent, transparent 59px, rgba(0,0,0,0.08) 59px, rgba(0,0,0,0.08) 60px);
    }

    /* Web lines across top */
    .web-top {
      position: fixed;
      top: 0; left: 0; right: 0;
      height: 220px;
      pointer-events: none;
      z-index: 10;
    }

    /* Halftone dots bg overlay */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background-image: radial-gradient(circle, rgba(0,0,0,0.15) 1.5px, transparent 1.5px);
      background-size: 18px 18px;
      pointer-events: none;
      z-index: 0;
    }

    .scene {
      position: relative;
      z-index: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 40px 20px 60px;
    }

    /* BOOM caption box */
    .caption-box {
      background: var(--yellow);
      border: 4px solid var(--black);
      border-radius: 6px;
      padding: 6px 18px;
      font-family: 'Bangers', cursive;
      font-size: 15px;
      letter-spacing: 2px;
      color: var(--black);
      margin-bottom: 16px;
      box-shadow: 4px 4px 0 var(--black);
      animation: fadeDown 0.5s ease both;
    }

    /* Main speech bubble */
    .bubble {
      background: var(--white);
      border: 5px solid var(--black);
      border-radius: 24px;
      padding: 36px 44px;
      max-width: 560px;
      width: 100%;
      text-align: center;
      position: relative;
      box-shadow: 8px 8px 0 var(--black);
      animation: popIn 0.5s cubic-bezier(.36,1.56,.64,1) 0.2s both;
    }

    /* Bubble tail */
    .bubble::after {
      content: '';
      position: absolute;
      bottom: -38px;
      left: 50%;
      transform: translateX(-50%);
      border: 18px solid transparent;
      border-top: 22px solid var(--black);
    }
    .bubble::before {
      content: '';
      position: absolute;
      bottom: -28px;
      left: 50%;
      transform: translateX(-50%);
      border: 14px solid transparent;
      border-top: 18px solid var(--white);
      z-index: 1;
    }

    .bubble h1 {
      font-family: 'Bangers', cursive;
      font-size: 52px;
      color: var(--red);
      letter-spacing: 3px;
      line-height: 1.05;
      -webkit-text-stroke: 2px var(--black);
      text-shadow: 4px 4px 0 var(--black);
      margin-bottom: 8px;
      animation: wiggle 3s ease-in-out 1s infinite;
    }

    .bubble p {
      font-size: 16px;
      color: #222;
      line-height: 1.6;
      font-weight: 700;
      margin-bottom: 24px;
    }

    /* Stats grid */
    .stats {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-top: 4px;
    }

    .stat {
      background: var(--blue);
      border: 3px solid var(--black);
      border-radius: 10px;
      padding: 12px 10px;
      box-shadow: 3px 3px 0 var(--black);
      transition: transform 0.15s ease, box-shadow 0.15s ease;
      cursor: default;
    }
    .stat:hover {
      transform: translate(-2px, -2px);
      box-shadow: 5px 5px 0 var(--black);
    }

    .stat-label {
      font-family: 'Bangers', cursive;
      font-size: 11px;
      letter-spacing: 2px;
      color: var(--yellow);
      display: block;
      margin-bottom: 2px;
    }
    .stat-value {
      font-family: 'Bangers', cursive;
      font-size: 20px;
      color: var(--white);
      letter-spacing: 1px;
    }

    /* Status badge */
    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: #1aab3a;
      border: 3px solid var(--black);
      border-radius: 99px;
      padding: 6px 16px;
      margin-bottom: 20px;
      box-shadow: 3px 3px 0 var(--black);
      font-family: 'Bangers', cursive;
      font-size: 16px;
      letter-spacing: 1px;
      color: var(--white);
    }
    .ping {
      width: 10px; height: 10px;
      background: var(--yellow);
      border-radius: 50%;
      border: 2px solid var(--black);
      animation: ping 1.2s ease-in-out infinite;
    }
    @keyframes ping {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.4; transform: scale(0.7); }
    }

    /* Spidey SVG */
    .spidey-wrap {
      margin-top: 52px;
      animation: swingIn 0.8s cubic-bezier(.36,1.4,.64,1) 0.6s both;
    }

    /* SFX burst */
    .sfx {
      font-family: 'Bangers', cursive;
      font-size: 54px;
      letter-spacing: 4px;
      -webkit-text-stroke: 3px var(--black);
      text-shadow: 5px 5px 0 var(--black);
      color: var(--yellow);
      margin-top: -10px;
      animation: sfxPop 0.6s cubic-bezier(.36,1.6,.64,1) 1s both;
      line-height: 1;
    }

    /* Footer */
    .footer-note {
      margin-top: 28px;
      font-family: 'Bangers', cursive;
      font-size: 13px;
      letter-spacing: 2px;
      color: rgba(255,255,255,0.55);
    }

    @keyframes popIn {
      from { opacity: 0; transform: scale(0.5) rotate(-4deg); }
      to   { opacity: 1; transform: scale(1) rotate(0deg); }
    }
    @keyframes fadeDown {
      from { opacity: 0; transform: translateY(-16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes swingIn {
      from { opacity: 0; transform: translateY(-60px) rotate(10deg); }
      to   { opacity: 1; transform: translateY(0) rotate(0deg); }
    }
    @keyframes sfxPop {
      from { opacity: 0; transform: scale(0.3) rotate(-8deg); }
      to   { opacity: 1; transform: scale(1) rotate(-2deg); }
    }
    @keyframes wiggle {
      0%, 100% { transform: rotate(-1deg); }
      50%       { transform: rotate(1deg); }
    }
    @keyframes webSwing {
      0%, 100% { transform: rotate(-6deg); }
      50%       { transform: rotate(6deg); }
    }
  </style>
</head>
<body>

<!-- Web SVG top-left -->
<svg class="web-top" viewBox="0 0 800 220" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#000" stroke-width="2.5" opacity="0.18">
    <line x1="0" y1="0" x2="200" y2="220"/>
    <line x1="80" y1="0" x2="280" y2="220"/>
    <line x1="160" y1="0" x2="340" y2="220"/>
    <line x1="240" y1="0" x2="420" y2="220"/>
    <line x1="0" y1="30" x2="420" y2="30"/>
    <line x1="0" y1="80" x2="420" y2="80"/>
    <line x1="0" y1="140" x2="420" y2="140"/>
    <line x1="0" y1="200" x2="420" y2="200"/>
    <path d="M0 30 Q100 55 200 30 Q300 5 400 30" fill="none"/>
    <path d="M0 80 Q100 105 200 80 Q300 55 400 80" fill="none"/>
    <path d="M0 140 Q100 165 200 140 Q300 115 400 140" fill="none"/>
  </g>
</svg>

<div class="scene">
  <div class="caption-box">AMAZING EC2 COMICS PRESENTS...</div>

  <div class="bubble">
    <div class="status-badge">
      <div class="ping"></div>
      SERVER IS LIVE
    </div>

    <h1>YOUR FRIENDLY<br>NEIGHBORHOOD<br>NGINX!</h1>
    <p>With great compute power<br>comes great responsibility.</p>

    <div class="stats">
      <div class="stat">
        <span class="stat-label">SERVER</span>
        <div class="stat-value">NGINX</div>
      </div>
      <div class="stat">
        <span class="stat-label">PLATFORM</span>
        <div class="stat-value">AMAZON LINUX</div>
      </div>
      <div class="stat">
        <span class="stat-label">PORT</span>
        <div class="stat-value">:80</div>
      </div>
      <div class="stat">
        <span class="stat-label">DEPLOY</span>
        <div class="stat-value">USER DATA</div>
      </div>
    </div>
  </div>

  <!-- Spiderman SVG figure -->
  <div class="spidey-wrap">
    <svg width="160" height="200" viewBox="0 0 160 200" xmlns="http://www.w3.org/2000/svg" style="animation: webSwing 3s ease-in-out infinite;">
      <!-- Web line hanging -->
      <line x1="80" y1="0" x2="80" y2="30" stroke="#000" stroke-width="3"/>
      <!-- Body -->
      <ellipse cx="80" cy="90" rx="28" ry="36" fill="#e62429" stroke="#000" stroke-width="3"/>
      <!-- Head -->
      <ellipse cx="80" cy="50" rx="22" ry="24" fill="#e62429" stroke="#000" stroke-width="3"/>
      <!-- Eyes (white lens) -->
      <ellipse cx="70" cy="48" rx="10" ry="7" fill="white" stroke="#000" stroke-width="2" transform="rotate(-10,70,48)"/>
      <ellipse cx="90" cy="48" rx="10" ry="7" fill="white" stroke="#000" stroke-width="2" transform="rotate(10,90,48)"/>
      <!-- Eye shine -->
      <ellipse cx="69" cy="47" rx="4" ry="3" fill="#aad4f5" opacity="0.7" transform="rotate(-10,69,47)"/>
      <ellipse cx="89" cy="47" rx="4" ry="3" fill="#aad4f5" opacity="0.7" transform="rotate(10,89,47)"/>
      <!-- Web lines on head -->
      <line x1="80" y1="26" x2="80" y2="74" stroke="#000" stroke-width="1.2" opacity="0.5"/>
      <line x1="58" y1="34" x2="102" y2="66" stroke="#000" stroke-width="1.2" opacity="0.5"/>
      <line x1="102" y1="34" x2="58" y2="66" stroke="#000" stroke-width="1.2" opacity="0.5"/>
      <path d="M59 42 Q80 38 101 42" fill="none" stroke="#000" stroke-width="1.2" opacity="0.5"/>
      <path d="M59 58 Q80 54 101 58" fill="none" stroke="#000" stroke-width="1.2" opacity="0.5"/>
      <!-- Blue chest panel -->
      <ellipse cx="80" cy="90" rx="16" ry="20" fill="#1a3a8c" stroke="#000" stroke-width="2"/>
      <!-- Spider logo -->
      <text x="80" y="96" text-anchor="middle" font-size="18" fill="black">✦</text>
      <!-- Arms -->
      <line x1="52" y1="75" x2="20" y2="55" stroke="#e62429" stroke-width="10" stroke-linecap="round"/>
      <line x1="20" y1="55" x2="8" y2="70" stroke="#e62429" stroke-width="8" stroke-linecap="round"/>
      <line x1="108" y1="75" x2="145" y2="100" stroke="#e62429" stroke-width="10" stroke-linecap="round"/>
      <line x1="145" y1="100" x2="155" y2="90" stroke="#e62429" stroke-width="8" stroke-linecap="round"/>
      <!-- Web from hand -->
      <line x1="8" y1="70" x2="0" y2="20" stroke="#888" stroke-width="1.5" stroke-dasharray="3,2"/>
      <!-- Legs -->
      <line x1="68" y1="124" x2="50" y2="165" stroke="#e62429" stroke-width="10" stroke-linecap="round"/>
      <line x1="50" y1="165" x2="38" y2="190" stroke="#1a3a8c" stroke-width="9" stroke-linecap="round"/>
      <line x1="92" y1="124" x2="110" y2="165" stroke="#e62429" stroke-width="10" stroke-linecap="round"/>
      <line x1="110" y1="165" x2="122" y2="190" stroke="#1a3a8c" stroke-width="9" stroke-linecap="round"/>
    </svg>
  </div>

  <div class="sfx">THWIP!</div>

  <p class="footer-note">DEPLOYED ON INSTANCE LAUNCH — NO SPIDER BITE REQUIRED</p>
</div>

</body>
</html>
HTMLEOF

systemctl enable nginx
systemctl start nginx

echo "=== Spidey nginx setup complete: $(date) ==="