import sys
import Executor

if len(sys.argv) != 4:
    print "Syntax: %s chr_from chr_to pop" % (sys.argv[0],)
    sys.exit(-1)

startChr = int(sys.argv[1])
endChr = int(sys.argv[2])
pop = sys.argv[3]

#executor = Executor.Condor()
#executor.javaVMArgs="-Xmx2g"
for k in range(startChr, endChr+1):
    if pop == "AFRO":
        bgltrios  = "Beagle/AFROtrios_chr%d.bgl"  % (k,)
        markers   = "Ped2Beagle/markers_chr%d.txt"    % (k,)
        unphased  = "%d/AFRICAN_chr%d.bgl"    % (k,)
        outbeagle = "%d/phasedAFRO_chr%d.bgl" % (k,)
    elif pop == "OOA":
        bgltrios  = "Beagle/OOAtrios_chr%d.bgl"   % (k,)
        markers   = "Ped2Beagle/markers_chr%d.txt"    % (k,)
        unphased  = "%d/OOA_chr%d.bgl"        % (k,)
        outbeagle = "%d/phasedOOA_chr%d.bgl"  % (k,)
    else:
        print "Unknown reference population: %s " % (pop, )
        sys.exit(-1)
    executor.send =[markers, bgltrios, unphased]
    executor.out = "out"
    executor.java("beagle.jar", "phaser.PhaseMain lowmem=true markers=%s phased=%s unphased=%s missing=0 out=%s" % (markers, bgltrios, unphased, outbeagle), "Memory>2000")
