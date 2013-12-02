// StopWatchTimer is a class that counts the time passed
class StopWatchTimer {
  int startTime = 0, stopTime = 0; // variables holding startTime and stopTime
  boolean running = false; // indicates whether the time is running

  //Starts the counting in milliseconds
  void start() {
    startTime = millis();
    running = true;
  }

  //Stops the counting in milliseconds
  void stop() {
    stopTime = millis();
    running = false;
  }
  // Counting how much time has passed since the start, if not runing showing the time it stopped at
  int getElapsedTime() {
    int elapsed;
    if (running) {
      elapsed = (millis() - startTime);
    }
    else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
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

