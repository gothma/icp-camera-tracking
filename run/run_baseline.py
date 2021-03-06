import client
from dispy.httpd import DispyHTTPServer

task_dict = dict(
    convergence='25steps',
    closest_points = 'delaunayn',
    icp_error_func = 'svd_error'
)

slice_size = 10
max_frame = 200
min_frame = 0

cluster = client.get_matlab_cluster()

for i in range(min_frame + 1, max_frame + 1, slice_size):
    slice_task = dict(task_dict)
    slice_task['frame'] = '%d:%d' % (i, min(i + slice_size, max_frame + 1))
    print('Task submitted: %s' % slice_task)
    cluster.submit('icp_worker', slice_task)

monitor = DispyHTTPServer(cluster)
cluster.wait()
monitor.shutdown()
cluster.close()
