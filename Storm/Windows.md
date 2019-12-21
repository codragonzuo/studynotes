
# Windowing 

https://storm.apache.org/releases/1.2.3/Windowing.html


## Understanding Watermarks

https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/developing-storm-applications/content/understanding_watermarks.html
https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/developing-storm-applications/storm-developing-applications.pdf




## watermarking

https://databricks.com/blog/2017/05/08/event-time-aggregation-watermarking-apache-sparks-structured-streaming.html?utm_content=bufferd7772&amp;utm_medium=social&amp;utm_source=pinterest.com&amp;utm_campaign=buffer

![](https://databricks.com/wp-content/uploads/2017/05/mapping-of-event-time-to-5-min-tumbling-windows.png)


![](https://databricks.com/wp-content/uploads/2017/05/mapping-of-event-time-to-overlapping-windows-of-length-10-mins-and-sliding-interval-5-mins.png)




### TupleWindow Start/End Time in Apache Storm

https://stackoverflow.com/questions/43068423/tuplewindow-start-end-time-in-apache-storm



If you are using a 1.x release of apache Storm, this information is not directly accessible via the TupleWindow. You will have to manually calculate this. E.g.
```JAVA
public class MyBolt extends BaseWindowedBolt {
  ...
  long slidingInterval;

  @Override
  public BaseWindowedBolt withWindow(Duration windowLength, Duration slidingInterval) {
      this.slidingInterval = slidingInterval.value;
      return super.withWindow(windowLength, slidingInterval);
  }


  public void execute(TupleWindow inputWindow) {
    long now = System.currentTimeMillis();
    long windowEnd = now;
    long windowStart = now - slidingInterval;
    ...
  }
```
But it may not be pretty straight forward in all cases especially if you are having event time windows.

In the latest master branch of storm, the TupleWindow has a getTimestamp method which returns the window end timestamp and works for both processing and event time based windows. This will be available in the future release of storm (2.0 release). It could be back ported and made available in future Storm 1.x releases as well.


### Trigger Apache Storm Window
https://stackoverflow.com/questions/50007765/trigger-apache-storm-window


I have been working on a stream processing project that streaming on incoming data using the sliding window technique on Apache Storm (v1.1.0).

I tried to portray the problem which I have in the picture below. Let me explain. e1,e2,e3,e4,e5,e6,e7,e8 are my events and coming to Apache Storm in time order. w1,w2,w3 etc represent the window name.

Between[0,5] there are events

Between[5,10] there are events

Between[10,15] there are not events

Between[15,20] there are not events

Between[20,25] there are not events

Between[25,30] there is event

Between[30,25] there is event

As an output, Apache Storm creates w1, w2, w3, w6 windows, but does not create w4 and w5

The problem is I need w4 and w5 for my logic. What can I do for that. I want to receive window even if there is no event for window

![](https://i.stack.imgur.com/vFVqv.jpg)

## Eviction and Trigger

eviction policy: when data points should  leave the windows, define window width/size

trigger policy : when to trigger computation on current window

## 

Semantic	Type	Description	Storm	Flink
Tumbling Windows	Window Assigners	"Predefined window size，A tuple belongs to only one window
Defined by time or event count
"	Implemented	Implemented
Sliding Windows	Window Assigners	"Predefined window size,A tuple can belong to multiple windows (slides),Defined by time or event  count
"	Implemented	Implemented
Session Windows	Window Assigners	Predefined max. gap size,No fixed, start/end time	Not Implemented	Implemented
Global Windows	Window Assigners	Key based,Requires trigger	Not Implemented	Implemented

