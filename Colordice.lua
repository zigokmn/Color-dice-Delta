
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#090611">
<title>COLOR DICE - Neon Arcade</title>

<style>
:root {
  --bg: #090611;
  --panel: #171024;
  --pink: #ff36c7;
  --cyan: #24f5ff;
  --yellow: #ffe45c;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  padding: 20px 12px 35px;
  color: white;
  background:
    radial-gradient(ellipse at top, #38104d 0%, transparent 55%),
    #090611;
  font-family: "Trebuchet MS", Arial, sans-serif;
  text-align: center;
}

button {
  font: inherit;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}

.container {
  max-width: 760px;
  margin: auto;
}

.topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 40px;
}

.brand {
  color: var(--cyan);
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 3px;
}

.mute {
  color: white;
  background: #ffffff10;
  border: 1px solid #ffffff35;
  border-radius: 30px;
  padding: 10px 13px;
  font-size: 11px;
  font-weight: bold;
}

.eyebrow {
  color: var(--yellow);
  font-size: 11px;
  font-weight: 900;
  letter-spacing: 5px;
}

h1 {
  margin: 12px 0;
  font-size: clamp(43px, 11vw, 82px);
  font-weight: 1000;
  font-style: italic;
  line-height: 1;
  letter-spacing: -3px;
  text-shadow: 3px 4px #82158d, 0 0 30px #ff36c766;
}

h1 span {
  color: var(--pink);
}

.subtitle {
  margin: 18px 0 30px;
  color: #b9abc9;
  font-size: 12px;
  letter-spacing: 2px;
}

.game {
  padding: clamp(16px, 5vw, 32px);
  border: 1px solid #ffffff25;
  border-radius: 25px;
  background: linear-gradient(145deg, #1d142bee, #100a19ee);
  box-shadow: 0 20px 60px #0008;
}

.label {
  margin-bottom: 25px;
  color: #a99bbf;
  font-size: 11px;
  font-weight: bold;
  letter-spacing: 3px;
}

.dice {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: clamp(7px, 2vw, 17px);
}

.die {
  --c: #ff304f;
  position: relative;
  display: flex;
  aspect-ratio: 1;
  min-width: 0;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border: 2px solid #ffffff80;
  border-radius: 22%;
  background: linear-gradient(145deg, #ffffff65, transparent 40%),
              var(--c);
  box-shadow:
    inset 0 -7px #0002,
    0 7px 0 #0006,
    0 0 22px color-mix(in srgb, var(--c), transparent 35%);
  transition: background .12s;
}

.die::before {
  content: "";
  position: absolute;
  top: 10%;
  left: 12%;
  width: 38%;
  height: 13%;
  border-radius: 50%;
  background: #ffffff80;
  filter: blur(4px);
  transform: rotate(-35deg);
}

.symbol {
  position: relative;
  margin-top: -10px;
  font-size: clamp(23px, 6vw, 46px);
  font-weight: 1000;
  text-shadow: 0 3px 5px #0005;
}

.die-name {
  position: absolute;
  bottom: 10%;
  width: 100%;
  font-size: clamp(8px, 1.8vw, 12px);
  font-weight: 900;
  text-shadow: 0 2px 4px #0008;
}

.rolling {
  animation: wobble .14s infinite alternate;
}

@keyframes wobble {
  from { transform: rotate(-8deg) scale(.94); }
  to   { transform: rotate(8deg) scale(1.04); }
}

.status {
  min-height: 20px;
  margin: 28px 0 18px;
  color: var(--cyan);
  font-size: 11px;
  font-weight: bold;
  letter-spacing: 3px;
}

.roll {
  width: 100%;
  max-width: 360px;
  min-height: 65px;
  border: 0;
  border-radius: 15px;
  color: white;
  background: linear-gradient(100deg, #ff32c7, #a83aff);
  box-shadow: 0 6px #701a85, 0 12px 30px #ff36c733;
  font-size: 21px;
  font-weight: 1000;
  letter-spacing: 5px;
  transition: .15s;
}

.roll:hover:not(:disabled) {
  transform: translateY(-3px);
  filter: brightness(1.15);
}

.roll:active:not(:disabled) {
  transform: translateY(4px);
  box-shadow: 0 2px #701a85;
}

.roll:disabled {
  opacity: .7;
  cursor: wait;
}

.reset {
  margin-top: 20px;
  padding: 12px 25px;
  color: #ddd3eb;
  background: #ffffff08;
  border: 1px solid #ffffff35;
  border-radius: 12px;
  font-size: 11px;
  font-weight: bold;
  letter-spacing: 2px;
}

.reset:hover, .mute:hover {
  border-color: var(--cyan);
}

.result-box {
  margin-top: 25px;
  padding: 20px 10px;
  border: 1px solid #ffffff15;
  border-radius: 16px;
  background: #08051099;
}

.result-title {
  margin-bottom: 12px;
  color: #9b8bac;
  font-size: 10px;
  font-weight: bold;
  letter-spacing: 4px;
}

.result {
  font-size: clamp(12px, 3vw, 19px);
  font-weight: 900;
  line-height: 1.8;
  overflow-wrap: anywhere;
}

.result-color {
  white-space: nowrap;
}

.palette {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 24px;
}

.chip {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 7px 10px;
  border: 1px solid #ffffff15;
  border-radius: 30px;
  color: #c6b9d5;
  font-size: 10px;
  font-weight: bold;
}

.swatch {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: var(--c);
  box-shadow: 0 0 8px var(--c);
}

footer {
  margin-top: 28px;
  color: #796b88;
  font-size: 10px;
  letter-spacing: 2px;
}

footer span {
  color: var(--pink);
}

@media (max-width: 380px) {
  .game { padding: 16px 10px; }
  .die-name { font-size: 8px; }
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: .01ms !important;
  }
}
</style>
</head>

<body>
<main class="container">

  <header class="topbar">
    <div class="brand">★ NEON ARCADE</div>
    <button class="mute" id="mute">🔊 SOUND ON</button>
  </header>

  <div class="eyebrow">✦ THE COLOR CHALLENGE ✦</div>
  <h1>COLOR <span>DICE</span></h1>
  <p class="subtitle">4 DICE · 6 COLORS · INFINITE FUN</p>

  <section class="game">
    <div class="label">— YOUR DICE ARE READY —</div>

    <!-- Genau vier Würfel -->
    <div class="dice" id="dice">
      <div class="die">
        <span class="symbol">★</span>
        <span class="die-name">Rot</span>
      </div>
      <div class="die">
        <span class="symbol">★</span>
        <span class="die-name">Orange</span>
      </div>
      <div class="die">
        <span class="symbol">★</span>
        <span class="die-name">Blau</span>
      </div>
      <div class="die">
        <span class="symbol">★</span>
        <span class="die-name">Lila</span>
      </div>
    </div>

    <div class="status" id="status" aria-live="polite">
      READY? LET'S ROLL!
    </div>

    <button class="roll" id="roll">🎲 ROLL</button>
    <br>
    <button class="reset" id="reset">↻ RESET</button>

    <div class="result-box" aria-live="polite">
      <div class="result-title">✦ LAST RESULT ✦</div>
      <div class="result" id="result"></div>
    </div>

    <div class="palette">
      <div class="chip"><i class="swatch" style="--c:#ff304f"></i>Rot</div>
      <div class="chip"><i class="swatch" style="--c:#ff872d"></i>Orange</div>
      <div class="chip"><i class="swatch" style="--c:#ffe45c"></i>Gold</div>
      <div class="chip"><i class="swatch" style="--c:#31ed82"></i>Grün</div>
      <div class="chip"><i class="swatch" style="--c:#318cff"></i>Blau</div>
      <div class="chip"><i class="swatch" style="--c:#bc56ff"></i>Lila</div>
    </div>
  </section>

  <footer><span>COLOR DICE</span> · ROLL YOUR LUCK · PLAY AGAIN</footer>
</main>

<script>
"use strict";

// ========================================
// EINSTELLUNGEN: Hier kannst du Farben ändern
// ========================================
const COLORS = [
  { name: "Rot",    hex: "#ff304f" },
  { name: "Orange", hex: "#ff872d" },
  { name: "Gold",   hex: "#ffe45c" },
  { name: "Grün",   hex: "#31ed82" },
  { name: "Blau",   hex: "#318cff" },
  { name: "Lila",   hex: "#bc56ff" }
];

const ROLL_DURATION = 1200;
const FRAME_SPEED = 90;

const dice = Array.from(document.querySelectorAll(".die"));
const rollButton = document.getElementById("roll");
const resetButton = document.getElementById("reset");
const muteButton = document.getElementById("mute");
const statusText = document.getElementById("status");
const resultText = document.getElementById("result");

let currentColors = [];
let previousColors = [];
let isRolling = false;
let muted = false;
let audioContext = null;
let frameTimer = null;
let finishTimer = null;
let rollId = 0;

// ========================================
// ZUFALL: vier verschiedene Farben
// ========================================
function makeColors(previous = []) {
  let shuffled;

  do {
    shuffled = [...COLORS];

    // Fisher-Yates Shuffle
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] =
        [shuffled[j], shuffled[i]];
    }
  } while (
    previous.length === 4 &&
    shuffled.every((color, i) => color.name === previous[i].name)
  );

  // Die ersten vier Farben sind immer unterschiedlich.
  return shuffled.slice(0, 4);
}

// ========================================
// WÜRFEL UND ERGEBNIS ANZEIGEN
// ========================================
function displayColors(colors, animate = false) {
  dice.forEach((die, index) => {
    const color = colors[index];

    die.style.setProperty("--c", color.hex);
    die.querySelector(".die-name").textContent = color.name;

    if (animate) {
      die.classList.remove("pop");
      void die.offsetWidth;
      die.classList.add("pop");
    }
  });

  resultText.replaceChildren();

  colors.forEach((color, index) => {
    const item = document.createElement("span");
    item.className = "result-color";
    item.textContent = color.name;
    item.style.color = color.hex;
    resultText.appendChild(item);

    if (index < colors.length - 1) {
      const separator = document.createElement("span");
      separator.className = "dot";
      separator.textContent = " · ";
      resultText.appendChild(separator);
    }
  });
}

// ========================================
// OPTIONALER SOUND MIT WEB AUDIO
// Kein externes Audio-Asset erforderlich
// ========================================
function playSound(frequency = 440, duration = 0.12) {
  if (muted) return;

  try {
    const AudioCtx =
      window.AudioContext || window.webkitAudioContext;

    if (!AudioCtx) return;

    if (!audioContext) audioContext = new AudioCtx();

    if (audioContext.state === "suspended") {
      audioContext.resume();
    }

    const oscillator = audioContext.createOscillator();
    const gain = audioContext.createGain();

    oscillator.type = "triangle";
    oscillator.frequency.value = frequency;

    gain.gain.setValueAtTime(0.08, audioContext.currentTime);
    gain.gain.exponentialRampToValueAtTime(
      0.001,
      audioContext.currentTime + duration
    );

    oscillator.connect(gain);
    gain.connect(audioContext.destination);

    oscillator.start();
    oscillator.stop(audioContext.currentTime + duration);
  } catch (error) {
    // Das Spiel funktioniert auch ohne Sound.
  }
}

// ========================================
// WÜRFEL ROLLEN
// ========================================
function rollDice() {
  if (isRolling) return;

  isRolling = true;
  rollId++;

  const thisRoll = rollId;

  rollButton.disabled = true;
  rollButton.textContent = "🎲 ROLLING...";
  statusText.textContent = "GOOD LUCK! ✨";

  dice.forEach(die => die.classList.add("rolling"));

  const start = performance.now();

  // Alle Animationsframes zeigen vier verschiedene Farben.
  frameTimer = setInterval(() => {
    if (thisRoll !== rollId) return;

    currentColors = makeColors(currentColors);
    displayColors(currentColors);
    playSound(240 + Math.random() * 450, 0.04);
  }, FRAME_SPEED);

  finishTimer = setTimeout(() => {
    if (thisRoll !== rollId) return;

    clearInterval(frameTimer);
    frameTimer = null;
    finishTimer = null;

    let finalColors = makeColors(previousColors);

    // Sicherheit: nie zweimal die gleiche Reihenfolge.
    if (
      previousColors.length === 4 &&
      finalColors.every((c, i) => c.name === previousColors[i].name)
    ) {
      finalColors = makeColors(previousColors);
    }

    previousColors = [...finalColors];
    currentColors = [...finalColors];

    displayColors(finalColors, true);

    dice.forEach(die => die.classList.remove("rolling"));

    statusText.textContent = "✦ RESULT LOCKED IN! ✦";
    rollButton.disabled = false;
    rollButton.textContent = "🎲 ROLL";
    isRolling = false;

    playSound(660, 0.18);
  }, Math.max(0, ROLL_DURATION - (performance.now() - start)));
}

// ========================================
// RESET: Spiel in den Startzustand setzen
// ========================================
function resetGame() {
  // Alte Animationen ungültig machen.
  rollId++;

  clearInterval(frameTimer);
  clearTimeout(finishTimer);
  frameTimer = null;
  finishTimer = null;

  isRolling = false;
  rollButton.disabled = false;
  rollButton.textContent = "🎲 ROLL";

  dice.forEach(die => {
    die.classList.remove("rolling", "pop");
  });

  currentColors = makeColors();
  previousColors = [...currentColors];

  displayColors(currentColors);

  statusText.textContent = "READY? LET'S ROLL!";
  playSound(350, 0.08);
}

// ========================================
// BUTTONS
// ========================================
rollButton.addEventListener("click", rollDice);

resetButton.addEventListener("click", resetGame);

muteButton.addEventListener("click", () => {
  muted = !muted;

  muteButton.textContent = muted
    ? "🔇 SOUND OFF"
    : "🔊 SOUND ON";

  muteButton.setAttribute("aria-pressed", String(muted));

  if (!muted) playSound(500, 0.1);
});

// ========================================
// STARTZUSTAND
// ========================================
currentColors = makeColors();
previousColors = [...currentColors];
displayColors(currentColors);
</script>
</body>
</html>
