int birdY; // Y-Position des Vogels
int birdSpeed; // Geschwindigkeit des Vogels
int gravity; // Schwerkraft

int pipeWidth = 60; // Breite der Rohre
int pipeGap = 150; // Abstand zwischen den Rohren
int pipeSpeed = 2; // Geschwindigkeit der Rohre
ArrayList<Pipe> pipes; // Liste der Rohre
int pipeCounter; // Zähler für durchflogene Rohre

boolean gameStarted; // Zeigt an, ob das Spiel gestartet wurde
boolean gameOver; // Zeigt an, ob das Spiel beendet wurde

void setup() {
  size(400, 600);
  resetGame();
}

void draw() {
  background(135, 206, 250); // Himmelblau

  if (!gameStarted) {
    drawStartScreen();
  } else if (gameOver) {
    drawGameOverScreen();
  } else {
    // Vogel
    fill(255, 255, 0);
    ellipse(100, birdY, 30, 30);

    // Bewegung des Vogels
    birdSpeed += gravity;
    birdY += birdSpeed;

    // Hindernisse zeichnen
    for (int i = pipes.size() - 1; i >= 0; i--) {
      Pipe p = pipes.get(i);
      p.update();
      p.display();

      if (p.offscreen()) {
        pipes.remove(i);
        pipeCounter++;
      }

      if (p.hits(100, birdY)) {
        gameOver = true; // Setzt das Spiel auf "Game Over"
      }
    }

    // Neuen Pipe hinzufügen, wenn nötig
    if (pipes.get(pipes.size() - 1).x < width - 200) {
      pipes.add(new Pipe());
    }

    // Kontrolliere, ob der Vogel den Boden oder das obere Ende berührt
    if (birdY > height || birdY < 0) {
      gameOver = true; // Setzt das Spiel auf "Game Over"
    }

    // Zähler für durchflogene Rohre anzeigen
    fill(0);
    textSize(32);
    textAlign(RIGHT, TOP);
    text("Pipes Passed: " + pipeCounter, width - 10, 10);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (!gameStarted || gameOver) {
      resetGame();
      gameStarted = true;
      gameOver = false;
    } else {
      birdSpeed = -10; // Der Vogel springt nach oben
    }
  }
}

// Funktion zum Zurücksetzen des Spiels
void resetGame() {
  birdY = height / 2;
  birdSpeed = 0;
  gravity = 1;
  pipeCounter = 0;

  pipes = new ArrayList<Pipe>();
  pipes.add(new Pipe());
}

// Startbildschirm anzeigen
void drawStartScreen() {
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Press SPACE to Start", width / 2, height / 2);
}

// Game Over-Bildschirm anzeigen
void drawGameOverScreen() {
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 2 - 50);
  textSize(32);
  text("Pipes Passed: " + pipeCounter, width / 2, height / 2 + 10);
  textSize(24);
  text("Press SPACE to Restart", width / 2, height / 2 + 50);
}

// Klasse für die Rohre
class Pipe {
  float x;
  float gapY;
  
  Pipe() {
    x = width;
    gapY = random(height / 4, 3 * height / 4);
  }
  
  void update() {
    x -= pipeSpeed;
  }
  
  void display() {
    fill(0, 255, 0);
    rect(x, 0, pipeWidth, gapY - pipeGap / 2);
    rect(x, gapY + pipeGap / 2, pipeWidth, height - (gapY + pipeGap / 2));
  }
  
  boolean offscreen() {
    return x < -pipeWidth;
  }
  
  boolean hits(float birdX, float birdY) {
    if (birdX > x && birdX < x + pipeWidth) {
      if (birdY < gapY - pipeGap / 2 || birdY > gapY + pipeGap / 2) {
        return true;
      }
    }
    return false;
  }
}
