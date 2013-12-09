/** 
* Title: Flights of Fury <br>
* Name: Amanda Lee and Justyna Ausareny <br>
* Date: December 9th, 2013 <br>
* Description: StopWatchTimer is a class that counts the time passed <br> 
**/

// StopWatchTimer is a class that counts the time passed
class StopWatchTimer {
  
  int startTime = 0;      // Start time of the counter
  int pauseTime = 0;      // Pause time of the counter
  boolean paused = false; // Indicates if the timer is paused
  
  // Starts the timer by setting startTime
  void start() {
    startTime = millis();
  }
  
  // Pauses the timer by setting pauseTime, and setting the paused flag to true
  void pause() {
    pauseTime = millis();
    paused = true;
  }
  
  // Resumes the timer by adjusting the start time with the time it spend during pause, and setting the paused flag to false
  void resume() {
    int timeInPauseState = millis() - pauseTime;
    startTime += timeInPauseState;
    paused = false;
  }
  
  // Returns how much time has passed since the start
  // Time in pause state is not included since we are adjusting the startTime in resume method
  int getElapsedTime() {
    return millis( )- startTime;
  }

  // Turning milliseconds into seconds
  int second() {
    return (getElapsedTime() / 1000) % 60;
  }
  // Turning milliseconds into minutes
  int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  // Turning milliseconds into hours
  int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
}

