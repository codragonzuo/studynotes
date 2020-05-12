## Architecture

![](https://spot.apache.org/library/images/architecture.png)


## Ingest
![](https://github.com/apache/incubator-spot/raw/master/docs/SPOT_Ingest_Framework1_1.png)


- streaming.py

class StreamPipeline:
    '''
        Create an input stream that pulls netflow messages from Kafka.
        

- processing.py
'''
    Methods that will be used to process and prepare netflow data, before being sent to
Kafka cluster.
'''
