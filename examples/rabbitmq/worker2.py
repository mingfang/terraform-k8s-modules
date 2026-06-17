from celery import Celery
from celery_dyrygent.tasks import register_workflow_processor
from celery_dyrygent.workflows import Workflow

app = Celery(
    'tasks',
    broker='amqp://guest:guest@rabbitmq.rabbitmq-example.svc.cluster.local:5672',
    # backend='rpc://'
    # backend='db+cockroachdb://root@cockroachdb.cockroachdb-example.svc.cluster.local:26257/postgres'
    backend='redis://redis.redis-example.svc.cluster.local:6379/1'
)

workflow_processor = register_workflow_processor(app)


@Workflow.connect('on_state_change')
def on_state_change(workflow, payload):
    print("Workflow {} state {}".format(workflow.id, payload))


@Workflow.connect('on_finish')
def on_finish(workflow, payload):
    print("Workflow {} finished".format(workflow.id))


@app.task
def noop(*args, **kwargs):
    print('noop {} {}'.format(args, kwargs))
    return True

@app.task
def echo(*args, **kwargs):
    print('echo {} {}'.format(args, kwargs))
    return args
