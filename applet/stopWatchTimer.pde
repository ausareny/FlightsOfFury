// StopWatchTimer is a class that counts the time passed
class StopWatchTimer {
  int startTime = 0;
  int pauseTime = 0;
  boolean paused = false;
  
  void start() {
    startTime = millis();
  }
  
  void pause() {
    pauseTime = millis();
    paused = true;
  }
  
  void resume() {
    startTime += (millis() - pauseTime);
    paused = false;
  }
  

  // Counting how much time has passed since the start, if not runing showing the time it stopped at
  int getElapsedTime() {
    return millis( )- startTime;
  }


  // Tourining milliseconds into seconds
  int second() {
    return (getElapsedTime() / 1000) % 60;
  }
  // Tourining milliseconds into minutes
  int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  // Tourining milliseconds into hours
  int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
}

