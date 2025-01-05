int shipSafeZoneX, shipSafeZoneY;
int shipX, shipY;
int starX, starY, starBonusX, starBonusY;
int meteorX, meteorY, meteorX2, meteorY2, meteorX3, meteorY3, meteorX4, meteorY4, meteorX5, meteorY5, meteorCount;
int score;
int collectedStars;
boolean bonusActive;
int bonusDuration;
boolean shipCollider;
boolean gameRunning;
boolean gameOver;
int screen;
int buttonX, buttonY, buttonWidth, buttonHeight;
PImage playerImage, crystalImage, backgroundImage, meteorImage, shipImage, bonusStarImage, backgroundMenuImage, rulesImage, winnerImage, loserImage;
PFont gameFont;

void setup() {
    size(1000, 800);
    initializeGameWindow();
    initializePlayerSettings();
    initializeMeteorSettings();
    initializeGameState();
    loadAssets();
}

void initializeGameWindow() {
    gameFont = createFont("chinese rocks rg.otf", 32);
    textFont(gameFont);
}

void initializePlayerSettings() {
    shipCollider = false;
    shipX = 800;
    shipY = 700;
    collectedStars = 0;
    shipSafeZoneX = width / 2;
    shipSafeZoneY = height / 2;
    starX = int(random(width));
    starY = 0;
    starBonusX = int(random(width));
    starBonusY = 0;
}

void initializeMeteorSettings() {
    meteorX = int(random(width));
    meteorY = 0;
    meteorX2 = int(random(width));
    meteorY2 = 0;
    meteorX3 = int(random(width));
    meteorY3 = 0;
    meteorX4 = int(random(width));
    meteorY4 = 0;
    meteorX5 = int(random(width));
    meteorY5 = 0;
    meteorCount = 1;
}

void initializeGameState() {
    bonusActive = false;
    bonusDuration = 0;
    score = 0;
    gameRunning = true;
    gameOver = false;
    screen = 0;
    buttonX = width / 2 - 100;
    buttonY = height / 2 - 25;
    buttonWidth = 200;
    buttonHeight = 50;
}

void loadAssets() {
    backgroundImage = loadImage("background.png");
    backgroundMenuImage = loadImage("menu_background.png");
    crystalImage = loadImage("crystal.png");
    shipImage = loadImage("ship.png");
    playerImage = loadImage("player.png");
    meteorImage = loadImage("meteor.png");
    bonusStarImage = loadImage("bonus_star.png");
    rulesImage = loadImage("rules.png");
    winnerImage = loadImage("winner.png");
    loserImage = loadImage("loser.png");
}

void draw() {
    if (screen == 0) {
        displayMenuScreen();
    } else if (screen == 1) {
        displayRulesScreen();
    } else if (screen == 2) {
        playGame();
    }
}

void displayMenuScreen() {
    background(0);
    image(backgroundMenuImage, 0, 0, width, height);
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(255);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    textSize(24);
    fill(0);
    text("Start Game", width / 2, height / 2);
    fill(255);
    rect(buttonX, buttonY + 75, buttonWidth, buttonHeight);
    fill(0);
    text("How to Play", width / 2, height / 2 + 75);

    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
        if (mousePressed) {
            screen = 2;
        }
    }
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY + 75 && mouseY < buttonY + 75 + buttonHeight) {
        if (mousePressed) {
            screen = 1;
        }
    }
}

void displayRulesScreen() {
    background(0);
    image(rulesImage, 0, 0, width, height);
    if (mousePressed) {
        screen = 0;
    }
}

void playGame() {
    background(0, 0, 255);
    image(backgroundImage, 0, 0, width, height);

    if (gameRunning) {
        renderPlayer();
        handlePlayerMovement();
        handleStarCollection();
        handleMeteorMovement();
        handleBonusCollection();
        checkGameOverConditions();
        displayScore();
    } else {
        displayEndScreen();
    }
}

void renderPlayer() {
    fill(0, 0, 255);
    image(shipImage, shipX - 100, shipY - 150, 150, 150);
    fill(255, 255, 0);
    image(playerImage, shipSafeZoneX, shipSafeZoneY, 80, 80);
}

void handlePlayerMovement() {
    if (keyPressed && keyCode == LEFT && shipSafeZoneX > 5) shipSafeZoneX -= 4;
    if (keyPressed && keyCode == RIGHT && shipSafeZoneX < width - 70) shipSafeZoneX += 4;
    if (keyPressed && keyCode == UP && shipSafeZoneY > 5) shipSafeZoneY -= 4;
    if (keyPressed && keyCode == DOWN && shipSafeZoneY < height - 70) shipSafeZoneY += 4;
}

void handleStarCollection() {
    fill(0, 255, 0);
    image(crystalImage, starX, starY, 50, 50);
    starY += 2;
    if (starY > height) {
        starX = int(random(width));
        starY = 0;
    }
    if (abs(shipSafeZoneX - starX) < 50 && abs(shipSafeZoneY - starY) < 50) {
        collectedStars += 1;
        shipCollider = false;
        starX = int(random(width));
        starY = 0;
        adjustMeteorCount();
    }
}

void adjustMeteorCount() {
    if (score >= 100 || collectedStars == 10) meteorCount = 2;
    if (score >= 250 || collectedStars == 15) meteorCount = 3;
    if (score >= 350 || collectedStars == 25) meteorCount = 4;
    if (score >= 450 || collectedStars == 35) meteorCount = 5;
}

void handleMeteorMovement() {
    fill(255, 0, 0);
    moveMeteor(meteorX, meteorY);

    if (meteorCount >= 2) moveMeteor(meteorX2, meteorY2);
    if (meteorCount >= 3) moveMeteor(meteorX3, meteorY3);
    if (meteorCount >= 4) moveMeteor(meteorX4, meteorY4);
    if (meteorCount >= 5) moveMeteor(meteorX5, meteorY5);
}

void moveMeteor(int x, int y) {
    image(meteorImage, x, y, 80, 80);
    y += 3;
    if (y > height) {
        x = int(random(width));
        y = 0;
    }
}

void handleBonusCollection() {
    if ((score >= 100 && score <= 120) || (score >= 250 && score <= 270) || (score >= 300 && score <= 320)) {
        if (!bonusActive) {
            activateBonus();
        }
    }

    if (bonusActive) {
        image(bonusStarImage, starBonusX, starBonusY, 70, 70);
        starBonusY += 3;
        if (starBonusY > height || bonusDuration <= 0) deactivateBonus();
    }

    if (abs(shipSafeZoneX - starBonusX) < 70 && abs(shipSafeZoneY - starBonusY) < 70) {
        bonusActive = true;
        bonusDuration = 300;
        collectedStars += 5;
        starBonusX = -100;
        starBonusY = -100;
        shipCollider = false;
        adjustMeteorSpeed();
    }
}

void activateBonus() {
    bonusActive = true;
    bonusDuration = 300;
    starBonusX = int(random(width));
    starBonusY = 0;
}

void deactivateBonus() {
    bonusActive = false;
}

void adjustMeteorSpeed() {
    meteorY += 0.5;
    meteorY2 += 0.5;
    meteorY3 += 0.5;
}

void checkGameOverConditions() {
    if (!shipCollider && abs(shipSafeZoneX - shipX) < 150 && abs(shipSafeZoneY - shipY) < 150) {
        score += collectedStars * 10;
        collectedStars = 0;
        shipCollider = true;
        if (score > 490) gameRunning = false;
    }
    if (checkMeteorCollision(meteorX, meteorY) || checkMeteorCollision(meteorX2, meteorY2) ||
        checkMeteorCollision(meteorX3, meteorY3) || checkMeteorCollision(meteorX4, meteorY4) ||
        checkMeteorCollision(meteorX5, meteorY5)) {
        gameRunning = false;
        gameOver = true;
    }
}

boolean checkMeteorCollision(int x, int y) {
    return abs(shipSafeZoneX - x) < 50 && abs(shipSafeZoneY - y) < 50;
}

void displayScore() {
    fill(255);
    textSize(24);
    text("\n Score: " + score, 50, 30);
    text("\n Crystals Collected: " + collectedStars, 115, 60);
}

void displayEndScreen() {
    if (gameOver) {
        image(loserImage, 0, -100, width, height);
        fill(255);
        textSize(36);
        text("Game Over", width / 2, height / 2 - 250);
        textSize(24);
        text("Crystals Collected: " + score, width / 2, height / 2 - 210);
    } else {
        image(winnerImage, 0, 0, width, height);
        fill(255);
        textSize(36);
        text("You Win!!", width / 2, height / 2 - 250);
        textSize(24);
        text("Crystals Collected: " + score, width / 2, height / 2 - 210);
    }
}
