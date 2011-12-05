#Implements asynchronous executors for local machines and condor
#
#The local executor is only partially async, if there is too much load
#   it will block!

import multiprocessing
import os
import subprocess
import time

class Condor:
    ''' Class for Condor.
    '''
    def __init__(self):
        ''' Constructor

            universe is vanilla OR standard ...
                Only vanilla is implemented (but standard should work)
        '''
        self.universe = "vanilla"
        self.job = 0

    def java(self, command, parameters, requirements):
        '''  Submits a condor java job.
        '''
        self.job += 1
        template = '''
universe=java
requirements=%s
should_transfer_files=yes
when_to_transfer_output=on_exit
transfer_input_files=%s
log=condor%d.log
error=condor%d.error
output=%s
executable=%s
arguments=%s
java_vm_args=%s
queue
        ''' % (requirements, ",".join(self.send), self.job, self.job, self.out, command, parameters, self.javaVMArgs)

        rootName = "condor%d" % (self.job,)
        jobName = rootName + ".job"
        logName = rootName + ".log"
        w = open(jobName, "w")
        w.write(template)
        w.close()
        subprocess.call( "condor_submit %s" % (jobName,), shell=True)
        self.logName = logName

    def submit(self, command, parameters):
        '''  Submits a condor job.
        '''
        self.job += 1
        template = '''
universe=%s
requirements=(Arch=="X86_64" || Arch=="INTEL") && ( OpSys=="LINUX")
rank = kflops
should_transfer_files=yes
when_to_transfer_output=on_exit
transfer_input_files=%s
log=condor%d.log
error=condor%d.error
output=%s
executable=%s
arguments=%s
queue
        ''' % (self.universe, ",".join(self.send), self.job, self.job, self.out, command, parameters)

        rootName = "condor%d" % (self.job,)
        jobName = rootName + ".job"
        logName = rootName + ".log"
        w = open(jobName, "w")
        w.write(template)
        w.close()
        subprocess.call( "condor_submit %s" % (jobName,), shell=True)
        self.logName = logName


class Local:
    ''' The local executor.

        This executor will block if there are no more slots available!
    '''
    def __init__(self, limit):
        '''

             Limit is the expected load average not to be used, for instance
                 if there are 32 cores and there is a limit of 6, the
                 system will try to never ago above 26
        '''
        self.limit = limit
        self.cpus = multiprocessing.cpu_count()
        self.running = []
        pass

    def cleanDone(self):
        '''Removes dead processes from the running list.
        '''
        myDels = []
        for rIdx, p in enumerate(self.running):
            if p.poll() is not None:
                myDels.append(rIdx)
        myDels.reverse()
        for myDel in myDels:
            del self.running[myDel]
       

    def wait(self):
        '''Blocks if there are no slots available (high load av)
        '''
        time.sleep(1)
        self.cleanDone()
        numWaits = 0
        while len(self.running) >= self.cpus - self.limit:
            time.sleep(1)
            self.cleanDone()
            if numWaits % 10 == 0 and numWaits>0:
                print "Waiting for %d seconds. Current load %f, max %d" % (
                      numWaits, os.getloadavg()[0], self.cpus - self.limit
                      )
            numWaits += 1

    def submit(self, command, parameters):
        '''Submits a job
        '''
        self.wait()  
        if hasattr(self, "out"):
            out = self.out
        else:
            out = "/dev/null"
        if hasattr(self, "err"):
            err = self.out
        else:
            err = "/dev/null"
        p = subprocess.Popen( "%s %s > %s 2> %s" % 
                        (command, parameters, out, err),
                        shell=True)
        self.running.append(p)

class Pseudo:
    ''' The pseudo executor.

        This executor will Dump of list of nohup nice commands
    '''
    def __init__(self, outFile = "/tmp/pseudo%d" % (os.getpid())):
        '''
           outFile is where the text is written
        '''
        self.outFile = open(outFile, "a")
        pass

    def submit(self, command, parameters):
        '''Submits a job
        '''
        self.outFile.write( "nohup /usr/bin/nice -n19 %s %s > %s\n" % (command, parameters, self.out))
        self.outFile.flush()

    def __del__(self):
        self.outFile.close()

