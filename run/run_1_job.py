import client
from dispy.httpd import DispyHTTPServer

task_dict = dict(
    convergence='1step',
    closest_points = 'delaunayn',
    icp_error_func = 'svd_error',
    frame='1:2',
)

slice_size = 10
max_frame = 200
min_frame = 0

cluster = client.get_matlab_cluster()
cluster.submit('icp_worker', task_dict)
