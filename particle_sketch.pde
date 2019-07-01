ParticleSystem ps;

void setup() {
  colorMode(HSB, 1);
  background(0);
  size(600, 600, P3D);
  float radius = 0.8 * height / 2;
  ps = new ParticleSystem(new PVector(width/2, 50), radius, 8000);
  ps.init();
  //println("The particles are all set");
}

void draw() {
  background(0);
  ps.run();
}

class ParticleSystem {
  float phi = (sqrt(5)+1)/2 - 1; // golden ratio
  float ga = phi*2*PI;           // golden angle
  
  float rotationX = 0;
  float rotationY = 0;
  float velocityX = 0;
  float velocityY = 0;
  float pushBack = 0;

  int MaxPoints = 100000;
  int numberOfPoints;
  float radius;
  
  Particle[] particles;
  PVector origin;

  ParticleSystem(PVector position, float radius, int numberOfPoints) {
    this.radius = radius;
    this.numberOfPoints = numberOfPoints;
    origin = position.copy();
    particles = new Particle[numberOfPoints];
  }
  
  void init() {
    for (int i = 1; i < min(numberOfPoints,particles.length); ++i) {
      float lon = ga*i;
      lon /= 2*PI; lon -= floor(lon); lon *= 2*PI;
      if (lon > PI)  lon -= 2*PI;
   
      // Convert dome height (which is proportional to surface area) to latitude
      float lat = asin(-1 + 2*i/(float)numberOfPoints);
   
      particles[i] = new Particle(lat, lon, radius);
    }
  }

  void run() {
    pushMatrix();
    translate(width/2.0, height/2.0, pushBack);
    
    rotationX += velocityX;
    rotationY += velocityY;
    velocityX *= 0.95;
    velocityY *= 0.95;
     
    float xRot = radians(-rotationX);
    float yRot = radians(270 - rotationY - millis()*.01);
    rotateX( xRot ); 
    rotateY( yRot );
    
   
    strokeWeight(3);
     
    float elapsed = millis()*.001;
    float secs = floor(elapsed);
     
    for (int i = 1; i < min(numberOfPoints, particles.length); ++i)
    {
      Particle p = particles[i];
        p.run(xRot, yRot);
        if (p.isDead()) {
          particles[i] = p.clone();
        }
       
    }
   
    popMatrix();
  }
}


class Particle {
  PVector origin;
  float originalRadius;
  float lat, lon;
  float radius;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(float lat, float lon, float radius) {
    this.originalRadius = radius;
    origin = new PVector(this.lat = lat, this.lon = lon);
    this.radius = radius;
    //acceleration = new PVector(0, 0.05);
    //velocity = new PVector(random(-1, 1), random(-2, 0));
    //position = l.copy();
    lifespan = 255.0;
  }

  void run(float xRotation, float yRotation) {
    update(xRotation, yRotation);
    //display();
  }

  // Method to update position
  void update(float xRotation, float yRotation) {
    //velocity.add(acceleration);
    //position.add(velocity);
    lifespan -= 1.0;
    radius += 1;
    
    pushMatrix();
    rotateY( lon);
    rotateZ( -lat);
    
    display(xRotation, yRotation);
     
    popMatrix();
  }

  // Method to display
  void display(float xRotation, float yRotation) {
    float lum = (cos(lon + PI * 0.33 + yRotation) + 1) / 2;
    stroke(0.5, 0.5 * lum, 0.2 + lum * 0.8);
     
    point(radius,0,0);
    //stroke(255, lifespan);
    //fill(255, lifespan);
    //ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  Particle clone() {
    return new Particle(origin.x, origin.y, originalRadius);
  }
}
