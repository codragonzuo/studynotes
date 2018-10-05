
### Front-end JavaScript single page application architecture
https://marcobotto.com/blog/frontend-javascript-single-page-application-architecture/

![](https://marcobotto.com/front-end-architecture-scheme-8911520b8088f02fb2a5e59886cdb8e0.svg)

### The Back-end for Front-end Pattern (BFF)
http://philcalcado.com/2015/09/18/the_back_end_for_front_end_pattern_bff.html

![](http://philcalcado.com/img/2015-09-back-end-for-front-end-pattern/sc-bff-6.png)

### P2P WebRTC file sharing app: Frontend using React & Flux

https://zohaib.me/p2p-webrtc-file-sharing-app-frontend-using-react/
![](https://zohaib.me/content/images/2015/08/flux-simple-f8-diagram-with-client-action-1300w.png)

One direction data flow
React & Flux data flow

If you have used other frameworks then you would have stumbled upon data binding which allows you to keep the Model and the View state in sync.
React does not follow the same concept of data binding. React has a more simpler approach i.e. one way flow. The flow works as the diagram suggests, that any change in view or user action will send an action to store (using dispatcher), store will change its state and send it to view which updates its state and re-renders.

You might think that this couples the Store & View. The way to decouple it is that the store can also emit events when it has made changes to data, the view registers to listen for that events. Only the bigger component should listen to such events and pass the necessary data to its children components, in this way not all views are coupled with that event, only few big ones are.

Unidirectional dataflow

