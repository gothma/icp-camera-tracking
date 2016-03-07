import logging
import dispy
import subprocess
import os

SECRET='f%7!g7OT31Nj6$<faR5"'

def run_matlab(function, args=None):
    import subprocess
    if args:
        arg_str = ', '.join('\'%s\', %s' % (k, repr(v)) for k, v in args.iteritems())
        call = "%s(%s)" % (function, arg_str)
    else:
        call = function
    print('Calling %s' % call)
    wrapped_call = 'try; %s; catch; exit; end; exit' % call


    total_arglist = ['matlab', '-nodisplay', '-nojvm', '-nosplash', '-r', wrapped_call]
    subprocess.call(total_arglist)

def get_matlab_cluster():
    cluster = dispy.JobCluster(
    run_matlab,
    loglevel=logging.DEBUG,
    node_port=32746,
    secret=SECRET)

def main():
    job = cluster.submit('runtests')
    res = job()
    print res

if __name__ == '__main__':
    main()
