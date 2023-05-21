// Credits
// =======
// Nintendo’s Duck Hunt: https://www.nintendo.com/games/detail/duck-hunt-wii-u
// DuckHuntCSS: https://github.com/vaielab/DuckHuntCss
// Duck Hunt Font: https://fonts2u.com/duck-hunt.font
// Duck Hunt Sound Effects: https://www.sounds-resource.com/nes/duckhunt/sound/4233/

var groundHeight, rate, sound, foreground, pointer, duck, dog, logo, bgFill;

//function preload() {
//  //groundHeight = 175;
//  //rate = 24;
//  //sound = [
//  //  loadSound("flap.mp3"),
//  //  loadSound("quack.mp3"),
//  //  loadSound("shot.mp3"),
//  //  loadSound("fall.mp3"),
//  //  loadSound("thump.mp3"),
//  //  loadSound("done.mp3")
//  //];
//  //foreground = {
//  //  img: loadImage("foreground.png"),
//  //  show: function() {
//  //    for (var x = 0; x < width; x += this.img.width)
//  //      image(this.img, x, 0);
//  //  }
//  };

  pointer = {
    //img: loadImage("crosshairs.png"),
    show: function() {
      if (duck.alive && mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
        noCursor();
        image(this.img, mouseX - this.img.width / 2, mouseY - this.img.height / 2);
      } else if (dog.done)
        cursor(HAND);
      else
        cursor();
    },
    shoot: function() {
      fill("white");  // Background turns white when shooting
      sound[2].play();

      //if (mouseX >= duck.x && mouseX <= duck.x + duck.rightImg[0].width &&
      //  mouseY >= duck.y && mouseY <= duck.y + duck.rightImg[0].height) {
      //  duck.alive = false;
      //  duck.animFrame = 0;
      //}
    }
  };
  duck = {
    //alive: true,
    dead: false,
    //x: windowWidth,
    //y: 0,
    //directionX: -1,
    //directionY: -1,
    //speed: 5,
    //speedFactor: 1,
    //animFrame: 0,
    //rightImg: [
    //  loadImage("duck-right-0.png"),
    //  loadImage("duck-right-1.png"),
    //  loadImage("duck-right-2.png"),
    //  loadImage("duck-right-1.png")
    //],
    //leftImg: [
    //  loadImage("duck-left-0.png"),
    //  loadImage("duck-left-1.png"),
    //  loadImage("duck-left-2.png"),
    //  loadImage("duck-left-1.png")
    //],
    //dyingImg: loadImage("duck-dying.png"),
    //deadImg: [
    //  loadImage("duck-dead-0.png"),
    //  loadImage("duck-dead-1.png")
    //],
    go: function() {
      
      if (this.alive) {
        
        // Duck flaps its wings constantly
        //if (frameCount % (rate / 6) == 0)
        //  sound[0].play();
        //// Duck quacks every second
        //if (frameCount % rate == 0)
        //  sound[1].play();




        // Determine speed and direction
        if (dist(mouseX, mouseY, this.x + this.rightImg[0].width / 2, this.y + this.rightImg[0].height / 2) < 200 ) {
          // Duck speeds up when mouse is close
          this.speedFactor = 2;

          // Duck moves away from mouse horizontally, but not past edges
          if (mouseX < this.x + this.rightImg[0].width / 2) {
            this.directionX = 1;
            if (this.x > width - this.rightImg[0].width)
              this.x = width - this.rightImg[0].width;
          }  else if (mouseX > this.x + this.rightImg[0].width / 2) {
            this.directionX = -1;
            if (this.x < 0)
              this.x = 0;
          }
          
          //// Duck moves away from mouse to empty half of screen, but not past edges
          //if (mouseY < groundHeight / 2) {
          //  this.directionY = 1;
          //  if (this.y > groundHeight - this.rightImg[0].height)
          //    this.y = groundHeight - this.rightImg[0].height;
          //}  else if (mouseY > groundHeight / 2) {
          //  this.directionY = -1;
          //  if (this.y < 0)
          //    this.y = 0;
          //}
          
        } else {
          // Normal speed and direction
          this.speedFactor = 1;

          // Turn around when hitting the edge – horizontal
          if (this.x < 0) {
            this.directionX = 1;
            this.x = 0;
          }  else if (this.x > width - this.rightImg[0].width) {
            this.directionX = -1;
            this.x = width - this.rightImg[0].width;
          }
          //// Turn around when hitting the edge – vertical
          //if (this.y < 0) {
          //  this.directionY = 1;
          //  this.Y = 0;
          //} else if (this.y > groundHeight - this.rightImg[0].height) {
          //  this.directionY = -1;
          //  this.Y = groundHeight - this.rightImg[0].height;
          //}
        }

         Place duck going in the right direction
        if (this.directionX == 1)
          image(this.rightImg[this.animFrame], this.x, this.y);
        else
          image(this.leftImg[this.animFrame], this.x, this.y);

         Increment duck position for next frame
        this.x += this.speed * this.directionX * this.speedFactor;
        this.y += this.speed * this.directionY * this.speedFactor;

        // Increment frame number for animation loop
        this.animFrame = (this.animFrame + 1) % 4;
        
        
        
        
        
      } else if (!this.dead) {
        // Duck falls to its death
        if (this.animFrame < (rate - 1)) {
          image(this.dyingImg, this.x, this.y);
          this.animFrame++;
        } else if (this.animFrame < rate) {
          sound[3].play();
          this.animFrame++;
        } else if (this.y < height) {
          image(this.deadImg[this.animFrame % 2], this.x, this.y);
          this.y += this.speed;
          this.animFrame++;
        } else {
          sound[4].play();
          if (this.x < 0)
            this.x = 0;
          else if (this.x > width - this.rightImg[0].width)
            this.x = width - this.rightImg[0].width;
          this.dead = true;
        }
      } else
        dog.fetch(this.x);
    }
  };
  
  //dog = {
  //  done: false,
  //  x: null,
  //  y: groundHeight,
  //  animFrame: 0,
  //  img: [
  //    loadImage("dog-right.png"),
  //    loadImage("dog-left.png")
  //  ],
  //  fetch: function(x) {
  //    if (!this.x)
  //      if (x + duck.rightImg[0].width / 2 >= width / 2) {
  //        this.x = x - (this.img[0].width - duck.rightImg[0].width);
  //        this.animFrame = 0;
  //      } else {
  //        this.x = x;
  //        this.animFrame = 1;
  //      }

  //    image(this.img[this.animFrame], this.x, this.y);

  //    if (this.y > groundHeight - this.img[0].height)
  //      this.y -= 2;
  //    else if (!this.done) {
  //      sound[5].play();
  //      this.done = true;
  //    } else
  //      noLoop();
  //  }
  //};
  //logo = {
  //  text: "DUCK\n EXTERMINATORS",
  //  font: loadFont("duckhunt.ttf"),
  //  color: color(0, 235, 219),
  //  lineColor: color(255, 163, 71),
  //  width: 320,
  //  height: 88,
  //  textSize: 32,
  //  x: 0,
  //  y: -90,
  //  show: function(x) {
  //    if (x + duck.rightImg[0].width / 2 >= width / 2)
  //      this.x = x - (dog.img[0].width - duck.rightImg[0].width) - this.width - 32;
  //    else
  //      this.x = x + dog.img[0].width + 32;

  //    // Logo background
  //    fill(0);
  //    rect(this.x, this.y, this.width, this.height);
  //    // Logo text
  //    fill(this.color);
  //    text(this.text, this.x + 12, this.y + 35);
  //    // Logo line
  //    strokeWeight(2);
  //    stroke(this.lineColor);
  //    line(this.x + 14, this.y + 44, this.x + 306, this.y + 44);

  //    // Reset fill and stroke
  //    fill(bgFill);
  //    noStroke();

  //    if (!dog.done)
  //      this.y += 3;
  //  },
  //  follow: function() {
  //    window.open("https://www.nintendo.com/games/detail/duck-hunt-wii-u");
  //  }
  //};
}

function setup() {
  //if (window.self != window.top)  // When embedded in an iframe (e.g., on OpenProcessing.org)
  //  createCanvas(windowWidth, 200);
  //else {  // When embedding within a normal page, move canvas to the top
  //  createCanvas(document.body.clientWidth, 200);  // Constrain width not to include scrollbar
  //  document.querySelector("body").insertBefore(document.querySelector("canvas"), document.querySelector("body").firstChild);
  //}

  //frameRate(rate);
  //bgFill = color(60, 188, 252);
  //noStroke();
  fill(bgFill);
  textFont(logo.font);
  textSize(logo.textSize);

  background("black");
}

function draw() {
  // Draw background (but not of containing OpenProcessing page)
  rect(0, 0, width, height);
  fill(bgFill);

  duck.go();

  // Draw foreground, logo, and cursor
  foreground.show();
  if (duck.dead)
    logo.show(duck.x);
  pointer.show();
}

function mousePressed() {
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)
    if (duck.alive)
      pointer.shoot();
    else if (dog.done)
      logo.follow();
}

//function windowResized() {
//  if (window.self != window.top)
//    resizeCanvas(windowWidth, 200);
//  else
//    resizeCanvas(document.body.clientWidth, 200);
//}
