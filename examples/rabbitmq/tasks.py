from celery import Celery

app = Celery(
    'tasks',
    broker='amqp://guest:guest@rabbitmq.rabbitmq-example.svc.cluster.local:5672',
    # backend='rpc://'
    # backend='db+cockroachdb://root@cockroachdb.cockroachdb-example.svc.cluster.local:26257/postgres'
)


@app.task
def hello():
    print('called')
    return 'hello world'
