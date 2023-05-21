int myFrameRate = 24; //init framerate
boolean dead = false; // inizializzazione per schermata del titolo

// inizializzazione suoni
import processing.sound.*;
SoundFile doneSound;
SoundFile fallSound;
SoundFile flapSound;
SoundFile quackSound;
SoundFile shotSound;
SoundFile thumpSound;

// inizializzazione sfondo
PImage foreground;
PImage crosshairs; //mirino

////////////////////////////////////////////////
// SBIRRO ////////////////////////////////////////
////////////////////////////////////////////////
// inizializzazione rapida immagini
// preso da qui https://forum.processing.org/one/topic/loading-pimage-into-an-array.html
String[] sbirroRightImgsNames = {
  "sbirro-right-0.png", 
  "sbirro-right-1.png", 
  "sbirro-right-2.png",
  "sbirro-right-1.png"
};
PImage[] sbirroRightImgs = new PImage[sbirroRightImgsNames.length];

String[] sbirroLeftImgsNames = {
  "sbirro-left-0.png", 
  "sbirro-left-1.png", 
  "sbirro-left-2.png",
  "sbirro-left-1.png"
};
PImage[] sbirroLeftImgs = new PImage[sbirroLeftImgsNames.length];
PImage sbirroDying;

String[] deadImgsNames = { 
  "sbirro-dead-0.png", 
  "sbirro-dead-1.png"
};
PImage[] deadImgs = new PImage[deadImgsNames.length];

boolean sbirroIsAlive = true; //init stato
int speed = 1; //init speed
int x = width; //init posizione iniziale sbirro
int y = height/2; //init altezza sbirro
int directionX = -1; //init direzione sull'asse orrizontale (se va a destra o a sinistra)
//int directionY = -1;
int myFreqWind = 6; //velocità battito ali (più il numero è grande e più sbatte le ali)
int speedFactor = 1; //moltiplicatore della velocità di spostamento - fa andare più veloce
int animFrame = 0; //selettore frame

void setup() {
  
  size(1500,200); //sfondo dinamico
  //fullScreen(); //per mettere a schermo intero
  
  noStroke(); //per non disegnare i bordi intorno ad ogni forma
  background(60, 188, 252); // per impostare lo sfondo 
  
  frameRate(myFrameRate); //imposto in framerate
  noCursor(); //nascondere la freccia del mouse
  
  // caricamento suoni
  doneSound = new SoundFile(this, "done.mp3");
  fallSound = new SoundFile(this, "fall.mp3");
  flapSound = new SoundFile(this, "flap.mp3");
  quackSound = new SoundFile(this, "quack.mp3");
  shotSound = new SoundFile(this, "shot.mp3");
  thumpSound = new SoundFile(this, "thump.mp3");
  
  // caricamento immagini
  foreground = loadImage("foreground.png"); //caricamento dello sfondo
  crosshairs = loadImage("crosshairs.png"); //caricamento del mirino
  
  // caricamento efficiente delle immagini di sbirro (preso da qui https://forum.processing.org/one/topic/loading-pimage-into-an-array.html)
  for (int i=0; i < sbirroRightImgsNames.length; i++){ // ciclo for per creare velocemente l'array dei frame della sbirro
    String imageName = sbirroRightImgsNames[i]; // per il ciclo for, creo una stringa temporanea che contiene l'i-esimo elemento dell'array sbirroRightImgsNames che contiene i nomi dei file
    sbirroRightImgs[i] = loadImage(imageName); // carico l'immagine nell'i-esimo elemento dell'array con gli oggetti
  }
  
  //faccio lo stesso che ho fatto sopra anche per le immagini di sinistra
  for (int i=0; i < sbirroLeftImgsNames.length; i++){
    String imageName = sbirroLeftImgsNames[i];
    sbirroLeftImgs[i] = loadImage(imageName);
  } //<>//
  
  sbirroDying = loadImage("sbirro-dying.png"); // qui carico l'immagine che sta morendo
  
  for (int i=0; i < deadImgsNames.length; i++){ //qui carico le immagini dell morte
    String imageName = deadImgsNames[i];
    deadImgs[i] = loadImage(imageName);
  }
 
}

void draw() { // come nel void loop di arduino
  
  if (sbirroIsAlive == true) { // controllo se la papera è viva...
    
    //disegno sfondo
    showForeground(); //definita in fondo per mostrare lo sfondo
    
    //SUONO ALI - ogni 4 frame (24 diviso 6) fa il suono del battito ali
    if (frameCount % (myFrameRate / myFreqWind) == 0) { 
      flapSound.play();
    }
    //SUONO VERSO ogni 4 frame (24 diviso 6) fa il suono del battito ali
    if (frameCount % myFrameRate == 0) { //ogni secondo fa il quacksound
      quackSound.play();
    }
    
    // inizio IF per cambiare la velocità in base alla distanza del mouse
    if ( dist(mouseX, mouseY, x + sbirroRightImgs[0].width / 2, y + sbirroRightImgs[0].height / 2) < 200 ) { // se il mouse si avvicina troppo alla papera...
      speedFactor = 2; // la papera va più veloce
      
      if (mouseX < x + sbirroRightImgs[0].width / 2) {
        directionX = 1;
        if (x > width - sbirroRightImgs[0].width) { // se sbirro raggiunge l'estremo destro dello schermo
          x = 0; // sbuco dalla parte opposta dello schermo, cioè dall'estremo sinistro
        }
      } else if (mouseX > x + sbirroRightImgs[0].width / 2) { // se sbirro raggiunge l'estremo sinistro dello schermo
        directionX = -1;
        if (x < 0) {
          x = width; //sbuco dalla parte opposta dello schermo
        }
      }
      
    } // fine IF per cambiare la velocità in base alla distanza del mouse
    
    else {
      speedFactor = 1; // altrimenti torna alla velocità regolare
      
      if (x < 0) { // se sbirro raggiunge l'estremo sinistro dello schermo
        directionX = 1; // cambio la direzione di spostamento...
        x = 0; // ... e lo faccio sbucare dall'estremo destro
      } else if (x > width - sbirroRightImgs[0].width) {
        directionX = -1; // cambio la direzione di spostamento...
        x = width-sbirroRightImgs[0].width; // ... e lo faccio sbucare dall'estremo sinistro
      }
    
    }
    
    // mostro la sbirro con il frame della direzione giusta
    if (directionX == 1) { // se directionX è =1 e quindi sta andando verso destra
      image(sbirroRightImgs[animFrame], x, y); // allora mostro i frame che puntano verso destra
    } else { // se invece non è =1 e quindi è uguale a -1...
      image(sbirroLeftImgs[animFrame], x, y); // ...allora mostro i frame che puntano verso sinistra
    }
    
    x += speed * directionX * speedFactor; // qui invece è dove aggiorno effettivamente la posizione di sbirro
    //y += speed * directionY * speedFactor;
    animFrame = (animFrame + 1) % 4; // questo serve per far cambiare il frame e fare quindi l'animazione scorrendo tra tutti quelli disponibili
    
    image(crosshairs, mouseX,mouseY); // mostro a schermo il mirino posizionato sulla posizione del mouse
    
  } else if ( sbirroIsAlive == false) { // se sbirro non è più vivo...
        // sbirro falls to its death
        if (animFrame < (myFrameRate - 1)) { // animazione dell acaduta della papera
          showForeground(); // mostro lo sfondo
          image(sbirroDying, x, y); // il frame della papera morente
          animFrame++; // scorro tra i frame
        } else if (animFrame < myFrameRate) {
          fallSound.play(); // suono della caduta
          animFrame++; // scorro tra i frame
        } else if (y < 100) { // finchè sbirro non è caduto abbastanza
          showForeground(); //continuo ad aggiornare lo sfondo
          image(deadImgs[animFrame % 2], x, y); // alterno tra i due frame della caduta
          y += speed*3; //velocità di caduta DA TARARE IN BASE ALLO SFONDO
          animFrame++; // scorro tra i frame
        } else { // se invece ho toccato il pavimento
          //thumpSound.play(); // da far suonare una volta sola
          if (x < 0) // si ferma quindi per terra
            x = 0;
          else if (x > width - sbirroRightImgs[0].width)
            x = width - sbirroRightImgs[0].width;
          dead = true; // imposto dead per poter poi mostrare la schermata del titolo
        }
  }
}

void mousePressed() { // qui controllo se viene premuto il mouse
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) { //controllo se viene premuto il mouse all'interno dello schermo
    if (sbirroIsAlive == true) { // controllo se sbirro è viva
      shotSound.play(); // suono dello sparo
      background(255);
      if (mouseX >= x && mouseX <= x + sbirroRightImgs[0].width &&
        mouseY >= y && mouseY <= y + sbirroRightImgs[0].height) { // se la posizione del mouse è dentro all'ingombro di sbirro
        sbirroIsAlive = false; // allora sbirro è morto
        // suono di morte
        animFrame = 0; // e mostro il frame 0
        showForeground(); //mostro lo schermo
        image(sbirroDying, x,y); 
      }
      
    }
  }
}


void showForeground() { // funzione usata per mostrare lo sfondo
  background(60, 188, 252); //sfondo azzurro
  for (int i = 0; i < width; i += foreground.width) { // applico l'immagine dello sfondo con un ciclo for per poterla ripetere all'infinito in base alla larghezza dello schermo
    image(foreground,i,0); // posiziono lo sfondo nella posizione i-esima
  }
}


//String text = "SBIRRO\n EXTERMINATORS";
  //  font = loadFont("duckhunt.ttf");
  //  color = color(0, 235, 219);
  //  fill(255, 163, 71);
  //  width: 320;
  //  height: 88;
  //  textSize: 32;
  //  x: 0;
  //  y: -90;
