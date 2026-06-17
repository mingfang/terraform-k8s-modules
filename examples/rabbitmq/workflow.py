from celery import chain, chord, group
from celery_dyrygent.workflows import Workflow

from worker2 import noop, echo

# celery_workflow = chain([
#     noop.s(0),
#     chord([noop.s(i) for i in range(10)], noop.s()),
#     chord([noop.s(i) for i in range(10)], noop.s()),
#     chord([noop.s(i) for i in range(10)], noop.s()),
#     chord([noop.s(i) for i in range(10)], noop.s()),
#     chord([noop.s(i) for i in range(10)], noop.s()),
#     noop.s()
# ])

celery_workflow = chord([echo.s(i) for i in range(2)], echo.s())

workflow = Workflow()
workflow.add_celery_canvas(celery_workflow)

print(celery_workflow.apply_async())
# print(workflow.apply_async())
