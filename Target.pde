/*
JLS 200725
Classe de gestion de l'évenement lorsque le blob touche la cible
Test interaction de base à adapter selon besoin
*/
class Target {
  PVector position;
  PVector velocity;

  Target() {
    position = new PVector(100, 100);
    velocity = new PVector(2.5, 2);
  }

  // Déplacement de la cible
  void update() {
    position.add(velocity);
    if ((position.x > width) || (position.x < 0)) {
      velocity.x *= -1;
    }
    if ((position.y > height) || (position.y < 0)) {
      velocity.y *= -1;
    }
  }
  
  // Affichage de la cible
  void display() {
    noStroke();
    fill(50,150,200);
    ellipse(position.x, position.y, 100, 100);
  }
  
  // Evenement lorsque cible touchée
  void hit(){
    noStroke();
    fill(250,50,50);
  }
  
  // Détection cible touchée
  boolean isInTarget(Blob b) {
     PVector distanceVect = PVector.sub(b.getCenter(), position);
     float distanceVectMag = distanceVect.mag();
     return distanceVectMag < 20 ? true : false;
  }
}
