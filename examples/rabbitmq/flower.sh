RABBITMQ=guest:guest@rabbitmq.rabbitmq-example.svc.cluster.local
celery \
--broker=amqp://$RABBITMQ:5672// \
flower \
--port=6666 \
--broker_api=http://$RABBITMQ:15672/api/
