class Marble {
  float x, y, dx, dy, r, theta, h;
  boolean collided, collidedCheck;

  Marble() {
    x = width / 2 + random(20) - 10;
    y = 100;
    dx = 0;
    dy = 0;
    r = 5;
    h = random(255);
  }

  void setTheta() {
    if (dy > 0) {
      theta = acos(dx / dist(0, 0, dx, dy)) + PI;
    } else if (dy < 0) {
      theta = -acos(dx / dist(0, 0, dx, dy)) + PI;
    } else if (dx < 0) {
      theta = 0;
    } else {
      theta = PI;
    }
    theta += TAU;
    theta %= TAU;
  }

  void collide() {
    float pTheta;
    collidedCheck = false;
    for (Post p : posts) {
      if (!collided) {
        if (dist(x, y, p.x, p.y) < r + p.r) {
          println(1);
          collided = true;
          collidedCheck = true;
          if (y < p.y) {
            pTheta = acos((p.x - x) / dist(x, y, p.x, p.y)) + PI;
          } else if (y > p.y) {
            break;
          } else if (x > p.x) {
            pTheta = 0;
          } else {
            pTheta = PI;
          }
          pTheta += TAU;
          pTheta %= TAU;
          setTheta();
          theta = pTheta + (pTheta - theta) + random(0.01f) - 0.005f;
          theta += TAU;
          theta %= TAU;
          dx = cos(theta) * dist(0, 0, dx, dy) / 1.8;
          dy = sin(theta) * dist(0, 0, dx, dy) / 1.8;
        }
      }
    }

    if (collidedCheck) {
      collided = true;
    } else {
      collided = false;
    }
  }


  void update() {
    collide();
    x += dx;
    y += dy;
    dy += 0.2;
  }

  void render() {
    stroke(0);
    if (y > 600) {
      noStroke();
    }
    colorMode(HSB, 255);
    stroke(h, 255, 255);
    fill(h, 255, 255, 255);
    ellipse(x, y, 2 * r, 2 * r);
    colorMode(RGB, 255);
  }
}


class Post {
  float x, y, r;

  Post(float x, float y) {
    this.x = x;
    this.y = y;
    r = 5;
  }

  void render() {
    fill(0);
    stroke(0);
    ellipse(x, y, 2 * r, 2 * r);
  }
}

void fillPosts() {
  columns = 21;
  xs = 25;
  float ys = xs * sin(PI / 3);
  for (float y = 1; y <= columns; y ++) {
    for (float x = 0; x < y + 10; x ++) {
      Post post = new Post(width / 2 + (x - y / 2 - 5) * xs, 100 + y * ys);
      posts.add(post);
    }
  }
}

void fillMarbles() {
  for (int i = 0; i < 1000; i ++) {
    Marble marble = new Marble();
    marbles.add(marble);
  }
}

class Bar {
  float x, h;
  int v = 0;

  Bar(float x) {
    this.x = x;
    h = 0;
  }

  void render() {
    if (max != 0) {
      h = (float) 480 / max * v;
    }
    fill(0);
    rect(x, height - h, 1280 / barCt, h);
  }
}

void fillBars() {
  for (int i = 0; i < barCt; i ++) {
    Bar bar = new Bar(width / 2 - 640 + i * (1280 / barCt));
    bars.add(bar);
  }
}

ArrayList<Post> posts;
ArrayList<Marble> marbles;
ArrayList<Bar> bars;
int columns;
int barCt = 50;
float xs;
int max = 0;

void setup() {
  fullScreen(P2D);
  posts = new ArrayList<Post>();
  fillPosts();
  marbles = new ArrayList<Marble>();
  fillMarbles();
  bars = new ArrayList<Bar>();
  fillBars();
}

void draw() {
  if (millis() > 10000) {
    background(255);
    for (int i = 0; i < marbles.size(); i ++) {
      Marble m = marbles.get(i);
      m.update();
      m.render();
      if (m.y > 600) {
        bars.get((int) (m.x - 320) / (1280 / barCt)).v ++;
        marbles.remove(i);
        i --;
      }
    }
    for (Post p : posts) {
      p.render();
    }
    for (Bar b : bars) {
      if (b.v > max) {
        max = b.v;
      }
      b.render();
    }
  }
}
