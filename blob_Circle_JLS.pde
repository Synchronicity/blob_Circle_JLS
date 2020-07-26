// JLS Adaptation sur base de: //<>//
// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/r0lvsMPGEoY

import processing.video.*;

Capture video;

Target cible;             // Cible à détecter
color trackColor;         // Couleur à détecter
float colThreshold = 40;  // Seuil nuance de couleur
float distThreshold = 5;  // Seuil distance blob différent

float bx = 0;             // Position x,y du blob
float by = 0;
int blobCounter = 0;      // Nombre de blobs détectés
int maxLife = 50;         // Durée de vie du blob

ArrayList<Blob> blobs = new ArrayList<Blob>();  // Blobs en cours de traitement


void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480, 30);
  video.start();
  trackColor = color(183, 12, 83); // Couleur par défaut remplacée par mousePressed()

  cible = new Target();            // Instanciation de la cible
}


void captureEvent(Capture video) {
  video.read();
}


// Paramétrages des seuils de détection
void keyPressed() {
  // Distance autre blob
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  // Nuance de couleur
  if (key == 'q') {
    colThreshold+=5;
  } else if (key == 's') {
    colThreshold-=5;
  }
}


void draw() {
  video.loadPixels();
  image(video, 0, 0);

  cible.update();    // Mise à jour déplacement
  cible.display();   // Affichage cible

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < colThreshold * colThreshold) {
        boolean found = false;

        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            
/*** Test interaction de base classe Target ***/
            // JLS test cible touchée et action si true (rect de couleur ici)
            if (cible.isInTarget(b)) {
             //println("DETECT X:" + cible.position.x + " Y:" + cible.position.y);  // info console
             println("Blob en cours ID: " + blobCounter);
             rect(100, 100, 20, 20);
             
             cible.hit();    // Evenement si touchée
             }
            break;
          }
        }
        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }
      }
    }
  }

  for (int i = currentBlobs.size()-1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < 100) {  // exclusion x*y detection (10*10 ==> < 100 ici)
      currentBlobs.remove(i);
    }
  }

  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    println("Adding blobs: " + blobCounter);    // info console
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Match whatever blobs you can match
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }

    // Whatever is leftover make new blobs
    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }

    // Match whatever blobs you can match
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d; 
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.become(cb);
      }
    }

    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        if (b.checkLife()) {
          blobs.remove(i);
        }
      }
    }
  }

  for (Blob b : blobs) {
    b.show();
  } 


  // Affichage paramètres de détection
  textAlign(RIGHT);
  fill(0, 200, 100);
  textSize(12);
  text("color threshold: " + colThreshold, width-10, 50);  
  text("distance threshold: " + distThreshold, width-10, 25);
}


// 2D version
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

// 3D version
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}


// Save color where the mouse is clicked in trackColor variable
void mousePressed() {
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  println(red(trackColor), green(trackColor), blue(trackColor));
}
